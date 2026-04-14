---
name: workspace
description: Manage the Layer 1 project registry at ~/codebases/second-brain/1-Projects/registry.md. Use when the user invokes /workspace-status, /workspace-register, /workspace-update, /workspace-switch, or /workspace-bootstrap — or asks to see/edit their project list, register a new project, mark something stalled, or bootstrap the second-brain vault.
user-invocable: true
---

# Workspace (Layer 1) — project registry manager

The registry lives at `~/codebases/second-brain/1-Projects/registry.md` — a markdown table read on every SessionStart by `~/.claude/hooks/workspace-context.sh`. See [references/registry-schema.md](references/registry-schema.md) for the column contract and [references/vault-claude-md.md](references/vault-claude-md.md) for the `second-brain/.claude/CLAUDE.md` template used by `/workspace-bootstrap`.

## Commands

### `/workspace-status`
Print the registry table. Annotate rows where `last_touched` is more than 14 days ago as **stalled**. If the registry does not exist, tell the user to run `/workspace-bootstrap`.

### `/workspace-register`
Append a new row. Required fields: `name`, `path`, `domain`, `status`, `next`. Set `last_touched` to today (format `YYYY-MM-DD`). Infer defaults from `$PWD` when possible:
- `name` = second segment of `$PWD` under `~/codebases/<domain>/<name>/`
- `path` = `$PWD` (write as `~/...` if inside `$HOME`)
- `domain` per the folder map: `company-stack→startup`, `research-lab→research`, `dev-sandbox→dev`, `side-projects→side`, `second-brain→knowledge`

Ask for `status` and `next` interactively. Render the `name` cell as `[[name]]` so Obsidian treats it as a wikilink.

### `/workspace-update`
Update `status`, `next`, and `last_touched` (to today) for the current project. Resolve the project from `$PWD` the same way `/workspace-register` does. Refuse if no matching row exists and suggest `/workspace-register`.

### `/workspace-switch <domain>`
Override the auto-detected posture for **this session only**. The hook cannot be re-run, so emit a one-line acknowledgement the user can paste, e.g. `Treat this session as domain=research — use that posture.` No file changes.

### `/workspace-bootstrap`
One-shot scaffold for a fresh second-brain vault. Create:
1. `~/codebases/second-brain/1-Projects/registry.md` from the schema in `references/registry-schema.md` (header row only, no data rows).
2. `~/codebases/second-brain/.claude/CLAUDE.md` from the template in `references/vault-claude-md.md`.

Refuse to overwrite if either file already exists. Print a diff-style summary of what was created.

## Conventions

- All writes go through the user's editor of record (the markdown file is in an Obsidian vault and a git repo). Prefer `Edit` / `Write` tools, not shell redirection.
- Never mutate `last_touched` silently — only the named commands above change it.
- Cross-domain connections are expressed with Obsidian `[[wikilinks]]` in the `name` and `next` columns. Do not introduce a parallel link system.
- Keep the registry a plain markdown table. Do not introduce Dataview blocks, YAML frontmatter, or HTML — it must remain greppable by the hook's awk parser.
