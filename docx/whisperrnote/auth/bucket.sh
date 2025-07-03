#!/bin/bash

# MY_APPWRITE_ENDPOINT="https://fra.cloud.appwrite.io/v1"
# MY_APPWRITE_PROJECT_ID="684332040001eee05350"

# change variable to my appwrite endpoint. 
# appwrite client --endpoint "$MY_APPWRITE_ENDPOINT" --project-id "$MY_APPWRITE_PROJECT_ID"

# User Avatars Bucket
appwrite storage create-bucket \
    --bucket-id "userAvatars" \
    --name "User Avatars" \
    --permissions "create(\"users\")" \
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
    --permissions "create(\"users\")" \
    --file-security true \
    --maximum-file-size 50000000 \
    --allowed-file-extensions "backup" \
    --allowed-file-extensions "enc" \
    --encryption true \
    --antivirus true
