# Development Standards — configuration, conventions, coding, security

A concise standard any ServiceNow team can adopt. Publish it where builders can find it; an unpublished standard is not a control. (For deep scripting and Fluent SDK guidance, defer to the `sn-scripting`, `sn-sdk-fluent`, and `sn-sdk-setup` sub-skills.)

## Configuration over customization

- Prefer out-of-the-box behavior, then configuration, then low-code, and only then scripting. Justify and record every customization.
- A "customization" is anything that changes or overrides baseline behavior (modified OOB scripts, UI changes to core forms, etc.). These carry an upgrade cost — keep them few, isolated, and documented.
- When a requirement pushes toward heavy customization, first ask whether the *process* can adapt to the platform. The cheapest customization is the one you didn't build.

## Scoping and structure

- Build in a **scoped application** rather than global whenever practical — it isolates your code, namespaces your objects, and controls cross-scope access.
- Keep a clear separation between apps/scopes by capability; avoid dumping everything in one scope.

## Naming conventions

Consistency makes an instance legible and reviewable. Agree and publish patterns for:

- **Update sets** — `<initiative>-<short-description>-<team>-<seq>`.
- **Script objects** (Script Includes, Business Rules, Client Scripts) — a prefix per application/scope + a descriptive name.
- **Tables and fields** — scope-prefixed, lowercase with underscores; meaningful, not cryptic.
- **Roles and groups** — a predictable pattern that shows the owning application and the access level.

## Coding standards (platform-agnostic essentials)

- **Server vs client boundary is real** — don't call server-only APIs from the client; use the right mechanism to cross it (see `sn-scripting`).
- **Query efficiently** — filter in the query, not in a loop; select only needed fields; avoid nested queries where a single query or a GlideAggregate would do.
- **No hard-coded values** — no hard-coded sys_ids, credentials, or instance URLs; use system properties, credential stores, and lookups.
- **Escape output** and validate on the server — never trust client input for security decisions.
- **Fail safely and log meaningfully** — log with enough context to debug, without leaking secrets.
- **Prefer declarative tools** (Flow Designer, UI Policies, Data Policies) over scripts when they can do the job — they're more upgrade-safe and readable.
- **Comment the "why," not the "what."**

## Security and access

- **Least privilege**: grant the narrowest role; `admin` is rare and audited.
- **ACLs** secure data at table/field/record level; write them deliberately and test with impersonation.
- **Protect sensitive data**: encryption/masking where required; mind privacy and retention obligations.
- **Integrations** use dedicated service accounts with scoped permissions, not personal or admin accounts.

## Documentation and definition of done

A change is "done" when:

- it meets its acceptance criteria and passed test (see `sn-delivery`);
- it's captured in a properly named update set / pipeline commit;
- knowledge-transfer notes are recorded (what/why, config vs customization);
- any customization is logged in the decisions & customizations register;
- security (roles/ACLs) was considered and set;
- it won't surprise the next upgrade.

## Managing technical debt

- Track customizations and deviations as an explicit backlog, not folklore.
- Review debt on a cadence; retire custom code when the platform gains the capability natively.
- Record accepted exceptions (with an owner and a revisit date) so "temporary" doesn't become permanent silently.
