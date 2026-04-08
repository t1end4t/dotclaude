---
description: Migrate Claude Code setup (.claude/ and CLAUDE.md) to OpenCode format. Converts agents, commands, skills, hooks, and settings.
agent: claude-to-opencode-migrator
---

> **NOTE:** When creating agent markdown files, use this frontmatter format:
> ```yaml
> ---
> name: <agent-name>
> description: <description>
> model: <model-id>
> color: "#00ff00"        # hex format only
> tools:                  # object format, not array
>   Read: true
>   Write: true
>   Bash: true
>   Glob: true
>   Grep: true
> ---
> ```
> 
> Common mistakes to avoid:
> - `color: green` → use hex format like `"#00ff00"`
> - `tools: [Read, Write]` → use object format `tools: { Read: true }`

Migrate the Claude Code setup in this project to OpenCode format.

The migrator will:
1. Scan your existing `.claude/` folder and `CLAUDE.md`
2. Copy agents, commands, and skills to `.opencode/`
3. Convert `settings.json` to `opencode.json`
4. Convert shell hooks to JavaScript plugins
5. Create a migration report

Run the migrator to proceed.
