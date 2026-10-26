#!/bin/sh
# PreToolUse hook (Bash): the shell routes around the editor hooks and the permission denies.
# Blocks: writes under specs/done/ (rule 7) except the ship move from specs/active/; recursive
# forced deletes in any flag order; force pushes in any form; hard resets; git clean -f;
# shell writes to protected quality settings (rule 5, same exceptions as protect-config.sh).
. "$(dirname "$0")/lib.sh"
hook_read
cmd=$(hook_field command); [ -n "$cmd" ] || exit 0

# one command per line: split on ; & | and newlines (quotes are not parsed — good enough to catch
# the plain forms; CI and review stay the backstop for the rest)
# harmless redirections first, so "2>&1" or ">/dev/null" never reads as a write
segs=$(printf '%s\n' "$cmd" | sed 's/[0-9]*>&[0-9-]//g; s/[0-9&]*>>*[[:space:]]*\/dev\/null//g' | tr ';&|' '\n\n\n' \
  | sed 's/^[[:space:]]*//; s/^sudo[[:space:]]\{1,\}//; s/^command[[:space:]]\{1,\}//; s/^exec[[:space:]]\{1,\}//; s/^env[[:space:]]\{1,\}//')
# git's own options before the subcommand, -C <dir> and -c <k=v> included
gitpre='git([[:space:]]+(-[Cc][[:space:]]+[^[:space:]]+|-[^[:space:]]+))*'
writes='(>|(^|[[:space:]])(sed|perl)([[:space:]].*)?[[:space:]]-[a-zA-Z]*i|--in-place|(^|[[:space:]])(tee|mv|rm|cp|truncate|touch|install|dd|ln)[[:space:]]|git[[:space:]]+(mv|rm|checkout|restore)[[:space:]])'

oldifs=$IFS; IFS='
'
for s in $segs; do
  # --- shipped specs ---
  case "$s" in
    *specs/done*)
      if printf '%s' "$s" | grep -qE '^git[[:space:]]+mv[[:space:]]+([^[:space:]]*/)?specs/active/[^[:space:]]+[[:space:]]+([^[:space:]]*/)?specs/done/?[^[:space:]]*[[:space:]]*$'; then
        :   # the ship move: a spec enters specs/done/, nothing in it is edited
      elif printf '%s' "$s" | grep -qE "$writes"; then
        hook_block "this command writes under specs/done/, which is immutable (AGENTS.md rule 7). The only write allowed there is the ship move: git mv specs/active/<file> specs/done/."
      fi ;;
  esac
  # --- recursive forced delete, any flag order ---
  if printf '%s' "$s" | grep -qE '^rm([[:space:]]|$)'; then
    words=$(printf '%s' "$s" | tr ' \t' '\n\n')
    short=$(printf '%s\n' "$words" | grep -E '^-[^-]' | tr -d '\n-')
    long=$(printf '%s\n' "$words" | grep -E '^--' | tr '\n' ' ')
    rec=0; frc=0
    case "$short" in *r*|*R*) rec=1 ;; esac
    case "$long" in *--recursive*) rec=1 ;; esac
    case "$short" in *f*) frc=1 ;; esac
    case "$long" in *--force*) frc=1 ;; esac
    [ "$rec" -eq 1 ] && [ "$frc" -eq 1 ] && hook_block "recursive forced delete (rm -rf in any flag order). Delete specific files, or ask the human."
  fi
  # --- history rewriting and forced pushes ---
  if printf '%s' "$s" | grep -qE "^$gitpre"'[[:space:]]+push([[:space:]]|$)'; then
    printf '%s' "$s" | grep -qE '[[:space:]](-f|--force|--force-with-lease(=[^[:space:]]*)?|--force-if-includes|--mirror|--delete|-d)([[:space:]]|$)|[[:space:]]\+[^[:space:]]+' \
      && hook_block "force push / remote deletion is forbidden (docs/git.md). Undo with git revert (R-11)."
  fi
  printf '%s' "$s" | grep -qE "^$gitpre"'[[:space:]]+reset([[:space:]].*)?[[:space:]]--hard' \
    && hook_block "git reset --hard is forbidden (docs/git.md). Undo with git revert (R-11)."
  printf '%s' "$s" | grep -qE "^$gitpre"'[[:space:]]+clean([[:space:]].*)?[[:space:]]-[a-zA-Z]*f' \
    && hook_block "git clean -f deletes untracked work for good. Remove specific files, or ask the human."
  # --- shell writes to protected quality settings ---
  if hook_configured && printf '%s' "$s" | grep -qE "$writes"; then
    for t in $(printf '%s' "$s" | tr ' \t>' '\n\n\n' | grep -E '[A-Za-z]'); do
      t=${t#\"}; t=${t%\"}; t=${t#\'}; t=${t%\'}
      rel=$(hook_rel "$t")
      if hook_is_config "$rel" && ! hook_plan_allows "$rel"; then
        case "$rel" in *"#unresolved") continue ;; esac
        hook_block "$rel is a protected quality setting (AGENTS.md rule 5) — not through the shell either. Propose the change in the plan's 'Files to change'."
      fi
    done
  fi
done
IFS=$oldifs
exit 0
