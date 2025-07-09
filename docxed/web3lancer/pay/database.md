## Current Database Structure

### Database: `payd`

#### Collection: `Users`
- `userId` (string, required)
- `email` (string, required)
- `username` (string, required)
- `displayName` (string, required)
- `profileImage` (string)
- `phoneNumber` (string)
- `kycStatus` (string, default: "pending")
- `kycLevel` (integer, default: 0)
- `twoFactorEnabled` (boolean, default: false)
- `isActive` (boolean, default: true)
- `country` (string)
- `timezone` (string)
- `preferredCurrency` (string, default: "USD")
- `createdAt` (datetime, required)
- `updatedAt` (datetime, required)
- Relationships: `wallets`, `transactions`, `paymentRequests`, `securityLogs`, `aPIKeys`

#### Collection: `Wallets`
- `walletId` (string, required)
- `userId` (string, required)
- `walletName` (string, required)
- `walletType` (string, required)
- `blockchain` (string, required)
- `publicKey` (string, required)
- `encryptedPrivateKey` (string)
- `walletAddress` (string, required)
- `derivationPath` (string)
- `isDefault` (boolean, default: false)
- `isActive` (boolean, default: true)
- `balance` (double, default: 0)
- `lastSyncAt` (datetime)
- `createdAt` (datetime, required)
- Relationships: `users`, `transactions`

#### Collection: `Tokens`
- `tokenId` (string, required)
- `symbol` (string, required)
- `name` (string, required)
- `blockchain` (string, required)
- `contractAddress` (string)
- `decimals` (integer, required)
- `logoUrl` (string)
- `isStablecoin` (boolean, default: false)
- `isActive` (boolean, default: true)
- `marketCap` (double, default: 0)
- `currentPrice` (double, default: 0)
- `priceChange24h` (double, default: 0)
- `lastPriceUpdate` (datetime)
- `createdAt` (datetime, required)
- Relationships: `transactions`

#### Collection: `Transactions`
- `transactionId` (string, required)
- `txHash` (string)
- `fromUserId` (string, required)
- `toUserId` (string[])
- `fromWalletId` (string, required)
- `toWalletId` (string)
- `fromAddress` (string, required)
- `toAddress` (string, required)
- `tokenId` (string, required)
- `amount` (string, required)
- `feeAmount` (string, default: "0")
- `gasPrice` (string)
- `gasUsed` (string)
- `status` (string, default: "pending")
- `type` (string, required)
- `description` (string)
- `metadata` (string)
- `blockNumber` (integer)
- `confirmations` (integer, default: 0)
- `createdAt` (datetime, required)
- `confirmedAt` (datetime)
- Relationships: `users`, `wallets`, `tokens`, `paymentRequests`

#### Collection: `Payment Requests`
- `requestId` (string, required)
- `fromUserId` (string, required)
- `toUserId` (string)
- `toEmail` (string)
- `tokenId` (string, required)
- `amount` (string, required)
- `description` (string)
- `dueDate` (datetime)
- `status` (string, default: "pending")
- `paymentTxId` (string)
- `invoiceNumber` (string)
- `metadata` (string)
- `createdAt` (datetime, required)
- `paidAt` (datetime)
- Relationships: `users`, `transactions`

#### Collection: `Exchange Rates`
- `rateId` (string, required)
- `fromCurrency` (string, required)
- `toCurrency` (string, required)
- `rate` (double, required)
- `source` (string, required)
- `lastUpdated` (datetime, required)
- `isActive` (boolean, default: true)

#### Collection: `Security Logs`
- `logId` (string, required)
- `userId` (string, required)
- `action` (string, required)
- `ipAddress` (string, required)
- `userAgent` (string)
- `location` (string)
- `success` (boolean, required)
- `riskScore` (integer, default: 0)
- `metadata` (string)
- `createdAt` (datetime, required)
- Relationships: `users`

#### Collection: `API Keys`
- `keyId` (string, required)
- `userId` (string, required)
- `keyName` (string, required)
- `publicKey` (string, required)
- `hashedSecret` (string, required)
- `permissions` (string, required)
- `isActive` (boolean, default: true)
- `lastUsed` (datetime)
- `expiresAt` (datetime)
- `createdAt` (datetime, required)
- Relationships: `users`

#### Collection: `virtual_cards`
- `cardId` (string, required)
- `userId` (string, required)
- `cardNumber` (string, required)
- `expiry` (string, required)
- `cvv` (string, required)
- `cardType` (string, required)
- `status` (string, required)
- `linkedWalletId` (string)
- `createdAt` (datetime)
- `updatedAt` (datetime)

#### Collection: `virtual_accounts`
- `accountId` (string, required)
- `userId` (string, required)
- `accountNumber` (string, required)
- `currency` (string)
- `balance` (double)
- `status` (string)
- `linkedWalletId` (string)
- `createdAt` (datetime)
- `updatedAt` (datetime)

---

## Proposed Modification

**Add a new field to the `Wallets` collection:**

- `creationMethod` (string, optional): Indicates how the wallet was created.  
  - Possible values: `"inbuilt"`, `"imported"`, `"external"`, etc.
  - Useful for distinguishing between default/inbuilt wallets and user-imported/external wallets.

This change is minimal and backward-compatible.
