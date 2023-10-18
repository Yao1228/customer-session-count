## Context
There are 6 products selling on an online store:
- A
- Y
- O
- I
- M
- a

Being a data-driven organization, we have many stakeholders who want to get their hands dirty
with data from this webshop in order to answer all kinds of analytical questions. 
Many of these analytical questions are based on the idea of a users "session". In particular, we'd like to know:

How much time does a user typically spend in our shop before committing to making a purchase
How many times does a user visit our shop before committing to making a purchase
Are there differences in session duration for sessions originating from different referrers

In order to answer these questions, the engineers who built our shop made sure to track user events. These events include:

- PAGE_VIEW
- ADD_PRODUCT_TO_CART
- REMOVE_PRODUCT_FROM_CART
- SIGN_UP_SUCCESS
- VISIT_RELATED_PRODUCT
- VISIT_RECENTLY_VISITED_PRODUCT
- VISIT_PERSONAL_RECOMMENDATION
- SEARCH

all events are stored with a timestamp, an event_type and additional event data in a table in the database. 
This event-data typically includes the users user-agent, ip address and customer-id if they are logged in.
Additionally, page-view events contain the url of the page the customer visited, as well as a referrer if 
they came from an external location.

A small sample of this data can be found below:

![](images/data.png)

If you put all these events on a timeline for each user, you will find short periods of high activity, 
followed by longer periods of inactivity. 

![](images/timeline.png)


These high activity periods can be considered as a users' session.

![](images/sessions.png)


### Step 1: Sessionize

In order to facilitate self-service analysis by our stakeholders and provide a good basis for further analysis we want to perform a preprocessing step
in which we group related events from a user into a session. We'll only focus on easily identifiable customers
that have logged in (e.g. have a not-null customer-id)

### Step 2: Metrics

The user session data you generated in step one can be used to drive many important processes for our webshop. 
We'd like to make the most essential information easily available in the database in the form of metrics.

The first metric here should return the median amount of sessions someone had before they had a session in which they made a purchase. 
The second metric does the same except it returns the median session duration someone had before the first session in which they had a purchase.

![](images/metrics.png)


