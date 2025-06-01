Sensay API
2025-03-25
Base URL
https://api.sensay.io
Introduction
This is the API for Sensay Platform.

You can find out more about Sensay at https://sensay.io.

Interested in using our API? You can request an API key by visiting the Sensay API account request form.

This API is an OpenAPI 3.0.0 (previously known as Swagger) API and as such you can make use of the extensive tools developed for OpenAPI: find them at https://tools.openapis.org.

You can play around with the API via Swagger UI at https://api.sensay.io/ui.



Please note that we are constantly evolving our API.

Join the Sensay API announcements Telegram channel to be notified in advance of breaking changes and new major features.

This is version 2025-03-25 of this API documentation. Last update on May 20, 2025.

Getting started
In this Getting started guide, we will assume you have already obtained your organization's Secret Service Token, which you will need to use in your server-to-server requests against https://api.sensay.io.

Walkthrough


All API requests must include a Content-Type header.



Specifying the API version as a X-API-Version header is highly recommended, as it will allow you to handle breaking changes without errors. All breaking changes are announced on our Sensay API Telegram Channel.

Set your variables
export USER_ID=test_user_id
export ORGANIZATION_SECRET=your_secret_token
export API_VERSION=2025-03-25
1. Create a user in your organization
Each organization can have many users. We will first create a new user for your organization:

curl -X POST https://api.sensay.io/v1/users \
 -H "X-ORGANIZATION-SECRET: $ORGANIZATION_SECRET" \
 -H "X-API-Version: $API_VERSION" \
 -H "Content-Type: application/json" \
 -d '{"id": "'"$USER_ID"'"}'
Example response:

{ "id": "test_user_id", "linkedAccounts": [] }
The id field is optional and allows you to provide a unique identifier for the user in your organization. It is used to identify the user in further requests. If you do not provide a user id, the API will generate a unique one for you:

curl -X POST https://api.sensay.io/v1/users \
 -H "X-ORGANIZATION-SECRET: $ORGANIZATION_SECRET" \
 -H "X-API-Version: $API_VERSION" \
 -H "Content-Type: application/json" \
 -d '{}'
Example response:

{ "id": "12345678-1234-1234-1234-123456789abc", "linkedAccounts": [] }
2. Create a user replica in your organization
Replicas belong to users, so we can create a new replica belonging to the user we created:

curl -X POST https://api.sensay.io/v1/replicas \
 -H "X-ORGANIZATION-SECRET: $ORGANIZATION_SECRET" \
 -H "X-API-Version: $API_VERSION" \
 -H "Content-Type: application/json" \
 -d '{
   "name": "My Replica",
   "shortDescription": "A helpful assistant",
   "greeting": "Hi there! How can I help you today?",
   "ownerID": "'"$USER_ID"'",
   "private": false,
   "slug": "my-replica",
   "llm": {
     "provider": "openai",
     "model": "gpt-4o"
   }
 }'
You will get a response similar to this one with the replica UUID returned.

{"success": true, "uuid": "12345678-1234-1234-1234-123456789abc"}
Export the replica UUID to use it in the next steps.

export REPLICA_UUID=copy_and_paste_the_uuid_returned_above
3. List replicas accessible by the user of your organization
curl -X GET https://api.sensay.io/v1/replicas \
 -H "X-ORGANIZATION-SECRET: $ORGANIZATION_SECRET" \
 -H "X-API-Version: $API_VERSION" \
 -H "Content-Type: application/json" \
 -H "X-USER-ID: $USER_ID"
The response will include all replicas that the user has access to, including private ones:

{
  "success": true,
  "type": "array",
  "items": [
    {
      "uuid": "12345678-1234-1234-1234-123456789abc",
      "name": "My Replica",
      "slug": "my-replica",
      "profile_image": "https://sensay.io/assets/default-replica-profile.webp",
      "short_description": "A helpful assistant",
      "introduction": "Hi there! How can I help you today?",
      "tags": [],
      "created_at": "2025-04-15T08:05:03.167222+00:00",
      "owner_uuid": "12345678-1234-1234-1234-123456789abc",
      "voice_enabled": false,
      "video_enabled": false,
      "chat_history_count": 0,
      "system_message": "",
      "telegram_service_name": null,
      "discord_service_name": null,
      "discord_is_active": null,
      "telegram_integration": null,
      "discord_integration": null
    }
  ],
  "total": 1
}

Alternatively, list all replicas within your Organization, including private ones:

curl -X GET https://api.sensay.io/v1/replicas \
 -H "Content-Type: application/json" \
 -H "X-API-Version: $API_VERSION" \
 -H "X-ORGANIZATION-SECRET: $ORGANIZATION_SECRET"


By not specifying X-USER-ID you are performing the request as an admin, hence listing all replicas within your Organization, including non-listed and private ones.

4. Get all chat history between a user and a replica
curl -X GET https://api.sensay.io/v1/replicas/$REPLICA_UUID/chat/history \
 -H "Content-Type: application/json" \
 -H "X-API-Version: $API_VERSION" \
 -H "X-ORGANIZATION-SECRET: $ORGANIZATION_SECRET" \
 -H "X-USER-ID: $USER_ID"
Initially, after creation, the chat history will be empty:

{
  "success": true,
  "type": "array",
  "items": []
}
5. Chat with a replica
curl -X POST https://api.sensay.io/v1/replicas/$REPLICA_UUID/chat/completions \
 -H "Content-Type: application/json" \
 -H "X-API-Version: $API_VERSION" \
 -H "X-ORGANIZATION-SECRET: $ORGANIZATION_SECRET" \
 -H "X-USER-ID: $USER_ID" \
 -d '{"content":"How did you handle the immense pressure during the Civil War?"}'
The response of the request include the chat response:

{
  "success": true,
  "content": "I don't have enough information to answer that question."
}
6. Retrieve the chat history again
curl -X GET https://api.sensay.io/v1/replicas/$REPLICA_UUID/chat/history \
 -H "Content-Type: application/json" \
 -H "X-API-Version: $API_VERSION" \
 -H "X-ORGANIZATION-SECRET: $ORGANIZATION_SECRET" \
 -H "X-USER-ID: $USER_ID"
Response now includes the chat message and its response:

{
  "success": true,
  "type": "array",
  "items": [
    {
      "id": 668,
      "created_at": "2025-04-15T08:11:00.093761+00:00",
      "content": "How did you handle the immense pressure during the Civil War?",
      "role": "user",
      "is_private": false,
      "source": "web",
      "replica_uuid": "4da68021-78a7-4fa2-91c1-ea2e5986e06f",
      "is_archived": false,
      "replica_slug": "my-replica",
      "user_uuid": "210bb355-193d-4ed0-8223-5802710438c9",
      "sources": []
    },
    {
      "id": 669,
      "created_at": "2025-04-15T08:11:00.299349+00:00",
      "content": "Response content",
      "role": "assistant",
      "is_private": false,
      "source": "web",
      "replica_uuid": "4da68021-78a7-4fa2-91c1-ea2e5986e06f",
      "is_archived": false,
      "replica_slug": "my-replica",
      "user_uuid": "210bb355-193d-4ed0-8223-5802710438c9",
      "sources": []
    }
  ]
}
7. Train your replica with custom knowledge
To make your replica more useful, you can train it with custom knowledge. Let's add some information about your company:

Create a knowledge base entry
curl -X POST https://api.sensay.io/v1/replicas/$REPLICA_UUID/training \
 -H "X-ORGANIZATION-SECRET: $ORGANIZATION_SECRET" \
 -H "X-API-Version: $API_VERSION" \
 -H "Content-Type: application/json" \
 -d '{}'
Example response:

{
  "success": true,
  "knowledgeBaseID": 12345
}
Export the knowledge base ID to use it in the next step:

export KNOWLEDGE_BASE_ID=12345
Add information to the knowledge base entry
curl -X PUT https://api.sensay.io/v1/replicas/$REPLICA_UUID/training/$KNOWLEDGE_BASE_ID \
 -H "X-ORGANIZATION-SECRET: $ORGANIZATION_SECRET" \
 -H "X-API-Version: $API_VERSION" \
 -H "Content-Type: application/json" \
 -d '{
   "rawText": "Our company was founded in 2020. We specialize in AI-powered customer service solutions. Our business hours are Monday to Friday, 9 AM to 5 PM Eastern Time. We offer a 30-day money-back guarantee on all our products."
 }'
Example response:

{
  "success": true
}
Test your trained replica
Now you can ask your replica about the information you just added:

curl -X POST https://api.sensay.io/v1/replicas/$REPLICA_UUID/chat/completions \
 -H "Content-Type: application/json" \
 -H "X-API-Version: $API_VERSION" \
 -H "X-ORGANIZATION-SECRET: $ORGANIZATION_SECRET" \
 -H "X-USER-ID: $USER_ID" \
 -d '{"content":"What are your business hours?"}'
Example response:

{
  "success": true,
  "content": "Our business hours are Monday to Friday, 9 AM to 5 PM Eastern Time."
}


The replica will now be able to answer questions based on the information you provided. For more advanced training options, see the Training documentation.

Conceptual model
The following diagram shows a simplified version of the entities you can interact with via the API. Refer to the endpoints documentation for a complete and up to date description of the entities.

Hierarchical structure
Organizations are the top-level entities that own users, users own replicas, and replicas are trained on training data (knowledge base).

Access control
Organizations cannot access each other's data (e.g. users, replicas, training data, ...).

A user can interact with a replica if they own it, or if the replica is public.

Chat history is owned by both users and replicas.

Diagram
Conceptual Model Diagram

Generating the SDK
The Sensay API provides an OpenAPI specification that allows you to automatically generate client SDKs for your preferred programming language and framework. Now that you familiarised with the API and its capabilities in the Getting started chapter, we will walk you through generating a TypeScript SDK using HeyAPI, though many other tools and languages are supported. See https://tools.openapis.org for a comprehensive list of the available tools.

1. Install HeyAPI or your preferred SDK generator
For this guide, we'll use HeyAPI, but many other generators are available depending on your needs.

From your project directory:

# Install HeyAPI
npm install @heyapi/cli
2. Generate a TypeScript SDK
# Generate a TypeScript SDK
npx heyapi generate-sdk \
  --input="https://api.sensay.io/schema" \
  --output-dir="./sensay-sdk" \
  --language="typescript" \
  --client="fetch"


The above command generates a TypeScript SDK with the fetch client. HeyAPI supports multiple client options including axios, angular, and more.

3. Install and configure the generated SDK
# Install the generated SDK dependencies
cd sensay-sdk
npm install

