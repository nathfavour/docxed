Execution
Appwrite Functions can be executed in several ways. Executions can be invoked through the Appwrite SDK and visiting its REST endpoint. Functions can also be triggered by events and scheduled executions. Here are all the different ways to consume your Appwrite Functions.

Domains
You can execute a function through HTTP requests, using a browser or by sending an HTTP request.

In the Appwrite Console's sidebar, click Functions.

Under Execute access, set the access to Any so that anyone can execute the function. You will use JWTs to authenticate users.

Under the Domains tab, you'll find the generated domain from Appwrite and your custom domains. Learn about adding a custom domain.

Bash

https://64d4d22db370ae41a32e.appwrite.global
When requests are made to this domain, whether through a browser or through an HTTP requests, the request information like request URL, request headers, and request body will be passed to the function.

Bash

curl -X POST https://64d4d22db370ae41a32e.appwrite.global \
-H "X-Custom-Header: 123" \
-H "x-appwrite-user-jwt: <YOUR_JWT_KEY>" \
-H "Content-Type: application/json" \
-d '{"data":"this is json data"}'
Notice how a x-appwrite-user-jwt header is passed in the request, you will use this to authenticate users. Learn more about JWTs.

This unlocks ability for you to develop custom HTTP endpoints with Appwrite Functions. It also allows accepting incoming webhooks for handling online payments, hosting social platform bots, and much more.

SDK
You can invoke your Appwrite Functions directly from the Appwrite SDKs.

Client SDKs
Server SDKs

import { Client, Functions } from "appwrite";

const client = new Client();

const functions = new Functions(client);

client
    .setProject('<PROJECT_ID>') // Your project ID
;

const promise = functions.createExecution(
        '<FUNCTION_ID>',  // functionId
        '<BODY>',  // body (optional)
        false,  // async (optional)
        '<PATH>',  // path (optional)
        'GET',  // method (optional)
        {} // headers (optional)
    );

promise.then(function (response) {
    console.log(response); // Success
}, function (error) {
    console.log(error); // Failure
});
Console
Another easy way to test a function is directly in the Appwrite Console. You test a function by hitting the Execute now button, which will display with modal below.

You'll be able to mock executions by configuring the path, method, headers, and body.

Create project screen

Events
Changes in Appwrite emit events. You can configure Functions to be executed in response to these events.

In Appwrite Console, navigate to Functions.

Click to open a function you wish to configure.

Under the Settings tab, navigate to Events.

Add one or multiple events as triggers for the function.

Be careful to avoid selecting events that can be caused by the function itself. This can cause the function to trigger its own execution, resulting in infinite recursions.

In these executions, the event that triggered the function will be passed as the header x-appwrite-event to the function. The request.body parameter will contain the event data. Learn more about events.

You can use one of the following events.

