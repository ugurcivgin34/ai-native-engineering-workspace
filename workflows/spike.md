# Workflow: Spike

**Goal:** answer ONE question by trying instead of guessing — "does this library fit?", "what
should this screen feel like?", "is this approach fast enough?" — cheaply, without the feature
loop's ceremony, and without any of its code reaching the product.

```
QUESTION → [GATE: human] → EXPLORE (timeboxed, throwaway branch) → NOTE → [GATE: human] → DISCARD
```

**Why this does not break "No spec, no code" (AGENTS.md rule 1):** spike code never ships. It
lives on a `spike/<slug>` branch that is never merged — CI fails a pull request from a `spike/`
branch (`scripts/doctor --strict`). What survives is knowledge, written down; the production
code is built later through the normal loop, from a spec, and reads the spike only as reference.

## Steps

1. **QUESTION** — Role: Developer (`prompts/spike.md`). State the one question, what an answer
   looks like (the stop condition), and a timebox (default: half a day of work, or what the
   human sets). More than one question → more than one spike. **[GATE: human]** confirm all three.
2. **EXPLORE** — on `spike/<slug>`, branched from the default branch. Allowed: no spec, no plan,
   no tests, red check, hard-coded data, copy-paste. Not allowed: touching the default branch,
   secrets or real customer data, and running past the timebox without asking. For UI spikes the
   agent may run a dev server or preview for the **human** to look at; it does not verify by
   operating the UI itself (docs/testing.md, UI tests).
3. **NOTE** — write `docs/spikes/NNNN-<slug>.md` from `docs/spikes/TEMPLATE.md`: the question,
   the answer (yes / no / partly, with evidence: commit refs on the spike branch, measurements),
   what surprised you, and the recommendation with its consequence. NNNN = highest in
   `docs/spikes/` + 1. The note is the only spike artifact that reaches the default branch
   (a docs-only commit under the trivial-change policy, `docs/git.md`).
4. **DECIDE** — **[GATE: human]** the recommendation becomes exactly one durable thing:
   - a decision → `/adr` (the note is linked as evidence);
   - a new or changed requirement → `/backlog`;
   - a feature → `/new-feature` / `/analyze`, the spec's Intent links the note;
   - nothing — "no, we don't do this" is a valid, valuable answer; the note says so.
5. **DISCARD** — the spike branch is deleted, or kept unmerged for reference; it is never
   rebased, cherry-picked or merged into the default branch. Code worth keeping is rewritten in
   BUILD under an approved plan.

## When to use it

- The clarify step hits a question nobody can answer by thinking — only by trying (R-10 offers a
  spike as one option).
- A UI flow or look must be seen before it can be specified (frontend, desktop).
- A library, API or platform is unknown and the cost of a wrong guess is high.

Not for: work you already know how to do (that is a feature), "quick fixes" (bug-fix or the
trivial lane), or a prototype meant to become the product (it is a feature with a spec).
