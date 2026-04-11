# Claude Code Best Practice

> Distilled from [shanraisshan/claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice) — tips by Boris Cherny (Claude Code creator), Thariq, and the Anthropic team.

---

## Concepts

| Concept | Location | What it is |
|---------|----------|------------|
| **Subagents** | `.claude/agents/<name>.md` | Autonomous actor in a fresh isolated context — custom tools, permissions, model, memory |
| **Commands** | `.claude/commands/<name>.md` | User-invoked prompt templates injected into the existing context |
| **Skills** | `.claude/skills/<name>/SKILL.md` | Configurable, preloadable, auto-discoverable — supports context forking and progressive disclosure |
| **Hooks** | `.claude/hooks/` | Shell/HTTP handlers that run outside the agentic loop on specific events |
| **MCP Servers** | `.claude/settings.json`, `.mcp.json` | Model Context Protocol connections to external tools, databases, and APIs |
| **Memory** | `CLAUDE.md`, `.claude/rules/` | Persistent context loaded at startup; use `@path` imports to modularize |
| **Settings** | `.claude/settings.json` | Hierarchical config — permissions, model, output style, sandboxing, keybindings |
| **Plugins** | distributable packages | Bundles of skills, subagents, hooks, MCP servers, and LSP servers |

---

## Tips & Tricks

### Prompting

- Challenge Claude: `"grill me on these changes and don't make a PR until I pass your test"` or `"prove to me this works"` — have Claude diff main vs your branch.
- After a mediocre fix: `"knowing everything you know now, scrap this and implement the elegant solution"`.
- Claude fixes most bugs itself — paste the bug, say `"fix"`, don't micromanage how.

### Planning & Specs

- Always start with plan mode (`shift+tab` to cycle, or `/plan`). Pour energy into the plan so Claude can 1-shot the implementation.
- Start with a minimal spec and ask Claude to interview you using the `AskUserQuestion` tool, then open a new session to execute the spec.
- Always make a phase-wise gated plan, with each phase having multiple tests (unit, automation, integration).
- Spin up a second Claude to review your plan as a staff engineer. Use cross-model review (e.g. Codex) for extra signal.
- Write detailed specs, reduce ambiguity before handing work off — the more specific you are, the better the output.
- Prototype > PRD — build 20–30 versions instead of writing specs; the cost of building is low so take many shots.
- The moment something goes sideways, switch back to plan mode and re-plan. Don't keep pushing forward.

### CLAUDE.md

- Keep each CLAUDE.md under 200 lines. Share a single root `CLAUDE.md` checked into git — have the whole team contribute.
- After every correction: `"Update your CLAUDE.md so you don't make that mistake again."` Claude is good at writing rules for itself.
- Wrap domain-specific rules in `<important if="...">` tags to prevent them from being ignored as the file grows longer.
- Use multiple CLAUDE.md files in monorepos — ancestor files load at startup, descendant files lazy-load when those subdirs are accessed.
- Use `.claude/rules/` to split large instruction sets into separate files.
- Any developer should be able to launch Claude, say `"run the tests"`, and it works on the first try — if not, CLAUDE.md is missing setup/build/test commands.
- Keep codebases clean and finish migrations — partially migrated frameworks confuse models that might pick the wrong pattern.
- Use `settings.json` for harness-enforced behavior (attribution, permissions, model) — don't put `"NEVER add Co-Authored-By"` in CLAUDE.md when `attribution.commit: ""` is deterministic.

### Agents (Subagents)

- Have feature-specific subagents (extra context) with skills (progressive disclosure) rather than generic qa/backend agents.
- Say `"use subagents"` to throw more compute at a problem — offload tasks to keep your main context clean and focused.
- Use agent teams with tmux and git worktrees for parallel development.
- Use test-time compute: separate context windows make results better — one agent can cause bugs and another (same model) can find them.

**Subagent frontmatter fields:**

| Field | Description |
|-------|-------------|
| `name` | Unique identifier (lowercase, hyphens) |
| `description` | When to invoke. Use `"PROACTIVELY"` for auto-invocation |
| `tools` | Comma-separated allowlist. Inherits all if omitted |
| `disallowedTools` | Tools to deny |
| `model` | `sonnet`, `opus`, `haiku`, full model ID, or `inherit` (default) |
| `permissionMode` | `default`, `acceptEdits`, `auto`, `bypassPermissions`, `plan` |
| `maxTurns` | Max agentic turns |
| `skills` | Skill names to preload at startup |
| `mcpServers` | MCP servers for this subagent |

### Commands

- Use commands for your repeatable workflows instead of one-off prompts.
- Turn every "inner loop" workflow you do multiple times a day into a command — they live in `.claude/commands/` and are checked into git.
- If you do something more than once a day, turn it into a skill or command.

### Skills

Skills are **folders**, not files — use `references/`, `scripts/`, `examples/` subdirectories for progressive disclosure.

- Use `context: fork` to run a skill in an isolated subagent — main context only sees the final result.
- Build a **Gotchas** section in every skill — highest-signal content; add Claude's failure points over time.
- The `description` field is a trigger, not a summary — write it for the model: "when should I fire?".
- Don't state the obvious in skills — focus on what pushes Claude out of its default behavior.
- Don't railroad Claude in skills — give goals and constraints, not prescriptive step-by-step instructions.
- Include scripts and libraries in skills so Claude composes rather than reconstructs boilerplate.
- Embed `` !`command` `` in SKILL.md to inject dynamic shell output into the prompt at invocation time.
- Use on-demand hooks inside skills: `/careful` blocks destructive commands, `/freeze` blocks edits outside a directory.
- Measure skill usage with a `PreToolUse` hook to find popular or undertriggering skills.
- Use skills in subfolders for monorepos.

