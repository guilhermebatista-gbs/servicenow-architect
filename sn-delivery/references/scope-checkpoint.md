# Scope Checkpoint — the scope-control gate

## Purpose

A scope checkpoint is a meeting that **aligns scope, budget, and timeline** with the customer. It acts as a **gate** to move from the Plan phase into Execute. Its documented outcome is a shared, point-in-time agreement on scope/budget/timeline that both sides can reference later — invaluable when there are many unknowns.

It is **not** sprint planning. Sprint planning schedules work already in scope; the scope checkpoint decides what *is* scope.

## How many checkpoints?

- Depends on project size and strategy. Roughly: **1** for a small project, **3–5** for a medium one.
- Decide the strategy during **Initiate**; run the checkpoints during **Plan**.
- Continue holding checkpoints until roughly **80% of the user stories** needed for the project have been reviewed through the checkpoint process.

## Strategy for organizing checkpoints

Break the work along logical lines, and weigh the pros/cons if more than one split applies:

- **Product-oriented** — one checkpoint per product/module.
- **Timeline-oriented** — checkpoints at fixed points as the plan progresses.
- Or by user area, by process, or by delivery priority.

## Defining scope at two levels

- **Macro level** — the high-level scope and key processes/assumptions in the SOW: type of work (advisory vs implementation), the applications listed, number of integrations, responsibilities, project tools. Changes here usually require a **change request** (even a zero-dollar one).
- **Micro level** — the SOW "snippets" / assumptions (e.g. "up to N notification templates", "load up to one knowledge source"). Changes here don't always need a change request, but review them: tell the customer which snippets are no longer needed, and use them to check that the effort still fits the budget.

## Scope analysis steps (roles)

1. **Finalize requirements** — BPC finalizes story contents; TC adds story points; customer PO signs off on stories and confirms what's in scope.
2. **Analyze** — BPC compares SOW scope vs the user stories and documents the delta; TC/EM total the points for a high-level level-of-effort (LOE); EM compares the staffing model to the LOE and updates the timeline; EM reviews impacts with the team and decides the course of action; if there's a significant gap, EM escalates internally, then with the customer's PM/sponsor; EM determines whether a change request is required and starts it.
3. **Present** — EM/BPC/TC complete the scope-checkpoint document; EM runs the meeting; EM sends formal notice that Plan is ending and new requirements are now enhancements; EM sends the checkpoint findings back to the presales/scoping function as a feedback loop.

## Reading the outcome — what changed?

- **Something added?** Compare SOW scope vs stories; flag scope not originally estimated; confirm it's really needed.
- **Something removed?** Flag SOW items with no stories; confirm they're out of scope.
- **Significant differences?** Flag items materially different from the SOW estimate.
- **Impact:** does the remaining budget/timeline support the agreed stories? Communicate updated impacts and decide whether change requests or re-prioritization conversations are needed.

## Handling awkward real-world scenarios

- **Development must start before Plan is fully done.** Split the project by product/epic; each time a subset of stories is approved, run a (shorter, iterative) checkpoint against the same documents.
- **Discovery-style products (e.g. ITOM) where requirements emerge over time.** These are more waterfall/fluid. Still document the SOW assumptions vs what's currently known, the remaining assumptions, and next steps.
- **A few big items (e.g. integrations) are late to be scoped.** Balance "enough documented to trust the plan" against "keep moving." Create placeholder stories for undocumented functionality with large estimates (from the original SOW basis or workshop knowledge), document that requirements will be captured later with assumptions, and continue the checkpoint. Anything unrelated to those items is still an enhancement.
- **Big delays; only ~20% of requirements documented and the customer is pushing to start.** The standard is not to advance without ~80–90% of the SOW-estimated story hours documented and estimated. Work with the sponsor and delivery management on the path forward (extend Plan? start Execute on signed-off requirements only with a new checkpoint date?). Document all decisions and risks. Prevent this by clear, consistent communication from the start — this should never be a surprise.

## The non-negotiable

Whatever the obstacles, **the scope checkpoint still happens** — its most important job is to document, in detail, what is known and unknown about the project, with all risks and assumptions, at an agreed point in time.
