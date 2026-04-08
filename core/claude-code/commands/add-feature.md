---
name: add-feature
description: Add any advanced Claude Code feature not covered by add-agent/command/skill/hook — scheduled tasks, MCP servers, agent teams, worktrees, channels, and more.
argument-hint: [feature name, e.g. "schedule", "mcp", "agent-team"]
---

Use the `claude-add-feature` sub-agent to implement an advanced feature for this project.

Pass `$ARGUMENTS` as the feature name or description. The agent will read the guide README to find the right implementation file, read only that section, and implement the feature with approval before writing. Run `/plan-claude` first if you're not sure what features to add.
