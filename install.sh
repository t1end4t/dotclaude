#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Colors ──────────────────────────────────────────────────────────
BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
DIM="\033[2m"
RESET="\033[0m"

# ── Target directories ─────────────────────────────────────────────
CLAUDE_HOME="$HOME/.claude"

COUNT=0

# ── Helpers ─────────────────────────────────────────────────────────
copy_dir() {
  local src="$1" dst="$2" label="$3"
  [ -d "$src" ] || return 0
  local has_files=false
  for f in "$src"/*; do [ -e "$f" ] && has_files=true && break; done
  $has_files || return 0

  mkdir -p "$dst"
  cp -r "$src"/* "$dst"/
  echo -e "  ✅  ${GREEN}${label}${RESET}"
  COUNT=$((COUNT + 1))
}

copy_file() {
  local src="$1" dst="$2" label="$3"
  [ -f "$src" ] || return 0
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  echo -e "  ✅  ${GREEN}${label}${RESET}"
  COUNT=$((COUNT + 1))
}

merge_json() {
  local src="$1" dst="$2" label="$3"
  [ -f "$src" ] || return 0
  mkdir -p "$(dirname "$dst")"
  if [ -f "$dst" ] && command -v jq &>/dev/null; then
    merged=$(jq -s '.[0] * .[1]' "$dst" "$src")
    echo "$merged" > "$dst"
    echo -e "  ✅  ${GREEN}${label}${RESET} ${DIM}(merged)${RESET}"
  else
    cp "$src" "$dst"
    echo -e "  ✅  ${GREEN}${label}${RESET}"
  fi
  COUNT=$((COUNT + 1))
}

# ── Install core ────────────────────────────────────────────────────
install_core() {
  local core="$SCRIPT_DIR/core"
  [ -d "$core" ] || { echo -e "  ${RED}core/ not found${RESET}"; return 1; }

  echo -e "${BOLD}Installing core (Layer 0)...${RESET}"
  echo ""

  # Claude Code
  if [ -d "$core/claude-code" ]; then
    echo -e "  ${CYAN}claude-code${RESET}"
    copy_dir  "$core/claude-code/hooks"     "$CLAUDE_HOME/hooks"     "~/.claude/hooks/"
    merge_json "$core/claude-code/settings.json" "$CLAUDE_HOME/settings.json" "~/.claude/settings.json"
    copy_file "$core/claude-code/CLAUDE.md" "$CLAUDE_HOME/CLAUDE.md" "~/.claude/CLAUDE.md"
    # Make hooks executable
    chmod +x "$CLAUDE_HOME/hooks/"*.sh 2>/dev/null || true
  fi

  # Environment
  if [ -d "$core/environment.d" ]; then
    local env_dst="$HOME/.config/environment.d"
    mkdir -p "$env_dst"
    for f in "$core/environment.d"/*; do
      [ -f "$f" ] || continue
      local fname=$(basename "$f")
      if [ -f "$env_dst/$fname" ]; then
        echo -e "  ⚠️   ${YELLOW}~/.config/environment.d/$fname${RESET} ${DIM}(already exists, skipped)${RESET}"
      else
        cp "$f" "$env_dst/$fname"
        echo -e "  ✅  ${GREEN}~/.config/environment.d/$fname${RESET}"
        COUNT=$((COUNT + 1))
      fi
    done
  fi

  # Guide path
  if [ -d "$SCRIPT_DIR/guide" ]; then
    echo "$SCRIPT_DIR/guide" > "$CLAUDE_HOME/claude-code-guide-path"
    echo -e "  ✅  ${GREEN}~/.claude/claude-code-guide-path${RESET}"
    COUNT=$((COUNT + 1))
  fi

  echo ""
}

# ── Install a pack ──────────────────────────────────────────────────
install_pack() {
  local pack_name="$1"
  local pack_dir="$SCRIPT_DIR/packs/$pack_name"

  if [ ! -d "$pack_dir" ]; then
    echo -e "  ${RED}Pack '$pack_name' not found${RESET}"
    return 1
  fi

  # Read description from manifest
  local desc=""
  if [ -f "$pack_dir/manifest.toml" ]; then
    desc=$(grep '^description' "$pack_dir/manifest.toml" | head -1 | sed 's/.*= *"\(.*\)"/\1/')
  fi

  echo -e "${BOLD}Installing pack: ${CYAN}$pack_name${RESET}"
  [ -n "$desc" ] && echo -e "  ${DIM}$desc${RESET}"
  echo ""

  # Claude Code skills
  if [ -d "$pack_dir/claude-code/skills" ]; then
    echo -e "  ${CYAN}claude-code${RESET}"
    for skill_dir in "$pack_dir/claude-code/skills"/*/; do
      [ -d "$skill_dir" ] || continue
      local skill_name=$(basename "$skill_dir")
      [ -f "$skill_dir/SKILL.md" ] || continue
      rm -rf "$CLAUDE_HOME/skills/$skill_name"
      cp -r "$skill_dir" "$CLAUDE_HOME/skills/$skill_name"
      echo -e "  ✅  ${GREEN}~/.claude/skills/$skill_name/${RESET}"
      COUNT=$((COUNT + 1))
    done
  fi

  echo ""
}

