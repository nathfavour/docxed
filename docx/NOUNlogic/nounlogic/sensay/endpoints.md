chat completions:
curl \
 --request POST 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53/chat/completions' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-USER-ID: $API_KEY" \
 --header "Content-Type: application/json" \
 --header "X-API-Version: 2025-03-25" \
 --data '{"content":"How did you handle the immense pressure during the Civil War?","skip_chat_history":false,"source":"discord","discord_data":{"channel_id":"string","channel_name":"string","author_id":"string","author_name":"string","message_id":"string","created_at":"string","server_id":"string","server_name":"string"}}'




chat history:
curl \
 --request GET 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53/chat/history' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-USER-ID: $API_KEY" \
 --header "X-API-Version: 2025-03-25"



get chat history:
curl \
 --request GET 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53/chat/history' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-USER-ID: $API_KEY" \
 --header "X-API-Version: 2025-03-25"




create a chat history entry:
curl \
 --request POST 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53/chat/history' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-USER-ID: $API_KEY" \
 --header "Content-Type: application/json" \
 --header "X-API-Version: 2025-03-25" \
 --data '{"content":"How did you handle the immense pressure during the Civil War?","source":"discord","discord_data":{"channel_id":"string","channel_name":"string","author_id":"string","author_name":"string","message_id":"string","created_at":"string","server_id":"string","server_name":"string"}}'



get web chat history:
curl \
 --request GET 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53/chat/history/web' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-USER-ID: $API_KEY"





get embed chat widget:
curl \
 --request GET 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53/chat/history/embed' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-USER-ID: $API_KEY"





get discord chat history:
curl \
 --request GET 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53/chat/history/discord' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-USER-ID: $API_KEY"








