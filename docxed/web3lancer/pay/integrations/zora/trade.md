Trading Coins
The Coins SDK provides powerful trading functionality through the tradeCoin function, which enables swapping between ETH and ERC20 tokens (including creator coins) using Externally Owned Accounts (EOAs) with permit signatures for secure, gasless approvals.

Overview
The tradeCoin function supports:

ETH ↔ ERC20 token swaps with semi-automatic routing
Creator coin ↔ Creator coin swaps with semi-automatic routing
Content coin ↔ Creator coin swaps with semi-automatic routing
ERC20 ↔ ERC20 token swaps using permit signatures
Permit-based approvals (via permit2) for secure token spending without separate approval transactions
Slippage protection and customizable trade parameters
EOA wallet support with smart wallet support coming soon
Currently, only the Base mainnet network is supported. Plans to add base sepolia are coming soon.

Basic Usage
Import the Function

import { tradeCoin, TradeParameters } from "@zoralabs/coins-sdk";
Trading ETH for Creator Coins

import { parseEther } from "viem";
import { privateKeyToAccount } from "viem/accounts";
 
// Set up your account
const account = privateKeyToAccount("0x...");
 
const tradeParameters: TradeParameters = {
  sell: { type: "eth" },
  buy: {
    type: "erc20",
    address: "0x4e93a01c90f812284f71291a8d1415a904957156", // Creator coin address
  },
  amountIn: parseEther("0.001"), // 0.001 ETH
  slippage: 0.05, // 5% slippage tolerance
  sender: account.address,
};
 
const receipt = await tradeCoin({
  tradeParameters,
  walletClient,
  account,
  publicClient,
});
Trading Creator Coin for ETH

const tradeParameters: TradeParameters = {
  sell: { 
    type: "erc20", 
    address: "0x4e93a01c90f812284f71291a8d1415a904957156" // Creator coin address
  },
  buy: { type: "eth" },
  amountIn: parseEther("100"), // 100 tokens (adjust decimals as needed)
  slippage: 0.15, // 15% slippage tolerance
  sender: account.address,
};
 
const receipt = await tradeCoin({
  tradeParameters,
  walletClient,
  account,
  publicClient,
});
Trading USDC for Creator Coin (with Permits)
When trading ERC20 tokens, the function automatically handles permit signatures for secure approvals:


import { TradeParameters, tradeCoin } from "@zoralabs/coins-sdk";
 
const tradeParameters: TradeParameters = {
  sell: {
    type: "erc20",
    address: "0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913", // USDC address
  },
  buy: {
    type: "erc20", 
    address: "0x9b13358e3a023507e7046c18f508a958cda75f54", // @jacob creator coin
  },
  amountIn: BigInt(4 * 10 ** 6), // 4 USDC (6 decimals)
  slippage: 0.05, // 5% slippage
  sender: account.address,
};
 
const receipt = await tradeCoin({
  tradeParameters,
  walletClient,
  account,
  publicClient,
});
Trading Between ERC20 Tokens
Only creator coins, USDC, and ZORA are supported for trading between ERC20 tokens. Content coins can currently be traded when the creator is the same but the current flow requires selling for ZORA, USDC, or ETH, then buying the new coin separately.


import { TradeParameters, tradeCoin } from "@zoralabs/coins-sdk";
 
const tradeParameters: TradeParameters = {
  sell: {
    type: "erc20",
    address: "0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913", // USDC
  },
  buy: {
    type: "erc20",
    address: "0x9b13358e3a023507e7046c18f508a958cda75f54", // @jacob creator coin
  },
  amountIn: BigInt(4 * 10 ** 6), // 4 USDC (6 decimals)
  slippage: 0.04, // 4% slippage
  sender: account.address,
};
 
const receipt = await tradeCoin({
  tradeParameters,
  walletClient,
  account,
  publicClient,
});
Disabling Transaction Validation
By default, tradeCoin validates transactions before execution. You can disable this for faster execution:


const receipt = await tradeCoin({
  tradeParameters,
  walletClient,
  account,
  publicClient,
  validateTransaction: false, // Skip validation and gas estimation
});
Function Signature

async function tradeCoin({
  tradeParameters,
  walletClient,
  account,
  publicClient,
  validateTransaction = true,
}: {
  tradeParameters: TradeParameters;
  walletClient: WalletClient;
  account: Account;
  publicClient: GenericPublicClient;
  validateTransaction?: boolean;
})
Trade Parameters
The TradeParameters interface supports the following options:


type TradeParameters = {
  sell: TradeCurrency; // Token to sell
  buy: TradeCurrency; // Token to buy
  amountIn: bigint; // Amount to sell (in token's smallest unit)
  slippage?: number; // Slippage tolerance (0-0.99, default: 5%)
  sender: Address; // Sender address (can be smart wallet or EOA)
  signer?: Address; // Must be EOA, defaults to sender if blank
  recipient?: Address; // Recipient address (optional, defaults to sender)
  signatures?: SignatureWithPermit<PermitStringAmounts>[]; // Pre-signed permits (optional)
  permitActiveSeconds?: number; // Permit validity duration (optional, defaults to 20 minutes)
};
 
// Trade currency can be ETH or an ERC20 token
type TradeCurrency = 
  | { type: "eth" }
  | { type: "erc20"; address: Address };
How Permits Work
When trading ERC20 tokens, tradeCoin automatically:

Checks existing allowances for the token being sold
Requests approval if insufficient allowance exists
Generates permit signatures using EIP-2612 standard
Signs typed data with your EOA for secure, gasless approvals
Includes permits in the trade transaction
This eliminates the need for separate approval transactions while maintaining security.

Direct ETH Calls with createTradeCall
For direct ETH trades without the full tradeCoin workflow, you can use createTradeCall:


import { createTradeCall } from "@zoralabs/coins-sdk";
 
// Get trade call data without executing
const quote = await createTradeCall(tradeParameters);
 
const walletClient = createWalletClient({/* ... */});
 
// Execute the call directly
const tx = await walletClient.sendTransaction({
  to: quote.call.target as Address,
  data: quote.call.data as Hex,
  value: BigInt(quote.call.value),
  account,
});
This is useful when you need more control over transaction execution or want to batch multiple operations.

This flow does not currently support the permits feature for selling ERC20 tokens.

Error Handling
The function validates parameters and throws descriptive errors:


// Invalid slippage (must be less than 1.0)
const invalidSlippage: TradeParameters = {
  // ... other parameters
  slippage: 1.5, // > 1.0
};
// Throws: "Slippage must be less than 1, max 0.99"
 
// Zero amount
const zeroAmount: TradeParameters = {
  // ... other parameters
  amountIn: BigInt(0),
};
// Throws: "Amount in must be greater than 0"
Smart Wallet Support
Smart wallet support is coming soon. Currently, the SDK works with:

✅ EOA wallets (MetaMask, WalletConnect, etc.)
🔄 Smart wallets (coming soon)
Best Practices
Set appropriate slippage based on market conditions and token liquidity
Use permit signatures for ERC20 trades to save gas on approvals
Validate transactions by keeping validateTransaction: true (default)
Handle errors gracefully with proper try-catch blocks
Test with small amounts before executing large trades
Account for token decimals when setting amountIn values
Network Support
Currently only supports Base mainnet.