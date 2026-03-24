# Claude Code Customizations

My personal Claude Code (`~/.claude/`) configuration. Public so I don't lose it and others can steal what's useful.

## What's here

### `statusline-command.sh`
Custom status bar with three labeled usage bars and reset countdowns:

```
[Claude Opus 4.6 (1M context)] my-project | main
ctx ████░░░░░░ 42% | 5h ███░░ 28% 1h42m | 7d █░░░░ 8% 4d | 3m 12s
```

- **ctx** — context window usage (10-char bar)
- **5h** — 5-hour rolling rate limit (5-char bar + reset countdown)
- **7d** — 7-day rolling rate limit (5-char bar + reset countdown)
- All bars color-coded: green < 70%, yellow 70-89%, red >= 90%
- Rate limit bars only appear on subscription plans (Pro/Max) after first API call
- Git branch cached for 5s to avoid lag

### `settings.json`
Global Claude Code settings:
- Status line command config
- Enabled plugins (superpowers, tdd-workflows, unit-testing)
- Plugin marketplace sources

### `CLAUDE.md`
Global instructions loaded into every Claude Code session:
- TDD-first development (red/green/refactor)
- Planning workflow
- Git discipline
- Subagent model tiering (Opus/Sonnet/Haiku)
- Context management strategies

## Setup

Copy files to your `~/.claude/` directory:

```bash
cp statusline-command.sh ~/.claude/statusline-command.sh
chmod +x ~/.claude/statusline-command.sh
cp settings.json ~/.claude/settings.json
cp CLAUDE.md ~/.claude/CLAUDE.md
```

Or cherry-pick what you want. The statusline script works standalone — just needs `jq` installed.
