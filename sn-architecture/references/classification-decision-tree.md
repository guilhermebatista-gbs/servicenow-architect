# Classification Decision Tree — BA vs Tool vs Software vs Service vs Dependency

Use this when someone asks "Is X a Business Application or not?" or when you must decide the home of an existing CI.

## The tree

### Q1 — Is it end-user-facing, consumed by the business?

- **No** (it's internal support, an integration, infrastructure, a runtime) → it's an **infrastructure/software CI**, not a BA.
- **Yes** → continue.

### Q2 — Does it have a clear business owner + IT application owner?

- **No** — ownership is diffuse, nobody answers for it → likely a **module/component** of another BA, or it needs foundations work before it can become a BA.
- **Yes** → continue.

### Q3 — Does it have its own lifecycle (can it be retired independently)?

- **No** — it disappears when another application disappears → it's a **dependency/component** of that other BA.
- **Yes** → continue.

### Q4 — Does it appear (or should it) in Demand / Enhancement / portfolio planning?

- **No** — nobody plans dedicated work for it → weak BA signal. Re-evaluate; it may be a **Tool** if it's for internal IT use.
- **Yes** → strong signal for **Business Application**.

### Q5 — Deployment model

- **SaaS, vendor-managed, no customer infrastructure**: it can still be a BA (if Q1–Q4 said yes), but model it minimally — no owned servers/DBs. Record explicitly "vendor-managed / no internal servers / no internal database." Map only: the entry point (SaaS URL), SSO/IdP, and integrations with internal systems.
- **On-prem / Cloud IaaS/PaaS with customer infrastructure**: BA + full Application Services with servers/DBs.
- **Hybrid**: BA + services per environment; note the hosting type on each service.

## The non-BA classes the tree can land on

| Classification | When to use | Generic example |
|---|---|---|
| **Tool** (IT-facing, not a business product) | Internal IT use; may have an IT owner but isn't consumed by the end business | An internal monitoring or admin utility |
| **Software / Product Model** | Reusable technology (runtime, DB engine, middleware) | A Java runtime, a database engine version |
| **Dependency / Component** | A tool/service that only makes sense inside another BA | A embedded analytics widget inside a larger portal |

## Worked examples (generic patterns)

### A marketing analytics SaaS embedded in a web portal
- Q1: yes (marketing uses it).
- Q2: check — it may sit under the portal's owner.
- Q3: own lifecycle? If cancelling it leaves the portal running, then yes → candidate **SaaS BA**.
- If its use is residual (one or two features inside a larger stack): it's a **dependency** of the portal BA.
- **Action:** confirm owner + SSO + integrations + whether it appears in Demand/Enhancement before deciding.

### An on-prem HR/finance system of record
- Q1–Q4: yes to all. Clear owner, own lifecycle, active demand.
- Deployment: on-prem → full BA + Application Services PROD/UAT/DEV with servers + DBs.
- **Action:** validate environments and entry points; confirm servers/DBs per environment with the owning team.

### A public-facing website "stack"
- Q1–Q4: yes. It's a BA in the web portfolio.
- **Action:** validate BA ↔ services ↔ dependencies; check whether internal components (CMS, payment module) are dependencies or BAs in their own right.

### A niche system nobody currently owns
- Doesn't appear on any critical list. Investigate: is it a BA? a dependency? already retired?
- **Action:** find who knows it; if nobody does, mark it "investigation pending" rather than guessing a class.

## Common traps (ground truth)

- **"It has a URL, so it's a Business Application."** False. A URL is the entry point of a *service*, not a criterion for a BA.
- **"It's on the Product Model / Software Package table, so keep it there."** False. Migrate it (see `taxonomy-metamodel.md`).
- **"It's a SaaS vendor, so we don't need to model it."** False. It still needs a BA (if Q1–Q4 pass) + a minimal service (entry point + SSO + integrations).
- **"Only PROD exists, so one service is enough."** Fine *if* only PROD truly exists. But if the owner mentions test/UAT at any point, ask for details.
