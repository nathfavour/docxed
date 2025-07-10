Coins SDK
Getting started
The Coins SDK is a library that allows you to create, manage, and query data for Zora coins.

Most features available on the Zora product on web and native mobile apps are available in the SDK and API.

Installation
This SDK is designed to work with both client and server environments running both js and typescript.

The SDK can be installed from NPM by running:

npm
pnpm
yarn
bun

pnpm install @zoralabs/coins-sdk
Additionally, the SDK requires viem to be installed as a peer dependency:

npm
pnpm
yarn
bun

pnpm install viem 
On-chain write operations will not work without viem installed.

Usage
The SDK integrates with fetch and viem for on-chain interactions and writes.

It can be used on both client and server environments.

API Key
The Coins SDK should be used with an API key to prevent rate limiting and unlock all features.

To set up your API key:

Log in or create an account on Zora
Navigate to Developer Settings on Zora
Create an API key
Use the API key in the SDK
The API key can be set using the setApiKey function:


import { setApiKey } from "@zoralabs/coins-sdk";
 
// Set up your API key before making any SDK requests
setApiKey("your-api-key-here");