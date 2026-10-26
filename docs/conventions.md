# Conventions

> **Template — filled during bootstrap.** Only rules that are real: every rule here should be
> either enforced by tooling (preferred) or checked in review. Aspirations don't belong here.

## Language
<!-- Set at bootstrap (step 0) and mirrored in AGENTS.md. Changing it later is allowed — edit both
     places; existing documents are not translated retroactively. -->
- Chat language (interviews, sessions): <!-- e.g. Turkish -->
- Document language (docs/, specs, plans, ADRs, review and verify reports): <!-- e.g. Turkish -->
- Always English (protocol, not prose): ANEW core files, template headings and field labels,
  `Status:` values (Draft / Approved / In progress / Shipped), `Approved by / on:`, `Source:`.
- Code identifiers, branch names, commit messages: <!-- default English; decide consciously -->
- Agent messages (handoff summaries, refusals, `Next:` lines): chat language; command names, file
  paths and protocol fields verbatim.

## Layers & stack reviewers
<!-- Filled at bootstrap when the repo holds more than one stack (e.g. a .NET API and a React app).
     One row per layer. The Developer reads the rules doc of every layer it touches; REVIEW runs
     the layer's stack reviewer as a read-only second pass over that layer's files
     (docs/roles/reviewer.md). A rules doc holds that layer's real rules; this file keeps what is
     shared by all layers. A stack reviewer is optional, and never has edit tools (doctor checks). -->
| Layer | Paths | Rules | Stack reviewer |
|---|---|---|---|
| <!-- e.g. API --> | <!-- e.g. src/Api/** --> | <!-- e.g. docs/backend.md --> | <!-- e.g. csharp-reviewer, or — --> |

## Language & framework versions
<!-- Pin what matters. -->

## Naming
<!-- Files, types, tests, branches — whatever the team must keep consistent. -->

## Error handling
<!-- The one blessed pattern. What never leaks to users. -->

## Data rules
<!-- e.g. money/percentages use decimal types; timestamps are UTC; IDs are ... -->

## Enforced by tooling
<!-- List what the compiler/linter/analyzers already enforce, so review doesn't re-litigate it.
Wire new rules into `scripts/check` whenever possible — prose is advice, tooling is law. -->
