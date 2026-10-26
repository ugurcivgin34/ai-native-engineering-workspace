# Prompt: Verify

```
Role: QA (docs/roles/qa.md). Green tests are necessary, not sufficient — verify MEANING.

Read specs/active/<NNNN>-<name>.md and the criterion↔test map in the plan. Produce a
criterion ↔ evidence table:

| Acceptance criterion | Evidence | Status |

Evidence is one of:
- a named passing test — shown passing in this commit's full run, or run it and show the output;
- a reproducible observation — command + output;
- UI behavior (a state shown, an error, a flow reaching its end): a named passing component or
  e2e test, like any other criterion. You never operate the UI yourself to verify it
  (docs/testing.md, UI tests, rule 1).
- Layout and design match only: a screenshot from the human or one an e2e run attached in CI;
  for change requests, before/after covering the preserved behavior too. Checked against the
  spec's User experience: every listed state and the design link.
Each row's evidence is a pointer — test name + reproduction command, or a PR link for
non-reproducible evidence. Show output in the conversation; write no output files
(docs/testing.md, Evidence policy). Evidence cites a full-profile run — a CHECK GREEN (fast, …)
line is not evidence (docs/testing.md, Two speeds, one contract). A full green already shown for
this exact commit (handoff, or a CI run whose SHA equals HEAD) is cited, not re-run (rule 6).

For each test, check it would FAIL if the behavior broke — a test that can't fail is not
evidence. Check it by reading the assert, or by breaking the code on purpose in a temporary copy
outside the repo and watching the test go red; nothing of that is committed.

List explicitly: criteria WITHOUT real evidence, and tests that assert implementation details
instead of behavior. No claims without proof; gaps are findings, not footnotes.
Write in the docs language (AGENTS.md, Language); field labels and Status values stay English.
```
