setup

import { Client, Account } from 'appwrite';

export const client = new Client();

client
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>'); // Replace with your project ID

export const account = new Account(client);
export { ID } from 'appwrite';






create a login page:



"use client";
import { useState } from "react";
import { account, ID } from "./appwrite";

const LoginPage = () => {
  const [loggedInUser, setLoggedInUser] = useState(null);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [name, setName] = useState("");

  const login = async (email, password) => {
    const session = await account.createEmailPasswordSession(email, password);
    setLoggedInUser(await account.get());
  };

  const register = async () => {
    await account.create(ID.unique(), email, password, name);
    login(email, password);
  };

  const logout = async () => {
    await account.deleteSession("current");
    setLoggedInUser(null);
  };

  if (loggedInUser) {
    return (
      <div>
        <p>Logged in as {loggedInUser.name}</p>
        <button type="button" onClick={logout}>
          Logout
        </button>
      </div>
    );
  }

  return (
    <div>
      <p>Not logged in</p>
      <form>
        <input
          type="email"
          placeholder="Email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
        <input
          type="password"
          placeholder="Password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
        <input
          type="text"
          placeholder="Name"
          value={name}
          onChange={(e) => setName(e.target.value)}
        />
        <button type="button" onClick={() => login(email, password)}>
          Login
        </button>
        <button type="button" onClick={register}>
          Register
        </button>
      </form>
    </div>
  );
};

export default LoginPage;














signup:

import { Client, Account, ID } from "appwrite";

const client = new Client()
    .setProject('<PROJECT_ID>'); // Your project ID

const account = new Account(client);

const promise = account.create('[USER_ID]', 'email@example.com', '');

promise.then(function (response) {
    console.log(response); // Success
}, function (error) {
    console.log(error); // Failure
});























login:


import { Client, Account } from "appwrite";

const client = new Client()
    .setProject('<PROJECT_ID>'); // Your project ID

const account = new Account(client);

const promise = account.createEmailPasswordSession('email@example.com', 'password');

promise.then(function (response) {
    console.log(response); // Success
}, function (error) {
    console.log(error); // Failure
});









verification:



import { Client, Account } from "appwrite";

const client = new Client()
    .setProject('<PROJECT_ID>') // Your project ID

const account = new Account(client);

const promise = account.createVerification('https://example.com/verify');

promise.then(function (response) {
    console.log(response); // Success
}, function (error) {
    console.log(error); // Failure
});




















next, implement the verification page:


import { Client, Account } from "appwrite";

const client = new Client()
    .setProject('<PROJECT_ID>'); // Your project ID

const account = new Account(client);

const urlParams = new URLSearchParams(window.location.search);
const secret = urlParams.get('secret');
const userId = urlParams.get('userId');

const promise = account.updateVerification(userId, secret);

promise.then(function (response) {
    console.log(response); // Success
}, function (error) {
    console.log(error); // Failure
});













password recovery:


import { Client, Account } from "appwrite";

const client = new Client()
    .setProject('<PROJECT_ID>'); // Your project ID

const promise = account.createRecovery('email@example.com', 'https://example.com/recovery');

promise.then(function (response) {
    console.log(response); // Success
}, function (error) {
    console.log(error); // Failure
});

























verification link, etc:




import { Client, Account } from "appwrite";

const client = new Client()
    .setProject('<PROJECT_ID>'); // Your project ID

const promise = account.updateRecovery(
    '[USER_ID]',
    '[SECRET]',
    'password'
);

promise.then(function (response) {
    console.log(response); // Success
}, function (error) {
    console.log(error); // Failure
});
