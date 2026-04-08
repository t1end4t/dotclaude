---
name: add-hook
description: Add a new lifecycle hook to this project — creates the hook script and registers it in .claude/settings.json.
argument-hint: [description of what the hook should do and when]
---

Use the `claude-add-hook` sub-agent to add a hook to this project.

Pass `$ARGUMENTS` as the hook description. The agent will read the hooks section of the settings guide, check existing hooks, generate the script and settings.json registration, and ask for approval before writing.
