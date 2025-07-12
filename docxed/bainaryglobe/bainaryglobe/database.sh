# Create BainaryGlobe core database
appwrite databases create --database-id "bainaryglobe" --name "BainaryGlobe"

# --- USERS COLLECTION ---
appwrite databases create-collection --database-id "bainaryglobe" --collection-id "users" --name "Users"
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "users" --key "userId" --size 36 --required true --array false
appwrite databases create-email-attribute --database-id "bainaryglobe" --collection-id "users" --key "email" --required true --array false
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "users" --key "name" --size 64 --required true --array false
appwrite databases create-enum-attribute --database-id "bainaryglobe" --collection-id "users" --key "role" --elements "admin,privileged,regular,product_owner,third_party" --required true --array false
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "users" --key "products" --size 1000 --required false --array true
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "users" --key "oauthProviders" --size 1000 --required false --array true
appwrite databases create-datetime-attribute --database-id "bainaryglobe" --collection-id "users" --key "createdAt" --required true --array false
appwrite databases create-datetime-attribute --database-id "bainaryglobe" --collection-id "users" --key "updatedAt" --required false --array false

# --- PRODUCTS COLLECTION ---
appwrite databases create-collection --database-id "bainaryglobe" --collection-id "products" --name "Products"
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "products" --key "productId" --size 36 --required true --array false
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "products" --key "name" --size 64 --required true --array false
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "products" --key "description" --size 255 --required false --array false
appwrite databases create-boolean-attribute --database-id "bainaryglobe" --collection-id "products" --key "standalone" --required true --array false
appwrite databases create-boolean-attribute --database-id "bainaryglobe" --collection-id "products" --key "ourApp" --required true --array false
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "products" --key "owners" --size 1000 --required false --array true
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "products" --key "modules" --size 1000 --required false --array true
appwrite databases create-boolean-attribute --database-id "bainaryglobe" --collection-id "products" --key "oauthEnabled" --required true --array false
appwrite databases create-datetime-attribute --database-id "bainaryglobe" --collection-id "products" --key "createdAt" --required true --array false
appwrite databases create-datetime-attribute --database-id "bainaryglobe" --collection-id "products" --key "updatedAt" --required false --array false

# --- MODULES COLLECTION ---
appwrite databases create-collection --database-id "bainaryglobe" --collection-id "modules" --name "Modules"
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "modules" --key "moduleId" --size 36 --required true --array false
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "modules" --key "productId" --size 36 --required true --array false
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "modules" --key "name" --size 64 --required true --array false
appwrite databases create-enum-attribute --database-id "bainaryglobe" --collection-id "modules" --key "type" --elements "blog,dashboard,analytics" --required true --array false
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "modules" --key "config" --size 1000 --required false --array false
appwrite databases create-datetime-attribute --database-id "bainaryglobe" --collection-id "modules" --key "createdAt" --required true --array false
appwrite databases create-datetime-attribute --database-id "bainaryglobe" --collection-id "modules" --key "updatedAt" --required false --array false

# --- PERMISSIONS COLLECTION ---
appwrite databases create-collection --database-id "bainaryglobe" --collection-id "permissions" --name "Permissions"
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "permissions" --key "permissionId" --size 36 --required true --array false
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "permissions" --key "userId" --size 36 --required true --array false
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "permissions" --key "productId" --size 36 --required true --array false
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "permissions" --key "moduleId" --size 36 --required false --array false
appwrite databases create-enum-attribute --database-id "bainaryglobe" --collection-id "permissions" --key "accessLevel" --elements "read,write,admin" --required true --array false
appwrite databases create-datetime-attribute --database-id "bainaryglobe" --collection-id "permissions" --key "createdAt" --required true --array false
appwrite databases create-datetime-attribute --database-id "bainaryglobe" --collection-id "permissions" --key "updatedAt" --required false --array false

# --- OAUTHCLIENTS COLLECTION ---
appwrite databases create-collection --database-id "bainaryglobe" --collection-id "oauthclients" --name "OAuthClients"
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "oauthclients" --key "clientId" --size 36 --required true --array false
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "oauthclients" --key "name" --size 64 --required true --array false
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "oauthclients" --key "redirectUris" --size 1000 --required true --array true
appwrite databases create-boolean-attribute --database-id "bainaryglobe" --collection-id "oauthclients" --key "ourApp" --required true --array false
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "oauthclients" --key "ownerId" --size 36 --required true --array false
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "oauthclients" --key "scopes" --size 1000 --required false --array true
appwrite databases create-boolean-attribute --database-id "bainaryglobe" --collection-id "oauthclients" --key "verificationSkipped" --required false --array false
appwrite databases create-datetime-attribute --database-id "bainaryglobe" --collection-id "oauthclients" --key "createdAt" --required true --array false
appwrite databases create-datetime-attribute --database-id "bainaryglobe" --collection-id "oauthclients" --key "updatedAt" --required false --array false

# --- CONTENT COLLECTION ---
appwrite databases create-collection --database-id "bainaryglobe" --collection-id "content" --name "Content"
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "content" --key "contentId" --size 36 --required true --array false
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "content" --key "productId" --size 36 --required true --array false
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "content" --key "moduleId" --size 36 --required true --array false
appwrite databases create-enum-attribute --database-id "bainaryglobe" --collection-id "content" --key "type" --elements "page,blog,footer" --required true --array false
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "content" --key "data" --size 5000 --required true --array false
appwrite databases create-string-attribute --database-id "bainaryglobe" --collection-id "content" --key "createdBy" --size 36 --required true --array false
appwrite databases create-datetime-attribute --database-id "bainaryglobe" --collection-id "content" --key "createdAt" --required true --array false
appwrite databases create-datetime-attribute --database-id "bainaryglobe" --collection-id "content" --key "updatedAt" --required false --array false
