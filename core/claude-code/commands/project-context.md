---
description: Ask OpenCode to summarize the current project — structure, tech stack, entry points. Use at the start of a session before planning any execution tasks.
---

Use the `opencode` skill to get a project overview from OpenCode. Do NOT read files yourself.

Delegate this task to OpenCode:

```
TASK: Give me a concise project overview for planning purposes
CONTEXT: Starting a new session. Need to understand the codebase before planning execution tasks.
FILES: unknown — please explore from the project root
CONSTRAINTS: Keep total output under 40 lines. Do not make any changes to files.
RETURN:
  1. Directory structure (2 levels deep, skip node_modules/.git)
  2. Tech stack (languages, frameworks, key dependencies)
  3. Main entry points
  4. Any notable config files (package.json, pyproject.toml, opencode.json, etc.)
  5. One-sentence description of what this project does
```

Working directory for the OpenCode call: $ARGUMENTS (if provided) or the current project directory.

After receiving OpenCode's output, present it cleanly to the user as a brief project summary. Do not add commentary beyond what OpenCode returned.
