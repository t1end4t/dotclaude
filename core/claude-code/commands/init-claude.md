---
name: init-claude
description: Initialize the Claude Code foundation for this project — CLAUDE.md and settings.json. Run this first, then /plan-claude.
argument-hint: [optional: target directory path]
---

Use the `claude-code-initializer` sub-agent to initialize this project.

Pass `$ARGUMENTS` as the target directory (if provided). The agent will read the best-practice guide, interview the user, and create CLAUDE.md and .claude/settings.json only — no agents, commands, or skills. Those come after `/plan-claude`.
