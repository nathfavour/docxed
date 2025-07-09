#!/bin/bash

set -e

# --- Create Databases ---
appwrite databases create --database-id "core" --name "core"
appwrite databases create --database-id "extensions" --name "extensions"

# --- USERS COLLECTION ---
appwrite databases create-collection --database-id "core" --collection-id "users" --name "Users" --permissions 'read("any")' 'write("any")'

appwrite databases create-string-attribute   --database-id "core" --collection-id "users" --key "userId"      --size 36   --required true
appwrite databases create-string-attribute   --database-id "core" --collection-id "users" --key "username"    --size 32   --required true
appwrite databases create-string-attribute   --database-id "core" --collection-id "users" --key "displayName" --size 64   --required false
appwrite databases create-url-attribute      --database-id "core" --collection-id "users" --key "avatarUrl"  --required false
appwrite databases create-string-attribute   --database-id "core" --collection-id "users" --key "bio"         --size 255  --required false
appwrite databases create-string-attribute   --database-id "core" --collection-id "users" --key "phone"       --size 20   --required false
appwrite databases create-email-attribute    --database-id "core" --collection-id "users" --key "email"       --required false
appwrite databases create-string-attribute   --database-id "core" --collection-id "users" --key "publicKey"   --size 1000 --required true
appwrite databases create-datetime-attribute --database-id "core" --collection-id "users" --key "createdAt"   --required true
appwrite databases create-datetime-attribute --database-id "core" --collection-id "users" --key "lastSeen"    --required false
appwrite databases create-enum-attribute --database-id "core" --collection-id "users" --key "status" --elements online offline away --required false

# Wait for attributes to be available
sleep 10

# Indexes for users
appwrite databases create-index --database-id "core" --collection-id "users" --key "unique_userId"   --type "unique" --attributes userId
appwrite databases create-index --database-id "core" --collection-id "users" --key "unique_username" --type "unique" --attributes username
appwrite databases create-index --database-id "core" --collection-id "users" --key "unique_phone"    --type "unique" --attributes phone
appwrite databases create-index --database-id "core" --collection-id "users" --key "unique_email"    --type "unique" --attributes email
appwrite databases create-index --database-id "core" --collection-id "users" --key "status_index"    --type "key"    --attributes status

# --- CHATS COLLECTION ---
appwrite databases create-collection --database-id "core" --collection-id "chats" --name "Chats" --permissions 'read("any")' 'write("any")'

appwrite databases create-string-attribute       --database-id "core" --collection-id "chats" --key "chatId"      --size 36   --required true
appwrite databases create-enum-attribute         --database-id "core" --collection-id "chats" --key "type"        --elements private,group,channel,bot,extension --required true
appwrite databases create-string-attribute       --database-id "core" --collection-id "chats" --key "title"       --size 64   --required false
appwrite databases create-url-attribute          --database-id "core" --collection-id "chats" --key "avatarUrl"  --required false
appwrite databases create-relationship-attribute --database-id "core" --collection-id "chats" --key "createdBy"   --related-collection-id "users" --type "oneToOne"
appwrite databases create-datetime-attribute     --database-id "core" --collection-id "chats" --key "createdAt"   --required true
appwrite databases create-datetime-attribute     --database-id "core" --collection-id "chats" --key "updatedAt"   --required true
appwrite databases create-boolean-attribute      --database-id "core" --collection-id "chats" --key "isEncrypted" --required false
appwrite databases create-string-attribute       --database-id "core" --collection-id "chats" --key "extensionType" --size 32 --required false

sleep 10

# Indexes for chats
appwrite databases create-index --database-id "core" --collection-id "chats" --key "unique_chatId"   --type "unique" --attributes chatId
# appwrite databases create-index --database-id "core" --collection-id "chats" --key "createdBy_index" --type "key"    --attributes createdBy
appwrite databases create-index --database-id "core" --collection-id "chats" --key "type_index"      --type "key"    --attributes type

# --- CHATMEMBERS COLLECTION ---
appwrite databases create-collection --database-id "core" --collection-id "chatmembers" --name "ChatMembers" --permissions 'read("any")' 'write("any")'