**9 skill categories (Thariq):**

| Category | Examples |
|----------|----------|
| Library & API Reference | billing-lib, internal-platform-cli |
| Product Verification | signup-flow-driver, checkout-verifier |
| Data Fetching & Analysis | funnel-query, cohort-compare, grafana |
| Business Process & Team Automation | standup-post, create-ticket, weekly-recap |
| Code Scaffolding & Templates | new-migration, create-app |
| Code Quality & Review | adversarial-review, code-style, testing-practices |
| CI/CD & Deployment | deploy, push, fetch |
| Research & Exploration | codebase-survey, dependency-audit |
| Personal Productivity | daily-standup, reminder, summarize |

### Hooks

- Use a `PostToolUse` hook to auto-format code — Claude generates well-formatted code; the hook handles the last 10% to avoid CI failures.
- Route permission requests to Opus via a hook — let it scan for attacks and auto-approve safe ones.
- Use a `Stop` hook to nudge Claude to keep going or verify its work at end of turn.

### Workflows

- Avoid the "agent dumb zone" — do manual `/compact` at max 50% context. Use `/clear` to reset context mid-session when switching to a new task.
- Vanilla Claude Code is better than any workflow for smaller tasks.
- Use `/model` to select model and reasoning; use Opus for plan mode and Sonnet for code.
- Always enable thinking mode (`true`) and Output Style `Explanatory` in `/config` for better insight into Claude's decisions.
- Use `ultrathink` keyword in prompts for high-effort reasoning.
- `/rename` important sessions (e.g. `[TODO - refactor task]`) and `/resume` them later.
- Use `Esc Esc` or `/rewind` to undo when Claude goes off-track instead of trying to fix it in the same context.

### Workflows — Advanced

- Use ASCII diagrams to understand your architecture.
- Use `/loop` for local recurring monitoring (up to 3 days); use `/schedule` for cloud-based recurring tasks that run even when your machine is off.
- Use `/permissions` with wildcard syntax (`Bash(npm run *)`, `Edit(/docs/**)`) instead of `dangerously-skip-permissions`.
- Use `/sandbox` to reduce permission prompts with file and network isolation.
- Invest in product verification skills (signup-flow-driver, checkout-verifier) — worth spending a week to perfect.

### Parallelism

- Run 5 Claudes in parallel in your terminal — number your tabs 1–5, use system notifications to know when a Claude needs input.
- Use git worktrees for parallel development — each agent gets its own isolated working copy (`git worktree add`).
- Use agent teams (`CLAUDE_AGENT_TEAMS=1`) with tmux for multiple agents on the same codebase with shared task coordination.

### Git / PR

- Keep PRs small and focused — median 118 lines per PR is the target. One feature per PR, easier to review and revert.
- Always squash merge PRs — clean linear history, one commit per feature, easy `git revert` and `git bisect`.
- Commit often — at least once per hour, as soon as a task is completed.
- Tag `@claude` on a coworker's PR to auto-generate lint rules for recurring review feedback — automate yourself out of code review.
- Use `/code-review` for multi-agent PR analysis — catches bugs, security vulnerabilities, and regressions before merge.

### Debugging

- Make a habit of taking screenshots and sharing with Claude whenever stuck.
- Use MCP (Claude in Chrome, Playwright, Chrome DevTools) to let Claude see browser console logs on its own.
- Always ask Claude to run the terminal (you want logs from) as a background task for better debugging.
- Use `/doctor` to diagnose installation, authentication, and configuration issues.
- Error during compaction: use `/model` to select a 1M token model, then run `/compact`.
- Agentic search (glob + grep) beats RAG — code drifts out of sync with vector databases and permissions are complex.

### Utilities

- Use iTerm / Ghostty / tmux instead of IDE terminal for best experience.
- Use `/voice` or Wispr Flow for voice prompting.
- Use the status line for context awareness and fast compacting — set in `settings.json`.
- Explore `settings.json` features like Plans Directory and Spinner Verbs for a personalized experience.

### Daily Habits

- Update Claude Code daily.
- Start your day by reading the [changelog](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md).

---

## CLAUDE.md Loading in Monorepos

```
/mymonorepo/
├── CLAUDE.md          ← loaded at startup (ancestor)
├── frontend/
│   └── CLAUDE.md      ← lazy-loaded when frontend/ files are touched
├── backend/
│   └── CLAUDE.md      ← lazy-loaded when backend/ files are touched
└── api/
    └── CLAUDE.md      ← lazy-loaded when api/ files are touched
```

- **Ancestor loading** (up the tree): loaded immediately at startup.
- **Descendant loading** (down the tree): lazy-loaded only when Claude reads files in that subdirectory.

---

## Key Commands Reference

| Command | Purpose |
|---------|---------|
| `/plan` / `shift+tab` | Enter plan mode |
| `/compact` | Compact context (do at ~50% full) |
| `/clear` | Reset context |
| `/model` | Switch model / effort level |
| `/config` | Configure settings |
| `/rewind` / `Esc Esc` | Undo last change (checkpointing) |
| `/loop <interval> <skill>` | Run skill on recurring schedule (local, up to 3 days) |
| `/schedule` | Schedule cloud-based recurring task |
| `/rename` | Name current session |
| `/resume` | Resume a named session |
| `/permissions` | Configure tool permissions with wildcards |
| `/sandbox` | Enable file/network isolation |
| `/doctor` | Diagnose installation issues |
| `/code-review` | Multi-agent PR analysis |
| `/voice` | Push-to-talk voice input |
| `/powerup` | Interactive lessons for Claude Code features |
| `/teleport` | Pull a cloud session to local terminal |
| `/remote-control` | Control local session from any device |
| `ultrathink` | Keyword for high-effort extended reasoning in prompts |
