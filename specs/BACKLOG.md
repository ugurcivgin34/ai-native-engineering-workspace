# Backlog — every requirement of the product, one line each

<!-- The one list of WHAT the product must do — before, during and after a spec exists.
     Content in the document language from AGENTS.md; the ID format, column order and State
     values stay English (protocol): scripts/backlog and scripts/doctor read them.

     Columns:
     - ID          REQ-NNN, never reused or renumbered. Next = highest + 1.
     - Requirement one line, business language (who can do what). No technical solutions.
     - Priority    Must | Should | Could | — (Existing rows: —)
     - State       set BY HAND, only these three values:
                     Open      wanted, not finished — the default for every new row
                     Existing  already built before ANEW was adopted (brownfield inventory, bootstrap)
                     Dropped   decided against — write the reason in Notes; the row stays
     - Notes       optional: reason for Dropped, a split hint, a work item link.

     Progress is NEVER written here. A spec links itself to requirements with its
     "- Requirements: REQ-NNN" line, and ./scripts/backlog derives each row's status from those
     specs' Status fields (Draft → Approved → In progress → Shipped). One source of truth per
     fact: the spec owns progress, this file owns the list.

     One requirement may take several specs (a large capability split by the SIZE rule,
     prompts/spec.md); one spec may serve several requirements. Changing an Existing requirement
     goes through /change (mini-spec), never a full spec that rebuilds it.

     Example rows (delete when the first real row is added):
     | REQ-001 | A visitor can register with an e-mail address | Must | Open | |
     | REQ-002 | A customer can see the product list | — | Existing | brownfield inventory |
     | REQ-003 | Push notifications for order updates | Could | Dropped | no mobile app in V1 |
-->

| ID | Requirement | Priority | State | Notes |
|---|---|---|---|---|
