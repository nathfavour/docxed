# Password Manager Storage Buckets (Appwrite)

## Buckets

### 1. UserAvatars
- **ID:** userAvatars
- **Purpose:** Store user profile pictures.
- **Max File Size:** 2MB
- **Allowed Extensions:** jpg, jpeg, png
- **Permissions:** user:[USER_ID] for read/update/delete

---

### 2. EncryptedDataBackups
- **ID:** encryptedDataBackups
- **Purpose:** Store user-encrypted vault backups.
- **Max File Size:** 50MB
- **Allowed Extensions:** backup, enc
- **Permissions:** user:[USER_ID] for read/update/delete

> **Note:** File-level permissions should be set by client on upload.