# Build the SDK
npm run build
4. Use the generated SDK in your application
import { Configuration, DefaultApi } from './sensay-sdk';

// Configure the SDK with your organization secret and API version
const config = new Configuration({
  basePath: 'https://api.sensay.io',
  headers: {
    'X-ORGANIZATION-SECRET': 'your_secret_token',
    'X-API-Version': '2025-05-01',
    'Content-Type': 'application/json'
  }
});

// Initialize the API client
const api = new DefaultApi(config);

// Create a user
const createUser = async () => {
  try {
    const response = await api.createUser({
      id: 'test_user_id'
    });
    console.log('User created:', response);
    return response;
  } catch (error) {
    console.error('Error creating user:', error);
  }
};

// Create a replica for the user
const createReplica = async (userId: string) => {
  try {
    const response = await api.createReplica({
      name: 'My SDK Replica',
      shortDescription: 'Created with the generated SDK',
      greeting: 'Hello! I was created using a generated SDK.',
      ownerID: userId,
      private: false,
      slug: 'sdk-replica',
      llm: {
        provider: 'openai',
        model: 'gpt-4o'
      }
    });
    console.log('Replica created:', response);
    return response;
  } catch (error) {
    console.error('Error creating replica:', error);
  }
};

// Chat with a replica
const chatWithReplica = async (replicaUuid: string, userId: string) => {
  try {
    // Note: Headers are configured at the client level, but can be overridden per request
    const response = await api.chatCompletions(replicaUuid, {
      content: 'Hello, I'm using the generated SDK!'
    }, {
      headers: {
        'X-USER-ID': userId,
        'X-ORGANIZATION-SECRET': 'your_secret_token', 
        'X-API-Version': '2025-03-25',
        'Content-Type': 'application/json'
      }
    });
    console.log('Chat response:', response);
    return response;
  } catch (error) {
    console.error('Error chatting with replica:', error);
  }
};

// Example usage
const main = async () => {
  const user = await createUser();
  if (user && user.id) {
    const replica = await createReplica(user.id);
    if (replica && replica.uuid) {
      await chatWithReplica(replica.uuid, user.id);
    }
  }
};

main();
Authentication in the SDK
For all API requests, you must include the proper authentication headers as described in the Authentication documentation:

// Configure global headers for all requests
const config = new Configuration({
  basePath: 'https://api.sensay.io/v1',
  headers: {
    // Required for all requests
    'X-ORGANIZATION-SECRET': 'your_secret_token',
    'X-API-Version': '2025-03-25',
    'Content-Type': 'application/json'
  }
});

// For user-specific operations, add the X-USER-ID header to individual requests
const response = await api.someUserSpecificOperation(params, {
  headers: {
    'X-USER-ID': 'user_id'
  }
});


The X-ORGANIZATION-SECRET header is required for all API requests. For operations that involve a specific user, you must also include the X-USER-ID header.

Alternative SDK Generation Tools
While HeyAPI is a great option, there are several other tools you can use to generate SDKs:

OpenAPI Generator - Supports 50+ languages and frameworks
Swagger Codegen - The original SDK generator for OpenAPI
NSwag - Excellent for .NET applications
openapi-typescript - TypeScript-specific generator with great type safety
Supported Languages and Frameworks
The OpenAPI ecosystem supports SDK generation for numerous languages and frameworks, including but not limited to:

TypeScript/JavaScript (Node.js, Browser, React, Angular, Vue)
Python
Java
C#/.NET
Go
Ruby
PHP
Swift
Kotlin
Rust
Dart/Flutter


For specific instructions on generating SDKs for other languages, please refer to the documentation of your chosen SDK generator.

Best Practices
Version your SDK: Always specify the API version in your SDK configuration to ensure compatibility.
Error handling: Implement proper error handling in your client code to catch and process API errors.
Authentication: Securely store and provide your organization's secret token.
Rate limiting: Implement retry mechanisms and respect API rate limits.
Keep up to date: Regularly update your SDK when new API versions are released.


Never hardcode your organization's secret token in client-side code. Always use environment variables or a secure configuration management system.

Further Resources
OpenAPI Specification
Authentication
You must authenticate your requests to secured endpoints using your organization secret X-ORGANIZATION-SECRET:

Method 1: Authenticating as an organization admin
Required headers:

X-ORGANIZATION-SECRET


When authenticating in this way, your request is performed as an admin and has full access to the organization.

Method 2: Authenticating as a user
Your request can authenticate as a specific user that belongs to your organization. To do so, in addition to the Service Token, you need to provide the user's ID in the following header:

Required headers:

X-ORGANIZATION-SECRET
X-USER-ID


If the specified user does not exist in Sensay API, an unauthorized error will be returned.

Method 3: Authenticating as user by one of their linked accounts' ID
You can also authenticate as a user by alternative IDs that have been associated to the user using the Users endpoints.

To do so, in addition to the Service Token and the user's ID, you need to provide the user's ID type in the following header:

Required headers:

X-ORGANIZATION-SECRET
X-USER-ID
X-USER-ID-TYPE
See POST /users for the list of supported IDs.



If the specified user does not exist in Sensay API, an unauthorized error will be returned.

Responses
Responses can be of three base types:

1. Successful response representing an Object:
  {
    "success": "true",
    "some_key": {
      "...": "..."
    }
  }
2. Successful response representing an Array:
  {
    "success": "true",
    "items": [
      {
        "...": "..."
      }
    ]
  }
3. Error response:
  {
    "success": "false",
    "message": "...",
    "...": "..."
  }
Training
Training your replica
This documentation explains how to train your replicas using the Sensay API. Training is essential for creating personalized replicas that can provide accurate and relevant responses based on your specific content.

What is a knowledge base?
A knowledge base is a collection of information that your replica uses to answer questions. It's the foundation of your replica's ability to provide accurate and contextually relevant responses. All training in Sensay relies on knowledge base entries.

Knowledge base workflow
When training a replica, each knowledge base entry goes through three stages:

Raw text stage: The initial, unprocessed content you provide (such as documents, articles, or custom text). This is the information you want your replica to learn from.
Processed text stage: The system optimizes your content for better understanding and retrieval.
Vector stage: The processed content is converted into a mathematical representation (vectors) that allows the replica to quickly find and retrieve relevant information when answering questions.
Adding content to the knowledge base
There are two methods to add content to your replica's knowledge base:

Method 1: Adding text content
Create a knowledge base entry
curl -X POST https://api.sensay.io/v1/replicas/$REPLICA_UUID/training \
 -H "X-ORGANIZATION-SECRET: $ORGANIZATION_SECRET" \
 -H "Content-Type: application/json" \
 -d '{}'
Example response:

{
  "success": true,
  "knowledgeBaseID": 12345
}
This creates a new empty knowledge base entry. The response includes a knowledgeBaseID that you'll need for the next step.

Add text to the knowledge base entry
curl -X PUT https://api.sensay.io/v1/replicas/$REPLICA_UUID/training/$KNOWLEDGE_BASE_ID \
 -H "X-ORGANIZATION-SECRET: $ORGANIZATION_SECRET" \
 -H "Content-Type: application/json" \
 -d '{
   "rawText": "Your training text content goes here. This can be any text you want your replica to learn from, such as product information, company policies, or specialized knowledge."
 }'


After adding text, the system automatically processes it and makes it available for your replica to use when answering questions.

Method 2: Uploading text-based files
Get a signed URL for file upload
curl -X GET https://api.sensay.io/v1/replicas/$REPLICA_UUID/training/files/upload?filename=your_file.pdf \
 -H "X-ORGANIZATION-SECRET: $ORGANIZATION_SECRET" \
 -H "Content-Type: application/json"
Example response:

{
  "success": true,
  "signedURL": "https://storage.googleapis.com/...",
  "knowledgeBaseID": 12345
}
This prepares the system for your file upload and returns a special URL where you can upload your file, along with the knowledge base ID for tracking. Files up to 50MB are supported.

Upload the file to the signed URL
curl -X PUT $SIGNED_URL \
 -H "Content-Type: application/octet-stream" \
 --data-binary @/path/to/your/file.pdf


After uploading, the system automatically extracts text from your file, processes it, and makes it available for your replica to use.

Managing knowledge base entries
List all knowledge base entries
curl -X GET https://api.sensay.io/v1/replicas/$REPLICA_UUID/training \
 -H "X-ORGANIZATION-SECRET: $ORGANIZATION_SECRET" \
 -H "Content-Type: application/json"
Get a specific knowledge base entry
curl -X GET https://api.sensay.io/v1/replicas/$REPLICA_UUID/training/$KNOWLEDGE_BASE_ID \
 -H "X-ORGANIZATION-SECRET: $ORGANIZATION_SECRET" \
 -H "Content-Type: application/json"
Example response:

{
  "success": true,
  "id": 12345,
  "replica_uuid": "12345678-1234-1234-1234-123456789abc",
  "type": "text",
  "filename": null,
  "status": "READY",
  "raw_text": "Your training text content...",
  "processed_text": "Optimized version of your content...",
  "created_at": "2025-04-15T08:11:00.093761+00:00",
  "updated_at": "2025-04-15T08:11:05.299349+00:00",
  "title": null,
  "description": null
}
Delete a knowledge base entry
curl -X DELETE https://api.sensay.io/v1/replicas/$REPLICA_UUID/training/$KNOWLEDGE_BASE_ID \
 -H "X-ORGANIZATION-SECRET: $ORGANIZATION_SECRET" \
 -H "Content-Type: application/json"
Example response:

{
  "success": true
}
Understanding knowledge base status values
The status field in a knowledge base entry indicates its current processing state:

BLANK: Initial state for a newly created text entry
AWAITING_UPLOAD: Initial state for a file entry before upload
SUPABASE_ONLY: File has been uploaded but not yet processed
PROCESSING: Entry is being processed
READY: Entry has been fully processed and is available for retrieval
SYNC_ERROR: An error occurred during synchronization
ERR_FILE_PROCESSING: An error occurred during file processing
ERR_TEXT_PROCESSING: An error occurred during text processing
ERR_TEXT_TO_VECTOR: An error occurred during vector conversion


If you encounter any error states, you may need to delete the entry and try again.

Versioning
Our API uses date-based versioning via the X-API-Version header. The value you provide—any valid date in the YYYY-MM-DD format—represents the exact state of the API as it existed on that day. This design allows you to pin your integration to a specific API snapshot or automatically track the latest stable behavior.

