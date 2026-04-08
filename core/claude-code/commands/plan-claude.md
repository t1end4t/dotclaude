---
name: plan-claude
description: Analyze this project and produce a Claude Code feature plan — what agents, commands, skills, hooks, and features to add, in what order. Saves plan to .claude/plan.md.
argument-hint: [optional: focus area or notes]
---

Use the `claude-code-planner` sub-agent to analyze this project and produce a feature plan.

Pass `$ARGUMENTS` as optional focus notes. The agent will read the guide README feature inventory, examine the current .claude/ state, and write a prioritized plan to `.claude/plan.md`. Run `/add-agent`, `/add-command`, `/add-skill`, `/add-hook`, or `/add-feature` to execute plan items.
