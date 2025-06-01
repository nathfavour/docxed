Start with Next.js
Learn how to setup your first Next.js project powered by Appwrite.

Create project
Head to the Appwrite Console.

Create project screen

If this is your first time using Appwrite, create an account and create your first project.

Then, under Add a platform, add a Web app. The Hostname should be localhost.

Add a platform

You can skip optional steps.

Create Next.js project
Create a Next.js project by running the following command:

Shell

npx create-next-app@latest && cd my-app
When prompted, configure your project with these recommended settings:

Would you like to use TypeScript? → No

Would you like to use ESLint? → Yes

Would you like to use Tailwind CSS? → No (unless you plan to use it)

Would you like to use src/ directory? → Yes/No (either works for this tutorial)

Would you like to use App Router? → Yes

Would you like to customize the default import alias? → No

These settings will create a minimal Next.js setup that's perfect for getting started with Appwrite.

Install Appwrite SDK
Install the JavaScript Appwrite SDK.

Shell

npm install appwrite@14.0.1
Define Appwrite service
Find your project's ID in the Settings page.

Project settings screen

Create a new file app/appwrite.js and add the following code to it, replace <PROJECT_ID> with your project ID.

Web

import { Client, Account } from 'appwrite';

export const client = new Client();

client
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>'); // Replace with your project ID

export const account = new Account(client);
export { ID } from 'appwrite';
Create a login page
Create or update app/page.js file and add the following code to it.

JavaScript

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
All set
Run your project with npm run dev and open Localhost on Port 3000 in your browser.

Don't forget to add some CSS to suit your 