Specifying the API version
Any date allowed: You may pass any valid date in the X-API-Version header. The date you choose directly corresponds to the API state at that point in time.
Optional header: Including the header is optional; if omitted, the API defaults to the latest stable version.
Response details
Each API response includes an X-API-Version header that shows the version (date) of the API that processed your request. This ensures transparency, so you're always aware of the API state applied to your request.

Migrating to a newer version
When migrating to a newer API version, specify the current date in the header. This deliberate action helps transition your integration to the updated API behavior.

Versioning Policy
Breaking changes only: New version dates are introduced only when breaking changes occur, requiring client-side adaptations.
Non-breaking updates: Enhancements such as additional response fields are deployed without updating the API version.
Beta features
Features marked with the Beta badge are experimental and might be changed or removed without notice.



Our API is always evolving, therefore we recommend to regularly monitor for new version releases and update your integration accordingly.

Please refer to our Telegram channel for updates: Sensay API Announcements Telegram channel.

Feature requests
You can submit your feature request at this link: https://sensay.canny.io/features

Troubleshooting
Issue	How to fix it
You cannot find a replica	Make sure that the user belongs to the same organization of the replica you are trying to interact with. Make sure that your user owns the replica or that the replica is public.
HTTP 401	You are not authenticated or authorized. Either your API key is missing or invalid, your organization is disabled, or the user you specified does not exist. Please check your API key, user ID, and user ID type.
HTTP 415	The request is missing a valid "Content-Type" header. Supported media types include "application/json".
HTTP 429	You are hitting the rate limit as you exceeded the number of requests allowed for your organization or API key. Please slow down or contact us to discuss raising your limit.
Time-out	We time-out requests after 90 seconds. If your requests times-out before that, or times-out consistently, please report it at this link: https://sensay.canny.io/bugs.
HTTP 500	This error is usually due to an internal error on our end. Please make a note of the response fingerprint and requestID, and contact us to report it here: https://sensay.canny.io/bugs.
Something else	Please file a bug report at this link: https://sensay.canny.io/bugs.
Tutorial: Next.js
Building a chat application with Sensay API in Next.js
This tutorial will guide you through building a modern chat application using Sensay API with Next.js and TypeScript. You'll learn how to integrate the API, handle authentication, manage users and replicas, and implement a fully functional chat interface.

Demo
You can see a deployed version of the tutorial application at https://api-tutorial-nextjs.vercel.app/

How to build a Sensay API in a Next.js app

Prerequisites
Before you begin, make sure you have:

Node.js 18+ installed (we recommend using fnm for version management)
A Sensay API key (either an invitation code or an active API key)
Basic knowledge of React, TypeScript, and Next.js
Git installed to clone the sample repository


If you don't have an API key yet, you can request one by filling out the form at Request API Key or redeem an invitation code if you have one.

Getting started
Clone the sample repository
Start by cloning the sample repository which contains all the necessary code to run a fully functional chat application:

git clone https://github.com/sensay-io/chat-client-sample.git
cd chat-client-sample
Install dependencies
Once you've cloned the repository, install the required dependencies:

npm install
Set up your environment
You can set up your environment in two ways:

Option 1: Using .env.local (Recommended for development)
Create a .env.local file in the root directory with your API key:

NEXT_PUBLIC_SENSAY_API_KEY=your_api_key_here
Option 2: In-app configuration
Alternatively, you can paste your API key directly in the application interface when prompted.

Run the application
Start the development server:

npm run dev
This will start the application on http://localhost:3000. Open this URL in your browser to access the chat application.

Understanding the application architecture
The sample application demonstrates a complete integration with Sensay API, handling:

Organization authentication
User creation and management
Replica creation and retrieval
Chat functionality
Key components
SDK Generation: The application uses openapi-typescript-codegen to generate a fully typed client from the Sensay API OpenAPI specification.
Authentication Flow: Demonstrates both organization-level and user-level authentication.
Chat Interface: A responsive UI built with React and Tailwind CSS.
Application initialization flow
When you first start the application, it performs the following steps:

Initializes a client using your provided API key
Checks if a sample user exists, creating one if necessary
Checks for existing replicas, creating a default one if none exists
Sets up the authenticated chat session
This flow mirrors the steps you would typically take when integrating Sensay API into your own applications.

Key implementation patterns
Let's examine the core patterns used in the application that you can adapt for your own projects.

Client initialization
The application initializes the Sensay client in two different ways:

// Organization-level authentication (admin access)
const organizationClient = new Client({
  BASE: 'https://api.sensay.io',
  HEADERS: {
    'X-ORGANIZATION-SECRET': apiKey,
    'Content-Type': 'application/json',
  },
});

// User-level authentication
const userClient = new Client({
  BASE: 'https://api.sensay.io',
  HEADERS: {
    'X-ORGANIZATION-SECRET': apiKey,
    'X-USER-ID': userId,
    'Content-Type': 'application/json',
  },
});
User management
The application demonstrates how to create users and check if they exist:

// Check if user exists
try {
  const user = await organizationClient.users.getUsersGet({
    id: userId,
  });
  console.log('User exists:', user);
  return user;
} catch (error) {
  if (error.status === 404) {
    // Create user if not found
    const newUser = await organizationClient.users.createUsersPost({
      id: userId,
    });
    console.log('Created new user:', newUser);
    return newUser;
  }
  throw error;
}
Replica management
Similarly, the application shows how to list and create replicas:

// List replicas for the user
const replicas = await userClient.replicas.listReplicasGet();

if (replicas.items.length === 0) {
  // Create a new replica if none exists
  const newReplica = await userClient.replicas.createReplicaPost({
    name: `Sample Replica ${Date.now()}`,
    shortDescription: 'A helpful assistant for demonstration purposes',
    greeting: 'Hello! I am a sample replica. How can I help you today?',
    ownerID: userId,
    private: false,
    slug: `sample-replica-${Date.now()}`,
    llm: {
      provider: 'openai',
      model: 'gpt-4o',
    },
  });
  return newReplica.uuid;
}

// Use the first available replica
return replicas.items[0].uuid;
Chat interaction
The chat completion functionality demonstrates how to send messages and receive responses:

// Send a chat message and get a response
const response = await userClient.replicaChatCompletions.createChatCompletionPost({
  replicaUuid: replicaId,
  content: message,
});

if (response.success) {
  // Process and display the response
  setMessages((prev) => [
    ...prev,
    { role: 'assistant', content: response.content },
  ]);
}
Regenerating the SDK
One of the key features of this integration approach is the ability to quickly adapt to API changes by regenerating the SDK. The Sensay API evolves frequently, and regenerating your SDK ensures you always have access to the latest features.

To regenerate the SDK:

npm run generate-sdk
This script fetches the latest OpenAPI specification and generates updated TypeScript client code in the src/sdk directory.



We recommend regenerating your SDK regularly to stay current with the API. The script uses openapi-typescript-codegen, which provides type-safe access to all endpoints.

Troubleshooting common issues
Authentication errors
If you encounter authentication errors:

Verify your API key is correct and not expired
Check that you're including the proper headers for your requests
Ensure you're using the correct user ID when authenticating as a user
"User not found" errors
This typically means the user ID you're using doesn't exist in your organization:

Verify the user has been created
Check that you're using the correct organization API key
Ensure you're not mixing user IDs between different organizations
SDK type errors
If you encounter TypeScript errors after regenerating the SDK:

Make sure your code is updated to match any breaking changes in the API
Check the Versioning documentation for information about API changes
Join the Sensay API Telegram Channel for announcements about breaking changes
Next steps
Now that you have a working chat application, consider:

Customizing the UI: Adapt the interface to match your brand and requirements
Adding Training: Use the Training API to make your replicas more knowledgeable
Implementing Additional Features: Explore features like voice integration or multiple replica support
Deploying Your Application: Deploy to services like Vercel, Netlify, or your own infrastructure
Additional resources
GitHub Repository
Video Tutorial
Sensay Documentation
OpenAPI Tools
Sensay API Telegram Channel
API Keys
Redeem an API key invitation
POST
/v1/api-keys/invites/{code}/redeem
If you have an invitation code, you can redeem it to create an Organization and an API key associated with it.

Path parameters
code string Required
The code of the invite you want to redeem.

application/json
Body
organizationName string Required
The name of the organization you want to create.

name string Required
The name of the point of contact for the API subscription.

email string(email) Required
The email of the point of contact for the API subscription.

Responses
 200
application/json
Details about the created Organization and API Key.

Hide response attributes
object
success boolean Required
Value is true.

apiKey string Required
The API key you will need to use to authenticate your requests. The key cannot be retrieved again after it is created: keep it safe.

organizationID string Required
The ID of the organization you have just created. You will need this ID to communicate with our team. Keep it safe.

validUntil string | null Required
The date until which the API subscroption is valid.

 400
application/json
Bad Request

Show response attributes
object
 401
application/json
Unauthorized

Show response attributes
object
 404
application/json
Not Found

Show response attributes
object
 415
application/json
Unsupported Media Type

Show response attributes
object
 500
application/json
Internal Server Error

Show response attributes
object
POST
/v1/api-keys/invites/{code}/redeem
curl \
 --request POST 'https://api.sensay.io/v1/api-keys/invites/{code}/redeem' \
 --header "Content-Type: application/json" \
 --data '{"organizationName":"string","name":"string","email":"hello@example.com"}'
Request examples
{
  "organizationName": "string",
  "name": "string",
  "email": "hello@example.com"
}
Response examples (200)
{
  "apiKey": "1234567890",
  "success": true,
  "validUntil": "2021-01-01",
  "organizationID": "1234567890"
}
Response examples (400)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (401)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (404)
{
  "success": true,
  "error": "string",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (415)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (500)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab",
  "inner_exception": {
    "name": "Server overheated",
    "cause": "Request too complicated",
    "stack": "Error: Server overheated due to an unexpected situation\n    at Object.eval (eval at <anonymous>...",
    "message": "The server overheated due to an unexpected situation"
  }
}
Chat completions
Generate a completion
POST
/v1/replicas/{replicaUUID}/chat/completions
 Organization service token & User  Organization service token
Ask for a completion and stores the prompt in the chat history.

Replica chat supports two response formats: streamed and JSON. To switch between these formats, use the 'Accept' header, specifying either 'text/event-stream' for streaming or 'application/json' for JSON. The streamed response honours the Stream Protocol, allowing the use of a number of SDKs, including Vercel AI SDK.

The streamed variant is not specified in the OpenAPI Schema because it is not an OpenAPI endpoint.

Headers
X-API-Version string
Default value is 2025-03-25.

Path parameters
replicaUUID string(uuid) Required
The UUID of the Replica

