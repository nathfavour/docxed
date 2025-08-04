#!/bin/bash

# Create databases
appwrite databases create --database-id "core" --name "core"
appwrite databases create --database-id "extensions" --name "extensions"

# --- USERS COLLECTION ---
appwrite databases create-collection --database-id "core" --collection-id "users" --name "Users" --permissions 'read("any")' 'write("any")'

appwrite databases create-string-attribute --database-id "core" --collection-id "users" --key "userId" --size 36 --required true --array false
appwrite databases create-string-attribute --database-id "core" --collection-id "users" --key "username" --size 32 --required true --array false
appwrite databases create-string-attribute --database-id "core" --collection-id "users" --key "displayName" --size 64 --required false --array false
appwrite databases create-url-attribute --database-id "core" --collection-id "users" --key "avatarUrl" --required false --array false
appwrite databases create-string-attribute --database-id "core" --collection-id "users" --key "bio" --size 255 --required false --array false
appwrite databases create-string-attribute --database-id "core" --collection-id "users" --key "phone" --size 20 --required false --array false
appwrite databases create-email-attribute --database-id "core" --collection-id "users" --key "email" --required false --array false
appwrite databases create-string-attribute --database-id "core" --collection-id "users" --key "publicKey" --size 1000 --required true --array false
appwrite databases create-datetime-attribute --database-id "core" --collection-id "users" --key "createdAt" --required true --array false
appwrite databases create-datetime-attribute --database-id "core" --collection-id "users" --key "lastSeen" --required false --array false
appwrite databases create-enum-attribute --database-id "core" --collection-id "users" --key "status" --elements "online,offline,away" --required false --array false

# --- CHATS COLLECTION ---
appwrite databases create-collection --database-id "core" --collection-id "chats" --name "Chats" --permissions 'read("any")' 'write("any")'

appwrite databases create-string-attribute --database-id "core" --collection-id "chats" --key "chatId" --size 36 --required true --array false
appwrite databases create-enum-attribute --database-id "core" --collection-id "chats" --key "type" --elements "private,group,channel,bot,extension" --required true --array false
appwrite databases create-string-attribute --database-id "core" --collection-id "chats" --key "title" --size 64 --required false --array false
appwrite databases create-url-attribute --database-id "core" --collection-id "chats" --key "avatarUrl" --required false --array false
appwrite databases create-relationship-attribute --database-id "core" --collection-id "chats" --key "createdBy" --related-collection-id "users" --type "oneToOne"
appwrite databases create-datetime-attribute --database-id "core" --collection-id "chats" --key "createdAt" --required true --array false
appwrite databases create-datetime-attribute --database-id "core" --collection-id "chats" --key "updatedAt" --required false --array false
appwrite databases create-boolean-attribute --database-id "core" --collection-id "chats" --key "isEncrypted" --required true --array false --default true
appwrite databases create-string-attribute --database-id "core" --collection-id "chats" --key "extensionType" --size 32 --required false --array false

# --- CHATMEMBERS COLLECTION ---
appwrite databases create-collection --database-id "core" --collection-id "chatmembers" --name "ChatMembers" --permissions 'read("any")' 'write("any")'

appwrite databases create-relationship-attribute --database-id "core" --collection-id "chatmembers" --key "chatId" --related-collection-id "chats" --type "oneToOne"
appwrite databases create-relationship-attribute --database-id "core" --collection-id "chatmembers" --key "userId" --related-collection-id "users" --type "oneToOne"
appwrite databases create-enum-attribute --database-id "core" --collection-id "chatmembers" --key "role" --elements "admin,member,owner,bot,extension" --required true --array false
appwrite databases create-datetime-attribute --database-id "core" --collection-id "chatmembers" --key "joinedAt" --required false --array false
appwrite databases create-datetime-attribute --database-id "core" --collection-id "chatmembers" --key "mutedUntil" --required false --array false

# --- MESSAGES COLLECTION ---
appwrite databases create-collection --database-id "core" --collection-id "messages" --name "Messages" --permissions 'read("any")' 'write("any")'

appwrite databases create-string-attribute --database-id "core" --collection-id "messages" --key "messageId" --size 36 --required true --array false
appwrite databases create-relationship-attribute --database-id "core" --collection-id "messages" --key "chatId" --related-collection-id "chats" --type "oneToOne"
appwrite databases create-relationship-attribute --database-id "core" --collection-id "messages" --key "senderId" --related-collection-id "users" --type "oneToOne"
appwrite databases create-string-attribute --database-id "core" --collection-id "messages" --key "content" --size 5000 --required true --array false
appwrite databases create-enum-attribute --database-id "core" --collection-id "messages" --key "type" --elements "text,image,file,audio,video,sticker,system" --required true --array false
appwrite databases create-datetime-attribute --database-id "core" --collection-id "messages" --key "createdAt" --required true --array false
appwrite databases create-datetime-attribute --database-id "core" --collection-id "messages" --key "editedAt" --required false --array false
appwrite databases create-relationship-attribute --database-id "core" --collection-id "messages" --key "replyTo" --related-collection-id "messages" --type "oneToOne"
appwrite databases create-boolean-attribute --database-id "core" --collection-id "messages" --key "isDeleted" --required true --array false --default false
appwrite databases create-string-attribute --database-id "core" --collection-id "messages" --key "extensionPayload" --size 1000 --required false --array false

# --- CONTACTS COLLECTION ---
appwrite databases create-collection --database-id "core" --collection-id "contacts" --name "Contacts" --permissions 'read("any")' 'write("any")'

appwrite databases create-relationship-attribute --database-id "core" --collection-id "contacts" --key "ownerId" --related-collection-id "users" --type "oneToOne"
appwrite databases create-relationship-attribute --database-id "core" --collection-id "contacts" --key "contactId" --related-collection-id "users" --type "oneToOne"
appwrite databases create-datetime-attribute --database-id "core" --collection-id "contacts" --key "createdAt" --required false --array false
appwrite databases create-string-attribute --database-id "core" --collection-id "contacts" --key "alias" --size 64 --required false --array false

# --- DEVICES COLLECTION ---
appwrite databases create-collection --database-id "core" --collection-id "devices" --name "Devices" --permissions 'read("any")' 'write("any")'

appwrite databases create-string-attribute --database-id "core" --collection-id "devices" --key "deviceId" --size 36 --required true --array false
appwrite databases create-relationship-attribute --database-id "core" --collection-id "devices" --key "userId" --related-collection-id "users" --type "oneToOne"
appwrite databases create-string-attribute --database-id "core" --collection-id "devices" --key "deviceType" --size 32 --required true --array false
appwrite databases create-string-attribute --database-id "core" --collection-id "devices" --key "pushToken" --size 255 --required false --array false
appwrite databases create-datetime-attribute --database-id "core" --collection-id "devices" --key "lastActive" --required false --array false

# --- EXTENSIONS DATABASE (collections only, attributes to be defined as needed) ---
appwrite databases create-collection --database-id "extensions" --collection-id "bots" --name "Bots" --permissions 'read("any")' 'write("any")'
appwrite databases create-collection --database-id "extensions" --collection-id "web3wallets" --name "Web3Wallets" --permissions 'read("any")' 'write("any")'
appwrite databases create-collection --database-id "extensions" --collection-id "integrations" --name "Integrations" --permissions 'read("any")' 'write("any")'
appwrite databases create-collection --database-id "extensions" --collection-id "extensionsettings" --name "ExtensionSettings" --permissions 'read("any")' 'write("any")'

# Add extension attributes as needed, using String (maxLength: 1000) for JSON-like fields.
