To use the Sensay AI API, you'll need an API key and a Replica UUID. The SDK will help you manage replicas and interact with the API.


import { SensayAPI } from '@/sensay-sdk';

// Import required constants
import { SAMPLE_USER_ID, SAMPLE_REPLICA_SLUG, API_VERSION } from '@/constants/auth';

// 1. Initialize organization-only client (no user authentication)
const orgClient = new SensayAPI({
  HEADERS: {
    'X-ORGANIZATION-SECRET': process.env.NEXT_PUBLIC_SENSAY_API_KEY_SECRET
  }
});

// 2. Check if sample user exists
let userExists = false;
try {
  await orgClient.users.getV1Users(SAMPLE_USER_ID);
  userExists = true;
} catch (error) {
  console.log('User does not exist, will create');
}

// 3. Create user if needed
if (!userExists) {
  await orgClient.users.postV1Users(API_VERSION, {
    id: SAMPLE_USER_ID,
    email: `${SAMPLE_USER_ID}@example.com`,
    name: "Sample User"
  });
}

// 4. Initialize user-authenticated client for further operations
const client = new SensayAPI({
  HEADERS: {
    'X-ORGANIZATION-SECRET': process.env.NEXT_PUBLIC_SENSAY_API_KEY_SECRET,
    'X-USER-ID': SAMPLE_USER_ID
  }
});

























Basic Chat Completion
Send a message to the API and receive a completion response:






// Simple chat completion

// 1. List replicas to find our sample replica
const replicas = await client.replicas.getV1Replicas();
let replicaId;

// 2. Look for the sample replica by slug
if (replicas.items && replicas.items.length > 0) {
  const sampleReplica = replicas.items.find(replica => replica.slug === SAMPLE_REPLICA_SLUG);
  if (sampleReplica) {
    replicaId = sampleReplica.uuid;
  }
}

// 3. Create the sample replica if it doesn't exist
if (!replicaId) {
  const newReplica = await client.replicas.postV1Replicas(API_VERSION, {
    name: "Sample Replica",
    shortDescription: "A sample replica for demonstration",
    greeting: "Hello, I'm the sample replica. How can I help you today?",
    slug: SAMPLE_REPLICA_SLUG,
    ownerID: SAMPLE_USER_ID,
    llm: {
      model: "claude-3-7-sonnet-latest",
      memoryMode: "prompt-caching",
      systemMessage: "You are a helpful AI assistant that provides clear and concise responses."
    }
  });
  replicaId = newReplica.uuid;
}

// 4. Use the replica for chat completion
const response = await client.chatCompletions.postV1ReplicasChatCompletions(
  replicaId,
  API_VERSION,
  {
    content: 'Hello, how can you help me today?',
    source: 'web',
    skip_chat_history: false
  }
);

console.log(response.content);




















OpenAI-Compatible Endpoint
If you need OpenAI-compatible response formatting, you can use the experimental endpoint:






// Using the OpenAI-compatible experimental endpoint

// First get your replica ID (same steps as in the previous example)
const replicas = await client.replicas.getV1Replicas();
let replicaId;

if (replicas.items && replicas.items.length > 0) {
  const sampleReplica = replicas.items.find(replica => replica.slug === SAMPLE_REPLICA_SLUG);
  if (sampleReplica) {
    replicaId = sampleReplica.uuid;
  }
}

// If you need OpenAI-compatible formatting, you can use the experimental endpoint
const response = await client.chatCompletions.postV1ExperimentalReplicasChatCompletions(
  replicaId,
  {
    messages: [
      { role: 'system', content: 'You are a helpful assistant.' },
      { role: 'user', content: 'Hello, how can you help me today?' }
    ],
    source: 'web',
    store: true
  }
);

// This response will include OpenAI-compatible format with choices array
console.log(response.choices[0].message.content);

// Note: The API does not currently support streaming. Attempting to use
// EventSource or setting up streaming with the 'Accept: text/event-stream'
// header will result in errors.