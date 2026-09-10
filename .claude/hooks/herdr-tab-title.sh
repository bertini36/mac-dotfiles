#!/usr/bin/env bash
# Mirror the Claude Code session topic (the terminal title) into the Herdr tab label.
set -uo pipefail

[[ "${HERDR_ENV:-}" == "1" ]] || exit 0
[[ -n "${HERDR_TAB_ID:-}" && -n "${HERDR_PANE_ID:-}" ]] || exit 0
command -v herdr >/dev/null 2>&1 || exit 0
command -v jq >/dev/null 2>&1 || exit 0

title=$(herdr pane get "$HERDR_PANE_ID" 2>/dev/null | jq -r '.result.pane.terminal_title_stripped // empty')
[[ -n "$title" ]] || exit 0

# Until Claude Code generates a topic the title is a path or a bare command name.
[[ "$title" == /* || "$title" == "~"* || "$title" != *" "* ]] && exit 0

max_length=44
(( ${#title} > max_length )) && title="${title:0:max_length-1}…"

current=$(herdr tab get "$HERDR_TAB_ID" 2>/dev/null | jq -r '.result.tab.label // empty')
[[ "$title" == "$current" ]] && exit 0

herdr tab rename "$HERDR_TAB_ID" "$title" >/dev/null 2>&1 || true
