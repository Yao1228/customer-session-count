-- Q1
-- select "customer-id" not null from column event and save in a new table
create schema if not exists target_schema;

create table if not exists target_schema.target_id(
id int4,
type varchar,
event json
);

insert into target_schema.target_id (id, "type", "event")
select *
from public.events
where event->>'customer-id' is not null;

--Q2
-- 1.add new column as cust_id, session_time
alter table target_schema.target_id 
add cust_id int;
update target_schema.target_id 
set cust_id = (event->> 'customer-id') :: int;

alter table target_schema.target_id
add column session_time timestamp;
update target_schema.target_id 
set session_time = (event->> 'timestamp') :: timestamp;

select * from target_id;

-- 2. select rows from table target_schema.target_id  where type is "placed_order"  and save it as temp table t1.
create table t1 as
select *
from target_schema.target_id 
where type='placed_order';

--3. select rows from table target_schema.target_id where "cust_id" is also in temp table t1 as temp table t2
create table t2 as
select *
from target_schema.target_id
where cust_id in (select cust_id from t1);

--4. GROUP t2 by cust_id and sort session_time by desc, index each cust_id
create table t3 as 
select
	t2.*, row_number() over (partition by cust_id order by session_time desc) as row_num
from t2;

select * from t3;
--5. group t3 by cust_id, assign row_number of each type by session order by desc,
-- group type without changing its logical order, and calculate duration(max session-min session) of each type
--delete the latest session_time when type is not "placed_order"
--count row number of each cust_id and get median

with t4 as (
	select 
		t3.cust_id,
		t3.type,
		t3.row_num,
		t3.session_time,
		lag(t3.type) over (partition by t3.cust_id) as prev_type
	from t3
),
merged_types as ( 
	select 
		t4.cust_id,
		t4.type,
		t4.row_num,
		t4.prev_type,		
		case 
			when type= prev_type then null
			else type
		end as merged_type, 
		t4.session_time
	from t4
),
session_group as(
	select
	    merged_types.cust_id,
	    merged_types.type,
	    merged_types.row_num,
	    merged_types.prev_type,
	    merged_types.merged_type,
	    merged_types.session_time,
	    case
	        when merged_type is null then
	            EXTRACT(EPOCH FROM (session_time - LAG(session_time) OVER (PARTITION BY cust_id))) / 60*(-1)
	        else
	            0
	    end as duration
	from
	    merged_types),----fixed 
placed_order_sessions AS (
    SELECT
        cust_id,
        Max(session_time) AS latest_placed_order_time
    FROM session_group
    WHERE type = 'placed_order'
    GROUP BY cust_id),	
session_clean as(
	select sg.*
	from session_group sg
	left join placed_order_sessions pos on sg.cust_id=pos.cust_id
	where sg.merged_type is not null or  (sg.session_time < pos.latest_placed_order_time)),
session_counts as (
	select cust_id, count(*) as row_count
	from session_clean
	group by cust_id
)
select percentile_cont(0.5) within group (order by row_count) as median
from session_counts;


--(2) return the median session duration someone had before the first session in which they had a purchase.

with t4 as (
	select 
		t3.cust_id,
		t3.type,
		t3.row_num,
		t3.session_time,
		lag(t3.type) over (partition by t3.cust_id) as prev_type
	from t3
),
merged_types as ( 
	select 
		t4.cust_id,
		t4.type,
		t4.row_num,
		t4.prev_type,		
		case 
			when type= prev_type then null
			else type
		end as merged_type, 
		t4.session_time
	from t4
),
session_group as(
	select
	    merged_types.cust_id,
	    merged_types.type,
	    merged_types.row_num,
	    merged_types.prev_type,
	    merged_types.merged_type,
	    merged_types.session_time,
	    case
	        when merged_type is null then
	            EXTRACT(EPOCH FROM (session_time - LAG(session_time) OVER (PARTITION BY cust_id))) / 60*(-1)
	        else
	            0
	    end as duration
	from
	    merged_types),----fixed , select * from session_group;  
placed_order_sessions AS (
    SELECT
        cust_id,
        Min(session_time) AS first_placed_order_time
    FROM session_group
    WHERE type = 'placed_order'
    GROUP BY cust_id),	
session_clean as(
	select sg.*
	from session_group sg
	left join placed_order_sessions pos on sg.cust_id=pos.cust_id
	where sg.session_time <= pos.first_placed_order_time),	
duration_counts as (
	select cust_id, sum(session_clean.duration) as d_sum
	from session_clean
	group by cust_id
)
select percentile_cont(0.5) within group (order by d_sum) as median
from duration_counts;--unit is min







