# Environment Management — dev/test/prod, update sets, clones, upgrades

## The instances and their roles

Good governance depends on each instance having a clear role. A typical topology:

| Instance | Purpose | Who works here | Characteristics |
|---|---|---|---|
| **Development** | Build configuration and code | Developers / builders | Changes captured in update sets or the SDK pipeline; may be reset/cloned often |
| **Test / QA (and UAT)** | Validate before production; user acceptance | Testers, business users | Should resemble production; receives changes only via the promotion path |
| **Production** | Live service | End users; admins for support only | No direct development; changes only via approved promotion |

Small programs may start with fewer instances and treat everything as if it were heading to production; add environments as complexity grows. Sub-production instances are refreshed from production by **clone**, so plan clone frequency and what to preserve/exclude (e.g. credentials, integrations, in-flight update sets).

## Update sets — the discipline

- **One naming standard.** Make it possible to know, at a glance, what a set contains and who owns it. A workable pattern: `<initiative>-<short-description>-<author-or-team>-<date/seq>`.
- **Scope a set to one logical change.** Avoid giant catch-all sets that are impossible to review or back out.
- **Validate before promotion** — the reviewer tests, ideally using impersonation to see the change as the target user, before the set moves forward.
- **Watch for collisions** — overlapping changes to the same objects across sets cause "update set collisions"; sequence and merge deliberately.
- **Batch related sets** so dependent changes move together.

Where maturity allows, graduate from manual update sets to a **CI/CD pipeline** (source control + automated build/test/deploy). It gives stronger traceability and repeatability, at the cost of more setup.

## Instance Scan and health checks

- Use **Instance Scan** to check the instance against best-practice and custom checks automatically, and to catch anti-patterns early rather than at upgrade time.
- Periodic platform health reviews (a vendor HealthScan or an internal equivalent) surface performance, security, and manageability issues. Treat their findings as a backlog, not a one-time event.

## Upgrades and release adoption

- **Stay current.** Falling behind on releases compounds risk and cost.
- **Design for the upgrade**: the more you customize, the more you re-test each release. Prefer configuration; isolate necessary customizations.
- **Adopt new capabilities deliberately.** Each release ships features that may replace a past customization — review release notes and retire custom code the platform now does natively.
- **Regression-test the customizations and integrations** each upgrade; keep a living inventory of them so the test scope is known.

## A pre-production checklist (before go-live)

- Request a platform/instance assessment from support well ahead of go-live (weeks, not days), sized to expected volume.
- Confirm integrations, SSO, and notifications behave in the production configuration.
- Confirm the promotion path is clean (no orphan/uncaptured changes in dev).
- Confirm rollback: can this release be backed out if needed?
