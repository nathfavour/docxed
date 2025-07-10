Coin Queries
The Coins SDK provides a comprehensive set of query functions to fetch information about coins, profiles, and related data. This page details the available query functions, their parameters, and usage examples.

Overview
The query functions are divided into several categories:

Coin Queries: Retrieve information on specific coins such as metadata, market data, and comments
Profile Queries: Retrieve information associated with users/wallets like holdings and activity
Explore Queries: Retrieve information about all coins (new, trending, top gainers, etc.)
Onchain Queries: Fetch data directly from the blockchain (API strongly recommended, only recommended for advanced users)
API Key Setup
Before using the API queries in a high-usage production environment, you'll need to set up an API key:


import { setApiKey } from "@zoralabs/coins-sdk";
 
// Set up your API key
setApiKey("your-api-key-here");
To set up an API key:

Create an account on Zora
Navigate to Zora Developer Settings
Create an API key
Use the API key in the SDK
Non-Javascript Usage
The Coins SDK API can be used in any language that supports HTTP requests.

Full API documentation can be found on the SDK site with a dynamic editor and an openapi definition file.

It's strongly recommended to use the authentication header for api-key with all requests to this API.

The paths and function names map directly to the SDK functions which can be used to document the usage of these API paths.