appwrite databases create-relationship-attribute --database-id "core" --collection-id "chatmembers" --key "chatId" --related-collection-id "chats" --type "oneToOne"
appwrite databases create-relationship-attribute --database-id "core" --collection-id "chatmembers" --key "userId" --related-collection-id "users" --type "oneToOne" 
appwrite databases create-enum-attribute         --database-id "core" --collection-id "chatmembers" --key "role"   --elements admin,member,owner,bot,extension --required true
appwrite databases create-datetime-attribute     --database-id "core" --collection-id "chatmembers" --key "joinedAt" --required true
appwrite databases create-datetime-attribute     --database-id "core" --collection-id "chatmembers" --key "mutedUntil" --required false

sleep 10

# Indexes for chatmembers
# appwrite databases create-index --database-id "core" --collection-id "chatmembers" --key "composite_chatId_userId" --type "unique" --attributes chatId userId
# appwrite databases create-index --database-id "core" --collection-id "chatmembers" --key "userId_index"            --type "key"    --attributes userId

# --- MESSAGES COLLECTION ---
appwrite databases create-collection --database-id "core" --collection-id "messages" --name "Messages" --permissions 'read("any")' 'write("any")'

appwrite databases create-string-attribute       --database-id "core" --collection-id "messages" --key "messageId"    --size 36   --required true
appwrite databases create-relationship-attribute --database-id "core" --collection-id "messages" --key "chatId"       --related-collection-id "chats" --type "oneToOne" 
appwrite databases create-relationship-attribute --database-id "core" --collection-id "messages" --key "senderId"     --related-collection-id "users" --type "oneToOne" 
appwrite databases create-string-attribute       --database-id "core" --collection-id "messages" --key "content"      --size 5000 --required true
appwrite databases create-enum-attribute         --database-id "core" --collection-id "messages" --key "type"         --elements text,image,file,audio,video,sticker,system --required false
appwrite databases create-datetime-attribute     --database-id "core" --collection-id "messages" --key "createdAt"    --required true
appwrite databases create-datetime-attribute     --database-id "core" --collection-id "messages" --key "editedAt"     --required false
appwrite databases create-relationship-attribute --database-id "core" --collection-id "messages" --key "replyTo"      --related-collection-id "messages" --type "oneToOne" 
appwrite databases create-boolean-attribute      --database-id "core" --collection-id "messages" --key "isDeleted"    --required false
appwrite databases create-string-attribute       --database-id "core" --collection-id "messages" --key "extensionPayload" --size 1000 --required false

sleep 10

# Indexes for messages
appwrite databases create-index --database-id "core" --collection-id "messages" --key "unique_messageId" --type "unique" --attributes messageId
# appwrite databases create-index --database-id "core" --collection-id "messages" --key "chatId_index"     --type "key"    --attributes chatId
# appwrite databases create-index --database-id "core" --collection-id "messages" --key "senderId_index"   --type "key"    --attributes senderId
appwrite databases create-index --database-id "core" --collection-id "messages" --key "createdAt_index"  --type "key"    --attributes createdAt

# --- CONTACTS COLLECTION ---
appwrite databases create-collection --database-id "core" --collection-id "contacts" --name "Contacts" --permissions 'read("any")' 'write("any")'

appwrite databases create-relationship-attribute --database-id "core" --collection-id "contacts" --key "ownerId"   --related-collection-id "users" --type "oneToOne" 
# appwrite databases create-relationship-attribute --database-id "core" --collection-id "contacts" --key "contactId" --related-collection-id "users" --type "oneToOne" 
appwrite databases create-datetime-attribute     --database-id "core" --collection-id "contacts" --key "createdAt" --required true
appwrite databases create-string-attribute       --database-id "core" --collection-id "contacts" --key "alias"     --size 64 --required false

sleep 10

# Indexes for contacts
# appwrite databases create-index --database-id "core" --collection-id "contacts" --key "composite_ownerId_contactId" --type "unique" --attributes ownerId,contactId
# appwrite databases create-index --database-id "core" --collection-id "contacts" --key "composite_ownerId_contactId" --type "unique" --attributes ownerId contactId
# --- DEVICES COLLECTION ---
appwrite databases create-collection --database-id "core" --collection-id "devices" --name "Devices" --permissions 'read("any")' 'write("any")'

