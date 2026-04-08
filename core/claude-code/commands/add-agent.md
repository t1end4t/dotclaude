---
name: add-agent
description: Add a new sub-agent to .claude/agents/ following best practices from the guide.
argument-hint: [description of what the agent should do]
---

Use the `claude-add-agent` sub-agent to create a new agent for this project.

Pass `$ARGUMENTS` as the agent description. The agent will read the subagents guide section, check existing agents to avoid duplication, generate the agent file, and ask for approval before writing.
