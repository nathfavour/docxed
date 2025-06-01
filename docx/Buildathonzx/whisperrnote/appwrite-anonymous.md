create anonymous session:

import { Client, Account } from "appwrite";

const client = new Client()
    .setEndpoint('https://cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>');                 // Your project ID

const account = new Account(client);

const promise = account.createAnonymousSession();

promise.then(function (response) {
    console.log(response); // Success
}, function (error) {
    console.log(error); // Failure
});






attaching an account:

Attaching an account
Anonymous users cannot sign back in. If the session expires, they move to another computer, or they clear their browser data, they won't be able to log in again. Remember to prompt the user to create an account to not lose their data.

Create an account with any of these methods to transition from an anonymous session to a user account session.