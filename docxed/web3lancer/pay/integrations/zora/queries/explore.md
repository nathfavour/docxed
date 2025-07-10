Explore Queries
The Coins SDK provides several explore functions to discover coins based on different criteria such as market performance, volume, and recency. These queries are useful for building discovery interfaces, trending sections, and leaderboards.

Queries:
getCoinsTopGainers
getCoinsTopVolume24h
getCoinsMostValuable
getCoinsNew
getCoinsLastTraded
getCoinsLastTradedUnique
Available Explore Queries
getCoinsTopGainers
The getCoinsTopGainers function retrieves coins that have increased the most in market cap over the last 24 hours.

Parameters

type ExploreQueryOptions = {
  after?: string;     // Optional: Pagination cursor for fetching next page
  count?: number;     // Optional: Number of coins to return per page (default: 20)
};
Usage Example

import { getCoinsTopGainers } from "@zoralabs/coins-sdk";
 
async function fetchTopGainers() {
  const response = await getCoinsTopGainers({
    count: 10,        // Optional: number of coins per page
    after: undefined, // Optional: for pagination
  });
 
  const tokens = response.data?.exploreList?.edges?.map((edge: any) => edge.node);
  
  console.log(`Top Gainers (${tokens?.length || 0} coins):`);
  
  tokens?.forEach((coin: any, index: number) => {
    const percentChange = coin.marketCapDelta24h 
      ? `${parseFloat(coin.marketCapDelta24h).toFixed(2)}%` 
      : "N/A";
    
    console.log(`${index + 1}. ${coin.name} (${coin.symbol})`);
    console.log(`   24h Change: ${percentChange}`);
    console.log(`   Market Cap: ${coin.marketCap}`);
    console.log(`   Volume 24h: ${coin.volume24h}`);
    console.log('-----------------------------------');
  });
  
  // For pagination
  if (response.data?.exploreList?.pageInfo?.endCursor) {
    console.log("Next page cursor:", response.data?.exploreList?.pageInfo?.endCursor);
  }
  
  return response;
}
getCoinsTopVolume24h
The getCoinsTopVolume24h function retrieves coins with the highest trading volume in the last 24 hours.

Usage Example

import { getCoinsTopVolume24h } from "@zoralabs/coins-sdk";
 
async function fetchTopVolumeCoins() {
  const response = await getCoinsTopVolume24h({
    count: 10,        // Optional: number of coins per page
    after: undefined, // Optional: for pagination
  });
 
  const tokens = response.data?.exploreList?.edges?.map((edge: any) => edge.node);
  
  console.log(`Top Volume Coins (${tokens?.length || 0} coins):`);
  
  tokens?.forEach((coin: any, index: number) => {
    console.log(`${index + 1}. ${coin.name} (${coin.symbol})`);
    console.log(`   Volume 24h: ${coin.volume24h}`);
    console.log(`   Market Cap: ${coin.marketCap}`);
    console.log(`   Holders: ${coin.uniqueHolders}`);
    console.log('-----------------------------------');
  });
  
  // For pagination
  if (response.data?.exploreList?.pageInfo?.endCursor) {
    console.log("Next page cursor:", response.data?.exploreList?.pageInfo?.endCursor);
  }
  
  return response;
}
getCoinsMostValuable
The getCoinsMostValuable function retrieves coins with the highest market capitalization.

Usage Example

import { getCoinsMostValuable } from "@zoralabs/coins-sdk";
 
async function fetchMostValuableCoins() {
  const response = await getCoinsMostValuable({
    count: 10,        // Optional: number of coins per page
    after: undefined, // Optional: for pagination
  });
  
  console.log(`Most Valuable Coins (${response.data?.exploreList?.edges?.length || 0} coins):`);
  
  response.data?.exploreList?.edges?.forEach((coin: any, index: number) => {
    console.log(`${index + 1}. ${coin.node.name} (${coin.node.symbol})`);
    console.log(`   Market Cap: ${coin.node.marketCap}`);
    console.log(`   Volume 24h: ${coin.node.volume24h}`);
    console.log(`   Created: ${coin.node.createdAt}`);
    console.log('-----------------------------------');
  });
  
  // For pagination
  if (response.data?.exploreList?.pageInfo?.endCursor) {
    console.log("Next page cursor:", response.data?.exploreList?.pageInfo?.endCursor);
  }
  
  return response;
}
getCoinsNew
The getCoinsNew function retrieves the most recently created coins.

Usage Example

import { getCoinsNew } from "@zoralabs/coins-sdk";
 
