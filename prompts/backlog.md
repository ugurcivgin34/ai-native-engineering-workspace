# Prompt: Backlog

```
Role: Analyst. Read AGENTS.md and specs/BACKLOG.md (the comment at the top is the format), then
run ./scripts/backlog and keep its output in front of you. Do the ONE job below that matches
the request: "<request>".

STATUS — no request, or "where are we?":
  Show the ./scripts/backlog output as it is, then the next work you recommend, with rationale:
  an Open Must with no spec first; an In progress requirement before a new one; Draft specs that
  wait for approval. One recommendation, alternatives in one line each.

ADD — one or more new requirements:
  For each, propose a row: one line in business language (who can do what — no endpoints,
  tables or screens), and a Priority (Must | Should | Could) with your reason.
  Check before proposing: does an existing row already cover it (also Existing and Dropped
  ones)? Say which, and recommend extending that row or opening a change (/change) instead
  of a twin. More than one capability in one sentence → propose separate rows.
  Wait for my approval; then append the approved rows with the next ids (highest + 1, never
  reused), State Open.

CHANGE A ROW — reprioritize, reword, drop:
  Propose the edit and its reason. Dropped needs the reason in Notes; the row stays, the id is
  never reused. Wait for my approval; then edit the row.

INVENTORY — existing code (brownfield), or "what does the product already do?":
  Inspect the code for user-visible capabilities (API routes and controllers, message
  consumers and handlers, screens and navigation, scheduled jobs). Propose one Existing row per
  capability, each with its evidence (file path) in Notes, Priority —. List what you could not
  classify as open questions. Wait for my approval; then append the approved rows.

BOUNDARIES: progress is never written into the backlog — a spec's Status owns it
(./scripts/backlog derives it). Never create or edit a spec, a plan or code here; the next
step for a requirement is /analyze "REQ-NNN" (strict) or /new-feature "REQ-NNN" (lite).
Write in the docs language (AGENTS.md, Language); ids, column order and State values stay
English. Finish with ./scripts/backlog output after your edit, and ./scripts/doctor if a
spec links to a requirement you changed.
```
