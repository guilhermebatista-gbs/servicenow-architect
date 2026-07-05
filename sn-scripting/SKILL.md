---
name: sn-scripting
description: >
  Generates GlideRecord queries, Script Include classes, and client scripts
  for ServiceNow legacy scripting. Use for Business Rules, Scheduled Jobs,
  server-side Script Includes, and client-side g_form/g_user scripts.
  Redirects to sn-sdk-fluent when Fluent SDK is detected in the workspace.
compatibility: Designed for Claude Code, Cursor, VS Code Copilot, Antigravity, Codex, and similar AI coding tools.
license: Apache-2.0
---

# ServiceNow Legacy Scripting

ServiceNow legacy scripting uses the GlideRecord API for server-side data access, Script Include classes for reusable server-side logic, Business Rules for server-side automation, and g_form/g_user/g_list for client-side form manipulation. All APIs are described in the reference files below.

## References

Read these files when you need them — do not pre-load all references at session start. Paths are relative to the skill root (the directory containing this `SKILL.md` file).

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

1. **Never use GlideRecord when ServiceNow Fluent SDK is present.**
   If the workspace contains `now.config.json`, `.now.ts` files, or imports from `@servicenow/sdk/core`,
   the developer is working in a Fluent SDK application. Stop and redirect:
   "I can see you're working in a Fluent SDK project. Use the sn-sdk-fluent skill to generate
   typed metadata definitions instead of GlideRecord scripts. GlideRecord is the legacy scripting
   API and does not work inside Fluent SDK `.now.ts` files."

2. **GlideRecord is server-side only** — never generate GlideRecord in a Client Script. Use GlideAjax.

3. **Always call query() before next()** — while(gr.next()) without gr.query() never executes.

4. **Use getValue() in loops** — gr.field_name returns a pointer; gr.getValue('field_name') returns the string value.

5. **Only use documented API methods** — do not invent methods like gr.getField(), gr.setQuery(), or gr.addOrder().

## Behavior by Task Type

### Generating

1. Check for Fluent SDK signals first (Hard Rule 1) — if detected, redirect immediately; do not generate GlideRecord code.
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
2. For Fluent SDK questions, redirect to the sn-sdk-fluent skill.
