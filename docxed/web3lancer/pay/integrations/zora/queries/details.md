Coin Queries
The Coins SDK provides several query functions to fetch information about specific coins. This page details the available coin query functions, their parameters, and includes usage examples.

Available Queries
getCoin
The getCoin function retrieves detailed information about a specific coin, including its metadata, market data, and creator information.

Parameters

type GetCoinParams = {
  address: string;   // The coin contract address
  chain?: number;    // Optional: The chain ID (defaults to Base: 8453)
};
Usage Example

import { getCoin } from "@zoralabs/coins-sdk";
import { base } from "viem/chains";
 
export async function fetchSingleCoin() {
  const response = await getCoin({
    address: "0x445e9c0a296068dc4257767b5ed354b77cf513de",
    chain: base.id, // Optional: Base chain set by default
  });
 
  const coin = response.data?.zora20Token;
 
  if (coin) {
    console.log("Coin Details:");
    console.log("- Name:", coin.name);
    console.log("- Symbol:", coin.symbol);
    console.log("- Description:", coin.description);
    console.log("- Total Supply:", coin.totalSupply);
    console.log("- Market Cap:", coin.marketCap);
    console.log("- 24h Volume:", coin.volume24h);
    console.log("- Creator:", coin.creatorAddress);
    console.log("- Created At:", coin.createdAt);
    console.log("- Unique Holders:", coin.uniqueHolders);
 
    // Access media if available
    if (coin.mediaContent?.previewImage) {
      console.log("- Preview Image:", coin.mediaContent.previewImage);
    }
  }
 
  return response;
}
Response Structure
The response includes a data object containing a zora20Token object with the following properties:


import { GetCoinResponse } from "@zoralabs/coins-sdk";
 
// The Zora20Token type is imported from the SDK's generated types.
// It includes detailed information about a specific coin, such as its metadata, market data, and creator information.
type 
Zora20Token = GetCoinResponse['zora20Token'];
 
 
 
 
 
//
getCoins
The getCoins function retrieves information about multiple coins at once, useful for batch processing or displaying multiple coins.

Parameters

type GetCoinsParams = {
  coins: {
    collectionAddress: string;
    chainId: number;
  }[]
};
Usage Example

import { getCoins } from "@zoralabs/coins-sdk";
import { base } from "viem/chains";
 
export async function fetchMultipleCoins() {
  const response = await getCoins({
    coins: [
      {
        chainId: base.id,
        collectionAddress: "0xFirstCoinAddress",
      },
      {
        chainId: base.id,
        collectionAddress: "0xSecondCoinAddress",
      },
      {
        chainId: base.id,
        collectionAddress: "0xThirdCoinAddress",
      },
    ],
  });
 
  // Process each coin in the response
  response.data?.zora20Tokens?.forEach((coin: any, index: number) => {
    console.log(`Coin ${index + 1}: ${coin.name} (${coin.symbol})`);
    console.log(`- Market Cap: ${coin.marketCap}`);
    console.log(`- 24h Volume: ${coin.volume24h}`);
    console.log(`- Holders: ${coin.uniqueHolders}`);
    console.log("-----------------------------------");
  });
 
  return response;
}
Response Structure
The response includes a zora20Tokens array containing objects with the same structure as the zora20Token object in the getCoin response.

getCoinComments
The getCoinComments function retrieves comments associated with a specific coin, useful for displaying community engagement.

Parameters

type GetCoinCommentsParams = {
  address: string;    // The coin contract address
  chain?: number;     // Optional: The chain ID (defaults to Base: 8453)
  after?: string;     // Optional: Pagination cursor for fetching next page
  count?: number;     // Optional: Number of comments to return per page
};
Usage Example

import { getCoinComments } from "@zoralabs/coins-sdk";
import { Address } from "viem";
 
export async function fetchCoinComments() {
  const response = await getCoinComments({
    address: "0xCoinContractAddress" as Address,
    chain: 8453, // Optional: Base chain
    after: undefined, // Optional: for pagination
    count: 20, // Optional: number of comments per page
  });
 
  // Process comments
  console.log(
    `Found ${response.data?.zora20Token?.zoraComments?.edges?.length || 0} comments`,
  );
 
  response.data?.zora20Token?.zoraComments?.edges?.forEach(
    (edge, index: number) => {
      console.log(`Comment ${index + 1}:`);
      console.log(
        `- Author: ${edge.node?.userProfile?.handle || edge.node?.userAddress}`,
      );
      console.log(`- Text: ${edge.node?.comment}`);
      console.log(`- Created At: ${edge.node?.timestamp}`);
 
      edge.node?.replies?.edges?.forEach((reply: any) => {
        console.log(`- Reply: ${reply.node.text}`);
      });
 
      console.log("-----------------------------------");
    },
  );
 
  // For pagination
  if (response.data?.zora20Token?.zoraComments?.pageInfo?.endCursor) {
    console.log(
      "Next page cursor:",
      response.data?.zora20Token?.zoraComments?.pageInfo?.endCursor,
    );
  }
 
  return response;
}
Paginating Through All Comments
To fetch all comments for a coin, you can use pagination:


import { getCoinComments, GetCoinCommentsResponse } from "@zoralabs/coins-sdk";
 
export async function fetchAllCoinComments(coinAddress: string) {
  let allComments: NonNullable<
    NonNullable<
      NonNullable<GetCoinCommentsResponse["zora20Token"]>["zoraComments"]
    >["edges"]
  > = [];
  let cursor = undefined;
  const pageSize = 20;
 
  // Continue fetching until no more pages
  do {
    const response = await getCoinComments({
      address: coinAddress,
      count: pageSize,
      after: cursor,
    });
 
    // Add comments to our collection
    if (
      response.data?.zora20Token?.zoraComments?.edges &&
      response.data?.zora20Token?.zoraComments?.edges.length > 0
    ) {
      allComments = [
        ...allComments,
        ...response.data?.zora20Token?.zoraComments?.edges,
      ];
    }
 
    // Update cursor for next page
    cursor = response.data?.zora20Token?.zoraComments?.pageInfo?.endCursor;
 
    // Break if no more results
    if (
      !cursor ||
      response.data?.zora20Token?.zoraComments?.edges?.length === 0
    ) {
      break;
    }
  } while (true);
 
  console.log(`Fetched ${allComments.length} total comments`);
  return allComments;
}
Response Structure
The response includes a comments array and pagination information:

Error Handling
All query functions follow the same error handling pattern. When an error occurs, the promise is rejected with an error object that includes details about what went wrong.


import { Address } from "viem";
import { getCoin } from "@zoralabs/coins-sdk";
 
try {
  const response = await getCoin({ address: "0xCoinAddress" as Address });
  // Process response...
  console.log(response);
} catch (error: any) {
  if (error.status === 404) {
    console.error("Coin not found");
  } else if (error.status === 401) {
    console.error("API key invalid or missing");
  } else {
    console.error("Unexpected error:", error.message);
  }
}