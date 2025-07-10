Profile Queries
The Coins SDK provides several query functions to retrieve information about user profiles and their coin holdings. This page details the available profile query functions, their parameters, and includes usage examples.

Queries:

getProfile
getProfileBalances
Available Queries
getProfile
The getProfile function retrieves detailed information about a user's profile, including their handle, display name, bio, and profile image.

Parameters

type GetProfileParams = {
  identifier: string;   // The user's wallet address or zora handle
};
Usage Example

import { getProfile } from "@zoralabs/coins-sdk";
 
async function fetchUserProfile() {
  const response = await getProfile({
    identifier: "0xUserWalletAddress",
  });
  
  // TODO: fix profile graphql types
  const profile: any = response?.data?.profile;
  
  if (profile) {
    console.log("Profile Details:");
    console.log("- Handle:", profile.handle);
    console.log("- Display Name:", profile.displayName);
    console.log("- Bio:", profile.bio);
    
    // Access profile image if available
    if (profile.avatar?.medium) {
      console.log("- Profile Image:", profile.avatar.medium);
    }
    
    // Access social links if available
    if (profile?.linkedWallets && profile?.linkedWallets?.edges?.length || 0 > 0) {
      console.log("Linked Wallets:");
      profile?.linkedWallets?.edges?.forEach((link: any) => {
        console.log(`- ${link?.node?.walletType}: ${link?.node?.walletAddress}`);
      });
    }
  } else {
    console.log("Profile not found or user has not set up a profile");
  }
  
  return response;
}
Response Structure
The response includes a profile object with the following properties:


type ProfileData = {
  profile?: {
    address?: string;         // User's wallet address
    handle?: string;          // Username/handle
    displayName?: string;     // User's display name
    bio?: string;             // User's biography/description
    joinedAt?: string;        // When the user joined
    profileImage?: {          // Profile image data
      small?: string;         // Small version of profile image
      medium?: string;        // Medium version of profile image
      blurhash?: string;      // Blurhash for image loading
    };
    linkedWallets?: Array<{     // Connected social accounts
      type?: string;
      url?: string;
    }>;
  }
}
getProfileBalances
The getProfileBalances function retrieves a list of all coin balances held by a specific user, including the coin details and current value.

Parameters

type GetProfileBalancesParams = {
  address: string;    // The user's wallet address
  after?: string;     // Optional: Pagination cursor for fetching next page
  count?: number;     // Optional: Number of balances to return per page
};
Usage Example

import { getProfileBalances } from "@zoralabs/coins-sdk";
 
async function fetchUserBalances() {
  const response = await getProfileBalances({
    identifier: "0xUserWalletAddress", // Can also be zora user profile handle
    count: 20,        // Optional: number of balances per page
    after: undefined, // Optional: for pagination
  });
 
  const profile: any = response.data?.profile;
  
  console.log(`Found ${profile.coinBalances?.length || 0} coin balances`);
  
  profile.coinBalances?.forEach((balance: any, index: number) => {
    console.log(balance)
  });
  
  // For pagination
  if (profile.coinBalances?.pageInfo?.endCursor) {
    console.log("Next page cursor:", profile.coinBalances?.pageInfo?.endCursor);
  }
  
  return response;
}
Paginating Through All Balances
If a user holds many coins, you might need to paginate through all of their balances:


import { getProfileBalances } from "@zoralabs/coins-sdk";
 
async function fetchAllUserBalances(userAddress: string) {
  let allBalances: any[] = [];
  let cursor = undefined;
  const pageSize = 20;
  
 
  // Continue fetching until no more pages
  do {
    const response = await getProfileBalances({
      identifier: userAddress, // UserAddress or zora handle
      count: pageSize,
      after: cursor,
    });
 
    const profile: any = response.data?.profile;
    
    // Add balances to our collection
    if (profile && profile.coinBalances) {
      allBalances = [...allBalances, ...profile.coinBalances.edges.map((edge: any) => edge.node)];
    }
    
    // Update cursor for next page
    cursor = profile?.coinBalances?.pageInfo?.endCursor;
    
    // Break if no more results
    if (!cursor || profile?.coinBalances?.edges?.length === 0) {
      break;
    }
    
  } while (true);
  
  console.log(`Fetched ${allBalances.length} total coin balances`);
  return allBalances;
}
Response Structure
The response includes a balances array and pagination information:


type Response = {
  balances?: Array<{
    id?: string;              // Unique identifier for this balance
    token?: {                 // Coin information
      id?: string;            // Coin ID
      name?: string;          // Coin name
      symbol?: string;        // Trading symbol
      address?: string;       // Coin contract address
      chainId?: number;       // Chain ID
      totalSupply?: string;   // Total supply of the coin
      marketCap?: string;     // Current market capitalization
      volume24h?: string;     // 24-hour trading volume
      createdAt?: string;     // Creation timestamp
      uniqueHolders?: number; // Number of unique holders
      media?: {               // Media associated with the coin
        previewImage?: string;
        medium?: string;
        blurhash?: string;
      };
    };
    amount?: {                // Balance amount
      amountRaw?: string;     // Raw amount (in base units)
      amountDecimal?: number; // Decimal representation
    };
    valueUsd?: string;        // Estimated USD value
    timestamp?: string;       // Last updated timestamp
  }>;
  pagination?: {
    cursor?: string;          // Cursor for the next page
  };
}