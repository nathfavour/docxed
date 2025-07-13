# WhisperrNote Upgraded Database Structure Proposal

This proposal builds upon the current Appwrite database schema, adding new collections and attributes to support extensibility, advanced features, and future-proofing for robust note-taking and blogging.

---

## 1. Notes Collection (Extend Existing)

- Add support for attachments (file IDs)
- Add support for comments (comment IDs)
- Add support for reactions (emoji, count)
- Add support for extensions/plugins (extension IDs)
- Add support for collaborators (user IDs, permissions)
- Add support for note status (draft, published, archived)
- Add support for parent/child notes (for hierarchical notes/outlines)
- Add support for custom metadata (key-value pairs)

**New/Extended Attributes:**
- `attachments: string[] | null` (File IDs)
- `comments: string[] | null` (Comment IDs)
- `reactions: { emoji: string, count: number }[] | null`
- `extensions: string[] | null` (Extension IDs)
- `collaborators: { userId: string, permission: string }[] | null`
- `status: 'draft' | 'published' | 'archived' | null`
- `parentNoteId: string | null`
- `metadata: Record<string, any> | null`

---

## 2. Comments Collection (New)

- For note comments, threaded discussions

**Attributes:**
- `id: string`
- `noteId: string`
- `userId: string`
- `content: string`
- `createdAt: datetime`
- `parentCommentId: string | null` (for threads)

---

## 3. Extensions Collection (New)

- For future extensibility (plugins, integrations, custom features)

**Attributes:**
- `id: string`
- `name: string`
- `description: string`
- `version: string`
- `authorId: string`
- `enabled: boolean`
- `settings: Record<string, any> | null`
- `createdAt: datetime`
- `updatedAt: datetime`

---

## 4. Reactions Collection (New, Optional)

- For tracking reactions on notes/comments

**Attributes:**
- `id: string`
- `targetType: 'note' | 'comment'`
- `targetId: string`
- `userId: string`
- `emoji: string`
- `createdAt: datetime`

---

## 5. Collaborators (Embedded in Notes, or Separate Collection)

- For real-time collaboration, permissions

**Attributes (if separate):**
- `id: string`
- `noteId: string`
- `userId: string`
- `permission: 'read' | 'write' | 'admin'`
- `invitedAt: datetime`
- `accepted: boolean`

---

## 6. BlogPosts Collection (Extend Existing)

- Add support for tags, cover image, excerpt, status, comments, reactions, extensions

**New/Extended Attributes:**
- `tags: string[] | null`
- `coverImage: string | null` (File ID)
- `excerpt: string | null`
- `status: 'draft' | 'published' | 'archived' | null`
- `comments: string[] | null`
- `reactions: { emoji: string, count: number }[] | null`
- `extensions: string[] | null`
- `metadata: Record<string, any> | null`

---

## 7. Tags Collection (Extend Existing)

- Add support for tag color, description, usage count

**New/Extended Attributes:**
- `color: string | null`
- `description: string | null`
- `usageCount: number | null`

---

## 8. ApiKeys Collection (Extend Existing)

- Add support for scopes/permissions, last used IP

**New/Extended Attributes:**
- `scopes: string[] | null`
- `lastUsedIp: string | null`

---

## 9. Activity Log Collection (New)

- For auditing, tracking actions (create, update, delete, share, etc.)

**Attributes:**
- `id: string`
- `userId: string`
- `action: string`
- `targetType: string`
- `targetId: string`
- `timestamp: datetime`
- `details: Record<string, any> | null`

---

## 10. Settings Collection (New)

- For user or workspace settings, preferences

**Attributes:**
- `id: string`
- `userId: string`
- `settings: Record<string, any>`
- `createdAt: datetime`
- `updatedAt: datetime`

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

