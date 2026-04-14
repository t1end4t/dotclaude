# Registry schema

File: `~/codebases/second-brain/1-Projects/registry.md`

One markdown table. Seven columns. Header row + separator row, then one data row per project.

```markdown
| name           | path                                | domain    | status  | next                         | last_touched |
|----------------|-------------------------------------|-----------|---------|------------------------------|--------------|
| [[dotclaude]]  | ~/codebases/dev-sandbox/dotclaude   | dev       | active  | implement Layer 1            | 2026-04-14   |
```

## Columns

| Column         | Purpose                                                                 | Allowed values                              |
|----------------|-------------------------------------------------------------------------|---------------------------------------------|
| `name`         | Project identifier. Matched by the hook against the second path segment of `$PWD`. Render as `[[name]]` so Obsidian treats it as a wikilink to `1-Projects/name.md`. | Any slug. No `|` characters.                |
| `path`         | Absolute-ish path, written with `~/...` when under `$HOME`.             | One line.                                   |
| `domain`       | The posture the AI should adopt — see `CLAUDE.md` "Workspace awareness". | `startup` \| `research` \| `dev` \| `side` \| `knowledge` |
| `status`       | Lifecycle state.                                                        | `active` \| `waiting` \| `paused` \| `done` |
| `next`         | One-line "what's the next concrete step". Wikilinks allowed.            | One line. No `|`.                           |
| `last_touched` | Date of last meaningful update (set by `/workspace-register`, `/workspace-update`). | ISO date `YYYY-MM-DD`.                     |

## Hook parsing contract

The hook (`~/.claude/hooks/workspace-context.sh`) uses awk with `-F'|'` and treats fields positionally:

- Field `$2` = name (with `[[ ]]` stripped, whitespace trimmed)
- Field `$5` = status
- Field `$6` = next
- Field `$7` = last_touched

The separator row (`|---|---|...`) is skipped by a regex on `^\|[[:space:]]*-`. The header row is skipped by a regex on `name`. Do not reorder columns or introduce extra columns without updating the hook.

## Stalled marker

If `last_touched` is more than 14 days before today (GNU `date -d`), the hook appends a "stalled" note to the injected context. This threshold is baked into the hook; edit `workspace-context.sh` if you want to change it.
