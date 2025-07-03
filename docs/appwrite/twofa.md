Multi-factor authentication
Multi-factor authentication (MFA) greatly increases the security of your apps by adding additional layers of protection. When MFA is enabled, a malicious actor needs to compromise multiple authentication factors to gain unauthorized access. Appwrite Authentication lets you easily implement MFA in your apps, letting you build more securely and quickly.

Looking for MFA on your Console account?
This page covers MFA for your app's end-users. If you are looking for MFA on your Appwrite Console account, please refer to the Console MFA page.

Appwrite currently allows two factors of authentication. More factors of authentication will be available soon.

Here are the steps to implement MFA in your application.

Display recovery codes
Initialize your Appwrite SDK's Client, Account, and Avatars. You'll use Avatars API to generate a QR code for the TOTP authenticator app, you can skip this import if you're not using TOTP.


import { Client, Account, Avatars } from "appwrite";

const client = new Client();

const account = new Account(client);
const avatars = new Avatars(client);

client
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>') // Your project ID
;
Before enabling MFA, you should display recovery codes to the user. The codes are single use passwords the user can use to access their account if they lose access to their MFA email, phone, or authenticator app. These codes can only be generated once, warn the users to save them.

The code will look like this, display them to the user and remind them to save the codes in a secure place.

JSON

{
    "recoveryCodes": [
        "b654562828",
        "a97c13d8c0",
        "311580b5f3",
        "c4262b3f88",
        "7f6761afb4",
        "55a09989be",
    ]
}
These codes can be used to complete the Complete challenge step if the user loses access to their MFA factors. Generate the recovery codes by calling account.createMfaRecoveryCodes().


const response = await account.createMfaRecoveryCodes();
console.log(response.recoveryCodes);
Verify MFA factors
Any verified email, phone number, or TOTP authenticator app can be used as a factor for MFA. Before they can be used as a factor, they need to be verified.

Email
Phone
Authenticator
First, set your user's email if they haven't already.


const response = await account.updateEmail(
    'email@example.com',  // email
    'password' // password
);
Then, initiate verification for the email by calling account.createEmailVerification(). Calling createEmailVerification will send a verification email to the user's email address with a link with the query parameter userId and secret.


const res = await account.createVerification(
    'https://example.com/verify-email' // url
);
After the user clicks the link in the email, they will be redirected to your site with the query parameters userId and secret. If you're on a mobile platform, you will need to create the appropriate deep link to handle the verification.

Finally, verify the email by calling account.updateVerification() with userId and secret.


const response = await account.updateVerification(
    '<USER_ID>',  // userId
    '<SECRET>', // secret
);
Enable MFA on an account
You can enable MFA on your account by calling account.updateMFA(). You will need to have added more than 1 factors of authentication to an account before the MFA is enforced.


const result = await account.updateMFA(true);
Initialize login
Begin your login flow with the default authentication method used by your app, for example, email password.


const session = await account.createEmailPasswordSession(
    'email@example.com', // email
    'password' // password
);
Check for multi-factor
Upon successful login in the first authentication step, check the status of the login by calling account.get(). If more than one factors are required, you will receive the error user_more_factors_required. Redirect the user in your app to perform the MFA challenge.


try {
    const response = await account.get();
    console.log(response);
} catch (error) {
    console.log(error);
    if (error.type === `user_more_factors_required`){
        // redirect to perform MFA
    }
    else {
        // handle other errors
    }
}
List factors
You can check which factors are enabled for an account using account.listMfaFactors(). The returned object will be formatted like this.

Web

{
    totp: true, // time-based one-time password
    email: false, // email
    phone: true // phone
}

const factors = await account.listMfaFactors();
// redirect based on factors returned.
Create challenge
Based on the factors available, initialize an additional auth step. Calling these methods will send a challenge to the user. You will need to save the challenge ID to complete the challenge in a later step.

Email
Phone
TOTP
Appwrite will use a verified email on the user's account to send the challenge code via email. Note that this is only valid as a second factor if the user did not initialize their login with email OTP.


const challenge = await account.createMfaChallenge(
    'email'  // factor
);

// Save the challenge ID to complete the challenge later
const challengeId = challenge.$id;
Complete challenge
Once the user receives the challenge code, you can pass the code back to Appwrite to complete the challenge.


const response = await account.updateMfaChallenge(
    '<CHALLENGE_ID>', // challengeId
    '<OTP>' // otp
);
After completing the challenge, the user is now authenticated and all requests will be authorized. You can confirm this by running account.get()

Recovery
In case your user needs to recover their account, they can use the recovery codes generated in the first step with the recovery code factor. Initialize the challenge by calling account.createMfaChallenge() with the factor recoverycode.


const challenge = await account.createMfaChallenge(
    'recoverycode' // factor
);

// Save the challenge ID to complete the challenge later
const challengeId = challenge.$id;
Then complete the challenge by calling account.updateMfaChallenge() with the challenge ID and the recovery code.


const response = await account.updateMfaChallenge(
    '<CHALLENGE_ID>', // challengeId
    '<RECOVERY_CODE>' // otp
);