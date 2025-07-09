# Appwrite Storage Buckets Structure

## Principles

- **Minimal:** Only create buckets for actual file/media needs.
- **Modular:** Separate buckets by logical domain (user, chat, extension).
- **Flexible:** Allow for future expansion (e.g., custom backgrounds, stickers).
- **Scalable:** Designed for growth in users, media, and extensions.

---

## Buckets

### 1. user-avatars
- **Purpose:** Store user profile avatars.
- **Access:** Private (user and system only), optionally public for avatars.
- **Usage:** Avatar uploads, updates, and retrieval.

### 2. chat-media
- **Purpose:** Store media shared in chats (images, files, audio, video, stickers).
- **Access:** Private (only chat members), enforce via Appwrite permissions.
- **Usage:** Message attachments, stickers, voice notes, etc.

### 3. backgrounds
- **Purpose:** Store custom user or chat backgrounds (images, SVGs, patterns).
- **Access:** Private (user or chat), optionally public for shared patterns.
- **Usage:** Custom motif backgrounds, theme assets.

### 4. extension-assets
- **Purpose:** Store files for bots, integrations, or extensions (e.g., bot icons, web3 assets).
- **Access:** Private or public, depending on extension.
- **Usage:** Extension UI, bot avatars, integration logos.

---

## Optional/Future Buckets

- **stickers**: For user-uploaded or custom sticker packs (if not in chat-media).
- **temp-uploads**: For temporary files (pre-processing, virus scan, etc.).
- **logs**: For audit or moderation logs (if needed, not for user data).

---

## Notes

- All buckets should have strict permissions and validation.
- Use Appwrite's file size and type restrictions for each bucket.
- Buckets can be extended or split as the app grows (e.g., separate video/audio if needed).
- For most use cases, 3-4 buckets are sufficient to start.

---

## Example Bucket IDs (for .env and code)

- `NEXT_PUBLIC_APPWRITE_BUCKET_USER_AVATARS=user-avatars`
- `NEXT_PUBLIC_APPWRITE_BUCKET_CHAT_MEDIA=chat-media`
- `NEXT_PUBLIC_APPWRITE_BUCKET_BACKGROUNDS=backgrounds`
- `NEXT_PUBLIC_APPWRITE_BUCKET_EXTENSION_ASSETS=extension-assets`
