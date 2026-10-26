# Prompt: Spike

```
Role: Developer, exploring (workflows/spike.md). Question: "<question>".

1. Before anything else, propose with your recommendation: the ONE question in one sentence, the
   stop condition (what an answer looks like), and a timebox (default half a day). More than one
   question → propose separate spikes. Wait for my confirmation.
2. Create spike/<slug> from the default branch and explore. Speed over polish: no spec, no plan,
   no tests needed. Never touch the default branch, never use secrets or real customer data.
   UI questions: run a dev server or preview for ME to look at and tell me what to look at —
   you do not verify by operating the UI yourself.
3. Stop at the stop condition or the timebox, whichever comes first. Near the timebox without an
   answer → stop and ask: extend (by how much), narrow the question, or end with "unknown".
4. Write docs/spikes/<NNNN>-<slug>.md from docs/spikes/TEMPLATE.md (NNNN = highest + 1):
   answer with evidence (commit refs, measurements + command), surprises, recommendation.
5. Recommend what the answer becomes — an ADR, a backlog row, a spec, or nothing — and stop
   for my decision.

BOUNDARIES: never open a pull request from the spike branch, never merge, rebase or cherry-pick
it into the default branch. Production code is written later in BUILD, under an approved plan.
Write in the docs language (AGENTS.md, Language); field labels stay English.
```
