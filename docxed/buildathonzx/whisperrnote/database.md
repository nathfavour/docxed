# WhisperrNote Upgraded Database Structure Proposal

This proposal builds upon the current Appwrite database schema, adding new collections and attributes to support extensibility, advanced features, and future-proofing for robust note-taking and blogging.

---

## Full Database Structure (Tabular Overview)

### 1. Users Collection

| Attribute      | Type      | Required | Array | Description                |
|----------------|-----------|----------|-------|----------------------------|
| id             | string    | No       | No    | User ID                    |
| email          | string    | No       | No    | Email address              |
| name           | string    | No       | No    | Name                       |
| walletAddress  | string    | No       | No    | Wallet address             |
| createdAt      | datetime  | No       | No    | Creation timestamp         |
| updatedAt      | datetime  | No       | No    | Last update timestamp      |

---

### 2. Notes Collection

| Attribute        | Type      | Required | Array | Description                                 |
|------------------|-----------|----------|-------|---------------------------------------------|
| id               | string    | No       | No    | Note ID                                     |
| title            | string    | No       | No    | Note title                                  |
| content          | string    | No       | No    | Note content                                |
| createdAt        | datetime  | No       | No    | Creation timestamp                          |
| updatedAt        | datetime  | No       | No    | Last update timestamp                       |
| userId           | string    | No       | No    | Owner user ID                               |
| isPublic         | boolean   | No       | No    | Public visibility                           |
| tags             | string    | No       | Yes   | Associated tag IDs                          |
| attachments      | string    | No       | Yes   | File IDs for attachments                    |
| comments         | string    | No       | Yes   | Comment IDs                                 |
| extensions       | string    | No       | Yes   | Extension IDs                               |
| collaborators    | string    | No       | Yes   | Collaborator IDs                            |
| status           | enum      | No       | No    | 'draft', 'published', 'archived'            |
| parentNoteId     | string    | No       | No    | Parent note ID (for hierarchy)              |
| metadata         | string    | No       | No    | Custom metadata (JSON string)               |

---

### 3. Tags Collection

| Attribute      | Type      | Required | Array | Description                |
|----------------|-----------|----------|-------|----------------------------|
| id             | string    | No       | No    | Tag ID                     |
| name           | string    | No       | No    | Tag name                   |
| notes          | string    | No       | Yes   | Associated note IDs        |
| createdAt      | datetime  | No       | No    | Creation timestamp         |
| color          | string    | No       | No    | Tag color                  |
| description    | string    | No       | No    | Tag description            |
| usageCount     | integer   | No       | No    | Usage count                |

---

### 4. ApiKeys Collection

| Attribute      | Type      | Required | Array | Description                |
|----------------|-----------|----------|-------|----------------------------|
| id             | string    | No       | No    | API Key ID                 |
| key            | string    | No       | No    | API Key                    |
| name           | string    | No       | No    | API Key name               |
| userId         | string    | No       | No    | Owner user ID              |
| createdAt      | datetime  | No       | No    | Creation timestamp         |
| lastUsed       | datetime  | No       | No    | Last used timestamp        |
| expiresAt      | datetime  | No       | No    | Expiry timestamp           |
| scopes         | string    | No       | Yes   | Scopes/permissions         |
| lastUsedIp     | string    | No       | No    | Last used IP address       |

---

### 5. BlogPosts Collection

| Attribute      | Type      | Required | Array | Description                |
|----------------|-----------|----------|-------|----------------------------|
| id             | string    | No       | No    | Blog post ID               |
| title          | string    | No       | No    | Blog post title            |
| content        | string    | No       | No    | Blog post content          |
| createdAt      | datetime  | No       | No    | Creation timestamp         |
| updatedAt      | datetime  | No       | No    | Last update timestamp      |
| authorId       | string    | No       | No    | Author user ID             |
| tags           | string    | No       | Yes   | Associated tag IDs         |
| coverImage     | string    | No       | No    | Cover image file ID        |
| excerpt        | string    | No       | No    | Blog post excerpt          |
| status         | enum      | No       | No    | 'draft', 'published', 'archived' |
| comments       | string    | No       | Yes   | Comment IDs                |
| extensions     | string    | No       | Yes   | Extension IDs              |
| metadata       | string    | No       | No    | Custom metadata (JSON)     |

