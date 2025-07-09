# Appwrite Database Structure for Next-Gen Chat Application

This document outlines the recommended Appwrite database schema for a secure, extensible, open-source chat platform. The structure is designed for core chat functionality, with future-proofing for bots, extensions, web3, and more.

---

## Databases

- **core**: Main chat and user data
- **extensions**: Integrations, bots, web3, wallets, etc.

---

## Collections (core)

### 1. Users

- **Attributes:**
  - `userId` (String, unique, indexed, required, maxLength: 36) // UUID
  - `username` (String, unique, indexed, required, maxLength: 32)
  - `displayName` (String, maxLength: 64)
  - `avatarUrl` (URL, maxLength: 255)
  - `bio` (String, maxLength: 255)
  - `phone` (String, unique, indexed, optional, maxLength: 20)
  - `email` (Email, unique, indexed, optional)
  - `publicKey` (String, required, maxLength: 1000) // For E2E encryption, may be long
  - `createdAt` (Datetime, indexed)
  - `lastSeen` (Datetime, indexed)
  - `status` (Enum: online, offline, away, etc., indexed)
  - `usernameCredibility` (Integer, min: 0, max: 100, default: 100)
  - `usernameHistory` (Array of Strings, all previous usernames, public)
  - `usernameChangedAt` (Datetime, last username change)
  - `credibilityTier` (Enum: bronze, silver, gold, platinum, diamond, default: bronze)
  - `credibilityScore` (Integer, 0-100, calculated from various factors)
  - `credibilityHistory` (Array of objects: {event, scoreChange, timestamp})
  - `twoFactorEnabled` (Boolean, default: false)
  - `emailVerified` (Boolean, default: false)
  - `phoneVerified` (Boolean, default: false)
  - `encryptionKeyExported` (Boolean, default: false) // Has user exported their E2E key
  - `recoveryPhraseBackedUp` (Boolean, default: false) // Has user confirmed backup of recovery phrase
  - `encryptedPrivateKey` (String, required, maxLength: 2000) // User's private key, encrypted with key derived from recovery phrase
- **Indexes:**
  - `userId` (unique)
  - `username` (unique)
  - `phone` (unique, optional)
  - `email` (unique, optional)
  - `status` (non-unique)
- **Relationships:**
  - Linked to Chats, Messages, Contacts

---

### 2. Chats

- **Attributes:**
  - `chatId` (String, unique, indexed, required, maxLength: 36)
  - `type` (Enum: private, group, channel, bot, extension, required)
  - `title` (String, optional, maxLength: 64)
  - `avatarUrl` (URL, optional, maxLength: 255)
  - `createdBy` (Relationship: userId, required)
  - `createdAt` (Datetime, indexed)
  - `updatedAt` (Datetime, indexed)
  - `isEncrypted` (Boolean, default: true)
  - `extensionType` (String, optional, maxLength: 32) // For future integrations
- **Indexes:**
  - `chatId` (unique)
  - `type` (non-unique)
  - _(Note: Appwrite automatically indexes relationship fields for queries, but you cannot add a custom index on `createdBy`.)_
- **Relationships:**
  - Linked to Users (members), Messages

---

### 3. ChatMembers

- **Attributes:**
  - `chatId` (Relationship: chatId, required)
  - `userId` (Relationship: userId, required)
  - `role` (Enum: admin, member, owner, bot, extension, required)
  - `joinedAt` (Datetime)
  - `mutedUntil` (Datetime, optional)
- **Indexes:**
  - _(Note: Composite unique index (`chatId`, `userId`) is **not supported** on relationship fields in Appwrite. Enforce this uniqueness in your application logic.)_
  - _(Note: Appwrite automatically indexes relationship fields for queries, but you cannot add a custom index on `userId` or `chatId`.)_
- **Relationships:**
  - Many-to-many: Users <-> Chats

---

### 4. Messages

- **Attributes:**
  - `messageId` (String, unique, indexed, required, maxLength: 36)
  - `chatId` (Relationship: chatId, required)
  - `senderId` (Relationship: userId, required)
  - `content` (String, encrypted, required, maxLength: 5000) // For chat message data
  - `type` (Enum: text, image, file, audio, video, sticker, system, etc.)
  - `createdAt` (Datetime, indexed)
  - `editedAt` (Datetime, optional)
  - `replyTo` (Relationship: messageId, optional)
  - `isDeleted` (Boolean, default: false)
  - `extensionPayload` (String, optional, maxLength: 1000) // JSON as string, parse/stringify on frontend
- **Indexes:**
  - `messageId` (unique)
  - `createdAt` (non-unique)
  - _(Note: Appwrite automatically indexes relationship fields for queries, but you cannot add a custom index on `chatId` or `senderId`.)_
- **Relationships:**
  - Linked to Chats, Users

---

### 5. Contacts

- **Attributes:**
  - `ownerId` (Relationship: userId, required)
  - `contactId` (Relationship: userId, required)
  - `createdAt` (Datetime)
  - `alias` (String, optional, maxLength: 64)
