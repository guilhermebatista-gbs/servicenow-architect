---
name: sn-scripting
description: >
  Generates GlideRecord queries, Script Include classes, and client scripts
  for ServiceNow scripting. Use for Business Rules, Scheduled Jobs,
  server-side Script Includes, and client-side g_form/g_user scripts —
  including the script bodies inside Fluent SDK metadata definitions.
  Metadata definition itself belongs to sn-sdk-fluent.
compatibility: Designed for Claude Code, Cursor, VS Code Copilot, Antigravity, Codex, and similar AI coding tools.
license: MIT
---

# ServiceNow Legacy Scripting

ServiceNow legacy scripting uses the GlideRecord API for server-side data access, Script Include classes for reusable server-side logic, Business Rules for server-side automation, and g_form/g_user/g_list for client-side form manipulation. All APIs are described in the reference files below.

## References

Read these files when you need them — do not pre-load all references at session start. Paths are relative to the skill root (the directory containing this file).

| File | When to Read |
|------|-------------|
| `references/gliderecord.md` | Generating or reviewing GlideRecord queries, CRUD operations, or addQuery/getValue patterns |
| `references/server-side.md` | Generating Script Includes, Business Rules, or using GlideSystem (gs.*) logging |
| `references/client-side.md` | Generating Client Scripts using g_form, g_user, or g_list; or any client-side form manipulation |
| `references/gotchas.md` | Before generating or reviewing any ServiceNow script — check for hallucination traps |

## Scripts

| Script | When to use |
|--------|------------|
| `scripts/validate-script.sh` | When validating a ServiceNow script file for common issues before deploying |

## Examples

Use these as structural templates — only read the example that matches your target type, do not pre-load all examples:

| File | Demonstrates |
|------|-------------|
| `assets/examples/gliderecord-crud.js` | Complete GlideRecord CREATE, READ (single and multi), UPDATE, DELETE with correct getValue() usage |
| `assets/examples/script-include-class.js` | Script Include using Class.create() pattern with initialize(), utility methods, and type property |
| `assets/examples/client-script-gform.js` | Client Script onLoad/onChange handlers using g_form.getValue(), g_form.setMandatory(), g_user.hasRole() |

## Hard Rules

1. **In a Fluent SDK project, know which layer you're on.**
   If the workspace contains `now.config.json`, `.now.ts` files, or imports from `@servicenow/sdk/core`,
   the developer is working in a Fluent SDK application. Two different layers apply:
   - **Metadata definition** (creating tables, ACLs, Business Rules, Script Includes as objects) →
     that is Fluent's job. Redirect to `../sn-sdk-fluent/` (read its main file) instead of writing
     GlideRecord "setup scripts" or standalone legacy artifacts.
   - **Script bodies** (the logic inside a `script` property, a `Now.include()` file, or `src/server/`
     modules) → that is exactly this sub-skill. Those bodies are standard Glide server-side JS —
     apply this file's rules and references to them.

2. **GlideRecord is server-side only** — never generate GlideRecord in a Client Script. Use GlideAjax.

3. **Always call query() before next()** — while(gr.next()) without gr.query() never executes.

4. **Use getValue() in loops** — gr.field_name returns a pointer; gr.getValue('field_name') returns the string value.

5. **Never invent method names** — no gr.getField(), gr.setQuery(), gr.addOrder(). Prefer the methods documented in `references/gliderecord.md`; it is a curated subset, not the whole platform API. If a real, commonly used method isn't listed (check the official ServiceNow API docs), you may use it — say explicitly that it's outside the local reference and worth verifying. What is never acceptable is guessing a plausible-sounding name.

## Behavior by Task Type

### Generating

1. Check for Fluent SDK signals first (Hard Rule 1) — if detected, decide the layer: metadata definition goes to `../sn-sdk-fluent/`; script bodies stay here.
2. Identify the script context: server-side (Business Rule, Script Include) or client-side (Client Script).
3. For server-side: read `references/gliderecord.md` for CRUD patterns, `references/server-side.md` for Script Include structure and Business Rule context variables.
4. For client-side: read `references/client-side.md` for g_form/g_user/g_list APIs. Never generate GlideRecord in a client script (Hard Rule 2).
5. Use example files in `assets/examples/` as working templates.

### Reviewing

1. Check Hard Rules 3 and 4: query() before next(), getValue() in loops.
2. Verify no GlideRecord in client-side code (Hard Rule 2).
3. Verify no invented methods — compare against `references/gliderecord.md` documented API (Hard Rule 5).
4. Run `scripts/validate-script.sh <file>` to check for GlideRecord in client scripts, bare setAbortAction, and g_form misuse.

### Explaining

1. Route the developer to the relevant reference file for detailed method documentation.
2. For Fluent SDK metadata questions, read the main file in `../sn-sdk-fluent/`.
