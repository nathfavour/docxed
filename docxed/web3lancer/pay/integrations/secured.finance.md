⛽
Fixed-Rate Lending SDK
Documentation for the Fixed-Rate Lending SDK

The Fixed-Rate Lending SDK is a comprehensive toolkit for developers to integrate and interact with the Secured Finance Fixed-Rate Lending protocol.

Overview
The Fixed-Rate Lending protocol provides a platform for fixed-rate lending and borrowing through an order book system. The SDK provides a programmatic interface to interact with the protocol, allowing developers to build applications that leverage Fixed-Rate Lending functionality.

How It Works
The Fixed-Rate Lending SDK is built on top of viem and provides a type-safe interface to interact with the Fixed-Rate Lending smart contracts. It abstracts away the complexity of direct contract interactions and provides a more developer-friendly API.

Installation
The Fixed-Rate Lending SDK packages are hosted on GitHub Packages registry, not the public NPM registry. You'll need to configure your .npmrc file to access them:

Copy
# Add this to your .npmrc file
@secured-finance:registry=https://npm.pkg.github.com
//npm.pkg.github.com/:_authToken=YOUR_GITHUB_TOKEN

# Then install the individual packages
npm install @secured-finance/sf-client
npm install @secured-finance/sf-graph-client
npm install @secured-finance/sf-core
For more details on setting up authentication for GitHub Packages, see the GitHub documentation.

Key Components
The Fixed-Rate Lending SDK consists of several packages:

sf-client
The core package for interacting with the Fixed-Rate Lending protocol.

Copy
import { SecuredFinanceClient } from "@secured-finance/sf-client";
sf-graph-client
Utilities for querying the Fixed-Rate Lending subgraph.

Copy
import { GraphClient } from "@secured-finance/sf-graph-client";
sf-core
Core components used across different Secured Finance projects.

Copy
import { Currency, Token } from "@secured-finance/sf-core";
Basic Usage
Connecting to the Protocol
Copy
import { SecuredFinanceClient } from "@secured-finance/sf-client";
import { createPublicClient, createWalletClient, http } from "viem";
import { filecoin } from "viem/chains";

// Connect to the protocol
async function connectToProtocol() {
  // Create viem clients
  const publicClient = createPublicClient({
    chain: filecoin,
    transport: http()
  });
  
  const walletClient = createWalletClient({
    chain: filecoin,
    transport: http()
  });
  
  // Create the Secured Finance client
  const client = new SecuredFinanceClient();
  await client.init(publicClient, walletClient);
  
  return client;
}
Reading Protocol State
Copy
import { Currency } from "@secured-finance/sf-core";

// Get supported currencies
async function getSupportedCurrencies(client) {
  const currencies = await client.getCurrencies();
  console.log("Supported currencies:", currencies);
  return currencies;
}

// Get lending markets
async function getLendingMarkets(client, currency) {
  const maturities = await client.getMaturities(currency);
  console.log("Available maturities:", maturities);
  
  const orderBookDetails = await client.getOrderBookDetailsPerCurrency(currency);
  console.log("Order book details:", orderBookDetails);
  
  return { maturities, orderBookDetails };
}

// Get order book
async function getOrderBook(client, currency, maturity) {
  const orderBookDetail = await client.getOrderBookDetail(currency, maturity);
  console.log("Order book detail:", orderBookDetail);
  
  const lendOrders = await client.getLendOrderBook(currency, maturity, 0, 10);
  console.log("Lend orders:", lendOrders);
  
  const borrowOrders = await client.getBorrowOrderBook(currency, maturity, 0, 10);
  console.log("Borrow orders:", borrowOrders);
  
  return { orderBookDetail, lendOrders, borrowOrders };
}

// Get user positions
async function getUserPositions(client, account) {
  const positions = await client.getPositions(account);
  console.log("User positions:", positions);
  return positions;
}
Order Operations
Copy
import { Currency } from "@secured-finance/sf-core";
import { OrderSide, WalletSource } from "@secured-finance/sf-client";

// Place a lend order
async function placeLendOrder(client, currency, maturity, amount, unitPrice) {
  const tx = await client.placeOrder(
    currency,
    maturity,
    OrderSide.LEND,
    amount,
    WalletSource.METAMASK,
    unitPrice
  );
  
  console.log("Lend order placed:", tx);
  return tx;
}

// Place a borrow order
async function placeBorrowOrder(client, currency, maturity, amount, unitPrice) {
  const tx = await client.placeOrder(
    currency,
    maturity,
    OrderSide.BORROW,
    amount,
    WalletSource.METAMASK,
    unitPrice
  );
  
  console.log("Borrow order placed:", tx);
  return tx;
}

// Cancel an order
async function cancelOrder(client, currency, maturity, orderId) {
  const tx = await client.cancelLendingOrder(currency, maturity, orderId);
  console.log("Order cancelled:", tx);
  return tx;
}
Collateral Management
Copy
// Deposit collateral
async function depositCollateral(client, currency, amount) {
  const tx = await client.depositCollateral(currency, amount);
  console.log("Collateral deposited:", tx);
  return tx;
}