application/json
Body
content string Required
The prompt to generate completions for, encoded as a string.

Minimum length is 1, maximum length is 100000.

skip_chat_history boolean
When set to true, historical messages are not used in the context, and the message is not appended to the conversation history, thus it is excluded from all future chat context.

Default value is false.

source string
The place where the conversation is happening, which informs where the message should be saved in the chat history.

Values are discord, telegram, embed, web, or telegram_autopilot.

discord_data object
Discord information about the message

Additional properties are NOT allowed.

Show discord_data attributes
object
Responses
 200
List of chat messages had with a replica by the current user, including the completion

Hide response attributes
object
success boolean Required
content string Required
 400
application/json
Bad Request

Show response attributes
object
 401
application/json
Unauthorized

Show response attributes
object
 404
application/json
Not Found

Show response attributes
object
 415
application/json
Unsupported Media Type

Show response attributes
object
 500
application/json
Internal Server Error

Show response attributes
object
POST
/v1/replicas/{replicaUUID}/chat/completions
curl \
 --request POST 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53/chat/completions' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-USER-ID: $API_KEY" \
 --header "Content-Type: application/json" \
 --header "X-API-Version: 2025-03-25" \
 --data '{"content":"How did you handle the immense pressure during the Civil War?","skip_chat_history":false,"source":"discord","discord_data":{"channel_id":"string","channel_name":"string","author_id":"string","author_name":"string","message_id":"string","created_at":"string","server_id":"string","server_name":"string"}}'
Request examples
# Headers
X-API-Version: 2025-03-25

# Payload
{
  "content": "How did you handle the immense pressure during the Civil War?",
  "skip_chat_history": false,
  "source": "discord",
  "discord_data": {
    "channel_id": "string",
    "channel_name": "string",
    "author_id": "string",
    "author_name": "string",
    "message_id": "string",
    "created_at": "string",
    "server_id": "string",
    "server_name": "string"
  }
}
Response examples (200)
{
  "content": "I handled the immense pressure during the Civil War by...",
  "success": true
}
Response examples (400)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (401)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (404)
{
  "success": true,
  "error": "string",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (415)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (500)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab",
  "inner_exception": {
    "name": "Server overheated",
    "cause": "Request too complicated",
    "stack": "Error: Server overheated due to an unexpected situation\n    at Object.eval (eval at <anonymous>...",
    "message": "The server overheated due to an unexpected situation"
  }
}
Chat history
Get chat history
GET
/v1/replicas/{replicaUUID}/chat/history
 Organization service token & User  Organization service token
List chat history items of a Replica belonging to the logged in user.

Headers
X-API-Version string
Default value is 2025-03-25.

Path parameters
replicaUUID string(uuid) Required
The UUID of the Replica

Responses
 200
application/json
List the chat history of the replica by the currently logged in user

Hide response attributes
object
success boolean Required
Indicates the status of the request

type string Required
items array[object]
Show items attributes
object
 400
application/json
Bad Request

Show response attributes
object
 401
application/json
Unauthorized

Show response attributes
object
 404
The replica specified could not be found or you do not have access to it

 415
application/json
Unsupported Media Type

Show response attributes
object
 500
application/json
Internal Server Error

Show response attributes
object
GET
/v1/replicas/{replicaUUID}/chat/history
curl \
 --request GET 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53/chat/history' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-USER-ID: $API_KEY" \
 --header "X-API-Version: 2025-03-25"
Response examples (200)
{
  "success": true,
  "type": "string",
  "items": [
    {
      "content": "Hello",
      "created_at": "2024-09-24T09:09:55.66709+00:00",
      "id": 1,
      "is_private": false,
      "role": "user",
      "source": "web",
      "sources": [
        {
          "id": 123,
          "score": 0.9,
          "status": "scored",
          "created_at": "2024-03-15T14:30:00.000Z",
          "name": "Q: Next, what’s your nationality?",
          "content": "Next, what’s your nationality? Mars"
        }
      ],
      "user_uuid": "03db5651-cb61-4bdf-9ef0-89561f7c9c53",
      "original_message_id": "msg-GbsIAyNcNZCMAaDET3zXhInw"
    }
  ]
}
Response examples (400)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (401)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (415)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (500)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab",
  "inner_exception": {
    "name": "Server overheated",
    "cause": "Request too complicated",
    "stack": "Error: Server overheated due to an unexpected situation\n    at Object.eval (eval at <anonymous>...",
    "message": "The server overheated due to an unexpected situation"
  }
}
Create a chat history entry
POST
/v1/replicas/{replicaUUID}/chat/history
 Organization service token & User  Organization service token
Save chat history items of a Replica belonging to the logged in user.

Headers
X-API-Version string
Default value is 2025-03-25.

Path parameters
replicaUUID string(uuid) Required
The UUID of the Replica

application/json
Body
content string Required
Content of the message

Minimum length is 1.

source string
The place where the conversation is happening, which informs where the message should be saved in the chat history.

Values are discord, telegram, embed, web, or telegram_autopilot.

discord_data object
Discord information about the message

Additional properties are NOT allowed.

Show discord_data attributes
object
Responses
 200
application/json
Saves the chat history of the replica by the currently logged in user.

Hide response attribute
object
success boolean Required
Indicates the status of the request

 404
The replica specified could not be found or you do not have access to it

POST
/v1/replicas/{replicaUUID}/chat/history
curl \
 --request POST 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53/chat/history' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-USER-ID: $API_KEY" \
 --header "Content-Type: application/json" \
 --header "X-API-Version: 2025-03-25" \
 --data '{"content":"How did you handle the immense pressure during the Civil War?","source":"discord","discord_data":{"channel_id":"string","channel_name":"string","author_id":"string","author_name":"string","message_id":"string","created_at":"string","server_id":"string","server_name":"string"}}'
Request examples
# Headers
X-API-Version: 2025-03-25

# Payload
{
  "content": "How did you handle the immense pressure during the Civil War?",
  "source": "discord",
  "discord_data": {
    "channel_id": "string",
    "channel_name": "string",
    "author_id": "string",
    "author_name": "string",
    "message_id": "string",
    "created_at": "string",
    "server_id": "string",
    "server_name": "string"
  }
}
Response examples (200)
{
  "success": true
}
Get Web chat history
GET
/v1/replicas/{replicaUUID}/chat/history/web
 Organization service token & User  Organization service token
List web chat history items of a Replica belonging to the logged in user.

Path parameters
replicaUUID string(uuid) Required
The UUID of the Replica

Responses
 200
application/json
List the chat history of the replica by the currently logged in user

Hide response attributes
object
success boolean Required
Indicates the status of the request

type string Required
items array[object]
Show items attributes
object
 400
application/json
Bad Request

Show response attributes
object
 401
application/json
Unauthorized

Show response attributes
object
 404
The replica specified could not be found or you do not have access to it

 415
application/json
Unsupported Media Type

Show response attributes
object
 500
application/json
Internal Server Error

Show response attributes
object
GET
/v1/replicas/{replicaUUID}/chat/history/web
curl \
 --request GET 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53/chat/history/web' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-USER-ID: $API_KEY"
Response examples (200)
{
  "success": true,
  "type": "string",
  "items": [
    {
      "content": "Hello",
      "created_at": "2024-09-24T09:09:55.66709+00:00",
      "id": 1,
      "is_private": false,
      "role": "user",
      "source": "web",
      "sources": [
        {
          "id": 123,
          "score": 0.9,
          "status": "scored",
          "created_at": "2024-03-15T14:30:00.000Z",
          "name": "Q: Next, what’s your nationality?",
          "content": "Next, what’s your nationality? Mars"
        }
      ],
      "user_uuid": "03db5651-cb61-4bdf-9ef0-89561f7c9c53",
      "original_message_id": "msg-GbsIAyNcNZCMAaDET3zXhInw"
    }
  ]
}
Response examples (400)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (401)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (415)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (500)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab",
  "inner_exception": {
    "name": "Server overheated",
    "cause": "Request too complicated",
    "stack": "Error: Server overheated due to an unexpected situation\n    at Object.eval (eval at <anonymous>...",
    "message": "The server overheated due to an unexpected situation"
  }
}
Chat-widget integration
Get Embed chat history
GET
/v1/replicas/{replicaUUID}/chat/history/embed
 Organization service token & User  Organization service token
List embed chat history items of a Replica belonging to the logged in user.

Path parameters
replicaUUID string(uuid) Required
The UUID of the Replica

Responses
 200
application/json
List the chat history of the replica by the currently logged in user

Hide response attributes
object
success boolean Required
Indicates the status of the request

type string Required
items array[object]
Show items attributes
object
 400
application/json
Bad Request

Show response attributes
object
 401
application/json
Unauthorized

Show response attributes
object
 404
The replica specified could not be found or you do not have access to it

 415
application/json
Unsupported Media Type

Show response attributes
object
 500
application/json
Internal Server Error

Show response attributes
object
GET
/v1/replicas/{replicaUUID}/chat/history/embed
curl \
 --request GET 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53/chat/history/embed' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-USER-ID: $API_KEY"
Response examples (200)
{
  "success": true,
  "type": "string",
  "items": [
    {
      "content": "Hello",
      "created_at": "2024-09-24T09:09:55.66709+00:00",
      "id": 1,
      "is_private": false,
      "role": "user",
      "source": "web",
      "sources": [
        {
          "id": 123,
          "score": 0.9,
          "status": "scored",
          "created_at": "2024-03-15T14:30:00.000Z",
          "name": "Q: Next, what’s your nationality?",
          "content": "Next, what’s your nationality? Mars"
        }
      ],
      "user_uuid": "03db5651-cb61-4bdf-9ef0-89561f7c9c53",
      "original_message_id": "msg-GbsIAyNcNZCMAaDET3zXhInw"
    }
  ]
}
Response examples (400)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (401)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (415)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (500)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab",
  "inner_exception": {
    "name": "Server overheated",
    "cause": "Request too complicated",
    "stack": "Error: Server overheated due to an unexpected situation\n    at Object.eval (eval at <anonymous>...",
    "message": "The server overheated due to an unexpected situation"
  }
}
Discord integration
Get Discord chat history
GET
/v1/replicas/{replicaUUID}/chat/history/discord
 Organization service token & User  Organization service token
List discord chat history items of a Replica belonging to the logged in user.

Path parameters
replicaUUID string(uuid) Required
The UUID of the Replica

Responses
 200
application/json
List the chat history of the replica by the currently logged in user

Hide response attributes
object
success boolean Required
Indicates the status of the request

type string Required
items array[object]
Show items attributes
object
 400
