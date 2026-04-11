# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

`dotclaude` is **not an application** — it is a personal distribution of configuration, skills, agents, commands, and hooks for three AI coding tools: **Claude Code**, **OpenCode**, and **Codex**. The `install.sh` script copies files from this repo into `~/.claude/`, `~/.config/opencode/`, `~/.codex/`, and `~/.config/environment.d/`. Editing this repo means editing a source-of-truth that gets materialized into those home directories on install.

The philosophical framing lives in `BLUEPRINT.md` (a layered AI-OS vision) and condensed tips live in `best-practice.md`. Read them before making non-trivial structural changes.

## Top-level layout

```
core/           Layer 0 — base config installed with `--core`
  manifest.toml               Declares what core installs
  claude-code/
    settings.json             Claude Code harness config (sandbox, permissions, hooks, plugins)
    CLAUDE.md                 Global behavioral rules for Claude Code
    commands/ agents/ hooks/  Installed to ~/.claude/{commands,agents,hooks}/
  opencode/
    opencode.json             Merged into ~/.config/opencode/opencode.json via `jq`
    agents/ commands/ AGENTS.md
  codex/skills/               Installed to ~/.codex/skills/
  environment.d/              Copied to ~/.config/environment.d/ (skipped if dest exists)

packs/          Opt-in domain packs installed with `--pack=NAME`
  local-llm/ infra/ data-science/ scientific-writing/ document-tools/ specialized/
  Each pack has its own manifest.toml and mirrors the core layout
  (claude-code/skills, opencode/agents, codex/skills).

guide/          Reference docs, tutorials, and patterns — NOT installed as config.
                install.sh only records its path in ~/.claude/claude-code-guide-path.
                guide/CLAUDE.md is a subagent reference, not a project-level CLAUDE.md.

install.sh      The entire "build system" (no Make/just/npm).
uninstall.sh    Symmetric removal by filename.
BLUEPRINT.md    Nine-layer design doc; read for high-level intent.
best-practice.md  Concept table + tips for prompts, plans, agents, skills, commands, hooks.
```

## Common commands

```bash
./install.sh --list                             # Show available packs and file counts
./install.sh --core                             # Install only core (Layer 0)
./install.sh --pack=local-llm                   # Install a single pack
./install.sh --pack=infra --pack=data-science   # Multiple packs in one invocation
./install.sh --all                              # Core + every pack
./uninstall.sh ...                              # Same flags, reverses install
```

There is no build step, no test suite, no linter. "Testing a change" means running `./install.sh --pack=<name>` against a local environment and exercising the installed skill/agent/command in Claude Code or OpenCode.

## How install.sh works (things to know before editing it)

- **Copies, does not symlink** — edits to the repo do not propagate until you re-run `install.sh`.
- **JSON files are merged with `jq -s '.[0] * .[1]'`** in `merge_json()` (install.sh:47-58), so downstream changes to `~/.config/opencode/opencode.json` survive re-installs. Plain files (like `settings.json`) are overwritten via `copy_file()`.
- **Hooks are chmod +x'd** after install — new hook scripts must be shell-executable.
- **Packs install skills by directory** (`packs/<pack>/claude-code/skills/<skill>/`), and **each skill directory must contain a `SKILL.md`** or `install_pack()` silently skips it (install.sh:141-151). This is the single most common reason a new skill "doesn't install."
- **`environment.d` files are skipped if the destination already exists** (never overwritten), unlike everything else.
- `install.sh` writes `$SCRIPT_DIR/guide` to `~/.claude/claude-code-guide-path` so other tools can find the guide docs.

## Pack manifest format

Every pack (and `core/`) has a `manifest.toml` with this shape:

```toml
[pack]
name = "local-llm"
description = "Route lightweight tasks to local llama-server to save API tokens"
version = "1.0.0"

[claude-code]
skills = "claude-code/skills"     # Only include sections the pack actually provides

[opencode]
agents = "opencode/agents"

[codex]
skills = "codex/skills"
```

Note: `install.sh` **does not actually parse the manifest** beyond grepping `description` for `--list` output. Installation is driven by directory conventions (`claude-code/skills/`, `opencode/agents/`, etc.), not manifest declarations. The manifest is documentation for humans. If you add a new target, you must teach `install_pack()` about it — updating the manifest alone is not enough.

## Where to put what

| Change                              | Edit                                                        |
| ----------------------------------- | ----------------------------------------------------------- |
| Global Claude Code behavior rules   | `core/claude-code/CLAUDE.md`                                |
| Harness / permissions / hooks / MCP | `core/claude-code/settings.json`                            |
| OpenCode MCP servers or perms       | `core/opencode/opencode.json`                               |
| A new general-purpose skill         | `core/claude-code/skills/<name>/SKILL.md` *or* a pack       |
| A domain-specific skill/agent       | `packs/<pack>/claude-code/skills/<name>/SKILL.md`           |
| A new pack                          | `packs/<name>/{manifest.toml,claude-code/,opencode/,codex/}`|
| Shell env vars for the whole system | `core/environment.d/<file>.sh`                              |

Prefer adding to an existing pack over creating a new one. A new pack should represent a cohesive domain (like `scientific-writing`), not a single skill.

## Conventions worth following

- **Skills are directories, not single files.** A `SKILL.md` is required; `references/`, `scripts/`, and `examples/` subdirectories are conventional. See `best-practice.md` for the full pattern.
- **Keep CLAUDE.md files short** (< 200 lines is the documented target). If rules grow, split into `.claude/rules/` or use `<important if="...">` tags.
- **Don't dump content into `guide/` expecting it to install.** `guide/` is read-only reference material that users browse from their installed `~/.claude/claude-code-guide-path` pointer.
- **settings.json changes are harness-level** — they affect sandbox, permissions, hooks, and plugins, which Claude cannot override at runtime. Use `settings.json` for deterministic behavior; use `CLAUDE.md` files for guidance.
