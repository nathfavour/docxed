
Creating Coins
The Coins SDK provides a set of functions to create new coins on the Zora protocol. This page details the process of creating a new coin, the parameters involved, and code examples to help you get started.

Overview
Creating a coin involves deploying a new ERC20 contract with the necessary Zora protocol integrations. The createCoin function handles this process and provides access to the deployed contract.

Parameters
To create a new coin, you'll need to provide the following parameters:


import { Address } from "viem";
import { DeployCurrency, InitialPurchaseCurrency, ValidMetadataURI } from "@zoralabs/coins-sdk";
 
type CreateCoinArgs = {
  name: string;             // The name of the coin (e.g., "My Awesome Coin")
  symbol: string;           // The trading symbol for the coin (e.g., "MAC")
  uri: ValidMetadataURI;    // Metadata URI (an IPFS URI is recommended)
  chainId?: number;         // The chain ID (defaults to base mainnet)
  owners?: Address[];       // Optional array of owner addresses, defaults to [payoutRecipient]
  payoutRecipient: Address; // Address that receives creator earnings
  platformReferrer?: Address; // Optional platform referrer address, earns referral fees
  // DeployCurrency.ETH or DeployCurrency.ZORA
  currency?: DeployCurrency; // Optional currency for trading (ETH or ZORA)
}
Metadata
The uri parameter structure is described in the Metadata section.

One should utilize our Metadata Builder tool to create a valid metadata URI.

Example metadata builder usage:


import { Address } from "viem";
import { createMetadataBuilder, DeployCurrency, createZoraUploaderForCreator } from "@zoralabs/coins-sdk";
 
const creatorAddress = "0xYourAddress" as Address;
 
const { createMetadataParameters } = await createMetadataBuilder()
  .withName("Test Base ZORA Coin")
  .withSymbol("TBZC")
  .withDescription("Test Description")
  .withImage(new File(['FILE'], "test.png", { type: "image/png" }))
  .upload(createZoraUploaderForCreator(creatorAddress as Address));
 
const createCoinArgs = {
  ...createMetadataParameters,
  payoutRecipient: "0xYourAddress" as Address,
  currency: DeployCurrency.ZORA,
};
Currency
The currency parameter determines which token will be used for the trading pair.


enum DeployCurrency {
  ZORA = 1,
  ETH = 2,
}
By default:

On Base mainnet, ZORA is used as the default currency
On other chains, ETH is used as the default currency
Note that ZORA is not supported on Base Sepolia.

Initial Supply Purchase
The initialPurchase parameter allows you to purchase an initial supply of your coin at the time of creation. This helps to seed the liquidity pool with some initial value.


enum InitialPurchaseCurrency {
  ZORA = 1,
  ETH = 2,
  USDC = 3,
}
Currently, initial purchase is only supported on Base mainnet with ETH as the input currency and the coin denominated in ZORA.

The system will swap ETH to ZORA through a multi-hop swap (ETH → USDC → ZORA) to establish initial liquidity and provide a better ZORA price than using the WETH pool directly.

Parameters:

currency: The currency to use for the initial purchase (currently only ETH is supported)
amount: The amount of ETH to use for the initial purchase (in wei)
amountOutMinimum: Optional minimum amount of tokens to receive (slippage protection)
Initial supply purchase only works on Base mainnet for now.

Chain ID
The chainId parameter defaults to Base mainnet. Make sure it matches the chain you're deploying to.

More Information
Further contract details can be found in the Factory Contract section and the Coin Contract section.

Usage
Basic Creation

import { createCoin, DeployCurrency, ValidMetadataURI } from "@zoralabs/coins-sdk";
import { Hex, createWalletClient, createPublicClient, http, Address } from "viem";
import { base } from "viem/chains";
 
// Set up viem clients
const publicClient = createPublicClient({
  chain: base,
  transport: http("<RPC_URL>"),
});
 
const walletClient = createWalletClient({
  account: "0x<YOUR_ACCOUNT>" as Hex,
  chain: base,
  transport: http("<RPC_URL>"),
});
 
// Define coin parameters
const coinParams = {
  name: "My Awesome Coin",
  symbol: "MAC",
  uri: "ipfs://bafybeigoxzqzbnxsn35vq7lls3ljxdcwjafxvbvkivprsodzrptpiguysy" as ValidMetadataURI,
  payoutRecipient: "0xYourAddress" as Address,
  platformReferrer: "0xOptionalPlatformReferrerAddress" as Address, // Optional
  chainId: base.id, // Optional: defaults to base.id
  currency: DeployCurrency.ZORA, // Optional: ZORA or ETH
};
 
// Create the coin
async function createMyCoin() {
  try {
    const result = await createCoin(coinParams, walletClient, publicClient, {
      gasMultiplier: 120, // Optional: Add 20% buffer to gas (defaults to 100%)
      // account: customAccount, // Optional: Override the wallet client account
    });
    
    console.log("Transaction hash:", result.hash);
    console.log("Coin address:", result.address);
    console.log("Deployment details:", result.deployment);
    
    return result;
  } catch (error) {
    console.error("Error creating coin:", error);
    throw error;
  }
}
Using with WAGMI
If you're using WAGMI in your frontend application, you can use the lower-level createCoinCall function:


import * as React from "react";
import { createCoinCall, DeployCurrency, InitialPurchaseCurrency, ValidMetadataURI } from "@zoralabs/coins-sdk";
import { Address, parseEther } from "viem";
import { useWriteContract, useSimulateContract } from "wagmi";
import { base } from "viem/chains";
 
// Define coin parameters
const coinParams = {
  name: "My Awesome Coin",
  symbol: "MAC",
  uri: "ipfs://bafybeigoxzqzbnxsn35vq7lls3ljxdcwjafxvbvkivprsodzrptpiguysy" as ValidMetadataURI,
  payoutRecipient: "0xYourAddress" as Address,
  platformReferrer: "0xOptionalPlatformReferrerAddress" as Address,
  chainId: base.id, // Optional: defaults to base.id
  currency: DeployCurrency.ZORA, // Optional: ZORA or ETH
  initialPurchase: { // Optional: Purchase initial supply during creation
    currency: InitialPurchaseCurrency.ETH,
    amount: parseEther("0.01"), // 0.01 ETH in wei
  },
};
 
// Create configuration for wagmi
const contractCallParams = await createCoinCall(coinParams);
 
// In your component
function CreateCoinComponent() {
  const { data: writeConfig } = useSimulateContract({
    ...contractCallParams,
  });
  
  const { writeContract, status } = useWriteContract(writeConfig);
  
  return (
    <button disabled={!writeContract || status !== 'pending'} onClick={() => writeContract?.()}>
      {status === 'pending' ? 'Creating...' : 'Create Coin'}
    </button>
  );
}
Metadata Validation
The SDK validates the metadata URI content before creating the coin. The uri parameter is expected to be a ValidMetadataURI type, which means it should point to valid metadata following the structure described in the Metadata section.


import { validateMetadataURIContent } from "@zoralabs/coins-sdk";
 
// This will throw an error if the metadata is not valid
await validateMetadataURIContent(uri);
Getting Coin Address from Transaction Receipt
Once the transaction is complete, you can extract the deployed coin address from the transaction receipt logs using the getCoinCreateFromLogs function:


import { getCoinCreateFromLogs } from "@zoralabs/coins-sdk";
 
// Assuming you have a transaction receipt
const coinDeployment = getCoinCreateFromLogs(receipt);
console.log("Deployed coin address:", coinDeployment?.coin);