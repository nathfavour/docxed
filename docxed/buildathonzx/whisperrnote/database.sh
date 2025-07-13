# --- NOTES COLLECTION EXTENSIONS ---
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "67ff05f3002502ef239e" --key "attachments" --size 256 --required false --array true
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "67ff05f3002502ef239e" --key "comments" --size 256 --required false --array true
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "67ff05f3002502ef239e" --key "extensions" --size 256 --required false --array true
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "67ff05f3002502ef239e" --key "collaborators" --size 256 --required false --array true
appwrite databases create-enum-attribute --database-id "67ff05a9000296822396" --collection-id "67ff05f3002502ef239e" --key "status" --elements "draft,published,archived" --required false --array false
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "67ff05f3002502ef239e" --key "parentNoteId" --size 256 --required false --array false
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "67ff05f3002502ef239e" --key "metadata" --size 1000 --required false --array false

# --- TAGS COLLECTION EXTENSIONS ---
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "67ff06280034908cf08a" --key "color" --size 32 --required false --array false
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "67ff06280034908cf08a" --key "description" --size 256 --required false --array false
appwrite databases create-integer-attribute --database-id "67ff05a9000296822396" --collection-id "67ff06280034908cf08a" --key "usageCount" --required false --array false

# --- APIKEYS COLLECTION EXTENSIONS ---
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "67ff064400263631ffe4" --key "scopes" --size 64 --required false --array true
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "67ff064400263631ffe4" --key "lastUsedIp" --size 64 --required false --array false

# --- BLOGPOSTS COLLECTION EXTENSIONS ---
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "67ff065a003e2bb950f7" --key "tags" --size 256 --required false --array true
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "67ff065a003e2bb950f7" --key "coverImage" --size 256 --required false --array false
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "67ff065a003e2bb950f7" --key "excerpt" --size 512 --required false --array false
appwrite databases create-enum-attribute --database-id "67ff05a9000296822396" --collection-id "67ff065a003e2bb950f7" --key "status" --elements "draft,published,archived" --required false --array false
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "67ff065a003e2bb950f7" --key "comments" --size 256 --required false --array true
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "67ff065a003e2bb950f7" --key "extensions" --size 256 --required false --array true
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "67ff065a003e2bb950f7" --key "metadata" --size 1000 --required false --array false

# --- NEW COLLECTIONS ---

# COMMENTS COLLECTION
appwrite databases create-collection --database-id "67ff05a9000296822396" --collection-id "comments" --name "Comments" --permissions 'create("users")' 'read("users")' 'update("users")' 'delete("users")'
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "comments" --key "noteId" --size 256 --required true --array false
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "comments" --key "userId" --size 256 --required true --array false
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "comments" --key "content" --size 2000 --required true --array false
appwrite databases create-datetime-attribute --database-id "67ff05a9000296822396" --collection-id "comments" --key "createdAt" --required true --array false
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "comments" --key "parentCommentId" --size 256 --required false --array false

# EXTENSIONS COLLECTION
appwrite databases create-collection --database-id "67ff05a9000296822396" --collection-id "extensions" --name "Extensions" --permissions 'create("users")' 'read("users")' 'update("users")' 'delete("users")'
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "extensions" --key "name" --size 128 --required true --array false
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "extensions" --key "description" --size 512 --required false --array false
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "extensions" --key "version" --size 32 --required false --array false
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "extensions" --key "authorId" --size 256 --required false --array false
appwrite databases create-boolean-attribute --database-id "67ff05a9000296822396" --collection-id "extensions" --key "enabled" --required false --array false
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "extensions" --key "settings" --size 1000 --required false --array false
appwrite databases create-datetime-attribute --database-id "67ff05a9000296822396" --collection-id "extensions" --key "createdAt" --required false --array false
appwrite databases create-datetime-attribute --database-id "67ff05a9000296822396" --collection-id "extensions" --key "updatedAt" --required false --array false

# REACTIONS COLLECTION
appwrite databases create-collection --database-id "67ff05a9000296822396" --collection-id "reactions" --name "Reactions" --permissions 'create("users")' 'read("users")' 'update("users")' 'delete("users")'
appwrite databases create-enum-attribute --database-id "67ff05a9000296822396" --collection-id "reactions" --key "targetType" --elements "note,comment" --required true --array false
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "reactions" --key "targetId" --size 256 --required true --array false
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "reactions" --key "userId" --size 256 --required true --array false
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "reactions" --key "emoji" --size 16 --required true --array false
appwrite databases create-datetime-attribute --database-id "67ff05a9000296822396" --collection-id "reactions" --key "createdAt" --required true --array false

# COLLABORATORS COLLECTION
appwrite databases create-collection --database-id "67ff05a9000296822396" --collection-id "collaborators" --name "Collaborators" --permissions 'create("users")' 'read("users")' 'update("users")' 'delete("users")'
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "collaborators" --key "noteId" --size 256 --required true --array false
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "collaborators" --key "userId" --size 256 --required true --array false
appwrite databases create-enum-attribute --database-id "67ff05a9000296822396" --collection-id "collaborators" --key "permission" --elements "read,write,admin" --required true --array false
appwrite databases create-datetime-attribute --database-id "67ff05a9000296822396" --collection-id "collaborators" --key "invitedAt" --required false --array false
appwrite databases create-boolean-attribute --database-id "67ff05a9000296822396" --collection-id "collaborators" --key "accepted" --required false --array false

# ACTIVITY LOG COLLECTION
appwrite databases create-collection --database-id "67ff05a9000296822396" --collection-id "activityLog" --name "ActivityLog" --permissions 'create("users")' 'read("users")' 'update("users")' 'delete("users")'
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "activityLog" --key "userId" --size 256 --required true --array false
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "activityLog" --key "action" --size 64 --required true --array false
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "activityLog" --key "targetType" --size 32 --required true --array false
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "activityLog" --key "targetId" --size 256 --required true --array false
appwrite databases create-datetime-attribute --database-id "67ff05a9000296822396" --collection-id "activityLog" --key "timestamp" --required true --array false
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "activityLog" --key "details" --size 1000 --required false --array false

# SETTINGS COLLECTION
appwrite databases create-collection --database-id "67ff05a9000296822396" --collection-id "settings" --name "Settings" --permissions 'create("users")' 'read("users")' 'update("users")' 'delete("users")'
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "settings" --key "userId" --size 256 --required true --array false
appwrite databases create-string-attribute --database-id "67ff05a9000296822396" --collection-id "settings" --key "settings" --size 1000 --required true --array false
appwrite databases create-datetime-attribute --database-id "67ff05a9000296822396" --collection-id "settings" --key "createdAt" --required false --array false
appwrite databases create-datetime-attribute --database-id "67ff05a9000296822396" --collection-id "settings" --key "updatedAt" --required false --array false

# --- END OF UPGRADE SCRIPT ---
