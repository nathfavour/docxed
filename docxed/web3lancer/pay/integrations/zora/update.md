
Updating Coins
The Coins SDK provides functionality to update existing coin properties. This page details how to update a coin's metadata URI and other properties.

Overview
After creating a coin, you might need to update various properties such as the metadata URI or payout recipient. The SDK provides functions to handle these updates securely.

Updating Coin URI
The most common update you might want to make is changing a coin's metadata URI.

Access Control
It's important to note that update functions like updateCoinURI and setPayoutRecipient can only be called by the coin's owner(s). If the account used to sign the transaction is not an owner, the transaction will revert with an OnlyOwner error.

URI Requirements
The newURI parameter must meet these requirements:

It is recommended to point to an ipfs://, https:// is also supported but not recommended.
It should point to a valid metadata JSON file.
If these requirements are not met, the update will fail with an error message.

Update Coin URI Parameters

import { Address } from "viem";
 
type UpdateCoinURIArgs = {
  coin: Address;    // The coin contract address
  newURI: string;   // The new URI for the coin metadata (must start with "ipfs://")
};
Basic URI Update

import { updateCoinURI } from "@zoralabs/coins-sdk";
import { createWalletClient, createPublicClient, http } from "viem";
import { base } from "viem/chains";
import { Address, Hex } from "viem";
 
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
 
// Define update parameters
const updateParams = {
  coin: "0xCoinContractAddress" as Address,
  newURI: "ipfs://bafkreihz5knnvvsvmaxlpw3kout23te6yboquyvvs72wzfulgrkwj7r7dm",
};
 
// Execute the update
async function updateCoinMetadata() {
  const result = await updateCoinURI(updateParams, walletClient, publicClient);
  
  console.log("Transaction hash:", result.hash);
  console.log("URI updated event:", result.uriUpdated);
  
  return result;
}
Using with WAGMI
If you're using WAGMI in your frontend application, you can use the lower-level updateCoinURICall function:


import { updateCoinURICall } from "@zoralabs/coins-sdk";
import { useContractWrite, useSimulateContract } from "wagmi";
 
// Define update parameters
const updateParams = {
  coin: "0xCoinContractAddress",
  newURI: "ipfs://bafkreihz5knnvvsvmaxlpw3kout23te6yboquyvvs72wzfulgrkwj7r7dm",
};
 
// Create configuration for wagmi
const contractCallParams = updateCoinURICall(updateParams);
 
// In your component
function UpdateCoinURIComponent() {
  const { data: config } = useSimulateContract({
    ...contractCallParams,
  });
  
  const { data, status, writeContract } = useContractWrite(config);
  
  return (
    <button disabled={!writeContract || status !== 'pending'} onClick={() => writeContract?.()}>
      {status === 'pending' ? 'Updating...' : 'Update Coin URI'}
    </button>
  );
}
Other Coin Updates
Updating Payout Recipient
After coin creation, the payout recipient (who receives creator rewards) can be updated using the SDK's updatePayoutRecipient function:


import { updatePayoutRecipient } from "@zoralabs/coins-sdk";
import { Address, Hex, createWalletClient, createPublicClient, http } from "viem";
import { base } from "viem/chains";
 
// Set up viem clients
const publicClient = createPublicClient({
  chain: base,
  transport: http("<RPC_URL>"),
});
 
const walletClient = createWalletClient({
  account: "0x<YOUR_ACCOUNT>" as Hex, // Must be an owner of the coin
  chain: base,
  transport: http("<RPC_URL>"),
});
 
// Update the payout recipient
const result = await updatePayoutRecipient({
  coin: "0xCoinContractAddress" as Address,
  newPayoutRecipient: "0xNewPayoutRecipientAddress" as Address,
}, walletClient, publicClient);
 
console.log("Transaction hash:", result.hash);
console.log("Receipt:", result.receipt);
Note: Only owners of the coin can update the payout recipient. If the account used to sign the transaction is not an owner, the transaction will revert with an OnlyOwner error.