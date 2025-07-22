Getting Started with AI Agents API
🚧
Beta Notice: This project is in rapid development and may not be stable for production use.

AI Agents in the IO Intelligence API are specialized assistants designed to handle a variety of tasks, from reasoning and summarization to sentiment analysis and translation. These agents leverage advanced AI capabilities to automate complex workflows, enhance decision-making, and streamline information processing.

Each AI agent is tailored for a specific function — whether it's extracting key information, classifying data, moderating content, or translating languages. By integrating these agents into your applications, you can harness powerful AI-driven automation with ease.

For a deeper understanding of how these agents and workflows operate, refer to the IO Intelligence Agent Framework, which provides details on agent creation, workflow orchestration, and API endpoints.

Important Note on Usage Limits
The IO Intelligence API provides the following free daily limits (measured in LLM tokens) per account, per day, per model.

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
You can interact with the API using HTTP requests from any programming language or by using the official Python.

To install the official Python library, run the following command:


pip install iointel
Example: Using the AI Agents API in Python
Here’s an example of how you can use the iointel Python library to interact with the IO Intelligence API:

Python

from iointel import (
    Agent,
    Workflow
)

import os
import asyncio

api_key = os.environ["OPENAI_API_KEY"]  # Replace with your actual IO.net API key

text = """In the rapidly evolving landscape of artificial intelligence, the ability to condense vast amounts of information into concise and meaningful summaries is crucial. From research papers and business reports to legal documents and news articles, professionals across industries rely on summarization to extract key insights efficiently. Traditional summarization techniques often struggle with maintaining coherence and contextual relevance. However, advanced AI models now leverage natural language understanding to identify core ideas, eliminate redundancy, and generate human-like summaries. As organizations continue to deal with an ever-growing influx of data, the demand for intelligent summarization tools will only increase. Whether enhancing productivity, improving decision-making, or streamlining workflows, AI-powered summarization is set to become an indispensable asset in the digital age."""

agent = Agent(
    name="Summarize Agent",
    instructions="You are an assistant specialized in summarization.",
    model="meta-llama/Llama-3.3-70B-Instruct",
    api_key=api_key,
    base_url="https://api.intelligence.io.solutions/api/v1"
)

workflow = Workflow(objective=text, client_mode=False)

async def run_workflow():
    results = (await workflow.summarize_text(max_words=50,agents=[agent]).run_tasks())["results"]
    return results

results = asyncio.run(run_workflow())
print(results)
This snippet demonstrates how to configure the client, send a chat completion request using the Llama-3.3-70B-Instruct agent, and retrieve a response.

🚧
run_tasks() is now asynchronous. All usage must be wrapped inside an async function. Use asyncio.run() to execute it.

Authentication
API keys
IO Intelligence APIs authenticate requests using API keys. You can generate API keys from your user account:

🚧
Always treat your API key as a secret! Do not share it or expose it in client-side code (e.g., browsers or mobile apps). Instead, store it securely in an environment variable or a key management service on your backend server.

Include the API key in an Authorization HTTP header for all API requests:


Authorization: Bearer $IOINTELLIGENCE_API_KEY
Example: List Available Agents
Here's an example curl command to list all agents available in IO Intelligence:

cURL

curl https://api.intelligence.io.solutions/api/v1/agents \
  -H "Authorization: Bearer $IOINTELLIGENCE_API_KEY" 

This request should return a response like this:

JSON

{
  "agents": {
    "reasoning_agent": {
      "name": "Reasoning Agent",
      "description": "A logic-driven problem solver that breaks down complex scenarios into clear, step-by-step conclusions. Whether evaluating arguments, making inferences, or troubleshooting issues, this agent excels at structured thinking and insightful analysis.",
      "persona": null,
      "metadata": {
        "image_url": null,
        "tags": [
          "text"
        ]
      }
    },
    "summary_agent": {
      ...
    },
    "sentiment_analysis_agent": {
     ...
    },
    ...
  }
}