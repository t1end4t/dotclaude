---
name: add-skill
description: Install a skill into .claude/skills/ — copies from the library or creates a new one.
argument-hint: [skill name or description]
---

Use the `claude-add-skill` sub-agent to install a skill for this project.

Pass `$ARGUMENTS` as the skill name or description. The agent will read the skills guide section, search the skills library for a match, and either copy the full skill directory or create a new SKILL.md from scratch — with approval before writing.
