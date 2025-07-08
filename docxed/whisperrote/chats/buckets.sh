# Create user avatars bucket
appwrite storage create-bucket \
  --bucket-id "user-avatars" \
  --name "User Avatars" \
  --file-security true

# Create chat media bucket
appwrite storage create-bucket \
  --bucket-id "chat-media" \
  --name "Chat Media" \
  --file-security true

# Create backgrounds bucket
appwrite storage create-bucket \
  --bucket-id "backgrounds" \
  --name "Backgrounds" \
  --file-security true

# Create extension assets bucket
appwrite storage create-bucket \
  --bucket-id "extension-assets" \
  --name "Extension Assets" \
  --file-security true

# (Optional) Create stickers bucket
# appwrite storage create-bucket \
#   --bucket-id "stickers" \
#   --name "Stickers" \
#   --file-security true

# (Optional) Create temp uploads bucket
# appwrite storage create-bucket \
#   --bucket-id "temp-uploads" \
#   --name "Temp Uploads" \
#   --file-security true

# (Optional) Create logs bucket
# appwrite storage create-bucket \
#   --bucket-id "logs" \
#   --name "Logs" \
#   --file-security true
