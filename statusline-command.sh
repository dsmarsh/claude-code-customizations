#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')

CYAN='\033[36m'; GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; DIM='\033[2m'; RESET='\033[0m'

# Color picker: green <70%, yellow 70-89%, red >=90%
pick_color() {
    local pct=$1
    if [ "$pct" -ge 90 ]; then echo "$RED"
    elif [ "$pct" -ge 70 ]; then echo "$YELLOW"
    else echo "$GREEN"; fi
}

# Build a bar of given width
make_bar() {
    local pct=$1 width=$2
    local filled=$((pct * width / 100))
    # At least 1 filled block when pct > 0
    [ "$pct" -gt 0 ] && [ "$filled" -eq 0 ] && filled=1
    [ "$filled" -gt "$width" ] && filled=$width
    local empty=$((width - filled))
    local bar=""
    [ "$filled" -gt 0 ] && bar=$(printf "%${filled}s" | tr ' ' '█')
    [ "$empty" -gt 0 ] && bar="${bar}$(printf "%${empty}s" | tr ' ' '░')"
    echo "$bar"
}

# Context bar (10 chars)
CTX_COLOR=$(pick_color "$PCT")
CTX_BAR=$(make_bar "$PCT" 10)

MINS=$((DURATION_MS / 60000)); SECS=$(((DURATION_MS % 60000) / 1000))

# Rate limits (present on subscription plans after first API call)
NOW=$(date +%s)
RATE_STR=""

FIVE_H_PCT=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
if [ -n "$FIVE_H_PCT" ]; then
    FIVE_H_INT=$(printf '%.0f' "$FIVE_H_PCT")
    FIVE_H_COLOR=$(pick_color "$FIVE_H_INT")
    FIVE_H_BAR=$(make_bar "$FIVE_H_INT" 5)
    FIVE_H_RESET=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
    FIVE_H_COUNTDOWN=""
    if [ -n "$FIVE_H_RESET" ]; then
        REMAINING=$((FIVE_H_RESET - NOW))
        if [ "$REMAINING" -gt 0 ]; then
            RH=$((REMAINING / 3600)); RM=$(((REMAINING % 3600) / 60))
            [ "$RH" -gt 0 ] && FIVE_H_COUNTDOWN=" ${DIM}${RH}h${RM}m${RESET}" || FIVE_H_COUNTDOWN=" ${DIM}${RM}m${RESET}"
        fi
    fi
    RATE_STR=" ${DIM}|${RESET} ${DIM}5h${RESET} ${FIVE_H_COLOR}${FIVE_H_BAR}${RESET} ${FIVE_H_INT}%${FIVE_H_COUNTDOWN}"
fi

SEVEN_D_PCT=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
if [ -n "$SEVEN_D_PCT" ]; then
    SEVEN_D_INT=$(printf '%.0f' "$SEVEN_D_PCT")
    SEVEN_D_COLOR=$(pick_color "$SEVEN_D_INT")
    SEVEN_D_BAR=$(make_bar "$SEVEN_D_INT" 5)
    SEVEN_D_RESET=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
    SEVEN_D_COUNTDOWN=""
    if [ -n "$SEVEN_D_RESET" ]; then
        REMAINING=$((SEVEN_D_RESET - NOW))
        if [ "$REMAINING" -gt 0 ]; then
            RD=$((REMAINING / 86400)); RH=$(((REMAINING % 86400) / 3600))
            if [ "$RD" -gt 0 ] && [ "$RH" -gt 0 ]; then SEVEN_D_COUNTDOWN=" ${DIM}${RD}d${RH}h${RESET}"
            elif [ "$RD" -gt 0 ]; then SEVEN_D_COUNTDOWN=" ${DIM}${RD}d${RESET}"
            else SEVEN_D_COUNTDOWN=" ${DIM}${RH}h${RESET}"; fi
        fi
    fi
    RATE_STR="${RATE_STR} ${DIM}|${RESET} ${DIM}7d${RESET} ${SEVEN_D_COLOR}${SEVEN_D_BAR}${RESET} ${SEVEN_D_INT}%${SEVEN_D_COUNTDOWN}"
fi

# Git branch with 5s cache to avoid lag
# NOTE: stat -f %m is macOS-specific. On Linux, use stat -c %Y instead.
CACHE_FILE="/tmp/statusline-git-cache"
CACHE_MAX_AGE=5
cache_stale() {
    [ ! -f "$CACHE_FILE" ] || \
    [ $(($(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0))) -gt $CACHE_MAX_AGE ]
}
if cache_stale; then
    if git rev-parse --git-dir > /dev/null 2>&1; then
        git branch --show-current 2>/dev/null > "$CACHE_FILE"
    else
        echo "" > "$CACHE_FILE"
    fi
fi
BRANCH=$(cat "$CACHE_FILE" 2>/dev/null)

BRANCH_STR=""
[ -n "$BRANCH" ] && BRANCH_STR=" ${DIM}|${RESET} ${GREEN}${BRANCH}${RESET}"

# Line 1: model, folder, git branch
echo -e "${CYAN}[${MODEL}]${RESET} ${DIR##*/}${BRANCH_STR}"
# Line 2: ctx bar, rate limits, duration
echo -e "${DIM}ctx${RESET} ${CTX_COLOR}${CTX_BAR}${RESET} ${PCT}%${RATE_STR} ${DIM}|${RESET} ${DIM}${MINS}m ${SECS}s${RESET}"
