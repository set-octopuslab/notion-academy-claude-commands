#!/bin/bash
# Sync notion-academy slash commands to ~/.claude/commands/
# Run from inside the cloned repo dir, or set REPO_DIR env var.

LOCAL="$HOME/.claude/commands"
REPO_DIR="${REPO_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"

mkdir -p "$LOCAL"
shopt -s nullglob

for f in "$REPO_DIR"/*.md; do
  base="$(basename "$f")"
  case "$base" in
    README.md|SETUP_FLOW.md|_DEPRECATED.md) continue ;;
  esac
  cp -u "$f" "$LOCAL/" 2>/dev/null
done

echo "[sync-commands] Copied .md files from $REPO_DIR to $LOCAL"