// Get protocol deposit amount
async function getProtocolDepositAmount(client) {
  const depositAmount = await client.getProtocolDepositAmount();
  console.log("Protocol deposit amount:", depositAmount);
  return depositAmount;
}
Position Management
Copy
// Unwind a position
async function unwindPosition(client, currency, maturity) {
  const tx = await client.unwindPosition(currency, maturity);
  console.log("Position unwound:", tx);
  return tx;
}

// Get total present value
async function getTotalPresentValue(client) {
  const presentValue = await client.getTotalPresentValueInBaseCurrency();
  console.log("Total present value:", presentValue);
  return presentValue;
}
Advanced Usage
Using the Graph Client
Copy
import { GraphClient, useQuery } from "@secured-finance/sf-graph-client";
import { useEffect, useState } from "react";

// Create a graph client for a specific network
const graphClient = new GraphClient({
  uri: "https://api.studio.thegraph.com/query/64582/sf-prd-arbitrum-sepolia/version/latest"
});

// Example 1: Simple query using the GraphClient directly
async function queryLendingMarkets() {
  try {
    // Define the query document
    const { lendingMarkets } = await graphClient.query({
      lendingMarkets: {
        id: true,
        currency: {
          id: true,
          symbol: true,
          decimals: true
        },
        maturity: true,
        isReady: true
      }
    });
    
    console.log("Lending markets:", lendingMarkets);
    return lendingMarkets;
  } catch (error) {
    console.error("Error querying lending markets:", error);
    return [];
  }
}

// Example 2: Using the useQuery hook in a React component
function LendingMarketsComponent() {
  // Define the query document
  const queryDocument = {
    lendingMarkets: {
      id: true,
      currency: {
        id: true,
        symbol: true
      },
      maturity: true,
      isReady: true
    }
  };
  
  // Execute the query
  const { data, loading, error } = useQuery(queryDocument, {
    client: graphClient,
    variables: {},
    fetchPolicy: "network-only"
  });
  
  // Handle loading and error states
  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;
  
  // Render the data
  return (
    <div>
      <h2>Available Lending Markets</h2>
      <ul>
        {data?.lendingMarkets?.map(market => (
          <li key={market.id}>
            {market.currency.symbol} - Maturity: {new Date(Number(market.maturity) * 1000).toLocaleDateString()}
          </li>
        ))}
      </ul>
    </div>
  );
}
Price Calculations
Copy
import { getUTCMonthYear } from "@secured-finance/sf-core";

// Convert unit price to APR
function unitPriceToAPR(unitPrice, maturity) {
  const now = Math.floor(Date.now() / 1000);
  const secondsToMaturity = maturity - now;
  const secondsPerYear = 365 * 24 * 60 * 60; // 31,536,000
  const yearsToMaturity = secondsToMaturity / secondsPerYear;
  
  // Different calculation methods based on maturity
  if (yearsToMaturity < 1) {
    // For bonds with maturity less than 1 year (linear calculation)
    return ((10000 / unitPrice) - 1) * (secondsPerYear / secondsToMaturity) * 100;
  } else {
    // For bonds with maturity greater than 1 year (annual compounding)
    return (Math.pow(10000 / unitPrice, 1 / yearsToMaturity) - 1) * 100;
  }
}

// Format maturity date
function formatMaturity(maturity) {
  return getUTCMonthYear(maturity, true);
}

// Calculate order estimation
async function calculateOrderEstimation(client, currency, maturity, account, side, amount, unitPrice) {
  const estimation = await client.getOrderEstimation(
    currency,
    maturity,
    account,
    side,
    amount,
    unitPrice
  );
  
  console.log("Order estimation:", estimation);
  return estimation;
}
FAQ
How do I handle transaction errors?
The SDK throws descriptive error objects that contain information about the failure. Wrap your transactions in try-catch blocks to handle errors gracefully.

Copy
try {
  await client.placeOrder(
    currency,
    maturity,
    OrderSide.LEND,
    amount,
    WalletSource.METAMASK,
    unitPrice
  );
} catch (error) {
  if (error.message.includes("InsufficientDepositAmount")) {
    console.error("Insufficient deposit amount. Deposit more collateral.");
  } else {
    console.error("Transaction failed:", error);
  }
}
How do I convert between unit price and APR?
The conversion between Zero-Coupon Bond prices and APR varies depending on the maturity period. For detailed information, refer to the official documentation on ZC Bond Price to APR conversion.

The calculation is implemented in the Price Calculations section above.

What networks does the SDK support?
The SDK supports all networks where the Fixed-Rate Lending protocol is deployed, including Ethereum, Arbitrum, and Filecoin.

Related Resources
Fixed-Rate Lending Protocol Documentation

Fixed-Rate Lending Subgraph Documentation

GitHub Repository

NPM Package