---

### 6. Comments Collection

| Attribute        | Type      | Required | Array | Description                |
|------------------|-----------|----------|-------|----------------------------|
| noteId           | string    | Yes      | No    | Associated note ID         |
| userId           | string    | Yes      | No    | Commenting user ID         |
| content          | string    | Yes      | No    | Comment content            |
| createdAt        | datetime  | Yes      | No    | Creation timestamp         |
| parentCommentId  | string    | No       | No    | Parent comment ID (thread) |

---

### 7. Extensions Collection

| Attribute      | Type      | Required | Array | Description                |
|----------------|-----------|----------|-------|----------------------------|
| name           | string    | Yes      | No    | Extension name             |
| description    | string    | No       | No    | Extension description      |
| version        | string    | No       | No    | Extension version          |
| authorId       | string    | No       | No    | Author user ID             |
| enabled        | boolean   | No       | No    | Enabled status             |
| settings       | string    | No       | No    | Extension settings (JSON)  |
| createdAt      | datetime  | No       | No    | Creation timestamp         |
| updatedAt      | datetime  | No       | No    | Last update timestamp      |

---

### 8. Reactions Collection

| Attribute      | Type      | Required | Array | Description                |
|----------------|-----------|----------|-------|----------------------------|
| targetType     | enum      | Yes      | No    | 'note', 'comment'          |
| targetId       | string    | Yes      | No    | Target note/comment ID     |
| userId         | string    | Yes      | No    | Reacting user ID           |
| emoji          | string    | Yes      | No    | Emoji                      |
| createdAt      | datetime  | Yes      | No    | Creation timestamp         |

---

### 9. Collaborators Collection

| Attribute      | Type      | Required | Array | Description                |
|----------------|-----------|----------|-------|----------------------------|
| noteId         | string    | Yes      | No    | Associated note ID         |
| userId         | string    | Yes      | No    | Collaborator user ID       |
| permission     | enum      | Yes      | No    | 'read', 'write', 'admin'   |
| invitedAt      | datetime  | No       | No    | Invitation timestamp       |
| accepted       | boolean   | No       | No    | Accepted status            |

---

### 10. ActivityLog Collection

| Attribute      | Type      | Required | Array | Description                |
|----------------|-----------|----------|-------|----------------------------|
| userId         | string    | Yes      | No    | Acting user ID             |
| action         | string    | Yes      | No    | Action performed           |
| targetType     | string    | Yes      | No    | Target type                |
| targetId       | string    | Yes      | No    | Target ID                  |
| timestamp      | datetime  | Yes      | No    | Timestamp                  |
| details        | string    | No       | No    | Additional details (JSON)  |

---

### 11. Settings Collection

| Attribute      | Type      | Required | Array | Description                |
|----------------|-----------|----------|-------|----------------------------|
| userId         | string    | Yes      | No    | User ID                    |
| settings       | string    | Yes      | No    | Settings (JSON)            |
| createdAt      | datetime  | No       | No    | Creation timestamp         |
| updatedAt      | datetime  | No       | No    | Last update timestamp      |

---

## Migration Strategy

- Add new collections and attributes as optional fields to avoid breaking existing data.
- Use embedded arrays/objects for extensibility where possible.
- Future extensions/plugins can be registered in the Extensions collection and referenced by Notes/BlogPosts.

---

## Summary

This structure supports:
- Robust note management (attachments, comments, reactions, metadata, hierarchy)
- Lightweight blogging (public notes, blog posts, tags, cover images)
- Extensibility (extensions/plugins)
- Collaboration (permissions, activity logs)
- Future-proofing for open source growth

