#!/bin/bash

# Appwrite Project Configuration
MY_APPWRITE_ENDPOINT="https://fra.cloud.appwrite.io/v1"
MY_APPWRITE_PROJECT_ID="684332040001eee05350"

MY_DATABASE_ID="passwordManagerDb"

# Create Database
appwrite databases create --database-id "$MY_DATABASE_ID" --name "PasswordManagerDB"

# Create Collections
appwrite databases create-collection --database-id "$MY_DATABASE_ID" --collection-id "credentials" --name "Credentials" --document-security true
appwrite databases create-collection --database-id "$MY_DATABASE_ID" --collection-id "totpSecrets" --name "TOTP Secrets" --document-security true
appwrite databases create-collection --database-id "$MY_DATABASE_ID" --collection-id "folders" --name "Folders" --document-security true
appwrite databases create-collection --database-id "$MY_DATABASE_ID" --collection-id "securityLogs" --name "Security Logs" --document-security true

# Credentials Attributes (reduced sizes to fit within limits)
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "credentials" --key "userId" --size 255 --required true
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "credentials" --key "name" --size 255 --required true
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "credentials" --key "url" --size 1024 --required false
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "credentials" --key "username" --size 3000 --required true
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "credentials" --key "password" --size 3000 --required true
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "credentials" --key "notes" --size 5000 --required false
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "credentials" --key "folderId" --size 255 --required false
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "credentials" --key "tags" --size 100 --required false --array true
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "credentials" --key "customFields" --size 5000 --required false
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "credentials" --key "faviconUrl" --size 1024 --required false
appwrite databases create-datetime-attribute --database-id "$MY_DATABASE_ID" --collection-id "credentials" --key "createdAt" --required false
appwrite databases create-datetime-attribute --database-id "$MY_DATABASE_ID" --collection-id "credentials" --key "updatedAt" --required false

# TOTPSecrets Attributes (fix default parameter syntax)
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "totpSecrets" --key "userId" --size 255 --required true
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "totpSecrets" --key "issuer" --size 255 --required true
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "totpSecrets" --key "accountName" --size 255 --required true
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "totpSecrets" --key "secretKey" --size 3000 --required true
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "totpSecrets" --key "algorithm" --size 10 --required false --xdefault "SHA1"
appwrite databases create-integer-attribute --database-id "$MY_DATABASE_ID" --collection-id "totpSecrets" --key "digits" --required false --xdefault 6
appwrite databases create-integer-attribute --database-id "$MY_DATABASE_ID" --collection-id "totpSecrets" --key "period" --required false --xdefault 30
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "totpSecrets" --key "folderId" --size 255 --required false
appwrite databases create-datetime-attribute --database-id "$MY_DATABASE_ID" --collection-id "totpSecrets" --key "createdAt" --required false
appwrite databases create-datetime-attribute --database-id "$MY_DATABASE_ID" --collection-id "totpSecrets" --key "updatedAt" --required false

# Folders Attributes
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "folders" --key "userId" --size 255 --required true
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "folders" --key "name" --size 255 --required true
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "folders" --key "parentFolderId" --size 255 --required false
appwrite databases create-datetime-attribute --database-id "$MY_DATABASE_ID" --collection-id "folders" --key "createdAt" --required false
appwrite databases create-datetime-attribute --database-id "$MY_DATABASE_ID" --collection-id "folders" --key "updatedAt" --required false

# SecurityLogs Attributes
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "securityLogs" --key "userId" --size 255 --required true
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "securityLogs" --key "eventType" --size 100 --required true
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "securityLogs" --key "ipAddress" --size 45 --required false
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "securityLogs" --key "userAgent" --size 512 --required false
appwrite databases create-string-attribute --database-id "$MY_DATABASE_ID" --collection-id "securityLogs" --key "details" --size 5000 --required false
appwrite databases create-datetime-attribute --database-id "$MY_DATABASE_ID" --collection-id "securityLogs" --key "timestamp" --required true

# Wait for attributes to be ready
sleep 15

# Indexes for Credentials
appwrite databases create-index --database-id "$MY_DATABASE_ID" --collection-id "credentials" --key "idx_userId" --type "key" --attributes "userId"
appwrite databases create-index --database-id "$MY_DATABASE_ID" --collection-id "credentials" --key "idx_folderId" --type "key" --attributes "folderId"
appwrite databases create-index --database-id "$MY_DATABASE_ID" --collection-id "credentials" --key "idx_tags" --type "key" --attributes "tags"

# Indexes for TOTPSecrets
appwrite databases create-index --database-id "$MY_DATABASE_ID" --collection-id "totpSecrets" --key "idx_userId" --type "key" --attributes "userId"
appwrite databases create-index --database-id "$MY_DATABASE_ID" --collection-id "totpSecrets" --key "idx_folderId" --type "key" --attributes "folderId"

# Indexes for Folders
appwrite databases create-index --database-id "$MY_DATABASE_ID" --collection-id "folders" --key "idx_userId" --type "key" --attributes "userId"
appwrite databases create-index --database-id "$MY_DATABASE_ID" --collection-id "folders" --key "idx_parentFolderId" --type "key" --attributes "parentFolderId"

# Indexes for SecurityLogs
appwrite databases create-index --database-id "$MY_DATABASE_ID" --collection-id "securityLogs" --key "idx_userId" --type "key" --attributes "userId"
appwrite databases create-index --database-id "$MY_DATABASE_ID" --collection-id "securityLogs" --key "idx_eventType" --type "key" --attributes "eventType"
appwrite databases create-index --database-id "$MY_DATABASE_ID" --collection-id "securityLogs" --key "idx_timestamp" --type "key" --attributes "timestamp" --orders "DESC"
