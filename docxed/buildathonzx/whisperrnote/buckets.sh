# Create storage buckets for WhisperrNote

appwrite storage create-bucket --bucket-id "profile_pictures" --name "profile_pictures" --permissions 'create("users")' 'read("users")' 'update("users")' 'delete("users")' --file-security false --maximum-file-size 5000000000 --compression "none" --encryption true --antivirus true

appwrite storage create-bucket --bucket-id "notes_attachments" --name "notes_attachments" --permissions 'create("users")' 'read("users")' 'update("users")' 'delete("users")' --file-security false --maximum-file-size 5000000000 --compression "none" --encryption true --antivirus true

appwrite storage create-bucket --bucket-id "blog_media" --name "blog_media" --permissions 'create("users")' 'read("users")' 'update("users")' 'delete("users")' --file-security false --maximum-file-size 5000000000 --compression "none" --encryption true --antivirus true

appwrite storage create-bucket --bucket-id "extension_assets" --name "extension_assets" --permissions 'create("users")' 'read("users")' 'update("users")' 'delete("users")' --file-security false --maximum-file-size 5000000000 --compression "none" --encryption true --antivirus true

appwrite storage create-bucket --bucket-id "backups" --name "backups" --permissions 'create("users")' 'read("users")' 'update("users")' 'delete("users")' --file-security false --maximum-file-size 5000000000 --compression "none" --encryption true --antivirus true

appwrite storage create-bucket --bucket-id "temp_uploads" --name "temp_uploads" --permissions 'create("users")' 'read("users")' 'update("users")' 'delete("users")' --file-security false --maximum-file-size 5000000000 --compression "none" --encryption true --antivirus true

# --- END OF BUCKET CREATION SCRIPT ---
