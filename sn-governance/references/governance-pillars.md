# The Five Governance Pillars — expanded

A practical way to design an instance-governance model. Pick the minimum controls that fit the organization's size and maturity; add more as the platform grows.

## 1. Control

**Question it answers:** who can change what, and how does a change reach production?

Concrete controls:
- Defined roles and role-assignment process (least privilege — see Security).
- A promotion path: dev → test → prod, with no direct changes in production.
- Update sets (or a source-controlled CI/CD pipeline) as the only way changes move.
- Change management for production releases, sized to risk (standard/normal/emergency).
- A gate for new applications and scopes: nothing new goes live without governance sign-off.

## 2. Traceability

**Question it answers:** can we tell who changed what, when, and why — and undo it?

Concrete controls:
- An update-set naming standard so any change is identifiable at a glance (see `development-standards.md`).
- Source control / the platform's DevOps or SDK pipeline for versioning where maturity allows.
- Field-level audit on sensitive tables.
- A "strategic decisions & customizations" log kept alive for the life of a project and handed over at close.

## 3. Security

**Question it answers:** is access least-privilege and is data protected?

Concrete controls:
- Least privilege: grant the narrowest role that does the job; treat `admin` as rare.
- ACL discipline: secure by table/field/record, test with impersonation.
- High-security settings and secure coding (no hard-coded credentials, escape output, server-side validation).
- Data protection appropriate to the regulatory context (privacy, retention, encryption of sensitive fields).
- Regular access reviews; remove entitlements when roles change.

## 4. Transparency

**Question it answers:** do stakeholders know the roadmap, the standards, and the decisions?

Concrete controls:
- A single, well-known "front door" for requests and for the published standards (a portal page, a wiki space).
- A visible roadmap and release calendar.
- Published coding/design standards that builders can actually find.
- Communication rhythm: what changed each release, what's coming, how to get help.

## 5. Methodology & Frameworks

**Question it answers:** are we building consistently and on a sound data model?

Concrete controls:
- A consistent delivery method with defined phases and gates (see `sn-delivery`).
- CSDM as the CMDB data model (see `sn-architecture`).
- Pragmatic use of reference frameworks — ITIL for process, a COBIT-style view of decision rights and accountability — without turning them into ceremony.
- A definition of done that every story/change is held to.

## How to present a governance recommendation

1. State the current risk (chaos, un-upgradeable instance, security exposure, scope creep).
2. Map recommended controls to the five pillars.
3. Right-size: start with the few controls that remove the biggest risk; sequence the rest.
4. Name an owner for each control (a person's *role*, never a named individual in a reusable artifact).
5. Make the standards visible — an unpublished standard is not a control.
