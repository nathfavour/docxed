# BainaryGlobe Database Structure (Appwrite)

## Overview
- Modular, scalable structure for conglomerate SaaS (multiple products).
- Permission-based CRUD for all entities.
- Flexible OAuth system for internal and third-party products.

---

## Collections

### 1. Users
- `userId` (string, unique)
- `email` (string)
- `name` (string)
- `role` (enum: admin, privileged, regular, product_owner, third_party)
- `products` (array of productIds)
- `oauthProviders` (array of linked providers)
- `createdAt`, `updatedAt`

### 2. Products
- `productId` (string, unique)
- `name` (string)
- `description` (string)
- `standalone` (boolean)
- `ourApp` (boolean) // true if internal product
- `owners` (array of userIds)
- `modules` (array of moduleIds)
- `oauthEnabled` (boolean)
- `createdAt`, `updatedAt`

### 3. Modules
- `moduleId` (string, unique)
- `productId` (string, ref)
- `name` (string)
- `type` (enum: blog, dashboard, analytics, etc)
- `config` (json)
- `createdAt`, `updatedAt`

### 4. Permissions
- `permissionId` (string, unique)
- `userId` (string, ref)
- `productId` (string, ref)
- `moduleId` (string, ref, optional)
- `accessLevel` (enum: read, write, admin)
- `createdAt`, `updatedAt`

### 5. OAuthClients
- `clientId` (string, unique)
- `name` (string)
- `redirectUris` (array)
- `ourApp` (boolean) // internal flag for company products
- `ownerId` (userId)
- `scopes` (array)
- `verificationSkipped` (boolean) // if ourApp is true
- `createdAt`, `updatedAt`

### 6. Content (for modular CRUD)
- `contentId` (string, unique)
- `productId` (string, ref)
- `moduleId` (string, ref)
- `type` (enum: page, blog, footer, etc)
- `data` (json)
- `createdBy` (userId)
- `createdAt`, `updatedAt`

---

## Relationships
- Users can own multiple products and modules.
- Products can have multiple modules.
- Permissions are granular (per product/module/user).
- OAuthClients can be internal (ourApp) or third-party.

---

## Notes
- All CRUD operations are permission-checked.
- OAuth system supports "Sign in with BainaryGlobe" for internal and third-party apps.
- Internal flag (`ourApp`) allows streamlined integration for company products.

---

## Example Use Cases
- Admin creates a new product, assigns owners, enables OAuth.
- Privileged user edits site content via frontend CRUD UI.
- Third-party app registers as OAuth client, flagged as external.
- Modular expansion: add new modules/products without schema changes.

---
