MCP
Connect Astrolescent to your LLM or AI Agents

Most LLMs are pretty isolated and have a hard time executing actions or fetching real-time information. The Model Context Protocol (MCP) fixes that. It gives the LLM or your AI Agent the options to interact with external services like Astrolescent. To fetch the latest price of $ASTRL for example, or the current staking yield. Or even to fetch a quote to buy 1k ASTRL.

Tools
An MCP server consists of several tools you can call from your prompt. All our tools return both a raw variable containing the JSON data from our API and a text variable that is human readable and helps the LLM to more easily interpret the raw JSON data.

Price
Returns the current price in XRD and USD, including the 24H and 7 days differences.

Example
Hey, use Astrolescent to display the current price of ASTRL in XRD.

Quote
Returns a quote to swap token A for token B, including all information needed to make the swap afterwards if you're an AI agent.

Example
Hey, use Astrolescent to get a quote for a swap from 100 XRD to ASTRL using account address account_rdx1abcdefg

The quote tool has 3 operations: buy, sell, and swap . When you buy, the sell token is automatically set to XRD and we try to predict how much XRD you need to sell to get to the wanted amount, and when you sell, you're buying XRD.

APY
Returns the current APYs for ASTRL staking, and the ASTRL rewards for staking on our validator node and providing liquidity on DefiPlaza.

Example
Hey, use Astrolescent to get the current APY on ASTRL staking.

Installation
You can use our remove MCP server by adding it to Claude Desktop, Cursor, Windsurf or any other tool that currently supports adding MCP servers. Unfortunately, none of the current web interfaces support MCP.

URL
https://mcp.astrolescent.com/sse
Claude Desktop

Copy
{
	"mcpServers": {
	  "astrolescent": {
		 "command": "npx",
		 "args": ["mcp-remote", "https://mcp.astrolescent.com/sse"]
	  }
	}
 }
Cursor

To connect Cursor with our remote MCP server, choose Type: "Command" and in the Commandfield, combine the command and args fields into one: npx mcp-remote https://mcp.astrolescent.com/sse

Windsurf

Copy
{
  "mcpServers": {
    "astrolescent": {
      "command": "npx",
      "args": ["mcp-remote", "https://mcp.astrolescent.com/sse"]
    }
  }
}
Previous
API
Next
Swap Widget
