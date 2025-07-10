Onchain Queries
The Coins SDK provides functions to query coin data directly from the blockchain. These queries are particularly useful in environments where API access is restricted or when you need guaranteed up-to-date information directly from the chain.

Overview
While the API queries provide extensive data with high performance, onchain queries have specific advantages:

Direct blockchain access: Get data straight from the source without intermediaries
No API key required: Only requires access to an RPC node
Real-time data: Always returns the current state of the blockchain
Targeted user balances: Efficiently retrieve a single user's balance without fetching all portfolio data
Available Onchain Queries
getOnchainCoinDetails
The getOnchainCoinDetails function fetches detailed information about a coin directly from the blockchain:


import { getOnchainCoinDetails } from "@zoralabs/coins-sdk";
import { createPublicClient, http } from "viem";
import { base } from "viem/chains";
 
// Set up viem public client
const publicClient = createPublicClient({
  chain: base,
  transport: http("<RPC_URL>"),
});
 
async function fetchCoinDetails() {
  const details = await getOnchainCoinDetails({
    coin: "0xCoinContractAddress",
    user: "0xOptionalUserAddress", // Optional: to get user's balance
    publicClient,
  });
  
  console.log("Coin market cap:", details.marketCap);
  console.log("Coin liquidity:", details.liquidity);
  console.log("Coin pool address:", details.pool);
  console.log("Coin owners:", details.owners);
  console.log("Payout recipient:", details.payoutRecipient);
  
  if (details.balance) {
    console.log("User balance:", details.balance);
  }
  
  return details;
}
Parameters

import { Address, PublicClient } from "viem";
 
type GetOnchainCoinDetailsParams = {
  coin: Address;              // The coin contract address
  user?: Address;             // Optional: User address to fetch balance for
  publicClient: PublicClient; // Viem public client for blockchain calls
};
Response Structure
The function returns a CoinDetailsOnchain object with the following properties:


import { Address } from "viem";
 
interface CoinDetailsOnchain {
  // Basic Coin Information
  address: Address;            // The coin contract address
  decimals: number;            // Token decimals (usually 18)
  name: string;                // Coin name
  symbol: string;              // Coin symbol
  totalSupply: bigint;         // Total supply of the coin
  
  // Pool Information
  pool: Address;               // Uniswap V3 pool address
  liquidity: bigint;           // Current pool liquidity
  marketCap: bigint;           // Current market cap in wei
  
  // Governance
  owners: Address[];           // Array of owner addresses
  payoutRecipient: Address;    // Address receiving creator rewards
  
  // Optional User-specific Information
  balance?: bigint;            // User's balance (only if user parameter provided)
}
Use Cases
Retrieving Individual User Balances
When you need to check a single user's balance without fetching their entire portfolio:


import { Address, formatEther, createPublicClient, http } from "viem";
import { base } from "viem/chains";
import { getOnchainCoinDetails } from "@zoralabs/coins-sdk";
 
const publicClient = createPublicClient({
  chain: base,
  transport: http("<RPC_URL>"),
});
 
const userCoinBalance = await getOnchainCoinDetails({
  coin: "0xCoinAddress" as Address,
  user: "0xUserAddress" as Address,
  publicClient,
});
 
console.log(`User has ${userCoinBalance.balance} tokens (${formatEther(userCoinBalance.balance)} ETH)`);
Backend Services with Limited API Access
Useful for backend services where you might not want to manage API keys:


// In a Node.js backend service
async function getCoinMarketCap(coinAddress) {
  const details = await getOnchainCoinDetails({
    coin: coinAddress,
    publicClient,
  });
  
  return details.marketCap;
}
Parallelism
Onchain queries are asynchronous and can be parallelized to improve performance:

However, the best way to fetch information about multiple coins is to use the getCoins query instead. That query is optimized for fetching multiple coins in a single request and individual or large RPC calls can get quite expensive and slow. Additionally, this API does not support or retrieve metadata.


const coinAddresses = ["0xCoin1", "0xCoin2", "0xCoin3"];
const detailsPromises = coinAddresses.map(address => 
  getOnchainCoinDetails({ coin: address, publicClient })
);
const allCoinDetails = await Promise.all(detailsPromises);