---
name: add-command
description: Add a new slash command to .claude/commands/ following best practices from the guide.
argument-hint: [description of what the command should do]
---

Use the `claude-add-command` sub-agent to create a new slash command for this project.

Pass `$ARGUMENTS` as the command description. The agent will read the commands guide section, check existing commands and available agents, generate the command file, and ask for approval before writing.
