# WhisperNote & To-Do Appwrite Database Schema

## Users
- **_id**: string (Appwrite user ID, primary key)
- **username**: string (unique)
- **email**: string
- **profile_picture**: string (URL, optional)
- **created_at**: datetime
- **updated_at**: datetime
- **settings**: object (theme, preferences, etc)
- **extensions**: array (list of enabled extension IDs)

## Notebooks
- **_id**: string (primary key)
- **owner_id**: string (user ID, indexed)
- **title**: string
- **description**: string
- **color**: string (optional)
- **icon**: string (optional)
- **created_at**: datetime
- **updated_at**: datetime
- **shared_with**: array (user IDs or group IDs)
- **is_encrypted**: boolean
- **metadata**: object (extensible)

## Notes
- **_id**: string (primary key)
- **notebook_id**: string (indexed)
- **owner_id**: string (user ID, indexed)
- **title**: string
- **content**: string (encrypted, markdown, rich text, or plaintext)
- **type**: enum ("text", "scribble", "audio", "image", "file", "math", etc)
- **attachments**: array (file IDs, images, audio, etc)
- **tags**: array (string)
- **created_at**: datetime
- **updated_at**: datetime
- **is_pinned**: boolean
- **is_archived**: boolean
- **is_deleted**: boolean
- **is_encrypted**: boolean
- **shared_with**: array (user IDs or group IDs)
- **ai_metadata**: object (AI-generated summaries, hints, etc)
- **extension_data**: object (for plugins/extensions)
- **analytics**: object (view count, last accessed, etc)

## ToDos
- **_id**: string (primary key)
- **owner_id**: string (user ID, indexed)
- **title**: string
- **description**: string
- **due_date**: datetime (optional)
- **reminder**: datetime (optional)
- **priority**: enum ("low", "medium", "high", "urgent")
- **status**: enum ("pending", "in_progress", "completed", "cancelled")
- **tags**: array (string)
- **created_at**: datetime
- **updated_at**: datetime
- **is_encrypted**: boolean
- **shared_with**: array (user IDs or group IDs)
- **recurrence**: object (for repeating tasks)
- **linked_notes**: array (note IDs)
- **extension_data**: object

## Sharing
- **_id**: string (primary key)
- **resource_id**: string (note, todo, or notebook ID)
- **resource_type**: enum ("note", "todo", "notebook")
- **shared_by**: string (user ID)
- **shared_with**: string (user ID or group ID)
- **permission**: enum ("read", "write", "admin")
- **created_at**: datetime
- **expires_at**: datetime (optional)

## Extensions
- **_id**: string (primary key)
- **name**: string
- **description**: string
- **type**: enum ("ai", "analytics", "theme", "integration", etc)
- **config_schema**: object (JSON schema for extension config)
- **enabled_by_default**: boolean
- **created_at**: datetime
- **updated_at**: datetime

## Analytics
- **_id**: string (primary key)
- **user_id**: string (indexed)
- **resource_id**: string (note, todo, etc)
- **resource_type**: enum ("note", "todo", etc)
- **event_type**: string ("view", "edit", "share", etc)
- **event_data**: object
- **created_at**: datetime

## Files
- **_id**: string (primary key)
- **owner_id**: string (user ID)
- **file_url**: string
- **file_type**: string
- **created_at**: datetime
- **linked_resource**: string (note/todo ID)

## Groups (for sharing)
- **_id**: string (primary key)
- **name**: string
- **owner_id**: string
- **members**: array (user IDs)
- **created_at**: datetime

---

# Notes
- All sensitive fields (content, attachments, etc) should be encrypted client-side.
- Use Appwrite's built-in permissions for access control, but also store sharing info for advanced features.
- The `extension_data` and `metadata` fields allow for future extensibility and plugin support.
- The schema supports AI integrations, analytics, math notes, scribbles, and more.
- Collections can be further normalized or denormalized as needed for performance.

