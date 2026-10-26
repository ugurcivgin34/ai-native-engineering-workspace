# Git

> **Template — adjust at bootstrap.** Defaults below are safe; loosen consciously, not accidentally.

## Branching
- `feature/<spec-no>-<short-name>` — **no branch without a spec.** Also for CHANGE-lane mini-specs.
- Refactors: `refactor/<spec-no>-<short-name>` (mini-spec with Changed behavior = none).
- Fixes: `fix/<report-id>-<short-name>` (bug fixes carry a report, not a spec number);
  incidents: `incident/<date>-<short-name>`; trivial changes: `trivial/<short-name>` (see below).

## Commits
- Conventional Commits, with a plan reference: `feat(catalog): paging endpoint [plan 0001/3]`.
  Review fixes name their fix round instead of the step:
  `fix(catalog): empty page size [plan 0001/fix-2]` — the reviewer counts rounds from these
  (R-06 after round 3).
- Agent commits follow the same standard: the agent writes the message, the human approves.

## Forbidden
- Direct commits to the default branch.
- Force push, history rewriting on shared branches. Undo = `git revert` (see recovery R-11).

## Trivial changes
<!-- Set at bootstrap. Applies only to requests the change-request triage rubric
     (workflows/change-request.md) classifies as TRIVIAL: no acceptance criterion changes, no shared code. -->
- Policy: **(1) PR + one reviewer, no spec** — default; alternatives: (2) direct commit allowed on a
  `trivial/<short-name>` branch · (3) everything goes through a mini-spec (`specs/TEMPLATE-mini.md`).
- Always: one narrow commit, `scripts/check` green. A second file or a new test means re-triage.

## Sidecar mode (code in its own repository)
<!-- Only when scripts/init --code <dir> was used (.anew-code exists). Delete otherwise. -->
For a codebase you cannot add ANEW files to — a team or company repository — this workspace
becomes a *sidecar*: specs, plans, backlog, docs and adapters live here; the application code is
its own repository in the directory `.anew-code` names, ignored by this one.
- **Two repositories, two jobs.** Code branches, commits and pull requests happen in the code
  repository, under that team's rules. This repository records the process: one commit per
  segment handoff (spec approved, plan approved, shipped).
- **Branch names and commit references** in the code repository follow its own convention when
  it has one; the `[plan NNNN/k]` and `[plan NNNN/fix-k]` references are then added only if the
  team accepts them. Without them, fix rounds are counted in the review report, not by doctor.
- **`scripts/check.conf` runs inside the code directory** (`build: cd <dir> && dotnet build`);
  `scripts/check` still runs from here.
- **Where this repository is pushed is a policy decision, not a default.** Specs and docs
  describe the code's domain: keep this repository where the code's owner allows — the team's
  own git server, a private repository the owner approved, or no remote at all (local only).
  Never push it somewhere the code itself may not go.

## Pull requests
- PR template checklist completed; `scripts/check` green in CI; squash-merge.
