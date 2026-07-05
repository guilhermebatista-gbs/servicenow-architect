# Requirements & User Stories — the standard

## The backlog hierarchy

- **Product** — a defined solution being implemented or built.
- **Theme** — a strategic initiative describing the team's high-level direction; ties the work to business objectives.
- **Epic** — a large body of work covering a major area of functionality, usually delivered across several releases.
- **User Story** — a specific piece of product functionality that delivers new value.
- **Task** — a specific unit of technical work needed to complete a story.
- **Defect** — a real failure against a completed story's documented acceptance criteria.
- **Enhancement** — a new or changed requirement beyond the documented acceptance criteria.

## What makes a user story healthy

- **Complete** — provides all pertinent information; minimizes later change; covers both positive and negative test scenarios in the acceptance criteria.
- **Understandable** — approved by the customer as meeting the business need; tied to a business outcome (captured in the Theme).
- **Estimable** — the solution and its impacts are understood; all activities needed to implement it are included.

And it should satisfy **INVEST**: **I**ndependent, **N**egotiable, **V**aluable, **E**stimable, **S**mall, **T**estable.

## What a story must answer

- **Who / What / When (BPC or PO):** what's the requirement? For which role/persona? When is the functionality used? What are the steps to validate completion?
- **Why (BPC or PO):** what's the context? How does this fit the wider solution? What must be considered — end-user experience, reporting/integration needs, dependent requirements?
- **How (TC):** is there a solution in mind? What platform features can be leveraged? What technical assumptions are made (e.g. "no scripts — use Flow", "use an out-of-the-box table")? Roughly how long should it take?

## Description vs Acceptance Criteria

**Description** — a detailed definition of what the story must achieve. Standard format:

> As **[a user persona]**, I want **[to perform this action]** so that **[I achieve this goal]**.

**Acceptance Criteria** — a highly detailed, testable scenario the story is validated against. Use the Given/When/Then pattern:

- **Given** — what is true (the starting state)
- **When** — the action taken
- **Then** — the expected result
- **And** — an additional result
- **But** — used for a negative scenario

Best practice is for the customer to author acceptance criteria; in reality the delivery team often writes the first draft. Whoever writes them, **the customer must formally approve them**, and the customer remains responsible for testing against them (UAT).

### Worked example

> **Description** — As a *customer*, I want a satisfaction survey generated on the portal when my case is closed, so that I can give feedback.
>
> **Acceptance Criteria**
> - *Given* I am a customer on the portal
> - *When* my case is closed
> - *Then* a satisfaction survey is displayed
> - *And* it shows the following questions: `<list so the TC knows what to configure>`
> - *And* I can submit the survey
> - *But* I cannot submit without answering all questions

### Technical / integration stories

They still serve a business purpose and use the same format — use a **"system"** persona when appropriate:

> As a *system*, I need data populated daily from a third-party system so that end users can work with current data.

## Story lifecycle & internal reviews

- **Internal story review** — the BPC walks the TCs through draft stories *before* showing the customer: align, surface open questions, agree the recommended solution. Reduces the "too many meetings" feeling and improves what the customer sees.
- **Refinement** — the BPC and PO refine the backlog, answer open questions, and get user approval so a story can reach **Ready** (Definition of Ready), be estimated, and be pulled into a sprint. If answers aren't available, create an action plan to get them.

**Definition of Ready** — move a story to Ready when it: meets INVEST; is reviewed and approved by the customer; has identified dependencies with owners and a resolution plan; was reviewed/estimated by the TC; is measurable and testable; and is sized in story points by the delivery team.

## Defects vs Enhancements (get this right)

| | **Defect** | **Enhancement** |
|---|---|---|
| Definition | A real failure of the documented acceptance criteria of an approved story | Any new or changed requirement beyond the documented acceptance criteria |
| Found | During UAT and after go-live | During Execute, UAT, and after go-live |
| Handling | Must include clear reproduction steps; qualified and prioritized before assignment | Closed and recreated as a story in the backlog; short description prefixed "ENHANCEMENT:"; linked to the original |

If a "defect" isn't actually a failure of documented criteria, it's an enhancement — recreate it as one and link it. Why bother? Because capturing every new requirement as an enhancement gives the team and customer **transparency and reporting** on how much new scope is appearing, and applies change-management rigor that turns requests into trackable decisions.

## Estimation

- A common cause of unfinished sprint stories is under-estimating total effort.
- Story points should cover **all** activities: requirement review/clarification, configuration (incl. data load), unit testing and fixes, support for test migration, and knowledge-transfer notes — plus a rounding-up contingency for skill-mix variation.
- Effort rises sharply when acceptance criteria aren't clearly defined — a reason to insist on them.
- Points-per-hour conventions vary by team; agree one and apply it consistently.

## RACI (typical)

| Story stage | Task | Customer PO | EM | BPC | TC |
|---|---|---|---|---|---|
| Draft | Document story + acceptance criteria | C | I | R/A | C |
| Draft | Internal review | C | I | R/A | C |
| Estimation | Estimate story points | C | I | C | R/A |
| Awaiting approval | Review, refine, approve with customer | R | A | C | C |
| Ready | Assign to sprint backlog | C | R/A | C | C |
| Work in progress | Development | I | I | C | R/A |
| Work in progress | Unit testing | I | I | C | R/A |
| Ready for testing | Assign to BPC/process owner | C | R/A | C | C |
| Testing | Conduct UAT | A/R | C/I | C | I |
| Failed testing | Validate failure, return to WIP | I | I | C | R/A |
| Complete | Testing passed, dev complete | I | R/A | I | I |

The EM holds overall accountability for the project except for customer-specific activities such as UAT.

## FAQs

- **"The customer says the story failed over a requirement we only discussed."** Undocumented requirements are handled as enhancements — no exceptions. That doesn't mean it won't be done; it means it's estimated and consciously accepted as new scope.
- **"Do technical/integration stories need the standard format?"** Yes — they still serve a business purpose (use the "system" persona).
- **"Our customer can't write acceptance criteria."** The delivery team may draft them, but agree who owns them before Initiate ends; the customer must still approve and test against them.
