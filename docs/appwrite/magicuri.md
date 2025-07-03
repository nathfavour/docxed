Magic URL login
Magic URL is a password-less way to authenticate users. When a user logs in by providing their email, they will receive an email with a "magic" link that contains a secret used to log in the user. The user can simply click the link to be logged in.

Send email
Initialize the log in process with the Create Magic URL Token route. If the email has never been used, a new account is generated, then the user will receive an email. If the email is already attached to an account, the user ID is ignored and the user will receive a link in their email.


import { Client, Account, ID } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>');                 // Your project ID

const account = new Account(client);

const token = await account.createMagicURLToken(
    ID.unique(),
    'email@example.com',
    'https://example.com/verify'
);
The url parameter specifies where users will be redirected after clicking the magic link. The secret and userId will be automatically appended as query parameters to this URL.

Login
After the user clicks the magic link in their email, they will be redirected to your specified URL with the secret and userId as query parameters. Use these parameters to create a session.


import { Client, Account } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>');                // Your project ID

const account = new Account(client);

const urlParams = new URLSearchParams(window.location.search);
const secret = urlParams.get('secret');
const userId = urlParams.get('userId');

const user = await account.createSession(userId, secret);