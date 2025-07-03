# Password Manager Database Structure (Appwrite)

## Database
- **Name:** PasswordManagerDB
- **ID:** passwordManagerDb

---

## Collections

### 1. Credentials
- **ID:** credentials
- **Purpose:** Store encrypted credentials for user accounts.
- **Attributes:**
    - userId: string, required (Appwrite user ID, owner)
    - name: string, required (e.g. "Google")
    - url: string, optional (e.g. "https://google.com")
    - username: string, required, encrypted
    - password: string, required, encrypted
    - notes: string, optional, encrypted
    - folderId: string, optional (FK to folders)
    - tags: string[], optional
    - customFields: string, optional, encrypted JSON
    - faviconUrl: string, optional
    - createdAt: datetime, auto
    - updatedAt: datetime, auto
- **Indexes:**
    - userId (key)
    - folderId (key)
    - tags (key/array)

---

### 2. TOTPSecrets
- **ID:** totpSecrets
- **Purpose:** Store encrypted TOTP secrets.
- **Attributes:**
    - userId: string, required
    - issuer: string, required
    - accountName: string, required
    - secretKey: string, required, encrypted
    - algorithm: string, default "SHA1"
    - digits: integer, default 6
    - period: integer, default 30
    - folderId: string, optional (FK to folders)
    - createdAt: datetime, auto
    - updatedAt: datetime, auto
- **Indexes:**
    - userId (key)
    - folderId (key)

---

### 3. Folders
- **ID:** folders
- **Purpose:** Organize credentials and TOTP secrets.
- **Attributes:**
    - userId: string, required
    - name: string, required
    - parentFolderId: string, optional, self-ref
    - createdAt: datetime, auto
    - updatedAt: datetime, auto
- **Indexes:**
    - userId (key)
    - parentFolderId (key)

---

### 4. SecurityLogs
- **ID:** securityLogs
- **Purpose:** Log security events.
- **Attributes:**
    - userId: string, required
    - eventType: string, required
    - ipAddress: string, optional
    - userAgent: string, optional
    - details: string, optional (JSON)
    - timestamp: datetime, required
- **Indexes:**
    - userId (key)
    - eventType (key)
    - timestamp (key, DESC)

---

### 5. user
- **ID:** user
- **Purpose:** store important user info and track masterpassword creation.
- **Attributes:**
    - userId: string, required
    - email: string, required
    - masterpass: boolean, optional (default, false)

- **Indexes:**
    - userId (key)
    - masterpass (key) (useful possibly for sending custom in-app reminding users with no masterpassword )

## Relationships
- Users (Appwrite Auth) 1:N Credentials (via userId)
- Users 1:N TOTPSecrets (via userId)
- Users 1:N Folders (via userId)
- Users 1:N SecurityLogs (via userId)
- Folders 1:N Credentials (via folderId)
- Folders 1:N TOTPSecrets (via folderId)
- Folders 1:N Folders (via parentFolderId)

> **Note:** All sensitive fields must be encrypted client-side before storage.
