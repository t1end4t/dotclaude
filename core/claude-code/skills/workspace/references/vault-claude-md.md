# Template for `second-brain/.claude/CLAUDE.md`

Written by `/workspace-bootstrap` into `~/codebases/second-brain/.claude/CLAUDE.md`. This is the vault-local project CLAUDE.md — it loads automatically whenever Claude Code is launched from anywhere inside the vault.

The template keeps the global `~/.claude/CLAUDE.md` in charge (domain posture, workflow rules). This file adds only the vault-specific context: "you are now in the PARA hub that manages every other codebase."

---

```markdown
# second-brain — PARA hub

This repo is the manager/hub for everything under `~/codebases/`. When you are
here, you are in **knowledge domain** posture (see `~/.claude/CLAUDE.md`
"Workspace awareness"): help retrieve, connect, and refine — don't capture for
the user.

## Layout (PARA)

- `1-Projects/` — anything with a current outcome. The Layer 1 registry lives
  at `1-Projects/registry.md`; individual project notes live beside it as
  `1-Projects/<name>.md`.
- `2-Areas/` — ongoing responsibilities (health, oncall rotations, standing
  reviews). No deadline.
- `3-Resources/` — reference material: papers, bookmarks, reusable snippets.
- `4-Archive/` — cold storage for anything no longer active.

## Operating rules in this vault

- **Wikilinks are the link substrate.** When you mention another note, use
  `[[note-name]]`. Obsidian resolves them; the AI should too.
- **Registry is the source of truth for project state**, not any individual
  note. Edit `1-Projects/registry.md` via the `/workspace-*` skills — don't
  hand-edit it unless asked.
- **Don't auto-capture.** If the user is thinking aloud, don't silently write
  a note. Ask first. The act of writing is part of learning.
- **Cross-domain connections** (research idea that helps the startup, etc.)
  belong in `3-Resources/` with wikilinks to both sides, not buried in one
  project's note.

## What lives where

| You want to...                          | Put it in                                     |
|-----------------------------------------|-----------------------------------------------|
| Track an active project                 | `1-Projects/<name>.md` + registry row         |
| Park an ongoing responsibility          | `2-Areas/`                                    |
| Save a paper / bookmark / snippet       | `3-Resources/`                                |
| Retire something                        | Move from `1-Projects/` to `4-Archive/`       |
```

---

## Bootstrap behavior

- Create `~/codebases/second-brain/.claude/` if missing.
- Write the file above (between the `---` fences, verbatim) to `~/codebases/second-brain/.claude/CLAUDE.md`.
- If the file already exists, refuse and tell the user.
