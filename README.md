# Analytics Engineering assessment

This repository contains all you need to get started with the Xccelerated Analytics Engineering assessment. We suggest that you start by reading this document carefully.

In the meantime, our bots have begun to provision a database that you can use during the assessment. Please find the issue that was just opened and follow the instructions therew.

Please push your solution to this repository before your scheduled presentations, and contact our CTO Matthijs at mbrouns@xccelerated.io, or our DE Lead Rick at rvergunst@xccelerated.io in case there are any questions

Good luck, and have fun!


## Context

Next to running a successfull training and consulting business, Xccelerated also runs a very real and totally 
non-fictitious webshop that sells all kinds of real products such as:

- Adaptive bi-directional analyzers;
- Yak shaving shears;
- Organic foreground paradigms;
- Intuitive asymmetric cores;
- Multi-lateral 6th-generation service-desk;
- and Seamless 4th-generation application.

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

## The assignment

For the assessment we have created an environment for you to work in. This environment is created in [Neon](https://neon.tech) PostgreSQL database with a single table. The table contains the data you can see in the image above and should form the starting point for the assessment. You should be able to the database with the given credentials and using your favourite database tool. (We like [DBeaver](https://dbeaver.io/), but you are free to use whatever you like)

### Step 1: Sessionize

In order to facilitate self-service analysis by our stakeholders and provide a good basis for further analysis we want to perform a preprocessing step
in which we group related events from a user into a session. We'll only focus on easily identifiable customers
that have logged in (e.g. have a not-null customer-id)

The output of this step should be stored in the database for further analysis. You are free to design
the database schema as you see fit as long as you can reason about it.

The output of this step should be a SQL script (or multiple) that generate the table as described and should be pushed to this repository.

[Windows functions](https://www.postgresql.org/docs/current/tutorial-window.html) will come in very handy for this part of the assessment. 


### Step 2: Metrics

The user session data you generated in step one can be used to drive many important processes for our webshop. 
We'd like to make the most essential information easily available in the database in the form of metrics.

The first metric here should return the median amount of sessions someone had before they had a session in which they made a purchase. 
The second metric does the same except it returns the median session duration someone had before the first session in which they had a purchase.

![](images/metrics.png)

Similar to Step 1 we expect a (or multiple) SQL script(s) are the answer, which should be pushed to this repository.

## Step 3: Visualizing the results

Seeing as you are the new Analytics Engineer, your work does not stop here. The next step is making insightful visualization for the stakeholders in order for them to see how the webshop is doing and to base their decisions on. We don't ask you to actually make a visualization, but we would like you to think about how a dashboard would look like that shows a stakeholder how the webshop is doing and where we are (possibly) missing the mark. Don't limit yourself to the metrics above but be creative with what would be insightful for a webshop. 

The end result should be a drawn up dashboard with graphs and whatever you see fit, which you can draw in whatever tool you like (an example we like is [Excalidraw](https://excalidraw.com/)). It's also important to be able to tell us why you made certain decisions and how it would help a stakeholder so make sure you do everything with a specific intent!

## Evaluation
The evaluation of your solution is based on a presentation given by you for two members of our team and on the solution itself.
Please provide us with the working solution beforehand (short notice is OK, doesn’t have to be weeks before) by
pushing it to this GitHub repository.

We care about your ability to create a data driven solution that is useful for end users. In the end we are about
creating software for our clients that will help them improve their organization. The result should fit that description.

Your solution is expected to work on the PostgreSQL database we provisioned for you. There are no strict rules regarding choice of other frameworks or tools. We want to see that you are capable of building a (simple) product, end-to-end.

Your solution must work out-of-the-box. This means that an individual reasonably proficient with computers and programming
should be able to get it running without having to contact you. A useful README must be in place if this is 
required to meet this requirement, but don't go overboard with documentation. 

## Timeframe
If you can make the assessment in approximately 8 to 10 hours of work that is a good sign. 
If you need a little more that’s ok too. However, do not spend a lot more hours on it. It’s better to 
deliver something simple and working than nothing at all. 

Also, let us know if you feel that the time estimate is inaccurate. This feedback is valuable for us. 


## Questions:

If you have any questions, please reach out to our CTO Matthijs at mbrouns@xccelerated.io, or our DE Lead Rick at
rvergunst@xccelerated.io