appwrite databases create-string-attribute       --database-id "core" --collection-id "devices" --key "deviceId"   --size 36   --required true
appwrite databases create-relationship-attribute --database-id "core" --collection-id "devices" --key "userId"     --related-collection-id "users" --type "oneToOne" 
appwrite databases create-string-attribute       --database-id "core" --collection-id "devices" --key "deviceType" --size 32   --required true
appwrite databases create-string-attribute       --database-id "core" --collection-id "devices" --key "pushToken"  --size 255  --required false
appwrite databases create-datetime-attribute     --database-id "core" --collection-id "devices" --key "lastActive" --required true

sleep 10

# Indexes for devices
appwrite databases create-index --database-id "core" --collection-id "devices" --key "unique_deviceId" --type "unique" --attributes deviceId
# appwrite databases create-index --database-id "core" --collection-id "devices" --key "userId_index"    --type "key"    --attributes userId

# --- EXTENSIONS DATABASE (collections only, attributes to be defined as needed) ---
appwrite databases create-collection --database-id "extensions" --collection-id "bots"             --name "Bots"             --permissions 'read("any")' 'write("any")'
appwrite databases create-collection --database-id "extensions" --collection-id "web3wallets"      --name "Web3Wallets"      --permissions 'read("any")' 'write("any")'
appwrite databases create-collection --database-id "extensions" --collection-id "integrations"     --name "Integrations"     --permissions 'read("any")' 'write("any")'
appwrite databases create-collection --database-id "extensions" --collection-id "extensionsettings" --name "ExtensionSettings" --permissions 'read("any")' 'write("any")'

# --- USERNAMES COLLECTION (for username tracking, cooldown, history) ---
appwrite databases create-collection --database-id "core" --collection-id "usernames" --name "Usernames" --permissions 'read("any")' 'write("any")'

appwrite databases create-string-attribute   --database-id "core" --collection-id "usernames" --key "username"      --size 32   --required true
appwrite databases create-enum-attribute     --database-id "core" --collection-id "usernames" --key "status"        --elements active cooldown available banned --required true
appwrite databases create-relationship-attribute --database-id "core" --collection-id "usernames" --key "lastUsedBy" --related-collection-id "users" --type "oneToOne"
appwrite databases create-datetime-attribute --database-id "core" --collection-id "usernames" --key "lastUsedAt"    --required false
appwrite databases create-datetime-attribute --database-id "core" --collection-id "usernames" --key "cooldownUntil" --required false
appwrite databases create-string-attribute   --database-id "core" --collection-id "usernames" --key "history"       --size 36   --required false --array true

sleep 10

# Indexes for usernames
appwrite databases create-index --database-id "core" --collection-id "usernames" --key "unique_username" --type "unique" --attributes username
appwrite databases create-index --database-id "core" --collection-id "usernames" --key "status_index"    --type "key"    --attributes status

# --- USERS COLLECTION MODIFICATIONS (add new attributes for credibility, recovery, etc.) ---
appwrite databases create-integer-attribute  --database-id "core" --collection-id "users" --key "usernameCredibility" --min 0 --max 100 --required false
appwrite databases create-string-attribute   --database-id "core" --collection-id "users" --key "usernameHistory"     --size 32 --required false --array true
appwrite databases create-datetime-attribute --database-id "core" --collection-id "users" --key "usernameChangedAt"   --required false
appwrite databases create-enum-attribute     --database-id "core" --collection-id "users" --key "credibilityTier"     --elements bronze silver gold platinum diamond --required false
appwrite databases create-integer-attribute  --database-id "core" --collection-id "users" --key "credibilityScore"    --min 0 --max 100 --required false
appwrite databases create-string-attribute   --database-id "core" --collection-id "users" --key "credibilityHistory"  --size 255 --required false --array true
appwrite databases create-boolean-attribute  --database-id "core" --collection-id "users" --key "twoFactorEnabled"    --required false
appwrite databases create-boolean-attribute  --database-id "core" --collection-id "users" --key "emailVerified"       --required false
appwrite databases create-boolean-attribute  --database-id "core" --collection-id "users" --key "phoneVerified"       --required false
appwrite databases create-boolean-attribute  --database-id "core" --collection-id "users" --key "encryptionKeyExported" --required false
appwrite databases create-boolean-attribute  --database-id "core" --collection-id "users" --key "recoveryPhraseBackedUp" --required false
appwrite databases create-string-attribute   --database-id "core" --collection-id "users" --key "encryptedPrivateKey" --size 2000 --required false

echo "Usernames collection and new user attributes for credibility, recovery, and tracking created successfully."

echo "All collections, attributes, and indexes created successfully."