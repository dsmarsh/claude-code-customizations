# Claude Code Customizations

My personal Claude Code (`~/.claude/`) configuration. Public so I don't lose it and others can steal what's useful.

## Quick Setup

```bash
git clone https://github.com/dsmarsh/claude-code-customizations.git
cd claude-code-customizations
./setup.sh
```

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
- Enabled plugins and marketplace sources
- Effort level, voice mode

### `CLAUDE.md`
Global instructions loaded into every Claude Code session:
- TDD-first development (red/green/refactor)
- Planning workflow
- Git discipline
- Subagent model tiering (Opus/Sonnet/Haiku)
- Context management strategies

### `setup.sh`
One-command installer that copies everything to `~/.claude/` and prints plugin install instructions.

## Plugins

These are installed via Claude Code's plugin manager (referenced in `settings.json`):

| Plugin | Source | What it does |
|--------|--------|-------------|
| **superpowers** v5.0.5 | [obra/superpowers-marketplace](https://github.com/obra/superpowers-marketplace) | TDD enforcement via hooks, skill-based workflows (brainstorming, debugging, planning, code review), git worktree support |
| **tdd-workflows** v1.3.0 | [wshobson/agents](https://github.com/wshobson/agents) | TDD orchestrator — red/green/refactor cycle management, code review agent |
| **unit-testing** v1.2.0 | [wshobson/agents](https://github.com/wshobson/agents) | Test automator agent, debugger agent |

Install manually if needed:
```
/install-plugin superpowers from obra/superpowers-marketplace
/install-plugin tdd-workflows from wshobson/agents
/install-plugin unit-testing from wshobson/agents
```

## Cherry-picking

Everything works independently. Just want the statusline?

```bash
cp statusline-command.sh ~/.claude/statusline-command.sh
chmod +x ~/.claude/statusline-command.sh
```

Then add to your `~/.claude/settings.json`:
```json
{
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/statusline-command.sh"
  }
}
```

Requires `jq` (`brew install jq`).
