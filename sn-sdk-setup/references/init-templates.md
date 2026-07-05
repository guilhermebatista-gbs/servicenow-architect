# ServiceNow SDK — Init Templates

Complete reference for `now-sdk init` template options, non-interactive flags, and scope naming rules.

For the step-by-step scaffold workflow, see `setup-workflows.md` section 1.

---

## Template Names

> **Always run `now-sdk init --help` to confirm the exact template list for your installed SDK version.**

Templates verified from two sources: `now-sdk init --help` (SDK 4.5.0) and the official ServiceNow Australia App Development documentation.

### New project templates

| Template flag value | Description | When to use |
|---|---|---|
| `typescript.basic` | Fluent + TypeScript, no UI framework | Server-side: Business Rules, Script Includes, Tables, ACLs, Flows, Service Portal |
| `typescript.react` | Fluent + TypeScript + React | Apps that need a custom React UI page |
| `typescript.vue` | Fluent + TypeScript + Vue | Apps that need a custom Vue UI page |
| `javascript.basic` | Fluent + JavaScript, no UI framework | Server-side work, prefer JS over TS |
| `javascript.react` | Fluent + JavaScript + React | React UI with JavaScript |
| `base` | Minimal structure only, no JS/TS modules | Bare scaffold, advanced use only |

### Partial templates (add to existing app)

| Template flag value | Description | When to use |
|---|---|---|
| `partial.typescript.react` | Adds React + TypeScript to existing app | Adding React UI to an app already initialized |
| `partial.javascript.react` | Adds React + JavaScript to existing app | Adding React UI to an existing JS app |

> **Note:** Partial templates do not appear in `now-sdk init --help` output but are documented in official ServiceNow documentation. Use with `--template partial.typescript.react` on an existing initialized project.

> **Note on `typescript.vue`:** This template is present in `now-sdk init --help` (SDK 4.5.0) and generates real Vue 3 `.vue` files with a `UiPage` Fluent DSL entry point. It is not listed in the Australia release PDF — it was added in a later SDK version. Verified working: generates `src/client/App.vue`, Vue components, and `src/fluent/ui-pages/*.now.ts`.

`typescript.basic` is the safe default. Use it unless the user explicitly needs React or Vue.

---

## Use-Case → Template Guide

Ask the user what they want to build, then pick from this table:

| User's use case | Recommended template |
|---|---|
| Business rules, script includes, scheduled jobs, tables, ACLs | `typescript.basic` |
| Service Portal widgets | `typescript.basic` (SP widgets are Fluent DSL types, no UI framework needed) |
| Custom React UI page — new app | `typescript.react` |
| Custom Vue UI page — new app | `typescript.vue` |
| Add React to an existing initialized app | `partial.typescript.react` |
| Server-side automation, prefer JavaScript | `javascript.basic` |
| React UI with JavaScript | `javascript.react` |
| Not sure / general purpose | `typescript.basic` |

> **Service Portal widgets** use `SPWidget`, `SPPage`, etc. from `@servicenow/sdk/core` — these are Fluent DSL types, not React/Vue components. `typescript.basic` is correct for all Service Portal work.

---

## Non-Interactive CLI Flags

Full flag reference for `now-sdk init`:

| Flag | Description |
|---|---|
| `--template <name>` | Template to use (see table above) |
| `--appName <name>` | Display name of the application |
| `--packageName <name>` | npm package name (lowercase, hyphenated) |
| `--scopeName <name>` | ServiceNow application scope (e.g., `x_myco_myapp`) |
| `--auth <alias>` | Auth alias to use for instance connection |
| `--from <sys_id or path>` | Init from existing app (sys_id from instance, or local path) |

### Fully non-interactive example

```bash
now-sdk init \
  --template typescript.basic \
  --appName "My Application" \
  --packageName my-application \
  --scopeName x_myco_myapp \
  --auth dev
```

---

## Scope Name Rules

- Must begin with `x_<prefix>` (e.g., `x_snc_`, `x_myco_`)
- Maximum **18 characters** total
- Example valid scope: `x_snc_myapp` (12 chars — valid)
- Example invalid scope: `x_mycompany_myapp123` (20 chars — too long)

---

## Global Apps

Global apps (scope `global`) are only supported on **Australia release or later** instances. If your target instance is pre-Australia, use a scoped app.

---

## After Init: Run npm install

After `now-sdk init` completes, you **must** run `npm install` before building:

```bash
npm install
```

The SDK will remind you if you attempt to build without installing. Skipping `npm install` causes TypeScript compilation to fail because SDK type definitions are not present.

---

## Init from Existing App

The `--from` parameter accepts:
- A `sys_id` from the sys_app table on your ServiceNow instance
- A local directory path to an existing app export

```bash
# From instance (requires --auth)
now-sdk init --from abc123def456 --auth dev

# From local path
now-sdk init --from ./exported-app/
```

For the full 5-step convert workflow, see `convert-existing-app.md`.

---

*Cross-reference: For the step-by-step scaffold workflow, see `setup-workflows.md` section 1.*
