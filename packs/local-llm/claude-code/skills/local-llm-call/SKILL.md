---
name: local-llm-call
description: Use this skill when sending a prompt to the local llama-server at localhost:8080 — triggers for LOCAL-tier tasks like summarization, code explanation, format conversion, config validation, commit messages, and log analysis where Claude tokens should be avoided.
user-invocable: false
allowed-tools: Bash
---

# local-llm-call

## Overview

Sends a prompt to the llama-server OpenAI-compatible endpoint at `localhost:8080` via `scripts/local-llm.sh`. All health checking, JSON escaping, and response parsing is handled by the script — this skill just invokes it.

## When to Use This Skill

**Use for `[LOCAL]` tier tasks:**
- Paper abstract / section summarization
- Code explanation within a single file
- Docstrings and code comments
- Config validation (JSON, YAML)
- Commit message generation
- Experiment log summarization
- Error pattern detection
- Data format conversion (JSON ↔ YAML, CSV → JSON)
- BibTeX / citation formatting
- Short email or note drafts
- TODO / action item extraction

**Do not use for:**
- Tasks requiring >4K tokens of context
- Cross-file or cross-repo reasoning
- Novel hypothesis generation or deep synthesis

## Usage

```bash
# Basic call
bash ~/.claude/skills/local-llm-call/scripts/local-llm.sh "<prompt>"

# With explicit max_tokens (default: 512)
bash ~/.claude/skills/local-llm-call/scripts/local-llm.sh "<prompt>" 1024
```

The script will:
1. Check `/health` — exit with a clear error if the server is down
2. Build the JSON payload safely via `python3 json.dumps`
3. POST to `localhost:8080/v1/chat/completions` with `temperature: 0.2`
4. Print `choices[0].message.content` to stdout

## Rules

- Never read more than 100 lines of any log or input — chunk and summarize iteratively.
- Stay under 4K tokens of combined prompt input per call.
- Do not fall back to Claude if the server is down — surface the error.
