#!/usr/bin/env bash
# Usage: local-llm.sh "<prompt>" [max_tokens]
set -euo pipefail

PROMPT="${1:?Usage: local-llm.sh '<prompt>' [max_tokens]}"
MAX_TOKENS="${2:-512}"
ENDPOINT="http://localhost:8080"

# Health check
if ! curl -s --connect-timeout 2 "$ENDPOINT/health" > /dev/null 2>&1; then
  echo "ERROR: local LLM server is not running at $ENDPOINT" >&2
  echo "Start it with: bash <your-scripts-dir>/run-model.sh <model>" >&2
  exit 1
fi

# Build payload safely (never raw shell interpolation) and send
curl -s "$ENDPOINT/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -d "$(python3 -c "
import json, sys
print(json.dumps({
  'model': 'local',
  'messages': [{'role': 'user', 'content': sys.argv[1]}],
  'temperature': 0.2,
  'max_tokens': int(sys.argv[2])
}))" "$PROMPT" "$MAX_TOKENS")" \
  | python3 -c "
import sys, json
data = json.load(sys.stdin)
if 'choices' not in data:
  print('ERROR: unexpected response:', json.dumps(data), file=sys.stderr)
  sys.exit(1)
print(data['choices'][0]['message']['content'])
"