# ── List available packs ───────────────────────────────────────────
list_packs() {
  echo -e "${BOLD}Available packs:${RESET}"
  echo ""
  for pack_dir in "$SCRIPT_DIR/packs"/*/; do
    [ -d "$pack_dir" ] || continue
    local name=$(basename "$pack_dir")
    local desc=""
    if [ -f "$pack_dir/manifest.toml" ]; then
      desc=$(grep '^description' "$pack_dir/manifest.toml" | head -1 | sed 's/.*= *"\(.*\)"/\1/')
    fi
    local file_count=$(find "$pack_dir" -type f ! -name "manifest.toml" | wc -l)
    echo -e "  ${CYAN}$name${RESET} ${DIM}($file_count files)${RESET}"
    [ -n "$desc" ] && echo -e "    $desc"
  done
  echo ""
}

# ── Usage ───────────────────────────────────────────────────────────
usage() {
  echo -e "${BOLD}dotclaude${RESET} — installable packs for Claude Code"
  echo ""
  echo "Usage:"
  echo "  ./install.sh --core                   Install Layer 0 (self-modification sandbox)"
  echo "  ./install.sh --pack=NAME              Install a specific pack"
  echo "  ./install.sh --pack=NAME --pack=NAME  Install multiple packs"
  echo "  ./install.sh --all                    Install core + all packs"
  echo "  ./install.sh --list                   List available packs"
  echo ""
  echo "Target: claude-code (~/.claude)"
  echo ""
}

# ── Parse args ──────────────────────────────────────────────────────
if [ $# -eq 0 ]; then
  usage
  exit 0
fi

DO_CORE=false
DO_ALL=false
PACKS=()

while [ $# -gt 0 ]; do
  case "$1" in
    --core)
      DO_CORE=true
      ;;
    --all)
      DO_ALL=true
      ;;
    --list)
      list_packs
      exit 0
      ;;
    --pack=*)
      PACKS+=("${1#--pack=}")
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${RESET}"
      usage
      exit 1
      ;;
  esac
  shift
done

# ── Execute ─────────────────────────────────────────────────────────
echo ""

if $DO_ALL; then
  install_core
  for pack_dir in "$SCRIPT_DIR/packs"/*/; do
    [ -d "$pack_dir" ] || continue
    install_pack "$(basename "$pack_dir")"
  done
elif $DO_CORE; then
  install_core
fi

for pack in "${PACKS[@]}"; do
  install_pack "$pack"
done

# ── Summary ─────────────────────────────────────────────────────────
if [ $COUNT -eq 0 ]; then
  echo -e "${YELLOW}Nothing new installed.${RESET}"
else
  echo -e "${BOLD}${CYAN}Done!${RESET} $COUNT item(s) installed."
fi
echo ""