async function fetchNewCoins() {
  const response = await getCoinsNew({
    count: 10,        // Optional: number of coins per page
    after: undefined, // Optional: for pagination
  });
  
  console.log(`New Coins (${response.data?.exploreList?.edges?.length || 0} coins):`);
  
  response.data?.exploreList?.edges?.forEach((coin: any, index: number) => {
    // Format the creation date for better readability
    const creationDate = new Date(coin.node.createdAt || "");
    const formattedDate = creationDate.toLocaleString();
    
    console.log(`${index + 1}. ${coin.node.name} (${coin.node.symbol})`);
    console.log(`   Created: ${formattedDate}`);
    console.log(`   Creator: ${coin.node.creatorAddress}`);
    console.log(`   Market Cap: ${coin.node.marketCap}`);
    console.log('-----------------------------------');
  });
  
  // For pagination
  if (response.data?.exploreList?.pageInfo?.endCursor) {
    console.log("Next page cursor:", response.data?.exploreList?.pageInfo?.endCursor);
  }
  
  return response;
}
getCoinsLastTraded
The getCoinsLastTraded function retrieves coins that have been traded most recently.

Usage Example

import { getCoinsLastTraded } from "@zoralabs/coins-sdk";
 
async function fetchLastTradedCoins() {
  const response = await getCoinsLastTraded({
    count: 10,        // Optional: number of coins per page
    after: undefined, // Optional: for pagination
  });
  
  console.log(`Recently Traded Coins (${response.data?.exploreList?.edges?.length || 0} coins):`);
  
  response.data?.exploreList?.edges?.forEach((coin: any, index: number) => {
    console.log(`${index + 1}. ${coin.node.name} (${coin.node.symbol})`);
    console.log(`   Market Cap: ${coin.node.marketCap}`);
    console.log(`   Volume 24h: ${coin.node.volume24h}`);
    console.log('-----------------------------------');
  });
  
  // For pagination
  if (response.data?.exploreList?.pageInfo?.endCursor) {
    console.log("Next page cursor:", response.data?.exploreList?.pageInfo?.endCursor);
  }
  
  return response;
}
getCoinsLastTradedUnique
The getCoinsLastTradedUnique function retrieves coins that have been traded by unique traders most recently.

Usage Example

import { getCoinsLastTradedUnique } from "@zoralabs/coins-sdk";
 
async function fetchLastTradedUniqueCoins() {
  const response = await getCoinsLastTradedUnique({
    count: 10,        // Optional: number of coins per page
    after: undefined, // Optional: for pagination
  });
  
  console.log(`Recently Traded Coins by Unique Traders (${response.data?.exploreList?.edges?.length || 0} coins):`);
  
  response.data?.exploreList?.edges?.forEach((coin: any, index: number) => {
    console.log(`${index + 1}. ${coin.node.name} (${coin.node.symbol})`);
    console.log(`   Market Cap: ${coin.node.marketCap}`);
    console.log(`   Volume 24h: ${coin.node.volume24h}`);
    console.log(`   Unique Holders: ${coin.node.uniqueHolders}`);
    console.log('-----------------------------------');
  });
  
  // For pagination
  if (response.data?.exploreList?.pageInfo?.endCursor) {
    console.log("Next page cursor:", response.data?.exploreList?.pageInfo?.endCursor);
  }
  
  return response;
}
Response Structure
All explore queries return a similar response structure:


type Response = {
  zora20Tokens?: Array<{
    // Same structure as the coin object in getCoin response
    id?: string;
    name?: string;
    description?: string;
    address?: string;
    symbol?: string;
    totalSupply?: string;
    totalVolume?: string;
    volume24h?: string;
    createdAt?: string;
    creatorAddress?: string;
    marketCap?: string;
    marketCapDelta24h?: string;
    chainId?: number;
    uniqueHolders?: number;
    // ... other coin properties
  }>;
  pagination?: {
    cursor?: string;  // Cursor for the next page
  };
}
Pagination
Most explore queries support pagination to handle large result sets. Here's an example of how to implement pagination to fetch all coins that match a particular explore query:


import { getCoinsTopGainers } from "@zoralabs/coins-sdk";
 
async function fetchAllTopGainers() {
  let allCoins: any[] = [];
  let cursor = undefined;
  const pageSize = 20;
  
  // Continue fetching until no more pages
  do {
    const response = await getCoinsTopGainers({
      count: pageSize,
      after: cursor,
    });
    
    // Add coins to our collection
    if (response.data?.exploreList && response.data?.exploreList?.edges?.length || 0 > 0) {
      allCoins = [...allCoins, ...(response.data?.exploreList?.edges?.map((edge: any) => edge.node) || [])];
    }
    
    // Update cursor for next page
    cursor = response.data?.exploreList?.pageInfo?.endCursor;
    
    // Break if no more results
    if (!cursor || response.data?.exploreList?.edges?.length === 0) {
      break;
    }
    
  } while (true);
  
  console.log(`Fetched ${allCoins.length} total top gaining coins`);
  return allCoins;
}