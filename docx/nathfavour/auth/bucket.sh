#!/bin/bash

APPWRITE_ENDPOINT="YOUR_ENDPOINT_URL"
APPWRITE_PROJECT_ID="YOUR_PROJECT_ID"
APPWRITE_API_KEY="YOUR_API_KEY"

appwrite client --endpoint "$APPWRITE_ENDPOINT" --project-id "$APPWRITE_PROJECT_ID" --key "$APPWRITE_API_KEY"

# User Avatars Bucket
appwrite storage create-bucket \
    --bucket-id "userAvatars" \
    --name "User Avatars" \
    --permissions "create(\"role:member\")" \
    --file-security true \
    --maximum-file-size 2000000 \
    --allowed-file-extensions "jpg" \
    --allowed-file-extensions "jpeg" \
    --allowed-file-extensions "png" \
    --encryption true \
    --antivirus true

# Encrypted Data Backups Bucket
appwrite storage create-bucket \
    --bucket-id "encryptedDataBackups" \
    --name "Encrypted Data Backups" \
    --permissions "create(\"role:member\")" \
    --file-security true \
    --maximum-file-size 50000000 \
    --allowed-file-extensions "backup" \
    --allowed-file-extensions "enc" \
    --encryption true \
    --antivirus true
