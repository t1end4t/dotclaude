#!/usr/bin/env bash
# SessionStart hook — inject workspace context (domain + project status).
# Reads cwd from stdin JSON; matches against ~/codebases/<domain>/<project>/
# and looks up the project row in ~/codebases/second-brain/1-Projects/registry.md.
# Stays silent outside ~/codebases/. Never mutates the registry.

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null)
[ -z "$CWD" ] && CWD="$PWD"

BASE="$HOME/codebases"
case "$CWD" in
  "$BASE"/*) ;;
  *) exit 0 ;;
esac

REL="${CWD#$BASE/}"
DOMAIN_DIR="${REL%%/*}"
REST="${REL#*/}"
if [ "$REST" = "$REL" ]; then
  PROJECT=""
else
  PROJECT="${REST%%/*}"
fi

case "$DOMAIN_DIR" in
  company-stack)  DOMAIN="startup" ;;
  research-lab)   DOMAIN="research" ;;
  dev-sandbox)    DOMAIN="dev" ;;
  side-projects)  DOMAIN="side" ;;
  second-brain)   DOMAIN="knowledge" ;;
  *)              DOMAIN="unknown" ;;
esac

REGISTRY="$BASE/second-brain/1-Projects/registry.md"
STATUS=""
NEXT=""
LAST=""

if [ -n "$PROJECT" ] && [ -f "$REGISTRY" ]; then
  # Find the row where column 1 (name, with [[ ]] stripped) equals $PROJECT.
  ROW=$(awk -F'|' -v p="$PROJECT" '
    /^\|/ && !/^\|[[:space:]]*-/ && !/^\|[[:space:]]*name[[:space:]]*\|/ {
      name=$2
      gsub(/\[\[|\]\]/, "", name)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", name)
      if (name == p) { print; exit }
    }
  ' "$REGISTRY" 2>/dev/null)

  if [ -n "$ROW" ]; then
    STATUS=$(echo "$ROW" | awk -F'|' '{ gsub(/^[[:space:]]+|[[:space:]]+$/, "", $5); print $5 }')
    NEXT=$(echo   "$ROW" | awk -F'|' '{ gsub(/^[[:space:]]+|[[:space:]]+$/, "", $6); print $6 }')
    LAST=$(echo   "$ROW" | awk -F'|' '{ gsub(/^[[:space:]]+|[[:space:]]+$/, "", $7); print $7 }')
  fi
fi

DAYS=""
STALE_NOTE=""
if [ -n "$LAST" ]; then
  LAST_EPOCH=$(date -d "$LAST" +%s 2>/dev/null || echo "")
  if [ -n "$LAST_EPOCH" ]; then
    NOW_EPOCH=$(date +%s)
    DAYS=$(( (NOW_EPOCH - LAST_EPOCH) / 86400 ))
    [ "$DAYS" -gt 14 ] && STALE_NOTE=$'\n'"Note: stalled >14 days — surface before starting new work."
  fi
fi

# Build the context block
CTX="# Workspace"$'\n'"Domain: $DOMAIN"
[ -n "$PROJECT" ] && CTX="$CTX"$'\n'"Project: $PROJECT"

if [ -n "$STATUS$NEXT$LAST" ]; then
  [ -n "$STATUS" ] && CTX="$CTX"$'\n'"Status: $STATUS"
  [ -n "$NEXT" ]   && CTX="$CTX"$'\n'"Next: $NEXT"
  if [ -n "$LAST" ]; then
    if [ -n "$DAYS" ]; then
      CTX="$CTX"$'\n'"Last touched: $LAST ($DAYS days ago)"
    else
      CTX="$CTX"$'\n'"Last touched: $LAST"
    fi
  fi
  CTX="$CTX"$'\n'"Posture: see CLAUDE.md 'Workspace awareness' section."
  [ -n "$STALE_NOTE" ] && CTX="$CTX$STALE_NOTE"
elif [ -n "$PROJECT" ]; then
  CTX="$CTX"$'\n'"Not in registry. Run /workspace-register to add this project."
  CTX="$CTX"$'\n'"Posture: see CLAUDE.md 'Workspace awareness' section."
else
  CTX="$CTX"$'\n'"Posture: see CLAUDE.md 'Workspace awareness' section."
fi

jq -n --arg ctx "$CTX" '{
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: $ctx
  }
}'
