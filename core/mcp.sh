#!/bin/bash

set -e

echo "Installing MCP servers..."

claude mcp add memory -s user -- npx -y @modelcontextprotocol/server-memory
claude mcp add filesystem -s user -- npx -y @modelcontextprotocol/server-filesystem "$HOME"
claude mcp add fetch -s user -- npx -y @kazuph/mcp-fetch

claude mcp list