- **Indexes:**
  - _(Note: Composite unique index (`ownerId`, `contactId`) is **not supported** on relationship fields in Appwrite. Enforce this uniqueness in your application logic.)_
- **Relationships:**
  - Many-to-many: Users <-> Users

---

### 6. Devices

- **Attributes:**
  - `deviceId` (String, unique, indexed, required, maxLength: 36)
  - `userId` (Relationship: userId, required)
  - `deviceType` (String, required, maxLength: 32)
  - `pushToken` (String, optional, maxLength: 255)
  - `lastActive` (Datetime, indexed)
- **Indexes:**
  - `deviceId` (unique)
  - _(Note: Appwrite automatically indexes relationship fields for queries, but you cannot add a custom index on `userId`.)_
- **Relationships:**
  - Linked to Users

---

## Collections (extensions)

- **Bots**
- **Web3Wallets**
- **Integrations**
- **ExtensionSettings**
- (Structure similar to above, with extension-specific attributes. Use String for JSON, maxLength: 1000.)

---

## Relationships Overview

- **Users <-> Chats**: Many-to-many via ChatMembers
- **Chats <-> Messages**: One-to-many
- **Users <-> Messages**: One-to-many (sender)
- **Users <-> Contacts**: Many-to-many
- **Users <-> Devices**: One-to-many

---

## Notes

- All sensitive data (messages, user info) should be encrypted at rest and in transit.
- All collections should support soft deletion (e.g., `isDeleted` flag).
- For any JSON-like data, use String (max: 1000) and handle JSON parsing/stringifying on the frontend.
- For most String fields, keep max length ≤255. For chat messages, up to 5000 is reasonable. For public keys or extension payloads, up to 1000.
- Appwrite's hard limit for a single string attribute is 36KB, but it's best to stay well below this for performance and reliability.
- Future collections for extensions, bots, and web3 can be added under the `extensions` database.
- **Appwrite automatically indexes relationship attributes for efficient querying, but does not support user-defined indexes (including composite or unique) on relationship fields. Enforce such uniqueness in your application logic.**
- Indexes should be optimized for search, retrieval, and scalability.

---

## Modification 1: Username Tracking, Credibility, and Recovery

### 7. Usernames

- **Attributes:**
  - `username` (String, unique, indexed, required, maxLength: 32)
  - `status` (Enum: active, cooldown, available, banned, required)
  - `lastUsedBy` (Relationship: userId, nullable)
  - `lastUsedAt` (Datetime)
  - `cooldownUntil` (Datetime, nullable)
  - `history` (Array of userIds, all users who have used this username)
- **Indexes:**
  - `username` (unique)
  - `status` (non-unique)
- **Relationships:**
  - Linked to Users

---

### Users Collection Modifications

- **Attributes (add):**
  - `usernameCredibility` (Integer, min: 0, max: 100, default: 100)
  - `usernameHistory` (Array of Strings, all previous usernames, public)
  - `usernameChangedAt` (Datetime, last username change)
  - `credibilityTier` (Enum: bronze, silver, gold, platinum, diamond, default: bronze)
  - `credibilityScore` (Integer, 0-100, calculated from various factors)
  - `credibilityHistory` (Array of objects: {event, scoreChange, timestamp})
  - `twoFactorEnabled` (Boolean, default: false)
  - `emailVerified` (Boolean, default: false)
  - `phoneVerified` (Boolean, default: false)
  - `encryptionKeyExported` (Boolean, default: false) // Has user exported their E2E key
  - `recoveryPhraseBackedUp` (Boolean, default: false) // Has user confirmed backup of recovery phrase
  - `encryptedPrivateKey` (String, required, maxLength: 2000) // User's private key, encrypted with key derived from recovery phrase

---

### Recovery & End-to-End Encryption

- On account creation, a 24-word recovery phrase is generated client-side.
- The user's encryption key is derived from this phrase.
- The user's private key is encrypted with this key and stored as `encryptedPrivateKey`.
- The recovery phrase is **never** stored or transmitted in plain text.
- To recover, the user enters their 24-word phrase, which is used to decrypt their private key.
- `recoveryPhraseBackedUp` tracks whether the user has confirmed saving their phrase.
- All messages and sensitive data are encrypted end-to-end by default.

---

### Credibility & Tier System

- `credibilityScore` and `credibilityTier` are updated based on user actions (e.g., username changes, verification, 2FA).
- `usernameCredibility` is 100% for never-changed usernames; frequent changes reduce this score.
- `credibilityHistory` logs all events affecting credibility.
- Users with low credibility scores trigger explicit warnings for others.

---

### Notes

- All new fields are optional or defaulted, ensuring backward compatibility.
- Username logic is handled in a dedicated collection for flexibility and future-proofing.
- The recovery system is secure, user-friendly, and does not store sensitive secrets in plain text.
- The credibility system is extensible and modular.