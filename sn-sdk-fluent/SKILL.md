---
name: sn-sdk-fluent
description: Use when working with ServiceNow Fluent DSL (.now.ts files) — generating, reviewing, or explaining metadata definitions for tables, ACLs, business rules, UI pages, client scripts, script includes, flows, service portal widgets, and other ServiceNow metadata types. Covers all 6 column types, all $id-required types, and scope prefix reading from now.config.json.
license: Apache-2.0
compatibility: Designed for Claude Code, Cursor, VS Code Copilot, Antigravity, Codex, and similar AI coding tools.
---

# ServiceNow Fluent SDK

ServiceNow Fluent is a TypeScript-based DSL for defining application metadata (sys_metadata) as code. Files use the `.now.ts` extension and are compiled with `now-sdk build`. Two-way sync keeps metadata in sync between code and the ServiceNow instance. All Fluent APIs import from `@servicenow/sdk/core`.

## Reference Files

Read these files when you need them — do not pre-load all references at session start. Paths are relative to the skill root (the directory containing this `SKILL.md` file).

| File | When to read |
|------|--------------|
| `references/metadata-types.md` | When generating or reviewing any Fluent metadata type |
| `references/column-types.md` | When working with Table column definitions (StringColumn, IntegerColumn, etc.) |
| `references/now-globals.md` | When using Now.ID, Now.include, or the script tagged template literal |
| `references/getting-started.md` | When helping someone install the SDK or create their first project |
| `references/project-structure.md` | When explaining file layout, now.config.json, or scope prefix rules |
| `references/gotchas.md` | When encountering auth errors, XML/source conflicts, --reinstall questions, Now.ID or Now.ref usage, -now: import prefix issues, JS module sync questions, or npx vs now-sdk confusion |
| `references/cli-reference.md` | When running or explaining build, install, transform, clean, or pack commands |

## Example Assets

Use these as structural templates — only read the example that matches your target type, do not pre-load all examples:

| File | Metadata type |
|------|--------------|
| `assets/examples/table.now.ts` | Table (all 6 column types) |
| `assets/examples/acl.now.ts` | Acl + Role |
| `assets/examples/business-rule.now.ts` | BusinessRule |
| `assets/examples/client-script.now.ts` | ClientScript (.client.js extension) |
| `assets/examples/script-include.now.ts` | ScriptInclude |
| `assets/examples/ui-action.now.ts` | UiAction |
| `assets/examples/ui-page.now.ts` | UiPage |
| `assets/examples/rest-api.now.ts` | RestApi |
| `assets/examples/flow.now.ts` | Flow (trigger + action) |

## Hard Rules

1. **Read before writing.** Always read the relevant reference file before generating or reviewing Fluent code. Do not write from memory.
2. **Only use documented APIs.** Only use field names and options that appear in the reference files. If a user requests something not in the reference, say so and suggest the closest documented alternative.
3. **Never use GlideRecord.** GlideRecord is the legacy scripting API. Fluent is the correct pattern for SDK applications.
4. **Never omit `Now.ID` where required.** Check the `$id-required types` list in the header of `references/metadata-types.md` before writing any metadata type.
5. **Always import from `@servicenow/sdk/core`.** Never from `@servicenow/sdk` — the `/core` subpath is required.
6. **Scope prefix comes from `now.config.json`.** NEVER invent or assume the scope prefix. Read `references/project-structure.md` for the schema. If `now.config.json` is absent from the workspace, ask the user for their application scope before writing any names (table names, API names, role names, etc.).

7. **Never run install without a successful build first.** `now-sdk install` deploys whatever is in `dist/`. Running it without a prior `now-sdk build` silently pushes stale or missing artifacts. Build must complete cleanly before deploy.
8. **Always verify auth before deploying.** OAuth tokens expire silently. Run `now-sdk auth --list` and confirm the correct alias is active before every deploy.
9. **`sys_app.do` is the app record, not the running UI.** After deploy, the install output link points to the app record. The live UI URL is the `endpoint` value in the `UiPage()` call in the `.now.ts` source — e.g. `https://<instance>.service-now.com/<endpoint>.do`.

**ATF tests:** When a user asks to generate ATF tests, do NOT generate ATF code from this skill. ATF API surface is extensive and version-sensitive. Direct them to: `github.com/ServiceNow/sdk-examples/tree/main/test-atf-sample`

## Behavior by Task Type

### Build & Deploy

**Pre-deploy checklist — always run through this first:**
1. `now-sdk auth --list` → confirm the correct alias is marked as default
2. Ensure all `.now.ts` changes are saved and complete
3. Run build — it must succeed cleanly before proceeding

**The sequence — never skip or reorder:**
```bash
npm run build    # now-sdk build — type-check + bundle
npm run deploy   # now-sdk install — push artifacts to instance
```

**Post-deploy verification — always confirm the right version landed:**
1. Open `https://<instance>.service-now.com/sys_app.do?sys_id=<scopeId>` (scopeId is in `now.config.json`)
2. Confirm **version** matches what you just deployed
3. Confirm **state** is `Active`
4. If either is wrong, check `sys_app_install_log` on the instance for errors

**Finding the live UI URL after deploy:**
The install output shows a `sys_app.do` link — that is the app record, not the running UI. To get the live URL:
1. Open the `UiPage()` definition in your `.now.ts` source file
2. Read the `endpoint` value (e.g. `x_snc_myapp_portal.do`)
3. Live URL: `https://<instance>.service-now.com/<endpoint>.do`

**Targeting a specific instance:**
```bash
now-sdk install --auth <alias>   # override the default alias
```

**Common failures and fixes:**

| Symptom | Cause | Fix |
|---------|-------|-----|
| Auth error mid-deploy | Expired OAuth token | Re-run `now-sdk auth --add <url> --type oauth --alias <name>` to refresh |
| Install succeeds but UI shows old code | Build was skipped or stale | Re-run `npm run build` then `npm run deploy` |
| Type-check error blocks build | TypeScript error in source | Fix the error reported — do not bypass |
| Scope conflict on install | Another app owns the scope | Check `sys_app` for conflicting scope, resolve before retrying |

---

### Generating Fluent code

1. If the scope prefix, metadata type, or required fields have not been stated by the user and cannot be unambiguously determined from the workspace — gather them before writing (ask for each piece of information sequentially to avoid overwhelming the user)
2. Read `references/metadata-types.md` for the target metadata type
3. Read the matching example from `assets/examples/`
4. Write code following the example structure exactly
5. Use `Now.ID['descriptive_key']` for stable IDs; use `Now.include('./filename.ext')` for external scripts
6. Prefix table names, API names, and role names with `x_scope_` (where `scope` comes from `now.config.json`); if `now.config.json` is absent, apply Hard Rule 6

### Reviewing Fluent code

1. Read `references/metadata-types.md`
2. Check every field and option in the code against the reference
3. Flag options not in the reference as "not in reference — may be valid but verify against SDK docs"
4. Flag missing `$id` on types that require it (marked in the reference header)
5. Flag any GlideRecord usage
6. Flag imports from `@servicenow/sdk` (should be `@servicenow/sdk/core`)

### Explaining Fluent code

1. Read the relevant section of `references/metadata-types.md`
2. For each field, paraphrase the reference definition — do not explain from memory
3. For Now.ID, Now.include, or `script` tag questions, also read `references/now-globals.md`
