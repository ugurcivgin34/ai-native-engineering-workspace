#!/bin/sh
# PreToolUse hook (Edit|Write|MultiEdit|NotebookEdit): files under specs/done/ are immutable
# (AGENTS.md invariant rule 7). The Bash route is guarded by guard-bash.sh.
. "$(dirname "$0")/lib.sh"
hook_read
path=$(hook_field file_path); [ -n "$path" ] || path=$(hook_field notebook_path)
[ -n "$path" ] || exit 0
rel=$(hook_rel "$path")
case "$rel" in
  specs/done/*|*/specs/done/*) ;;
  *"#unresolved") case "$path" in *done*) ;; *) exit 0 ;; esac ;;
  *) exit 0 ;;
esac
hook_block "specs/done/ is immutable (shipped specs are the historical record — AGENTS.md rule 7). Behavior changing? Open a NEW spec in specs/active/ referencing the old one (/change)."
exit 0
