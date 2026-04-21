#!/usr/bin/env bash
set -e

echo "Setting up RTK (Rust Token Killer)..."

if ! command -v rtk &>/dev/null; then
  echo "  Installing RTK binary..."
  curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
else
  echo "  RTK already installed: $(rtk --version 2>/dev/null || echo 'unknown')"
fi

rtk init -g
echo "  RTK hook configured for Claude Code"
