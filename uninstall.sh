#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
DIM="\033[2m"
RESET="\033[0m"

CLAUDE_HOME="$HOME/.claude"

COUNT=0

remove_if_exists() {
  local path="$1" label="$2"
  if [ -e "$path" ]; then
    rm -rf "$path"
    echo -e "  🗑  ${RED}$label${RESET}"
    COUNT=$((COUNT + 1))
  fi
}

# ── Uninstall core ──────────────────────────────────────────────────
uninstall_core() {
  local core="$SCRIPT_DIR/core"
  echo -e "${BOLD}Uninstalling core...${RESET}"
  echo ""

  # Claude Code hooks
  if [ -d "$core/claude-code/hooks" ]; then
    for f in "$core/claude-code/hooks"/*; do
      [ -f "$f" ] || continue
      remove_if_exists "$CLAUDE_HOME/hooks/$(basename "$f")" "~/.claude/hooks/$(basename "$f")"
    done
  fi

  remove_if_exists "$CLAUDE_HOME/settings.json" "~/.claude/settings.json"
  remove_if_exists "$CLAUDE_HOME/CLAUDE.md" "~/.claude/CLAUDE.md"
  remove_if_exists "$CLAUDE_HOME/claude-code-guide-path" "~/.claude/claude-code-guide-path"

  # Claude Code core skills
  if [ -d "$core/claude-code/skills" ]; then
    for skill_dir in "$core/claude-code/skills"/*/; do
      [ -d "$skill_dir" ] || continue
      local skill_name=$(basename "$skill_dir")
      remove_if_exists "$CLAUDE_HOME/skills/$skill_name" "~/.claude/skills/$skill_name/"
    done
  fi

  echo ""
}

# ── Uninstall a pack ───────────────────────────────────────────────
uninstall_pack() {
  local pack_name="$1"
  local pack_dir="$SCRIPT_DIR/packs/$pack_name"

  if [ ! -d "$pack_dir" ]; then
    echo -e "  ${RED}Pack '$pack_name' not found${RESET}"
    return 1
  fi

  echo -e "${BOLD}Uninstalling pack: ${CYAN}$pack_name${RESET}"
  echo ""

  # Claude Code skills (match pack:skill naming from install)
  if [ -d "$pack_dir/claude-code/skills" ]; then
    for skill_dir in "$pack_dir/claude-code/skills"/*/; do
      [ -d "$skill_dir" ] || continue
      local skill_name=$(basename "$skill_dir")
      remove_if_exists "$CLAUDE_HOME/skills/${pack_name}:${skill_name}" "~/.claude/skills/${pack_name}:${skill_name}/"
    done
  fi

  echo ""
}

# ── Usage ───────────────────────────────────────────────────────────
usage() {
  echo -e "${BOLD}dotclaude uninstall${RESET}"
  echo ""
  echo "Usage:"
  echo "  ./uninstall.sh --core                   Uninstall Layer 0"
  echo "  ./uninstall.sh --pack=NAME              Uninstall a specific pack"
  echo "  ./uninstall.sh --all                    Uninstall core + all packs"
  echo ""
}

if [ $# -eq 0 ]; then
  usage
  exit 0
fi

DO_CORE=false
DO_ALL=false
PACKS=()

while [ $# -gt 0 ]; do
  case "$1" in
    --core)     DO_CORE=true ;;
    --all)      DO_ALL=true ;;
    --pack=*)   PACKS+=("${1#--pack=}") ;;
    -h|--help)  usage; exit 0 ;;
    *)          echo -e "${RED}Unknown option: $1${RESET}"; usage; exit 1 ;;
  esac
  shift
done

echo ""

if $DO_ALL; then
  uninstall_core
  for pack_dir in "$SCRIPT_DIR/packs"/*/; do
    [ -d "$pack_dir" ] || continue
    uninstall_pack "$(basename "$pack_dir")"
  done
elif $DO_CORE; then
  uninstall_core
fi

for pack in "${PACKS[@]}"; do
  uninstall_pack "$pack"
done

if [ $COUNT -eq 0 ]; then
  echo -e "${YELLOW}Nothing to uninstall.${RESET}"
else
  echo -e "${BOLD}${CYAN}Done!${RESET} $COUNT item(s) removed."
fi
echo ""