application/json
Bad Request

Show response attributes
object
 401
application/json
Unauthorized

Show response attributes
object
 404
The replica specified could not be found or you do not have access to it

 415
application/json
Unsupported Media Type

Show response attributes
object
 500
application/json
Internal Server Error

Show response attributes
object
GET
/v1/replicas/{replicaUUID}/chat/history/discord
curl \
 --request GET 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53/chat/history/discord' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-USER-ID: $API_KEY"
Response examples (200)
{
  "success": true,
  "type": "string",
  "items": [
    {
      "content": "Hello",
      "created_at": "2024-09-24T09:09:55.66709+00:00",
      "id": 1,
      "is_private": false,
      "role": "user",
      "source": "web",
      "sources": [
        {
          "id": 123,
          "score": 0.9,
          "status": "scored",
          "created_at": "2024-03-15T14:30:00.000Z",
          "name": "Q: Next, what’s your nationality?",
          "content": "Next, what’s your nationality? Mars"
        }
      ],
      "user_uuid": "03db5651-cb61-4bdf-9ef0-89561f7c9c53",
      "original_message_id": "msg-GbsIAyNcNZCMAaDET3zXhInw"
    }
  ]
}
Response examples (400)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (401)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (415)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (500)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab",
  "inner_exception": {
    "name": "Server overheated",
    "cause": "Request too complicated",
    "stack": "Error: Server overheated due to an unexpected situation\n    at Object.eval (eval at <anonymous>...",
    "message": "The server overheated due to an unexpected situation"
  }
}
Experimental
Generate a completion (OpenAI-compatible, non-streaming)
Beta
POST
/v1/experimental/replicas/{replicaUUID}/chat/completions
 Organization service token & User
Limited OpenAI Chat Completions API compatibility. Supports basic chat completion with standard message roles and JSON responses. Not supported: OpenAI-style streaming, tool calls, stop sequences, logprobs, and most request parameters.

Creates a chat completion response from a list of messages comprising a conversation.

Path parameters
replicaUUID string(uuid) Required
The UUID of the Replica

application/json
Body
messages array[object] Required
A list of messages that make up the conversation context. Only the last message is used for completion.

Show messages attributes
object
store boolean
When set to false, historical messages are not used in the context, and the message is not appended to the conversation history.

Default value is true.

source string
The place where the conversation is happening, which informs where the message should be saved in the chat history if store is true.

Values are discord, embed, or web. Default value is web.

discord_data object
Discord information about the message

Additional properties are NOT allowed.

Show discord_data attributes
object
Responses
 200
application/json
Chat completion response in OpenAI compatible format

Hide response attributes
object
id string Required
A unique identifier for the chat completion.

created integer Required
The Unix timestamp (in seconds) of when the chat completion was created.

object string Required
The object type, which is always "chat.completion"

Value is chat.completion.

model string Required
The model used for the chat completion.

choices array[object] Required
An array of chat completion choices.

Show choices attributes
object
usage object Required
Usage statistics for the completion request.

Show usage attributes
object
 400
application/json
Bad Request

Show response attributes
object
 401
application/json
Unauthorized

Show response attributes
object
 404
application/json
Not Found

Show response attributes
object
 415
application/json
Unsupported Media Type

Show response attributes
object
 500
application/json
Internal Server Error

Show response attributes
object
POST
/v1/experimental/replicas/{replicaUUID}/chat/completions
curl \
 --request POST 'https://api.sensay.io/v1/experimental/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53/chat/completions' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-USER-ID: $API_KEY" \
 --header "Content-Type: application/json" \
 --data '{"messages":[{"role":"system","content":"You are a helpful assistant."},{"role":"user","content":"How did you handle the immense pressure during the Civil War?"}],"store":true,"source":"web","discord_data":{"channel_id":"string","channel_name":"string","author_id":"string","author_name":"string","message_id":"string","created_at":"string","server_id":"string","server_name":"string"}}'
Request examples
{
  "messages": [
    {
      "role": "system",
      "content": "You are a helpful assistant."
    },
    {
      "role": "user",
      "content": "How did you handle the immense pressure during the Civil War?"
    }
  ],
  "store": true,
  "source": "web",
  "discord_data": {
    "channel_id": "string",
    "channel_name": "string",
    "author_id": "string",
    "author_name": "string",
    "message_id": "string",
    "created_at": "string",
    "server_id": "string",
    "server_name": "string"
  }
}
Response examples (200)
{
  "id": "chatcmpl-abc123",
  "created": 1677858242,
  "object": "chat.completion",
  "model": "o1",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "During the Civil War, I faced tremendous pressure...",
        "tool_calls": []
      },
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 56,
    "completion_tokens": 31,
    "total_tokens": 87
  }
}
Response examples (400)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (401)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (404)
{
  "success": true,
  "error": "string",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (415)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (500)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab",
  "inner_exception": {
    "name": "Server overheated",
    "cause": "Request too complicated",
    "stack": "Error: Server overheated due to an unexpected situation\n    at Object.eval (eval at <anonymous>...",
    "message": "The server overheated due to an unexpected situation"
  }
}
Updates a replica
PUT
/v1/replicas/{replicaUUID}
 Organization service token
Updates an existing replica.

Headers
X-API-Version string
Default value is 2025-03-25.

Path parameters
replicaUUID string(uuid) Required
The UUID of the Replica

application/json
Body
name string Required
The name of the replica.

Maximum length is 50.

purpose string
The purpose of the replica. This field is not used for training the replica.

Maximum length is 200.

shortDescription string Required
A short description of your replica. This field is not used for training the replica.

Maximum length is 50.

greeting string Required
The first thing your replica will say when you start a conversation with them.

Maximum length is 600.

type string
The replica type. individual: A replica of yourself. character: A replica of a character: can be anything you want. brand: A replica of a business persona or organization.

Values are individual, character, or brand. Default value is character.

ownerID string Required
The replica owner ID.

private boolean
Visibility of the replica. When set to true, only the owner will be able to find the replica and chat with it.

Default value is false.

whitelistEmails array[string(email)]
Emails of users who can use the replica.

Default value is [] (empty).

slug string Required
The slug of the replica. Slugs can be used by API consumers to determine the URLs where replicas can be found.

Maximum length is 50.

tags array[string]
The tags associated with the replica. Tags help categorize replicas and make them easier to find.

Default value is [] (empty).

profileImage string(uri)
The URL of the profile image of the replica. The image will be downloaded, optimized and stored on our servers, so the URL in the response will be different. Supported formats: .jpg, .jpeg, .png, .bmp, .webp, .avif

Format should match the following pattern: https?:\/\/[-a-zA-Z0-9@:%._+~#=]{1,256}\.[a-zA-Z0-9()]+\b([-a-zA-Z0-9()@:%_+.~#?&\/=]*). Default value is https://sensay.io/assets/default-replica-profile.webp.

suggestedQuestions array[string]
Suggested questions when starting a conversation.

Default value is [] (empty).

llm object Required
Show llm attributes
object
voicePreviewText string
Text that can be used to generate a voice preview.

Maximum length is 400.

Responses
 200
application/json
The request outcome

Hide response attribute
object
success boolean Required
Indicates if the replica was created successfully

 400
application/json
Bad Request

Show response attributes
object
 401
application/json
Unauthorized

Show response attributes
object
 404
application/json
Not Found

Show response attributes
object
 409
application/json
Conflict

Show response attributes
object
 415
application/json
Unsupported Media Type

Show response attributes
object
 500
application/json
Internal Server Error

Show response attributes
object
PUT
/v1/replicas/{replicaUUID}
curl \
 --request PUT 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "Content-Type: application/json" \
 --header "X-API-Version: 2025-03-25" \
 --data '{"name":"John Smith","purpose":"Acts as my AI twin for answering questions about my creative work.","shortDescription":"John Smith is a 55 year old accountant from Brooklyn who loves sports and his family.","greeting":"What would you like to know?","type":"character","ownerID":"a-user-id","private":false,"whitelistEmails":["user@domain.example"],"slug":"example-replica","tags":["male","italian"],"profileImage":"https://images.invalid/photo.jpeg","suggestedQuestions":["What is the meaning of life?"],"llm":{"model":"gpt-4o","memoryMode":"rag-search","systemMessage":"Concise, knowledgeable, empathetic and cheerful.","tools":["getTokenInfo"]},"voicePreviewText":"Hi, I'm your Sensay replica! How can I assist you today?"}'
Request examples
# Headers
X-API-Version: 2025-03-25

# Payload
{
  "name": "John Smith",
  "purpose": "Acts as my AI twin for answering questions about my creative work.",
  "shortDescription": "John Smith is a 55 year old accountant from Brooklyn who loves sports and his family.",
  "greeting": "What would you like to know?",
  "type": "character",
  "ownerID": "a-user-id",
  "private": false,
  "whitelistEmails": [
    "user@domain.example"
  ],
  "slug": "example-replica",
  "tags": [
    "male",
    "italian"
  ],
  "profileImage": "https://images.invalid/photo.jpeg",
  "suggestedQuestions": [
    "What is the meaning of life?"
  ],
  "llm": {
    "model": "gpt-4o",
    "memoryMode": "rag-search",
    "systemMessage": "Concise, knowledgeable, empathetic and cheerful.",
    "tools": [
      "getTokenInfo"
    ]
  },
  "voicePreviewText": "Hi, I'm your Sensay replica! How can I assist you today?"
}
Response examples (200)
{
  "success": true
}
Response examples (400)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (401)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (404)
{
  "success": true,
  "error": "string",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (409)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (415)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (500)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab",
  "inner_exception": {
    "name": "Server overheated",
    "cause": "Request too complicated",
    "stack": "Error: Server overheated due to an unexpected situation\n    at Object.eval (eval at <anonymous>...",
    "message": "The server overheated due to an unexpected situation"
  }
}
Delete a replica
DELETE
/v1/replicas/{replicaUUID}
 Organization service token
Deletes a replica by UUID.

Headers
X-API-Version string
Default value is 2025-03-25.

Path parameters
replicaUUID string(uuid) Required
The UUID of the Replica

Responses
 200
application/json
Replica has been deleted

Hide response attribute
object
success boolean Required
Indicates if the replica was deleted successfully

 400
application/json
Bad Request

Show response attributes
object
 401
application/json
Unauthorized

Show response attributes
object
 404
application/json
Not Found

Show response attributes
object
 415
application/json
Unsupported Media Type

Show response attributes
object
 500
application/json
Internal Server Error

Show response attributes
object
DELETE
/v1/replicas/{replicaUUID}
curl \
 --request DELETE 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-API-Version: 2025-03-25"
Response examples (200)
{
  "success": true
}
Response examples (400)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (401)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (404)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (415)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (500)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab",
  "inner_exception": {
    "name": "Server overheated",
    "cause": "Request too complicated",
    "stack": "Error: Server overheated due to an unexpected situation\n    at Object.eval (eval at <anonymous>...",
    "message": "The server overheated due to an unexpected situation"
  }
}
Telegram integration
Get Telegram chat history
GET
/v1/replicas/{replicaUUID}/chat/history/telegram
 Organization service token & User  Organization service token
