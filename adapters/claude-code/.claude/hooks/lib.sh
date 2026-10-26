# Shared helpers for the ANEW Claude Code hooks. Sourced, never run.
# The hook input (tool-call JSON) is read once into $HOOK_INPUT by hook_read.
hook_read() { HOOK_INPUT=$(cat); }

# hook_field <key>: tool_input.<key> as text. jq, then python3, then a grep fallback.
hook_field() {
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$HOOK_INPUT" | jq -r --arg k "$1" '.tool_input[$k] // empty | strings' 2>/dev/null
  elif command -v python3 >/dev/null 2>&1; then
    printf '%s' "$HOOK_INPUT" | python3 -I -c 'import json,sys
try: v = json.load(sys.stdin).get("tool_input", {}).get(sys.argv[1])
except Exception: v = None
sys.stdout.write(v if isinstance(v, str) else "")' "$1" 2>/dev/null
  else
    printf '%s' "$HOOK_INPUT" | grep -o "\"$1\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" | head -n 1 \
      | sed "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"//; s/\"\$//"
  fi
}

# hook_rel <path>: the path relative to the project, "." and ".." segments resolved.
hook_rel() {
  p=$1
  root=${CLAUDE_PROJECT_DIR:-$(pwd)}
  case "$p" in /*) ;; *) p="$root/$p" ;; esac
  case "$p" in
    */./*|*/../*|*/.|*/..)
      if command -v python3 >/dev/null 2>&1; then
        p=$(python3 -I -c 'import os,sys; sys.stdout.write(os.path.normpath(sys.argv[1]))' "$p")
      else
        p="$p#unresolved"   # no resolver: callers treat an unresolved path as protected
      fi ;;
  esac
  printf '%s' "${p#"$root"/}"
}

# hook_block <message>: refuse the tool call; Claude Code shows stderr to the agent.
hook_block() { echo "Blocked: $1" >&2; exit 2; }

# hook_configured: bootstrap has run (AGENTS.md no longer says NOT CONFIGURED).
hook_configured() { ! grep -q "STATUS: NOT CONFIGURED" "${CLAUDE_PROJECT_DIR:-.}/AGENTS.md" 2>/dev/null; }

# hook_plan_allows <relpath>: an approved plan of a spec still in specs/active/ lists the path in
# its file list — the human approved that change (prompts/plan.md, Files to change).
hook_plan_allows() {
  root=${CLAUDE_PROJECT_DIR:-.}
  for plan in "$root/specs/plans/"[0-9]*-plan.md; do
    [ -f "$plan" ] || continue
    n=$(basename "$plan" | sed 's/-plan\.md$//')
    ls "$root/specs/active/$n-"*.md >/dev/null 2>&1 || continue
    approval=$(grep -m1 '^- Approved by / on:' "$plan" | sed 's/<!--.*-->//g; s/^- Approved by \/ on:[[:space:]]*//; s/[[:space:]]*$//')
    case "$approval" in ""|"-"|"—") continue ;; esac
    grep -qF -- "$1" "$plan" && return 0
  done
  return 1
}

# hook_is_config <relpath>: lint, analyzer, formatter, type-check and check-contract settings.
# Weakening any of them turns red into green without fixing anything (AGENTS.md rule 5).
hook_is_config() {
  case "$1" in *"#unresolved") return 0 ;; esac
  case "$1" in
    scripts/check.conf|*/scripts/check.conf) return 0 ;;
  esac
  case "${1##*/}" in
    .editorconfig|.globalconfig|*.globalconfig|Directory.Build.props|Directory.Build.targets|\
    Directory.Packages.props|*.ruleset|stylecop.json|.eslintrc|.eslintrc.*|eslint.config.*|\
    .prettierrc|.prettierrc.*|prettier.config.*|tsconfig.json|tsconfig.*.json|biome.json|\
    biome.jsonc|.stylelintrc|.stylelintrc.*|stylelint.config.*|.markdownlint*|ruff.toml|\
    .flake8|mypy.ini|.golangci.yml|.golangci.yaml|detekt.yml|.swiftlint.yml|checkstyle.xml)
      return 0 ;;
  esac
  return 1
}