Authentication
Name	Description
teams.*	This event triggers on any teams event. Returns Team Object
teams.*.create	This event triggers when a team is created. Returns Team Object
teams.*.delete	This event triggers when a team is deleted. Returns Team Object
teams.*.memberships.*	This event triggers on any team memberships event. Returns Membership Object
teams.*.memberships.*.create	This event triggers when a membership is created. Returns Membership Object
teams.*.memberships.*.delete	This event triggers when a membership is deleted. Returns Membership Object
teams.*.memberships.*.update	This event triggers when a membership is updated. Returns Membership Object
teams.*.memberships.*.update.status	This event triggers when a team memberships status is updated. Returns Membership Object
teams.*.update	This event triggers when a team is updated. Returns Team Object
teams.*.update.prefs	This event triggers when a team's preferences are updated. Returns Team Object
users.*	This event triggers on any user's event. Returns User Object
users.*.create	This event triggers when a user is created. Returns User Object
users.*.delete	This event triggers when a user is deleted. Returns User Object
users.*.recovery.*	This event triggers on any user's recovery token event. Returns Token Object
users.*.recovery.*.create	This event triggers when a recovery token for a user is created. Returns Token Object
users.*.recovery.*.update	This event triggers when a recovery token for a user is validated. Returns Token Object
users.*.sessions.*	This event triggers on any user's sessions event. Returns Session Object
users.*.sessions.*.create	This event triggers when a session for a user is created. Returns Session Object
users.*.sessions.*.delete	This event triggers when a session for a user is deleted. Returns Session Object
users.*.update	This event triggers when a user is updated. Returns User Object
users.*.update.email	This event triggers when a user's email address is updated. Returns User Object
users.*.update.name	This event triggers when a user's name is updated. Returns User Object
users.*.update.password	This event triggers when a user's password is updated. Returns User Object
users.*.update.prefs	This event triggers when a user's preferences is updated. Returns User Object
users.*.update.status	This event triggers when a user's status is updated. Returns User Object
users.*.verification.*	This event triggers on any user's verification token event. Returns Token Object
users.*.verification.*.create	This event triggers when a verification token for a user is created. Returns Token Object
users.*.verification.*.update	This event triggers when a verification token for a user is validated. Returns Token Object
Databases
Name	Description
databases.*	This event triggers on any database event. Returns Database Object
databases.*.collections.*	This event triggers on any collection event. Returns Collection Object
databases.*.collections.*.attributes.*	This event triggers on any attributes event. Returns Attribute Object
databases.*.collections.*.attributes.*.create	This event triggers when an attribute is created. Returns Attribute Object
databases.*.collections.*.attributes.*.delete	This event triggers when an attribute is deleted. Returns Attribute Object
databases.*.collections.*.create	This event triggers when a collection is created. Returns Collection Object
databases.*.collections.*.delete	This event triggers when a collection is deleted. Returns Collection Object
databases.*.collections.*.documents.*	This event triggers on any documents event. Returns Document Object
databases.*.collections.*.documents.*.create	This event triggers when a document is created. Returns Document Object
databases.*.collections.*.documents.*.delete	This event triggers when a document is deleted. Returns Document Object
databases.*.collections.*.documents.*.update	This event triggers when a document is updated. Returns Document Object
databases.*.collections.*.indexes.*	This event triggers on any indexes event. Returns Index Object
databases.*.collections.*.indexes.*.create	This event triggers when an index is created. Returns Index Object
databases.*.collections.*.indexes.*.delete	This event triggers when an index is deleted. Returns Index Object
databases.*.collections.*.update	This event triggers when a collection is updated. Returns Collection Object
databases.*.create	This event triggers when a database is created. Returns Database Object
databases.*.delete	This event triggers when a database is deleted. Returns Database Object
databases.*.update	This event triggers when a database is updated. Returns Database Object
Storage
Name	Description
buckets.*	This event triggers on any buckets event. Returns Bucket Object
buckets.*.create	This event triggers when a bucket is created. Returns Bucket Object
buckets.*.delete	This event triggers when a bucket is deleted. Returns Bucket Object
buckets.*.files.*	This event triggers on any files event. Returns File Object
buckets.*.files.*.create	Since the Appwrite SDK chunks files in 5MB increments, this event will trigger for each 5MB chunk. A file is fully uploaded when chunksTotal equals chunksUploaded. Returns File Object
buckets.*.files.*.delete	This event triggers when a file is deleted. Returns File Object
buckets.*.files.*.update	This event triggers when a file is updated. Returns File Object
buckets.*.update	This event triggers when a bucket is updated. Returns Bucket Object
Functions
Name	Description
functions.*	This event triggers on any functions event. Returns Function Object
functions.*.create	This event triggers when a function is created. Returns Function Object
functions.*.delete	This event triggers when a function is deleted. Returns Function Object
functions.*.deployments.*	This event triggers on any deployments event. Returns Deployment Object
functions.*.deployments.*.create	This event triggers when a deployment is created. Returns Deployment Object
functions.*.deployments.*.delete	This event triggers when a deployment is deleted. Returns Deployment Object
functions.*.deployments.*.update	This event triggers when a deployment is updated. Returns Deployment Object
functions.*.executions.*	This event triggers on any executions event. Returns Execution Object
functions.*.executions.*.create	This event triggers when an execution is created. Returns Execution Object
functions.*.executions.*.delete	This event triggers when an execution is deleted. Returns Execution Object
functions.*.executions.*.update	This event triggers when an execution is updated. Returns Execution Object
functions.*.update	This event triggers when a function is updated. Returns Function Object
Messaging
Schedule
Appwrite supports scheduled function executions. You can schedule executions using cron expressions in the settings of your function. Cron supports recurring executions as frequently as every minute.

Here are some cron expressions for common intervals:

Cron Expression	Schedule
*/15 * * * *	Every 15 minutes
0 * * * *	Every Hour
0 0 * * *	Every day at 00:00
0 0 * * 1	Every Monday at 00:00
Delayed executions
You can also delay function executions, which trigger the function only once at a future date and time. You can schedule a function execution using the Appwrite Console, a Client SDK, or a Server SDK.

Console
Client SDK
Server SDK
To schedule an execution, navigate to Your function > Executions > Execute now > Schedule in the Appwrite Console.

Scheduled execution details screen

Permissions
Appwrite Functions can be executed using Client or Server SDKs. Client SDKs must be authenticated with an account that has been granted execution permissions on the function's settings page. Server SDKs require an API key with the correct scopes.

If your function has a generated or custom domain, executions are not authenticated. Anyone visiting the configured domains will be considered a guest, so make sure to give Any execute permission in order for domain executions to work. If you need to enforce permissions for functions with a domain, use authentication methods like JWT.