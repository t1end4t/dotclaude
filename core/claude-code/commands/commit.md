---
allowed-tools: Bash(git status:*), Bash(git diff HEAD:*), Bash(git branch --show-current:*), Bash(git log --oneline -10:*), Bash(git add:*), Bash(git commit:*)
description: Create a git commit using local LLM for message generation
---

## Context

Gather the git context using the following commands:

!`git status`
!`git diff HEAD`
!`git branch --show-current`
!`git log --oneline -10`

## Your task

1. Run the git commands above to gather context about current changes
2. Send a prompt to the local LLM at localhost:8080 to generate a commit message based on the changes
3. Use the generated commit message to stage relevant files and create a commit

### Local LLM Invocation

Capture the diff and pass it explicitly to the local LLM:

```bash
# Capture the diff
DIFF=$(git diff HEAD)

# If diff is very long, use stat instead
if [ ${#DIFF} -gt 3000 ]; then
  DIFF=$(git diff HEAD --stat)
fi

# Call local LLM with the diff
bash skills/workflow/local-llm-call/scripts/local-llm.sh "Generate a concise git commit message for these changes. Format: <type>: <description>. Types: feat, fix, docs, style, refactor, test, chore. Keep it under 72 characters. Changes: $DIFF"
```

### Commit creation

After receiving the commit message from local LLM:
1. Stage relevant files (exclude .env, credentials.json, secrets)
2. Create the commit with the generated message
3. Show the commit result

Do not use any other tools or do anything else. Do not send any other text or messages besides the necessary git tool calls and the local LLM call.
