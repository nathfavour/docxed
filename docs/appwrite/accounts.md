Accounts
Appwrite Account API is used for user signup and login in client applications. Users can be organized into teams and be given labels, so they can be given different permissions and access different resources. Each user's account can also have their own preference object, which you can use to save preferences such as theme, language, and notification settings.

Account vs Users API
The Account API is the API you should use in your client applications with Client SDKs like web, Flutter, mobile, and native apps. Account API creates sessions, which represent an authenticated user and is attached to a user's account. Sessions respect permissions, which means users can only access resources if they have been granted the correct permissions.

The Users API is a dedicated API for managing users from an admin's perspective. It should be used with backend or server-side applications with Server SDKs. Users API uses API keys instead of sessions. This means they're not restricted by permissions, but by the scopes granted to the API key used.

Signup and login
You can signup and login a user with an account create through email password, phone (SMS), Anonymous, magic URL, and OAuth 2 authentication.

Preferences
You can store user preferences on a user's account using Appwrite's Update Preferences endpoint. You can store preferences such as theme, notification settings, or preferred language so they can be synced across multiple devices.

Preferences are stored as a key-value JSON object. The maximum allowed size for preferences is 64kB, and an error will be thrown if this limit is exceeded.


import { Client, Account } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>');                 // Your project ID

const account = new Account(client);

const promise = account.updatePrefs({darkTheme: true, language: 'en'});

promise.then(function (response) {
    console.log(response); // Success
}, function (error) {
    console.log(error); // Failure
});
After a user's preferences are updated, they can be retrieved using the get account preferences endpoint.


import { Client, Account } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>');                 // Your project ID

const account = new Account(client);

const promise = account.getPrefs();

promise.then(function (response) {
    console.log(response); // Success
}, function (error) {
    console.log(error); // Failure
});
Permissions
You can grant permissions to all users using the Role.users(<STATUS>) role or individual users using the Role.user(<USER_ID>, <STATUS>) role.

Description	Role
Verified users	Role.users('verified')
Unverified users	Role.users('unverified')
Verified user	Role.user(<USER_ID>, 'verified')
Unverified user	Role.user(<USER_ID>, 'unverified')