---
description: Directly delegate a task to the local llama-server at localhost:8080 via the local-llm agent, bypassing any routing logic.
argument-hint: <task description>
---

Delegate $ARGUMENTS directly to the `local-llm` agent without any classification or routing.

## Steps

1. Pass `$ARGUMENTS` as the task description to the `local-llm` agent.
2. Return the agent's response verbatim.
3. If the agent reports the server is not running, remind the user to start it with their configured run script.

## Hard rules

- No routing logic — this command is a direct shortcut to local inference only.
- Do not fall back to Claude if the local server is unavailable; surface the error and prompt the user to start the server.