List telegram chat history items of a Replica belonging to the logged in user.

Path parameters
replicaUUID string(uuid) Required
The UUID of the Replica

Responses
 200
application/json
List the chat history of the replica by the currently logged in user

Hide response attributes
object
success boolean Required
Indicates the status of the request

type string Required
items array[object]
Show items attributes
object
 400
application/json
Bad Request

Show response attributes
object
 401
application/json
Unauthorized

Show response attributes
object
 404
The replica specified could not be found or you do not have access to it

 415
application/json
Unsupported Media Type

Show response attributes
object
 500
application/json
Internal Server Error

Show response attributes
object
GET
/v1/replicas/{replicaUUID}/chat/history/telegram
curl \
 --request GET 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53/chat/history/telegram' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-USER-ID: $API_KEY"
Response examples (200)
{
  "success": true,
  "type": "string",
  "items": [
    {
      "content": "Hello",
      "created_at": "2024-09-24T09:09:55.66709+00:00",
      "id": 1,
      "is_private": false,
      "role": "user",
      "source": "web",
      "sources": [
        {
          "id": 123,
          "score": 0.9,
          "status": "scored",
          "created_at": "2024-03-15T14:30:00.000Z",
          "name": "Q: Next, what’s your nationality?",
          "content": "Next, what’s your nationality? Mars"
        }
      ],
      "user_uuid": "03db5651-cb61-4bdf-9ef0-89561f7c9c53",
      "original_message_id": "msg-GbsIAyNcNZCMAaDET3zXhInw"
    }
  ]
}
Response examples (400)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (401)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (415)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (500)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab",
  "inner_exception": {
    "name": "Server overheated",
    "cause": "Request too complicated",
    "stack": "Error: Server overheated due to an unexpected situation\n    at Object.eval (eval at <anonymous>...",
    "message": "The server overheated due to an unexpected situation"
  }
}
Create a Telegram chat history entry
POST
/v1/replicas/{replicaUUID}/chat/history/telegram
 Organization service token & User  Organization service token
Save chat history items of a Replica belonging to the logged in user.

Path parameters
replicaUUID string(uuid) Required
The UUID of the Replica

application/json
Body
content string Required
Content of the message

Minimum length is 1.

telegram_data object Required
Telegram information about the message

Additional properties are NOT allowed.

Show telegram_data attributes
object
Responses
 200
application/json
Saves the chat history of the replica by the currently logged in user.

Hide response attribute
object
success boolean Required
Indicates the status of the request

 404
The replica specified could not be found or you do not have access to it

POST
/v1/replicas/{replicaUUID}/chat/history/telegram
curl \
 --request POST 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53/chat/history/telegram' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-USER-ID: $API_KEY" \
 --header "Content-Type: application/json" \
 --data '{"content":"How did you handle the immense pressure during the Civil War?","telegram_data":{"chat_type":"string","chat_id":42.0,"user_id":42.0,"username":"string","message_id":42.0,"message_thread_id":42.0}}'
Request examples
{
  "content": "How did you handle the immense pressure during the Civil War?",
  "telegram_data": {
    "chat_type": "string",
    "chat_id": 42.0,
    "user_id": 42.0,
    "username": "string",
    "message_id": 42.0,
    "message_thread_id": 42.0
  }
}
Response examples (200)
{
  "success": true
}
Generate a Telegram completion
POST
/v1/replicas/{replicaUUID}/chat/completions/telegram
 Organization service token & User  Organization service token
Ask for a completion and stores the prompt in the chat history.

Replica chat supports two response formats: streamed and JSON. To switch between these formats, use the 'Accept' header, specifying either 'text/event-stream' for streaming or 'application/json' for JSON. The streamed response honours the Stream Protocol, allowing the use of a number of SDKs, including Vercel AI SDK.

The streamed variant is not specified in the OpenAPI Schema because it is not an OpenAPI endpoint.

Path parameters
replicaUUID string(uuid) Required
The UUID of the Replica

application/json
Body
content string Required
The prompt to generate completions for, encoded as a string.

Minimum length is 1, maximum length is 100000.

skip_chat_history boolean
When set to true, historical messages are not used in the context, and the message is not appended to the conversation history, thus it is excluded from all future chat context.

Default value is false.

imageURL string(uri) Beta
The URL of the image to be used as context for the completion.

