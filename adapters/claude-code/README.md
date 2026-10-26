# Adapter: Claude Code

Install: `./scripts/init claude-code` — copies `CLAUDE.md` and `.claude/` to the repo root.

What it adds on top of the core:

- **Segment commands** (`.claude/commands/`): `/analyze`, `/plan`, `/build`, `/review`, `/verify`
  — one per segment of `workflows/segments.md`. Each checks its entry condition (spec
  `Status: Approved`, plan `Approved by / on`, build evidence, triage), does its segment, and
  **always stops** with a handoff line naming the next command. Handoffs travel through files.
- **Chainer**: `/new-feature` reads the Mode from `AGENTS.md`. In `lite` it runs the segments in
  order and asks at each gate (spec, plan, triage, ship); in `strict` it refuses and redirects to
  the segment commands, one role per session. The rule:
  *Segments always stop; /new-feature flows only as far as the mode allows.*
- **Change requests**: `/change` — runs the triage rubric of `workflows/change-request.md`
  (bug / trivial / change) with a reasoned verdict, then the lane the behavior demands; in strict
  mode it stops after the mini-spec, in lite it chains with gate approvals.
- **Other commands**: `/bootstrap`, `/fix-bug`, `/refactor`, `/spike`, `/backlog`, `/adr`, `/recover` — each loads the
  matching workflow and honors the operating mode. All commands are thin by design: they point to
  `workflows/` and `prompts/`, they don't restate them.
- **Read-only reviewer subagent** (`.claude/agents/reviewer.md`): the "producer never verifies its
  own work" rule at the tool level — the subagent has no Edit/Write tools. Bash stays so it can run
  `scripts/check`, and it is instructed never to write; CI review gates are the backstop.
- **Permission denies** (`.claude/settings.json`): force push, hard reset, `git rebase`,
  `git clean -f`, `rm -rf` and its common flag orders — the first layer, matched by prefix.
- **Hooks** (`.claude/hooks/`, shared helpers in `lib.sh`; JSON read with jq or python3 when
  present, a plain fallback otherwise) — tested by `scripts/selftest`:
  - `protect-shipped.sh` — Edit/Write/MultiEdit/NotebookEdit under `specs/done/` are rejected,
    `..` tricks included.
  - `protect-config.sh` — lint, analyzer, formatter and type-check settings (`.editorconfig`,
    `Directory.Build.props`, `*.ruleset`, ESLint, Prettier, `tsconfig*.json`, …) and
    `scripts/check.conf` cannot be edited after bootstrap unless the approved plan of an active
    spec lists the file. Loosening a rule is the linter's version of skipping a test (rule 5).
  - `guard-bash.sh` — the shell route around both: writes under `specs/done/` (the ship move
    `git mv specs/active/… specs/done/` is allowed), shell writes to protected settings,
    recursive forced deletes in any flag order, force pushes in any form (`-f`, `--force*`,
    `+refspec`, `--delete`), `reset --hard` and `clean -f` — also behind `git -C <dir>`.
  Quotes are not parsed: an obfuscated command can still slip through; the CI gate
  (`scripts/doctor --strict`) and review stay the backstop.

All defaults are adjustable — see "Adapting it" in the root README.
