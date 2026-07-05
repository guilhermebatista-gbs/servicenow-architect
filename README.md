# servicenow-architect

> Expert-level agent skills for the whole ServiceNow lifecycle — architect, govern, deliver, and build.

A multi-skill suite that gives any compatible AI coding/agent tool senior-ServiceNow-architect knowledge. It spans the strategic layers most skill packs miss — **enterprise architecture (CMDB/CSDM/APM), platform governance, and delivery/requirements/scope management** — and pairs them with hands-on **development** knowledge (Fluent SDK, legacy scripting, and CLI setup). Every answer is biased toward business value, product thinking, and platform best practices.

## What's inside

| Sub-skill | What it covers |
|-----------|----------------|
| **[sn-architecture](./sn-architecture/)** | CMDB & CSDM modeling, Business Application vs Application Service vs infrastructure, Service Mapping readiness, TPM/TRM & Technical Debt, CI classification, taxonomy/metamodel, stakeholder communication templates. |
| **[sn-governance](./sn-governance/)** | Platform & instance governance (five pillars), governance boards, update sets & CI/CD, environment management, upgrades, development standards, customization-vs-configuration, citizen-dev guardrails. |
| **[sn-delivery](./sn-delivery/)** | Requirements & user-story standards (INVEST, Given/When/Then), estimation, backlog, scope checkpoint & scope control, enhancements vs defects, phase gates, delivery quality reviews. |
| **[sn-sdk-fluent](./sn-sdk-fluent/)** | Fluent SDK metadata (`.now.ts`): Tables, Columns, ACLs, Flow triggers, UI Actions, Business Rules, Service Portal widgets. |
| **[sn-scripting](./sn-scripting/)** | Legacy scripting: GlideRecord (CRUD & querying), Script Includes, Client Scripts, UI Policies, `g_form`, and the server/client execution boundary. |
| **[sn-sdk-setup](./sn-sdk-setup/)** | `now-sdk` CLI & scaffolding, OAuth/Basic auth profiles, project architecture, environment configuration. |

## How it works

The top-level `SKILL.md` is a router. When a task arrives, it applies a quick **business + product lens**, then points to the single sub-skill that fits — so the agent loads only the knowledge it needs. Architecture and governance decisions constrain the build sub-skills, keeping generated solutions upgrade-safe and in line with CSDM.

## Try these prompts

- *"Is this SaaS app a Business Application or a dependency? Here's what I know about it…"*
- *"Where should these CIs live in the CMDB?"* (paste a CI list)
- *"Set up a lightweight governance model for a mid-size instance."*
- *"Rewrite this vague requirement as a healthy user story with acceptance criteria."*
- *"We're 3 weeks from go-live — what does a scope checkpoint need to cover?"*
- *"Create a Business Rule that updates the parent problem on incident creation. Use the Fluent SDK."*
- *"Write a GlideRecord query for active tickets older than 30 days and update their state."*

## Install

Copy the sub-skill folders into your agent tool's skills directory. For most tools:

```sh
cp -r sn-architecture sn-governance sn-delivery sn-sdk-fluent sn-scripting sn-sdk-setup <your-skills-directory>/
```

Or install the whole suite as a plugin/skill bundle per your tool's documentation.

## Scope & disclaimer

This suite is a **knowledge and best-practice guide**, not a substitute for your instance's dictionary or your organization's standards. Table and class names can vary by release and by customization — always verify in your instance. It does not make changes to any ServiceNow instance on its own; it helps you design, decide, and build.

## License

MIT — see [LICENSE](./LICENSE).
