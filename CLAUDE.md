# Global Development Rules

## Testing
Claude's default is implementation-first. Override it:
- RED: Write a failing test. Do NOT write implementation. Run it. Confirm failure.
- GREEN: Minimum code to pass. No extras, no cleverness.
- REFACTOR: Clean up. Tests must stay green.

Anti-patterns to avoid:
- Never use .skip(), .only(), or comment out tests — debug and fix.
- Assert exact values, error types, state changes. No toBeTruthy().
- Mock ONLY external services. Real objects for internal code.
- Test failure modes: invalid inputs, empty collections, boundaries.

Superpowers plugin handles TDD enforcement via hooks. wshobson tdd-workflows plugin provides orchestration.

## Planning
- Multi-file tasks: plan to `plan.md`, wait for confirmation. Skip if told "just do it".
- Update `plan.md` as work progresses. Extended thinking for complex tasks.

## Git Discipline
- Commit after each meaningful, passing change. Explain WHY not WHAT.
- Never commit with failing tests.

## Context Management
- Subagents for research/exploration — keep main context clean.
- /clear between unrelated tasks.
- Before compact/clear: save state to plan.md. After: re-read plan.md.
- Proactively suggest /compact before quality degrades.
- When compacting, preserve: modified file paths, test commands, plan state, failures, decisions.

## Subagent Model Tiering
- **Opus**: architecture decisions, security audits, code review
- **Sonnet**: implementation, testing, debugging, general tasks
- **Haiku**: documentation, fast lookups, simple operations

## User Preferences
- SSH and do things directly. Read-only auto-run, ask before write/destructive.
- **Cost conscious:** <$2/day. Use model tiering above for subagents.
- **Background everything** — parallel subagents, max delegation.
- **Don't hold back** — aggressive, proactive.
- **Always run full test suite** before declaring done.
- **After completing work:** update MEMORY.md, comment on affected GitHub issues, update relevant docs. Part of "done".
- **NO workarounds without user approval** — diagnose properly.
- **NEVER print secrets** — tokens, API keys, passwords stay in keychain. Never echo or display.

## Local Dev Environment
- **Hooks need PATH prefix:** `export PATH="$HOME/.local/share/fnm/node-versions/v22.22.0/installation/bin:$PATH"`
- **PreToolUse hook:** gates git commits — blocks when tests fail.
- **Stop hook:** runs verification agent. Must output "condition IS MET" for skip cases.
