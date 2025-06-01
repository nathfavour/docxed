# Appwrite Database Structure for WhisperrNote

This document specifies the Appwrite database, collections, and attributes to use for WhisperrNote. Use this as a blueprint for setting up your Appwrite Console.

---

## Database
- **Database Name:** whisperrnote
- **Database ID:** (67ff05a9000296822396)

---

## Collections

### 1. users (Collection)
- **Collection ID:** (67ff05c900247b5673d3)
- **Attributes:**
  - id: string, required, unique, default: ID.unique()
  - email: string, optional, unique
  - name: string, optional
  - passwordHash: string, optional
  - walletAddress: string, optional, unique
  - createdAt: datetime, required, default: now
  - updatedAt: datetime, required, auto-updated

### 2. notes (Collection)
- **Collection ID:** (67ff05f3002502ef239e)
- **Attributes:**
  - id: string, required, unique, default: ID.unique()
  - title: string, required
  - content: string, required
  - createdAt: datetime, required, default: now
  - updatedAt: datetime, required, auto-updated
  - userId: string, required (reference to users.id)
  - isPublic: boolean, required, default: false
  - tags: string[], optional (array of tag IDs or names)

### 3. tags (Collection)
- **Collection ID:** (67ff06280034908cf08a)
- **Attributes:**
  - id: string, required, unique, default: ID.unique()
  - name: string, required
  - notes: string[], optional (array of note IDs)
  - createdAt: datetime, required, default: now

### 4. apiKeys (Collection)
- **Collection ID:** (67ff064400263631ffe4)
- **Attributes:**
  - id: string, required, unique, default: ID.unique()
  - key: string, required, unique
  - name: string, required
  - userId: string, required (reference to users.id)
  - createdAt: datetime, required, default: now
  - lastUsed: datetime, required, default: now
  - expiresAt: datetime, optional

### 5. blogPosts (Collection) *(optional)*
- **Collection ID:** (67ff065a003e2bb950f7)
- **Attributes:**
  - id: string, required, unique, default: ID.unique()
  - title: string, required
  - content: string, required
  - createdAt: datetime, required, default: now
  - updatedAt: datetime, required, auto-updated
  - authorId: string, required (reference to users.id)

---

## Indexes & Permissions
- Add indexes on frequently queried fields: userId, email, tags, etc.
- Use Appwrite's built-in permissions to restrict access to documents as needed.

---

## Storage Buckets (if needed)
- **notes-attachments**: (67ff068f0036c272503f)For file uploads related to notes
- **profile-pictures**: (67ff06c2003831f1cd5c) For user profile pictures

## Setup Checklist
1. Create the `whisperrnote` database in Appwrite Console.
2. Create each collection above and add the listed attributes.
3. Record the generated IDs for database and collections in this file for reference.
4. Set up indexes and permissions as required by your app's logic.
5. Create storage buckets if your app needs file uploads.

---

This structure is modular and can be extended as your application grows. Record all Appwrite IDs here for easy reference in your codebase.
