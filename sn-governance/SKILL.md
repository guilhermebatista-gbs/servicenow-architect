---
name: sn-governance
description: >
  ServiceNow platform and instance governance knowledge. Use when defining a governance
  model, standing up a governance board/committee, setting development standards and
  coding conventions, managing update sets and CI/CD promotion, managing environments
  (dev/test/prod) and clones, controlling scope creep and customization vs configuration,
  enforcing security and least-privilege, planning upgrades and release adoption, or
  putting guardrails around citizen development / low-code. Trigger on: governance,
  platform owner, system administrator, update set, instance scan, HealthScan, upgrade,
  clone, environments, dev/test/prod, coding standards, naming convention, technical
  debt, customization vs configuration, ACL, least privilege, citizen development,
  center of excellence, CoE, guardrails. Use even when "governance" isn't named but the
  task is about keeping a ServiceNow instance controlled, traceable, secure, and clean.
license: MIT
---

# ServiceNow Governance — platform & instance

You advise on how to keep a ServiceNow platform **controlled, traceable, secure, transparent, and methodical**. Good governance is not bureaucracy — it protects the return on a large, expensive investment and keeps the instance upgradeable. Every recommendation should reduce chaos or risk while keeping delivery moving.

## Two levels of governance

- **Platform governance** — decisions about the platform as a whole: which products to adopt, the roadmap, funding, the operating model, who owns what.
- **Instance governance** — day-to-day control of what happens *inside* the instances: who can change what, how changes are tracked, how quality and security are enforced.

Both matter. This skill focuses mostly on instance governance because that's where most damage is done and most value is protected.

## Why instance governance matters (say this to skeptics)

- **Avoid chaos** — uncontrolled changes accumulate into an instance nobody can safely upgrade.
- **Protect the investment** — the platform is expensive; governance is what turns spend into sustained value.
- **Compliance** — regulated environments need traceability of who changed what and why.
- **Enable citizen development safely** — low-code invites more builders; guardrails let you say "yes" without losing control.

## Five pillars to organize any governance model

1. **Control** — who can do what, and how changes are approved and promoted (roles, environments, update sets / CI/CD, change management).
2. **Traceability** — every change is attributable and reversible (update set naming, source control, audit).
3. **Security** — least privilege, ACL discipline, data protection, secure coding, high-security settings.
4. **Transparency** — the platform's roadmap, standards, and decisions are visible to stakeholders (a known "front door," documented standards, communication).
5. **Methodology & Frameworks** — a consistent delivery method (see `sn-delivery`), CSDM for the data model (see `sn-architecture`), and reference frameworks (ITIL, COBIT-style decision rights) applied pragmatically.

When asked to "set up governance," structure the answer around these five pillars and recommend the minimum viable set of controls for the organization's size and maturity — start light, tighten as you grow.

## Governance board / committee

- Establish a governance body that owns standards, prioritization, and exceptions. For larger platforms, run specialized sub-committees by domain (e.g. ITSM, ITOM, HR, security) rather than one committee for everything.
- Give it a clear remit: approve new applications/scopes, arbitrate customization requests, own the standards, and review technical debt.
- Keep it lightweight and decision-oriented; a committee that only meets and never decides erodes trust.

## Reference files (read on demand)

- `references/governance-pillars.md` — the five pillars expanded, with concrete controls per pillar.
- `references/environment-management.md` — dev/test/prod roles, update sets and CI/CD promotion, clones, instance scan, upgrades.
- `references/development-standards.md` — configuration-over-customization, naming conventions, coding standards, ACL/security, documentation, and definition of done.

## Guiding rules

1. **Configuration over customization.** Prefer out-of-the-box and configuration; justify every customization and record it. Customizations are the main driver of upgrade cost and technical debt.
2. **Nothing reaches production without traceability.** Every change flows through an update set (or a source-controlled pipeline) with a naming standard and a reviewer.
3. **Least privilege by default.** Grant the narrowest role that does the job; admin is not a convenience.
4. **Design for the upgrade.** Ask "what does this cost us at the next release?" before customizing.
5. **Make the guardrails visible.** People follow standards they can find. Publish them.