Format should match the following pattern: https?:\/\/[-a-zA-Z0-9@:%._+~#=]{1,256}\.[a-zA-Z0-9()]+\b([-a-zA-Z0-9()@:%_+.~#?&\/=]*).

telegram_data object Required
Telegram information about the message

Additional properties are NOT allowed.

Show telegram_data attributes
object
Responses
 200
List of chat messages had with a replica by the current user, including the completion

Hide response attributes
object
success boolean Required
content string Required
 400
application/json
Bad Request

Show response attributes
object
 401
application/json
Unauthorized

Show response attributes
object
 404
application/json
Not Found

Show response attributes
object
 415
application/json
Unsupported Media Type

Show response attributes
object
 500
application/json
Internal Server Error

Show response attributes
object
POST
/v1/replicas/{replicaUUID}/chat/completions/telegram
curl \
 --request POST 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53/chat/completions/telegram' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-USER-ID: $API_KEY" \
 --header "Content-Type: application/json" \
 --data '{"content":"How did you handle the immense pressure during the Civil War?","skip_chat_history":false,"imageURL":"https://images.invalid/photo.jpeg","telegram_data":{"chat_type":"string","chat_id":42.0,"user_id":42.0,"username":"string","message_id":42.0,"message_thread_id":42.0}}'
Request examples
{
  "content": "How did you handle the immense pressure during the Civil War?",
  "skip_chat_history": false,
  "imageURL": "https://images.invalid/photo.jpeg",
  "telegram_data": {
    "chat_type": "string",
    "chat_id": 42.0,
    "user_id": 42.0,
    "username": "string",
    "message_id": 42.0,
    "message_thread_id": 42.0
  }
}
Response examples (200)
{
  "content": "I handled the immense pressure during the Civil War by...",
  "success": true
}
Response examples (400)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (401)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (404)
{
  "success": true,
  "error": "string",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (415)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (500)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab",
  "inner_exception": {
    "name": "Server overheated",
    "cause": "Request too complicated",
    "stack": "Error: Server overheated due to an unexpected situation\n    at Object.eval (eval at <anonymous>...",
    "message": "The server overheated due to an unexpected situation"
  }
}
Create a replica Telegram integration
POST
/v1/replicas/{replicaUUID}/integrations/telegram
 Organization service token & User  Organization service token
Integrates a replica to Telegram. The default Sensay Telegram integration will run a bot for you until you delete the integration.

Headers
X-API-Version string
Default value is 2025-03-25.

Path parameters
replicaUUID string(uuid) Required
The UUID of the Replica

application/json
Body
telegram_token string Required
Telegram Bot ID

mention string Required
Telegram Bot Name

Responses
 200
application/json
Telegram integration created successfully

Hide response attributes
object
success boolean Required
Indicates the status of the request

id number Required
 202
application/json
Telegram integration created successfully, but failed to notify the external integration server. If you are using the default Sensay Telegram Integration, we will retry starting the bot asynchronously.

Hide response attributes
object
success boolean Required
Indicates the status of the request

id number Required
message string Required
The reason why the operation is accepted instead of returning an immediate success.

 400
application/json
Bad Request

Show response attributes
object
 401
application/json
Unauthorized

Show response attributes
object
 404
application/json
Not Found

Show response attributes
object
 415
application/json
Unsupported Media Type

Show response attributes
object
 500
application/json
Internal Server Error

Show response attributes
object
POST
/v1/replicas/{replicaUUID}/integrations/telegram
curl \
 --request POST 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53/integrations/telegram' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-USER-ID: $API_KEY" \
 --header "Content-Type: application/json" \
 --header "X-API-Version: 2025-03-25" \
 --data '{"telegram_token":"string","mention":"string"}'
Request examples
# Headers
X-API-Version: 2025-03-25

# Payload
{
  "telegram_token": "string",
  "mention": "string"
}
Response examples (200)
{
  "success": true,
  "id": 42.0
}
Response examples (202)
{
  "success": true,
  "id": 42.0,
  "message": "Telegram integration created successfully, but failed to notify the external integration server. If you are using the default Sensay Telegram Integration, we will retry starting the bot asynchronously."
}
Response examples (400)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (401)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (404)
{
  "success": true,
  "error": "string",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (415)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (500)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab",
  "inner_exception": {
    "name": "Server overheated",
    "cause": "Request too complicated",
    "stack": "Error: Server overheated due to an unexpected situation\n    at Object.eval (eval at <anonymous>...",
    "message": "The server overheated due to an unexpected situation"
  }
}
Delete a replica Telegram integration
DELETE
/v1/replicas/{replicaUUID}/integrations/telegram
 Organization service token & User  Organization service token
Removes a replica Telegram integration.

Headers
X-API-Version string
Default value is 2025-03-25.

Path parameters
replicaUUID string(uuid) Required
The UUID of the Replica

Responses
 200
application/json
Telegram integration deleted successfully

Hide response attribute
object
success boolean Required
Indicates the status of the request

 202
application/json
Telegram integration deleted successfully, but failed to notify the external integration server. If you are using the default Sensay Telegram Integration, we will retry stopping the bot asynchronously.

Hide response attributes
object
success boolean Required
Indicates the status of the request

message string Required
The reason why the operation is accepted instead of returning an immediate success.

 400
application/json
Bad Request

Show response attributes
object
 401
application/json
Unauthorized

Show response attributes
object
 404
application/json
Not Found

Show response attributes
object
 415
application/json
Unsupported Media Type

Show response attributes
object
 500
application/json
Internal Server Error

Show response attributes
object
DELETE
/v1/replicas/{replicaUUID}/integrations/telegram
curl \
 --request DELETE 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53/integrations/telegram' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-USER-ID: $API_KEY" \
 --header "X-API-Version: 2025-03-25"
Response examples (200)
{
  "success": true
}
Response examples (202)
{
  "success": true,
  "message": "Telegram integration deleted successfully, but failed to notify the external integration server. If you are using the default Sensay Telegram Integration, we will retry stopping the bot asynchronously."
}
Response examples (400)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (401)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (404)
{
  "success": true,
  "error": "string",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (415)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (500)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab",
  "inner_exception": {
    "name": "Server overheated",
    "cause": "Request too complicated",
    "stack": "Error: Server overheated due to an unexpected situation\n    at Object.eval (eval at <anonymous>...",
    "message": "The server overheated due to an unexpected situation"
  }
}
Create a knowledge base entry
Beta
POST
/v1/replicas/{replicaUUID}/training
 Organization service token
Creates a new empty knowledge base entry for a replica. This is the first step in the text-based training process. After creating the entry, you'll receive a knowledgeBaseID that you'll need to use in the next step to add your training content using the Update endpoint. The entry starts with a BLANK status and will be processed automatically once you add content.

Headers
X-API-Version string
Default value is 2025-03-25.

Path parameters
replicaUUID string(uuid) Required
The UUID of the Replica

Responses
 200
application/json
The created knowledge base entry

Hide response attributes
object
success boolean Required
Indicates if the knowledge base entry was created successfully

knowledgeBaseID number Required
The unique identifier for the newly created knowledge base entry. You'll need this ID for subsequent operations like adding content via the Update endpoint.

 400
application/json
Bad Request

Show response attributes
object
 401
application/json
Unauthorized

Show response attributes
object
 404
application/json
Not Found

Show response attributes
object
 415
application/json
Unsupported Media Type

Show response attributes
object
 500
application/json
Internal Server Error

Show response attributes
object
POST
/v1/replicas/{replicaUUID}/training
curl \
 --request POST 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53/training' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-API-Version: 2025-03-25"
Response examples (200)
{
  "success": true,
  "knowledgeBaseID": 12345
}
Response examples (400)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (401)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (404)
{
  "success": true,
  "error": "string",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (415)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (500)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab",
  "inner_exception": {
    "name": "Server overheated",
    "cause": "Request too complicated",
    "stack": "Error: Server overheated due to an unexpected situation\n    at Object.eval (eval at <anonymous>...",
    "message": "The server overheated due to an unexpected situation"
  }
}
Update knowledge base entry
Beta
PUT
/v1/replicas/{replicaUUID}/training/{trainingID}
 Organization service token
Updates a knowledge base entry with training content. This is the second step in the training process after creating an entry. You can provide "rawText" which is the content you want your replica to learn from (such as product information, company policies, or specialized knowledge). The system will automatically process this text and make it available for your replica to use when answering questions. The entry status will change to PROCESSING and then to READY once fully processed.

Path parameters
replicaUUID string(uuid) Required
The UUID of the Replica

trainingID number | null
The ID of the knowledge base entry

application/json
Body
rawText string
The text content you want your replica to learn

Minimum length is 1.

processedText string
Pre-processed text ready for the knowledge base

Minimum length is 1.

vectorEntryId string
ID of the vector entry in the database

metadata object
Additional information about the knowledge base entry (only used with vectorEntryId)

Additional properties are allowed.

Responses
 200
application/json
Knowledge base entry updated successfully.

Hide response attribute
object
success boolean Required
Indicates the status of the request

 400
application/json
Bad Request

Show response attributes
object
 401
application/json
Unauthorized

Show response attributes
object
 404
application/json
Not Found

Show response attributes
object
 415
application/json
Unsupported Media Type

Show response attributes
object
 500
application/json
Internal Server Error

Show response attributes
object
PUT
/v1/replicas/{replicaUUID}/training/{trainingID}
curl \
 --request PUT 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53/training/{trainingID}' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "Content-Type: application/json" \
 --data '{"rawText":"Our company was founded in 2020. We specialize in AI-powered customer service solutions.","processedText":"Our company was founded in 2020. We specialize in AI-powered customer service solutions.","vectorEntryId":"1337","metadata":{"page":42,"tags":["company info","history"],"source":"company handbook"}}'
Request examples
{
  "rawText": "Our company was founded in 2020. We specialize in AI-powered customer service solutions.",
  "processedText": "Our company was founded in 2020. We specialize in AI-powered customer service solutions.",
  "vectorEntryId": "1337",
  "metadata": {
    "page": 42,
    "tags": [
      "company info",
      "history"
    ],
    "source": "company handbook"
  }
}
Response examples (200)
{
  "success": true
}
Response examples (400)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (401)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (404)
{
  "success": true,
  "error": "string",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (415)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (500)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab",
  "inner_exception": {
    "name": "Server overheated",
    "cause": "Request too complicated",
    "stack": "Error: Server overheated due to an unexpected situation\n    at Object.eval (eval at <anonymous>...",
    "message": "The server overheated due to an unexpected situation"
  }
}
List all knowledge base entries
Beta
GET
/v1/training
 Organization service token
Returns a list of all knowledge base entries belonging to your organization. This endpoint allows you to view all your training data in one place, with optional filtering by status or type. You can use this to monitor the overall state of your knowledge base, check which entries are still processing, and identify any that might have encountered errors. The response includes detailed information about each entry including its content, status, and metadata.

Headers
X-API-Version string
Default value is 2025-03-25.

Query parameters
status string
Filter to show only knowledge base entries with a specific processing status (e.g., READY, PROCESSING, ERR_FILE_PROCESSING)

Values are AWAITING_UPLOAD, SUPABASE_ONLY, PROCESSING, READY, SYNC_ERROR, ERR_FILE_PROCESSING, ERR_TEXT_PROCESSING, ERR_TEXT_TO_VECTOR, or BLANK.

type string
Filter to show only knowledge base entries of a specific type (e.g., text, file_upload, url, training_history)

Values are file_upload, url, training_history, or text.

page string
The page number for paginated results (starts at 1). Use this to navigate through large result sets.

Format should match the following pattern: ^\d+$. Default value is 1.

limit string
The maximum number of knowledge base entries to return per page (up to 100). Use this to control result set size.

Format should match the following pattern: ^\d+$. Default value is 100.

Responses
 200
application/json
List of knowledge base entries returned successfully.

Hide response attributes
object
success boolean Required
Indicates if the list operation was successful

items array[object] Required
Array of knowledge base entries matching your query parameters

Show items attributes
object
 400
application/json
Bad Request

Show response attributes
object
 401
application/json
Unauthorized

Show response attributes
object
 404
application/json
Not Found

Show response attributes
object
 415
application/json
Unsupported Media Type

Show response attributes
object
 500
application/json
Internal Server Error

Show response attributes
object
GET
/v1/training
curl \
 --request GET 'https://api.sensay.io/v1/training' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-API-Version: 2025-03-25"
Response examples (200)
{
  "success": true,
  "items": [
    {
      "id": 12345,
      "type": "text",
      "title": "Company Information",
      "status": "READY",
      "filename": null,
      "raw_text": "Our company was founded in 2020...",
      "created_at": "2025-04-15T08:11:00.093761+00:00",
      "updated_at": "2025-04-15T08:11:05.299349+00:00",
      "description": "Basic company details and policies",
      "replica_uuid": "03db5651-cb61-4bdf-9ef0-89561f7c9c53",
      "processed_text": "Our company was founded in 2020..."
    }
  ]
}
Response examples (400)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (401)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (404)
{
  "success": true,
  "error": "string",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (415)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (500)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab",
  "inner_exception": {
    "name": "Server overheated",
    "cause": "Request too complicated",
    "stack": "Error: Server overheated due to an unexpected situation\n    at Object.eval (eval at <anonymous>...",
    "message": "The server overheated due to an unexpected situation"
  }
}
Get knowledge base entry by ID
Beta
GET
/v1/training/{trainingID}
 Organization service token
Retrieves detailed information about a specific knowledge base entry using its ID. This endpoint returns the complete entry data including its type, status, content, and metadata. You can use this to check the processing status of your training content, view the raw and processed text, and see when it was created and last updated. This is useful for monitoring the progress of your training data as it moves through the processing pipeline.

Headers
X-API-Version string
Default value is 2025-03-25.

Path parameters
trainingID number | null
The unique identifier of the knowledge base entry you want to retrieve details for

Responses
 200
application/json
The knowledge base entry returned successfully.

Hide response attributes
object
id integer Required
The unique identifier for this knowledge base entry. Use this ID in subsequent API calls to update or delete this entry.

replica_uuid string | null Required
The unique identifier of the replica that owns this knowledge base entry. This links the training data to a specific replica.

type string Required
The category of knowledge base entry, indicating how the content was added and how it should be processed.

Values are file_upload, url, training_history, or text.

filename string | null Required
For file_upload entries, the original filename that was uploaded. This helps identify the source of the content.

status string Required
The current stage in the processing pipeline. Use this to track progress and identify any issues with processing.

Values are AWAITING_UPLOAD, SUPABASE_ONLY, PROCESSING, READY, SYNC_ERROR, ERR_FILE_PROCESSING, ERR_TEXT_PROCESSING, ERR_TEXT_TO_VECTOR, or BLANK.

raw_text string | null Required
The original, unmodified text content that was submitted for training. May be truncated for large entries.

processed_text string | null Required
The optimized version of the text after system processing. This is what gets converted to vectors for retrieval.

created_at string(date-time) Required
ISO 8601 timestamp when this knowledge base entry was first created.

updated_at string(date-time) Required
ISO 8601 timestamp when this knowledge base entry was last modified. Use this to track when processing completed.

title string | null Required
Optional title for this knowledge base entry. Helps identify the content in listings.

description string | null Required
Optional description providing more details about this knowledge base entry.

 400
application/json
Bad Request

Show response attributes
object
 401
application/json
Unauthorized

Show response attributes
object
 404
application/json
Not Found

Show response attributes
object
 415
application/json
Unsupported Media Type

Show response attributes
object
 500
application/json
Internal Server Error

Show response attributes
object
GET
/v1/training/{trainingID}
curl \
 --request GET 'https://api.sensay.io/v1/training/12345' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-API-Version: 2025-03-25"
Response examples (200)
{
  "id": 12345,
  "replica_uuid": "03db5651-cb61-4bdf-9ef0-89561f7c9c53",
  "type": "file_upload",
  "filename": "company_handbook.pdf",
  "status": "READY",
  "raw_text": "Our company was founded in 2020. We specialize in AI-powered customer service solutions. Our business hours are Monday to Friday, 9 AM to 5 PM Eastern Time.",
  "processed_text": "Our company was founded in 2020. We specialize in AI-powered customer service solutions. Our business hours are Monday to Friday, 9 AM to 5 PM Eastern Time.",
  "created_at": "2025-04-15T08:11:00.093761+00:00",
  "updated_at": "2025-04-15T08:15:05.299349+00:00",
  "title": "Company Information",
  "description": "Basic company details including founding date, business focus, and operating hours."
}
Response examples (400)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (401)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (404)
{
  "success": true,
  "error": "string",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (415)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (500)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab",
  "inner_exception": {
    "name": "Server overheated",
    "cause": "Request too complicated",
    "stack": "Error: Server overheated due to an unexpected situation\n    at Object.eval (eval at <anonymous>...",
    "message": "The server overheated due to an unexpected situation"
  }
}
Delete knowledge base entry by ID
Beta
DELETE
/v1/training/{trainingID}
 Organization service token
Permanently removes a specific knowledge base entry and its associated vector database entry. Use this endpoint when you need to remove outdated or incorrect training data from your replica's knowledge base. This operation cannot be undone, and the entry will no longer be available for retrieval during conversations with your replica. This endpoint handles the complete cleanup process, removing both the database record and any associated vector embeddings.

Headers
X-API-Version string
Default value is 2025-03-25.

Path parameters
trainingID number | null
The unique identifier of the knowledge base entry you want to permanently remove

Responses
 200
application/json
The knowledge base entry was deleted successfully.

Hide response attribute
object
success boolean Required
Indicates whether the knowledge base entry and its associated vector embeddings were successfully deleted from the system

 404
application/json
Knowledge base entry not found.

Show response attributes
object
DELETE
/v1/training/{trainingID}
curl \
 --request DELETE 'https://api.sensay.io/v1/training/12345' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-API-Version: 2025-03-25"
Response examples (200)
{
  "success": true
}
Response examples (404)
{
  "success": true,
  "error": "string",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Generate a signed URL for file upload
Beta
GET
/v1/replicas/{replicaUUID}/training/files/upload
 Organization service token
Creates a signed URL for uploading a file to the knowledge base. This is the first step in the file-based training process. The response includes both a signedURL where you can upload your file and a knowledgeBaseID for tracking. After receiving these, use a PUT request to the signedURL to upload your file (with Content-Type: application/octet-stream). The system will automatically extract text from your file, process it, and make it available for your replica to use. Supported file types include PDF, DOCX, and other text-based formats. Files up to 50MB are supported.

Path parameters
replicaUUID string(uuid) Required
The UUID of the Replica

Query parameters
filename string Required
The name of the file you want to upload to the knowledge base. This helps identify the file in your knowledge base. Files up to 50MB are supported.

Minimum length is 1.

Responses
 200
application/json
The generated signed URL

Hide response attributes
object
success boolean Required
Indicates if the signed URL was generated successfully

signedURL string
The temporary URL where you should upload your file using a PUT request with Content-Type: application/octet-stream

knowledgeBaseID number
The unique identifier for the newly created knowledge base entry. Use this to track the processing status of your file.

 400
application/json
Bad Request

Show response attributes
object
 401
application/json
Unauthorized

Show response attributes
object
 404
application/json
Not Found

Show response attributes
object
 415
application/json
Unsupported Media Type

Show response attributes
object
 500
application/json
Internal Server Error

Show response attributes
object
GET
/v1/replicas/{replicaUUID}/training/files/upload
curl \
 --request GET 'https://api.sensay.io/v1/replicas/03db5651-cb61-4bdf-9ef0-89561f7c9c53/training/files/upload?filename=company_handbook.pdf' \
 --header "X-ORGANIZATION-SECRET: $API_KEY"
Response examples (200)
{
  "success": true,
  "signedURL": "https://storage.googleapis.com/replica_files/...",
  "knowledgeBaseID": 12345
}
Response examples (400)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (401)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (404)
{
  "success": true,
  "error": "string",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (415)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (500)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab",
  "inner_exception": {
    "name": "Server overheated",
    "cause": "Request too complicated",
    "stack": "Error: Server overheated due to an unexpected situation\n    at Object.eval (eval at <anonymous>...",
    "message": "The server overheated due to an unexpected situation"
  }
}
Users
Get the current user
GET
/v1/users/me
 Organization service token & User
Returns information about the current user.

Headers
X-API-Version string
Default value is 2025-03-25.

Responses
 200
application/json
User information

Hide response attributes
object
name string
The name of the user

email string(email)
The email address

id string Required
The ID of the user

Minimum length is 1.

linkedAccounts array[object]
Show linkedAccounts attributes
object
GET
/v1/users/me
curl \
 --request GET 'https://api.sensay.io/v1/users/me' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-USER-ID: $API_KEY" \
 --header "X-API-Version: 2025-03-25"
Response examples (200)
{
  "name": "John Doe",
  "email": "user@example.com",
  "id": "johndoe",
  "linkedAccounts": [
    {
      "accountID": "string",
      "accountType": "discord"
    }
  ]
}
Update the current user
PUT
/v1/users/me
 Organization service token & User
Update the currently logged in user.

Headers
X-API-Version string
Default value is 2025-03-25.

application/json
Body
name string
The name of the user

email string(email)
The email address

id string Required
The ID of the user

Minimum length is 1.

linkedAccounts array[object]
Show linkedAccounts attributes
object
Responses
 200
application/json
The updated User entity

Hide response attributes
object
name string
The name of the user

email string(email)
The email address

id string Required
The ID of the user

Minimum length is 1.

linkedAccounts array[object]
Show linkedAccounts attributes
object
 400
application/json
Bad Request

Show response attributes
object
 401
application/json
Unauthorized

Show response attributes
object
 404
application/json
Not Found

Show response attributes
object
 409
application/json
Linked account or email already exists or is invalid

Show response attributes
object
 415
application/json
Unsupported Media Type

Show response attributes
object
 500
application/json
Internal Server Error

Show response attributes
object
PUT
/v1/users/me
curl \
 --request PUT 'https://api.sensay.io/v1/users/me' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-USER-ID: $API_KEY" \
 --header "Content-Type: application/json" \
 --header "X-API-Version: 2025-03-25" \
 --data '{"name":"John Doe","email":"user@example.com","id":"johndoe","linkedAccounts":[{"accountID":"string","accountType":"discord"}]}'
Request examples
# Headers
X-API-Version: 2025-03-25

# Payload
{
  "name": "John Doe",
  "email": "user@example.com",
  "id": "johndoe",
  "linkedAccounts": [
    {
      "accountID": "string",
      "accountType": "discord"
    }
  ]
}
Response examples (200)
{
  "name": "John Doe",
  "email": "user@example.com",
  "id": "johndoe",
  "linkedAccounts": [
    {
      "accountID": "string",
      "accountType": "discord"
    }
  ]
}
Response examples (400)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (401)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (404)
{
  "success": true,
  "error": "string",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (409)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (415)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (500)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab",
  "inner_exception": {
    "name": "Server overheated",
    "cause": "Request too complicated",
    "stack": "Error: Server overheated due to an unexpected situation\n    at Object.eval (eval at <anonymous>...",
    "message": "The server overheated due to an unexpected situation"
  }
}
Delete the current user
DELETE
/v1/users/me
 Organization service token & User
This endpoint permanently deletes the currently authenticated user account, including all associated data. After deletion, the account cannot be recovered.

Headers
X-API-Version string
Default value is 2025-03-25.

Responses
 204
User deleted successfully

 400
application/json
Bad Request

Show response attributes
object
 401
application/json
Unauthorized

Show response attributes
object
 404
application/json
Not Found

Show response attributes
object
 415
application/json
Unsupported Media Type

Show response attributes
object
 500
application/json
Internal Server Error

Show response attributes
object
DELETE
/v1/users/me
curl \
 --request DELETE 'https://api.sensay.io/v1/users/me' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "X-USER-ID: $API_KEY" \
 --header "X-API-Version: 2025-03-25"
Response examples (400)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (401)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (404)
{
  "success": true,
  "error": "string",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (415)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Response examples (500)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab",
  "inner_exception": {
    "name": "Server overheated",
    "cause": "Request too complicated",
    "stack": "Error: Server overheated due to an unexpected situation\n    at Object.eval (eval at <anonymous>...",
    "message": "The server overheated due to an unexpected situation"
  }
}
Create a user
POST
/v1/users
 Organization service token
Creates a new user.

Headers
X-API-Version string
Default value is 2025-03-25.

application/json
Body
name string
The name of the user

email string(email)
The email address

id string
The ID of the user

linkedAccounts array[object]
Show linkedAccounts attributes
object
Responses
 200
application/json
The created User entity

Hide response attributes
object
name string
The name of the user

email string(email)
The email address

id string Required
The ID of the user

Minimum length is 1.

linkedAccounts array[object]
Show linkedAccounts attributes
object
 409
application/json
User, email, or linked account already exists

Show response attributes
object
POST
/v1/users
curl \
 --request POST 'https://api.sensay.io/v1/users' \
 --header "X-ORGANIZATION-SECRET: $API_KEY" \
 --header "Content-Type: application/json" \
 --header "X-API-Version: 2025-03-25" \
 --data '{"name":"John Doe","email":"user@example.com","id":"string","linkedAccounts":[{"accountID":"string","accountType":"discord"}]}'
Request examples
# Headers
X-API-Version: 2025-03-25

# Payload
{
  "name": "John Doe",
  "email": "user@example.com",
  "id": "string",
  "linkedAccounts": [
    {
      "accountID": "string",
      "accountType": "discord"
    }
  ]
}
Response examples (200)
{
  "name": "John Doe",
  "email": "user@example.com",
  "id": "johndoe",
  "linkedAccounts": [
    {
      "accountID": "string",
      "accountType": "discord"
    }
  ]
}
Response examples (409)
{
  "success": true,
  "error": "string",
  "fingerprint": "14fceadd84e74ec499afe9b0f7952d6b",
  "request_id": "xyz1::reg1:reg1::ab3c4-1234567890123-0123456789ab"
}
Get a user by ID
GET
/v1/users/{userID}
 Organization service token
Returns information about the user with the specified ID.

Headers
X-API-Version string
Default value is 2025-03-25.

Path parameters
userID string Required
User ID

Minimum length is 1.

Responses
 200
application/json
User entity

Hide response attributes
object
name string
The name of the user

email string(email)
The email address

id string Required
The ID of the user

Minimum length is 1.

linkedAccounts array[object]
Show linkedAccounts attributes
object
 404
application/json
User not found

Show response attributes
object