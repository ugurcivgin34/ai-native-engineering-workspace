# Prompt: Plan

```
Role: Developer (docs/roles/developer.md). Read specs/active/<NNNN>-<name>.md and docs/
(architecture, conventions, testing, security). Produce specs/plans/<NNNN>-plan.md from
specs/plans/TEMPLATE.md:

- Files to change/add, path by path (this is the blast radius — be honest). Nothing the spec does
  not ask for: no extra endpoints, settings, generic helpers or layers "for later" (AGENTS.md rule 9).
- Ordered, commit-sized steps.
- Risks and points you are NOT sure about — each with your recommendation and rationale.
- Criterion ↔ test map: every acceptance criterion, the ONE primary test that will prove it at the
  lowest level that can (docs/testing.md, Test budget), and the profile it runs in (fast or full).
  e2e only for criteria the spec marks as critical flows. The map is the budget: no other tests. A new test must be caught by its step's selector in
  scripts/check.conf (docs/testing.md, Two speeds, rule 4).

Write in the docs language (AGENTS.md, Language); field labels stay English.
WRITE NO CODE. Present the plan and stop for my approval. If the spec has a gap or conflicts
with docs/, say so now (recovery R-10) — not during build.
```
