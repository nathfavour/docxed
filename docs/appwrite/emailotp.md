Email OTP
Email OTP (one-time password) authentication lets users create accounts using their email address and log in using a 6 digit code delivered to their email inbox. This method is similar to Magic URL login, but can provide better user experience in some scenarios.

Email OTP vs Magic URL
Email OTP sends an email with a 6 digit code that user needs to enter into the app, while Magic URL delivers a clickable button or a link to user's inbox. Both allow passwordless login flows with different advantages.

Benefits of Email OTP	Downsides of Email OTP
Doesn't require user to be signed into email inbox on the device	Expires quicker
Doesn't disturb application flow with a redirect	Requires more inputs from user
Doesn't require deep linking on mobile apps	
Send email
Email OTP authentication is done using a two-step authentication process. The authentication request is initiated from the client application and an email message is sent to the user's email inbox. The email will contain a 6-digit number the user can use to log in.

Send an an email to initiate the authentication process. A new account will be created for this email if it has never been used before.


import { Client, Account, ID } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>');

const account = new Account(client);

const sessionToken = await account.createEmailToken(
    ID.unique(),
    'email@example.com'
);

const userId = sessionToken.userId;
Login
After initiating the email OTP authentication process, the returned user ID and secret are used to authenticate the user. The user will use their 6-digit one-time password to log in to your app.


import { Client, Account, ID } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>');

const account = new Account(client);

const session = await account.createSession(
    userId,
    '[SECRET]'
);
After the secret is verified, a session will be created.

Security phrase
A security phrase is a randomly generated phrase provided on the login page, as well as inside Email OTP login email. Users must match the phrase on the login page with the phrase provided inside the email. Security phrases offer protection for various types of phishing and man-in-the-middle attacks.

By default, security phrases are disabled. To enable a security phrase in Email OTP, enable it in first step of the authentication flow.


import { Client, Account, ID } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>');                 // Your project ID

const account = new Account(client);

const promise = account.createEmailToken(
        ID.unique(),
        'email@example.com',
        true
    );

promise.then(function (response) {
    console.log(response); // Success
}, function (error) {
    console.log(error); // Failure
});
By enabling security phrase feature, you will recieve phrase in the response. You need to display this phrase to the user, and we recommend informing user what this phrase is and how to check it. When security phrase is enabled, email will also include a new section providing user with the security phrase.