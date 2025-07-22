Getting Started with AI Models API
IO Intelligence API (Application Programming Interface) serves as a bridge to powerful, open-source machine learning models, deployed on IO Net hardware, allowing you to integrate cutting-edge AI capabilities into your projects with relative ease. In simpler terms, the API is like a helper that lets you use smart programs in your projects. To make the integration easy for your application, we fully support the API contract presented by OpenAI, being fully OpenAI API compatible for Chat Completions and more.


Important Note on Usage Limits
The IO Intelligence API provides the following free daily limits (measured in LLM tokens) per account, per day, per model..

Column Definitions:
LLM Model Name: The name of the large language model (LLM) available for use.
Daily Chat Quota: The maximum number of tokens you can use in chat-based interactions with this model per day.
Daily API Quota: The maximum number of tokens allowed for API-based interactions per day.
Daily Embeddings Quota: The maximum number of tokens available for embedding operations per day.
Context Length: The maximum number of tokens the model can process in a single request (including both input and output).
Please refer to the table below for model-specific limits:

LLM Model Name	Daily Chat quote	Daily API quote	Daily Embeddings quote	Context Length
meta-llama/Llama-4-Maverick-17B-128E-Instruct-FP8	1,000,000 tk	500,000 tk	N/A	430,000 tk
deepseek-ai/DeepSeek-R1-0528	1,000,000 tk	500,000 tk	N/A	128,000 tk
Qwen/Qwen3-235B-A22B-FP8	1,000,000 tk	500,000 tk	N/A	128,000 tk
meta-llama/Llama-3.3-70B-Instruct	1,000,000 tk	500,000 tk	N/A	128,000 tk
google/gemma-3-27b-it	1,000,000 tk	500,000 tk	N/A	8,000 tk
mistralai/Magistral-Small-2506	1,000,000 tk	500,000 tk	N/A	128,000 tk
mistralai/Devstral-Small-2505	1,000,000 tk	500,000 tk	N/A	128,000 tk
deepseek-ai/DeepSeek-R1-Distill-Llama-70B	1,000,000 tk	500,000 tk	N/A	128,000 tk
deepseek-ai/DeepSeek-R1	1,000,000 tk	500,000 tk	N/A	128,000 tk
deepseek-ai/DeepSeek-R1-Distill-Qwen-32B	1,000,000 tk	500,000 tk	N/A	128,000 tk
microsoft/phi-4	1,000,000 tk	500,000 tk	N/A	16,000 tk
nvidia/AceMath-7B-Instruct	1,000,000 tk	500,000 tk	N/A	4,000 tk
mistralai/Mistral-Large-Instruct-2411	1,000,000 tk	500,000 tk	N/A	128,000 tk
bespokelabs/Bespoke-Stratos-32B	1,000,000 tk	500,000 tk	N/A	32,000 tk
netease-youdao/Confucius-o1-14B	1,000,000 tk	500,000 tk	N/A	32,000 tk
CohereForAI/aya-expanse-32b	1,000,000 tk	500,000 tk	N/A	8,000 tk
THUDM/glm-4-9b-chat	1,000,000 tk	500,000 tk	N/A	128,000 tk
mistralai/Ministral-8B-Instruct-2410	1,000,000 tk	500,000 tk	N/A	32,000 tk
openbmb/MiniCPM3-4B	1,000,000 tk	500,000 tk	N/A	32,000 tk
ibm-granite/granite-3.1-8b-instruct	1,000,000 tk	500,000 tk	N/A	128,000 tk
Qwen/Qwen2.5-VL-32B-Instruct	0 tk	500,000 tk	N/A	32,000 tk
meta-llama/Llama-3.2-90B-Vision-Instruct	0 tk	500,000 tk	N/A	16,000 tk
BAAI/bge-multilingual-gemma2	N/A	N/A	50,000,000 tk	4,096 tk
This limit is designed to ensure fair and balanced usage for all users. If you anticipate needing a higher request limit, please consider optimizing your implementation or reach out to us for assistance.

Introduction
You can interact with the API using HTTP requests from any programming language or by using the official Python and Node.js libraries.

To install the official Python library, run the following command:


pip install openai
To install the official Node.js library, run this command in your Node.js project directory:


npm install openai
Example: Using the IO Intelligence API with Python
Here’s an example of how you can use the openai Python library to interact with the IO Intelligence API:

openai Python

import openai

client = openai.OpenAI(
    api_key="$IOINTELLIGENCE_API_KEY",
    base_url="https://api.intelligence.io.solutions/api/v1/",
)

response = client.chat.completions.create(
    model="meta-llama/Llama-3.3-70B-Instruct",
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Hi, I am doing a project using IO Intelligence."},
    ],
    temperature=0.7,
    stream=False,
    max_completion_tokens=50
)

print(response.choices[0].message.content)
This snippet demonstrates how to configure the client, send a chat completion request using the Llama-3.3-70B-Instruct model, and retrieve a response.

Authentication
API keys
IO Intelligence APIs authenticate requests using API keys. You can generate API keys from your user account:

🚧
Always treat your API key as a secret! Do not share it or expose it in client-side code (e.g., browsers or mobile apps). Instead, store it securely in an environment variable or a key management service on your backend server.

Include the API key in an Authorization HTTP header for all API requests:


Authorization: Bearer $IOINTELLIGENCE_API_KEY
Example: List Available Models
Here's an example curl command to list all models available in IO Intelligence:

cURL

curl https://api.intelligence.io.solutions/api/v1/models \
  -H "Authorization: Bearer $IOINTELLIGENCE_API_KEY" 

This request should return a response like this:

JSON

{
  "object": "list",
  "data": [
    {
      "id": "meta-llama/Llama-3.3-70B-Instruct",
      "object": "model",
      "created": 1736168795,
      "owned_by": "io-intelligence",
      "root": null,
      "parent": null,
      "max_model_len": null,
      "permission": [
        {
          "id": "modelperm-30ac078e67ab456a9279d53cf83155bb",
          "object": "model_permission",
          "created": 1736755239,
          "allow_create_engine": false,
          "allow_sampling": true,
          "allow_logprobs": true,
          "allow_search_indices": false,
          "allow_view": true,
          "allow_fine_tuning": false,
          "organization": "*",
          "group": null,
          "is_blocking": false
        }
      ]
    },
    ...
  ]
}
Making requests
To test the API, use the following curl command. Replace $IOINTELLIGENCE_API_KEY with your actual API key.

cURL

curl https://api.intelligence.io.solutions/api/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $IOINTELLIGENCE_API_KEY" \
  -d '{
     "model": "meta-llama/Llama-3.3-70B-Instruct",
     "messages": [{"role": "user", "content": "Say this is a test!"}],
     "reasoning_content": true,
     "temperature": 0.7
   }'

This command queries the meta-llama/Llama-3.3-70B-Instruct model to generate a chat completion for the input: "Say this is a test!".:

Example Response
The API should return a response like this:

JSON

{
  "id": "01945ea6-1d9f-9d46-efbc-2608dcc78169",
  "object": "chat.completion",
  "created": 1736754732,
  "model": "meta-llama/Llama-3.3-70B-Instruct",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "This is a test!"
      },
      "logprobs": null,
      "finish_reason": "stop",
      "stop_reason": null
    }
  ],
  "usage": {
    "prompt_tokens": 12,
    "total_tokens": 18,
    "completion_tokens": 6,
    "prompt_tokens_details": null
  },
  "prompt_logprobs": null
}