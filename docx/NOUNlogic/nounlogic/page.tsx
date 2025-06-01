'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import ChatInterface from '@/components/ChatInterface';
import CodeBlock from '@/components/CodeBlock';
import RedeemKeyModal from '@/components/RedeemKeyModal';
import EnvChecker from '@/components/EnvChecker';
import { SAMPLE_USER_ID, SAMPLE_REPLICA_SLUG, API_VERSION } from '@/constants/auth';

export default function Home() {
  const [activeTab, setActiveTab] = useState<'chat' | 'code'>('chat');
  const [isRedeemModalOpen, setIsRedeemModalOpen] = useState(false);
  
  const codeExamples = {
    initialization: `
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
    email: \`\${SAMPLE_USER_ID}@example.com\`,
    name: "Sample User"
  });
}

// 4. Initialize user-authenticated client for further operations
const client = new SensayAPI({
  HEADERS: {
    'X-ORGANIZATION-SECRET': process.env.NEXT_PUBLIC_SENSAY_API_KEY_SECRET,
    'X-USER-ID': SAMPLE_USER_ID
  }
});`,
    chatCompletion: `
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

console.log(response.content);`,
    experimentalCompletions: `
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
// header will result in errors.`
  };

  return (
    <div className="flex flex-col min-h-screen">
      <header className="py-6 border-b border-gray-200">
        <div className="flex flex-col lg:flex-row justify-between items-center gap-4">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Sensay AI Chat Sample</h1>
            <p className="text-gray-600 mt-1">
              A demonstration of integrating with the Sensay AI API
            </p>
            <div className="mt-2">
              <EnvChecker />
            </div>
          </div>
          <div className="flex flex-wrap gap-3">
            <button
              onClick={() => setIsRedeemModalOpen(true)}
              className="btn bg-green-600 hover:bg-green-700 text-white"
            >
              Redeem API Key
            </button>
            <a
              href="https://docs.google.com/forms/d/11ExevrfKClc7IfQf7kjEpIiLqHtHE_E42Y752KV7mYY/edit"
              target="_blank"
              rel="noopener noreferrer"
              className="btn bg-purple-600 hover:bg-purple-700 text-white"
              onClick={(e) => { 
                e.preventDefault(); 
                window.open('https://docs.google.com/forms/d/11ExevrfKClc7IfQf7kjEpIiLqHtHE_E42Y752KV7mYY/edit', '_blank', 'noopener,noreferrer'); 
              }}
            >
              Request API Key
            </a>
            <a
              href="https://docs.sensay.io"
              target="_blank"
              rel="noopener noreferrer"
              className="btn btn-secondary"
              onClick={(e) => { 
                e.preventDefault(); 
                window.open('https://docs.sensay.io', '_blank', 'noopener,noreferrer'); 
              }}
            >
              API Documentation
            </a>
            <a
              href="https://github.com/sensay-io/chat-client-sample"
              target="_blank"
              rel="noopener noreferrer"
              className="btn btn-primary"
              onClick={(e) => { 
                e.preventDefault(); 
                window.open('https://github.com/sensay-io/chat-client-sample', '_blank', 'noopener,noreferrer'); 
              }}
            >
              GitHub Repo
            </a>
          </div>
        </div>
        
        <div className="mt-6 border-b border-gray-200">
          <nav className="flex space-x-8">
            <button
              onClick={() => setActiveTab('chat')}
              className={`py-2 px-1 font-medium text-sm ${
                activeTab === 'chat'
                  ? 'text-primary border-b-2 border-primary'
                  : 'text-gray-500 hover:text-gray-700'
              }`}
            >
              Chat Demo
            </button>
            <button
              onClick={() => setActiveTab('code')}
              className={`py-2 px-1 font-medium text-sm ${
                activeTab === 'code'
                  ? 'text-primary border-b-2 border-primary'
                  : 'text-gray-500 hover:text-gray-700'
              }`}
            >
              Code Examples
            </button>
          </nav>
        </div>
      </header>

      <div className="flex-1 py-6">
        {activeTab === 'chat' ? (
          <div className="card h-[75vh]">
            <ChatInterface apiKey={process.env.NEXT_PUBLIC_SENSAY_API_KEY_SECRET} />
          </div>
        ) : (
          <div className="space-y-8">
            <section>
              <h2 className="text-xl font-semibold mb-4">Getting Started</h2>
              <p className="mb-4">
                To use the Sensay AI API, you&apos;ll need an API key and a Replica UUID. 
                The SDK will help you manage replicas and interact with the API.
              </p>
              <CodeBlock
                language="typescript"
                code={codeExamples.initialization}
                title="Initializing the Sensay API Client"
              />
            </section>
            
            <section>
              <h2 className="text-xl font-semibold mb-4">Basic Chat Completion</h2>
              <p className="mb-4">
                Send a message to the API and receive a completion response:
              </p>
              <CodeBlock
                language="typescript"
                code={codeExamples.chatCompletion}
                title="Creating a Chat Completion"
              />
            </section>
            
            <section>
              <h2 className="text-xl font-semibold mb-4">OpenAI-Compatible Endpoint</h2>
              <p className="mb-4">
                If you need OpenAI-compatible response formatting, you can use the experimental endpoint:
              </p>
              <CodeBlock
                language="typescript"
                code={codeExamples.experimentalCompletions}
                title="OpenAI-Compatible Chat Completion"
              />
            </section>
            
            <section>
              <h2 className="text-xl font-semibold mb-4">Next Steps</h2>
              <ul className="list-disc pl-5 space-y-2">
                <li>
                  <a 
                    href="https://docs.sensay.io" 
                    className="text-primary hover:underline"
                    target="_blank"
                    rel="noopener noreferrer"
                    onClick={(e) => { 
                      e.preventDefault(); 
                      window.open('https://docs.sensay.io', '_blank', 'noopener,noreferrer'); 
                    }}
                  >
                    Explore the Sensay API documentation
                  </a>
                </li>
                <li>
                  Add user authentication to your application
                </li>
                <li>
                  Implement chat history persistence
                </li>
                <li>
                  Customize the AI responses with system prompts
                </li>
              </ul>
            </section>
          </div>
        )}
      </div>
      
      <footer className="py-6 border-t border-gray-200 mt-auto">
        <div className="flex justify-between items-center">
          <p className="text-sm text-gray-500">
            &copy; {new Date().getFullYear()} Sensay AI Sample
          </p>
          <div className="flex space-x-4">
            <a
              href="https://sensay.io"
              target="_blank"
              rel="noopener noreferrer"
              className="text-sm text-gray-500 hover:text-gray-700"
              onClick={(e) => { 
                e.preventDefault(); 
                window.open('https://sensay.io', '_blank', 'noopener,noreferrer'); 
              }}
            >
              Sensay AI Website
            </a>
            <a
              href="https://docs.sensay.io"
              target="_blank"
              rel="noopener noreferrer"
              className="text-sm text-gray-500 hover:text-gray-700"
              onClick={(e) => { 
                e.preventDefault(); 
                window.open('https://docs.sensay.io', '_blank', 'noopener,noreferrer'); 
              }}
            >
              API Documentation
            </a>
          </div>
        </div>
      </footer>
      
      {/* Redeem API Key Modal */}
      <RedeemKeyModal 
        isOpen={isRedeemModalOpen} 
        onClose={() => setIsRedeemModalOpen(false)} 
      />
    </div>
  );
}