#!/bin/bash
# Rebuild Claude Code setup from this repo
# Usage: ./setup.sh

set -euo pipefail

CLAUDE_DIR="$HOME/.claude"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Setting up Claude Code customizations..."

# Core config files
cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
cp "$SCRIPT_DIR/settings.json" "$CLAUDE_DIR/settings.json"
cp "$SCRIPT_DIR/statusline-command.sh" "$CLAUDE_DIR/statusline-command.sh"
chmod +x "$CLAUDE_DIR/statusline-command.sh"

echo "Copied: CLAUDE.md, settings.json, statusline-command.sh"

# Plugins need to be installed via Claude Code's plugin manager.
# The settings.json already has enabledPlugins and extraKnownMarketplaces,
# so Claude Code should prompt to install them on next launch.
# If not, install manually:
echo ""
echo "Plugins to install (run inside Claude Code):"
echo "  /install-plugin superpowers from obra/superpowers-marketplace"
echo "  /install-plugin tdd-workflows from wshobson/agents"
echo "  /install-plugin unit-testing from wshobson/agents"
echo ""
echo "Done! Restart Claude Code to pick up changes."
