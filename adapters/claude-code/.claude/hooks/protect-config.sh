#!/bin/sh
# PreToolUse hook (Edit|Write|MultiEdit|NotebookEdit): lint, analyzer, formatter, type-check
# settings and scripts/check.conf are protected — loosening them makes red green without fixing
# anything (AGENTS.md rule 5). Allowed while bootstrap has not run, and for a file the approved
# plan of an active spec lists (the human approved that change).
. "$(dirname "$0")/lib.sh"
hook_read
path=$(hook_field file_path); [ -n "$path" ] || exit 0
rel=$(hook_rel "$path")
hook_is_config "$rel" || exit 0
hook_configured || exit 0
hook_plan_allows "$rel" && exit 0
hook_block "$rel is a protected quality setting (AGENTS.md rule 5). Fix the code, not the rule. If the setting itself must change, propose it: it goes into the plan's 'Files to change' with a reason, and the human approves the plan."
