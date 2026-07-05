---
name: sn-delivery
description: >
  ServiceNow delivery, requirements, and scope-management best practices for running an
  implementation well. Use when writing or reviewing user stories, defining acceptance
  criteria, running requirements workshops, estimating with story points, managing a
  product backlog, controlling scope (scope creep, change requests, enhancements vs
  defects), planning sprints and releases, running phase gates, or setting up a delivery
  quality review. Trigger on: user story, acceptance criteria, INVEST, backlog, epic,
  theme, sprint, story points, scope checkpoint, scope creep, change request, enhancement,
  defect, UAT, requirements workshop, phase gate, RIDAC/RAID, delivery methodology,
  Now Create, engagement manager, BPC, technical consultant, definition of ready, definition
  of done. Use even when a methodology isn't named but the task is about getting requirements
  right and keeping a project's scope, budget, and timeline aligned.
license: MIT
---

# ServiceNow Delivery — requirements & scope management

You help teams deliver ServiceNow implementations that stay on scope, on budget, and aligned to business value. The recurring failure mode in these projects is **scope creep from undocumented requirements**; most of this skill is about preventing that with clear requirements, healthy user stories, and disciplined scope control. This aligns with the standard ServiceNow delivery methodology (Now Create) and general agile practice.

## What good delivery protects

Three outcomes, in priority order:
1. **Well-defined requirements** — everyone agrees what "done" means before building.
2. **A plan for deviations** — a known way to handle the inevitable new requirements.
3. **A process to control change** — scope, budget, and timeline stay aligned as reality shifts.

## The delivery phases (and what matters in each)

| Phase | Focus | Key outputs |
|---|---|---|
| **Initiate** | Understand business objectives; set up project governance and the team; formal kick-off | Objectives & goals, governance model, scope document, kick-off |
| **Plan** | Environment setup; workshops (platform, process, integrations); build & prioritize the product backlog; release planning; test strategy; **scope checkpoint** | Backlog, release plan, timeline, scope-checkpoint sign-off |
| **Execute** | Run agile sprints; project communications; plan tests and UAT | Working increments, burndown, tested stories |
| **Deliver** | System test and UAT; go-live plan; operational plan; training; go-live | Go-live, trained users, cutover |
| **Close** | Operational handover, hypercare, lessons learned, value measurement, formal close | Close-out, success case, backlog roadmap |

## Roles (titles, not people)

- **Engagement Manager (EM)** — the project manager and single point of accountability for delivery against the contract/SOW; owns status, escalation, and scope decisions.
- **Business Process Consultant (BPC)** — the bridge between business need and platform; runs discovery workshops, translates requirements into functional design and stories, drives best practice.
- **Technical Consultant (TC)** — configures, builds, and integrates; turns requirements into a working, upgrade-safe solution; participates in code reviews and testing.

## The core discipline: document requirements as healthy user stories

A healthy user story is **Complete, Understandable, and Estimable**, and meets **INVEST**. See `references/requirements-and-user-stories.md` for the full standard: story anatomy (theme/epic/story), the description vs acceptance-criteria formats, the Given/When/Then pattern, defects vs enhancements, estimation, and the RACI.

## The core control: the scope checkpoint

A **scope checkpoint** is a gate between Plan and Execute where you align scope, budget, and timeline with the customer against the SOW. New requirements found after it are **enhancements**, not silent scope. See `references/scope-checkpoint.md`.

## Reference files (read on demand)

- `references/requirements-and-user-stories.md` — story standards, INVEST, description vs acceptance criteria, defects vs enhancements, estimation, RACI, FAQs.
- `references/scope-checkpoint.md` — purpose, how many checkpoints, the analysis steps, and how to handle awkward real-world scenarios.
- `references/delivery-quality-review.md` — a delivery-excellence review: the documents to check per phase, cadence, and how to escalate when the customer resists best practice.

## Guiding rules

1. **If it isn't in a story, it isn't in scope.** New, undocumented requirements become enhancements with their own estimate — no exceptions. This isn't a "no"; it's a transparent way to say "let's size it and decide."
2. **Acceptance criteria before build.** A story without testable acceptance criteria isn't Ready. Ambiguous criteria are the #1 cause of underestimated stories.
3. **Best practice first; document the risk if the customer declines.** Present options with pros/cons, recommend the upgrade-safe path, and if the customer chooses otherwise, record the decision and its consequences (a "DECISION" email + the risk log) and make sure all stakeholders see it.
4. **Estimate the whole story, not just the build.** Include requirement clarification, configuration, unit testing, fixes, and knowledge transfer.
5. **Communicate continuously.** Scope surprises are a communication failure. Regular updates on story creation, approvals, and blockers prevent the end-of-plan crunch.
