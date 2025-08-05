#!/bin/bash

# Create main database (safe to re-run)
appwrite databases create --database-id "core" --name "core"

# --- USERS COLLECTION ATTRIBUTES ---
appwrite databases create-string-attribute --database-id "core" --collection-id "users" --key "name" --size 64 --array false --required true
appwrite databases create-email-attribute --database-id "core" --collection-id "users" --key "email" --array false --required true
appwrite databases create-url-attribute --database-id "core" --collection-id "users" --key "avatarUrl" --array false --required false
appwrite databases create-datetime-attribute --database-id "core" --collection-id "users" --key "createdAt" --array false --required false
appwrite databases create-boolean-attribute --database-id "core" --collection-id "users" --key "deleted" --array false --xdefault false --required false

# --- PROJECTS COLLECTION ATTRIBUTES ---
appwrite databases create-string-attribute --database-id "core" --collection-id "projects" --key "name" --size 64 --array false --required true
appwrite databases create-string-attribute --database-id "core" --collection-id "projects" --key "description" --size 255 --array false --required false
appwrite databases create-relationship-attribute --database-id "core" --collection-id "projects" --key "owner" --related-collection-id "users" --type "oneToOne"
appwrite databases create-datetime-attribute --database-id "core" --collection-id "projects" --key "createdAt" --array false --required false
appwrite databases create-datetime-attribute --database-id "core" --collection-id "projects" --key "updatedAt" --array false --required false
appwrite databases create-boolean-attribute --database-id "core" --collection-id "projects" --key "deleted" --array false --xdefault false --required false

# --- BOTS COLLECTION ATTRIBUTES ---
appwrite databases create-string-attribute --database-id "core" --collection-id "bots" --key "name" --size 64 --array false --required true
appwrite databases create-string-attribute --database-id "core" --collection-id "bots" --key "type" --size 32 --array false --required true
appwrite databases create-relationship-attribute --database-id "core" --collection-id "bots" --key "projectId" --related-collection-id "projects" --type "oneToOne"
appwrite databases create-string-attribute --database-id "core" --collection-id "bots" --key "config" --size 1000 --array false --required false
appwrite databases create-string-attribute --database-id "core" --collection-id "bots" --key "status" --size 16 --array false --required false
appwrite databases create-datetime-attribute --database-id "core" --collection-id "bots" --key "createdAt" --array false --required false
appwrite databases create-datetime-attribute --database-id "core" --collection-id "bots" --key "updatedAt" --array false --required false
appwrite databases create-boolean-attribute --database-id "core" --collection-id "bots" --key "deleted" --array false --xdefault false --required false

# --- AGENTS COLLECTION ATTRIBUTES ---
appwrite databases create-string-attribute --database-id "core" --collection-id "agents" --key "name" --size 64 --array false --required true
appwrite databases create-relationship-attribute --database-id "core" --collection-id "agents" --key "projectId" --related-collection-id "projects" --type "oneToOne"
appwrite databases create-string-attribute --database-id "core" --collection-id "agents" --key "config" --size 1000 --array false --required false
appwrite databases create-string-attribute --database-id "core" --collection-id "agents" --key "status" --size 16 --array false --required false
appwrite databases create-datetime-attribute --database-id "core" --collection-id "agents" --key "createdAt" --array false --required false
appwrite databases create-datetime-attribute --database-id "core" --collection-id "agents" --key "updatedAt" --array false --required false
appwrite databases create-boolean-attribute --database-id "core" --collection-id "agents" --key "deleted" --array false --xdefault false --required false

# --- MESSAGES COLLECTION ATTRIBUTES ---
appwrite databases create-relationship-attribute --database-id "core" --collection-id "messages" --key "botId" --related-collection-id "bots" --type "oneToOne"
appwrite databases create-relationship-attribute --database-id "core" --collection-id "messages" --key "agentId" --related-collection-id "agents" --type "oneToOne"
appwrite databases create-relationship-attribute --database-id "core" --collection-id "messages" --key "projectId" --related-collection-id "projects" --type "oneToOne"
appwrite databases create-relationship-attribute --database-id "core" --collection-id "messages" --key "userId" --related-collection-id "users" --type "oneToOne"
appwrite databases create-string-attribute --database-id "core" --collection-id "messages" --key "content" --size 5000 --array false --required true
appwrite databases create-string-attribute --database-id "core" --collection-id "messages" --key "type" --size 16 --array false --required false
appwrite databases create-datetime-attribute --database-id "core" --collection-id "messages" --key "timestamp" --array false --required false
appwrite databases create-boolean-attribute --database-id "core" --collection-id "messages" --key "deleted" --array false --xdefault false --required false

# --- SETTINGS COLLECTION ATTRIBUTES ---
appwrite databases create-relationship-attribute --database-id "core" --collection-id "settings" --key "userId" --related-collection-id "users" --type "oneToOne"
appwrite databases create-relationship-attribute --database-id "core" --collection-id "settings" --key "projectId" --related-collection-id "projects" --type "oneToOne"
appwrite databases create-string-attribute --database-id "core" --collection-id "settings" --key "key" --size 64 --array false --required true
appwrite databases create-string-attribute --database-id "core" --collection-id "settings" --key "value" --size 1000 --array false --required false
appwrite databases create-boolean-attribute --database-id "core" --collection-id "settings" --key "deleted" --array false --xdefault false --required false

