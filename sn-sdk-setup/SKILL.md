---
name: sn-sdk-setup
description: Use when setting up, configuring, building, or deploying with the ServiceNow SDK — scaffolding new projects, configuring Basic or OAuth authentication, converting existing applications, building and deploying to an instance, or validating a development environment. Covers all init templates, auth setup with named aliases, the build→deploy→verify lifecycle, and the check-environment script.
license: MIT
compatibility: Designed for Claude Code, Cursor, VS Code Copilot, Antigravity, Codex, and similar AI coding tools.
---

# ServiceNow SDK Setup

The ServiceNow SDK (now-sdk) CLI scaffolds, builds, and deploys Fluent DSL applications. Use this skill for any SDK installation, project creation, authentication, or environment validation task.

## Reference Files

Read only the file relevant to your task. Do not pre-load references at session start.

| File | When to read |
|------|--------------|
| `references/setup-workflows.md` | When scaffolding a new project, configuring auth, converting an existing app, or diagnosing environment issues |
| `references/auth-profiles.md` | When configuring Basic or OAuth auth, managing named aliases, or passing `--auth` to commands |
| `references/init-templates.md` | When choosing a project template or passing non-interactive init flags |
| `references/convert-existing-app.md` | When converting an existing application from XML metadata or Update Set |
| `references/third-party-libraries.md` | When adding npm packages to an SDK project |
| `references/js-modules-types.md` | When using JS modules in src/server/, TypeScript in server-side modules, or @servicenow/glide type definitions |
| `references/cli-reference.md` | When looking up auth, init, build, install, download, or dependencies command flags |

## Scripts

| Script | When to use |
|--------|------------|
| `scripts/check-environment.sh` | When validating the developer environment before starting SDK work. Use `--offline` in CI pipelines. |

## Hard Rules

1. **Read before advising.** Always read `references/setup-workflows.md` before giving setup instructions. Do not rely on memory for command syntax — SDK commands change between versions.
2. **Use `now-sdk auth --add`, not `auth save` or `login`.** `auth save` does not exist. `login` is deprecated. The correct command is `now-sdk auth --add <url> --alias <name>`.
3. **Always use a named alias.** Use `now-sdk auth --add <url> --alias dev` — aliases allow multiple instances.
4. **Never pick a template without understanding the use case.** Follow the discovery flow in the scaffold behavior below. Default to `typescript.basic` only as a last resort after two unanswered prompts.
5. **The scope prefix comes from now.config.json.** For writing Fluent DSL code after setup, read the main file in `../sn-sdk-fluent/` — that sub-skill owns code generation.
6. **Never run install without a successful build first.** `now-sdk install` deploys whatever is in `dist/`. Running it without a prior `now-sdk build` silently pushes stale or missing artifacts. Build must complete cleanly before deploy.
7. **Always verify auth before deploying.** OAuth tokens expire silently. Run `now-sdk auth --list` and confirm the correct alias is active before every deploy. A mid-deploy auth failure is confusing and hard to diagnose.
8. **`sys_app.do` is the app record, not the running UI.** After deploy, the link in the install output points to the app record. The live UI URL is the `endpoint` value defined in the `UiPage()` call in the `.now.ts` source — e.g. `https://<instance>.service-now.com/<endpoint>.do`.

## Behavior by Task Type

### New project scaffold

Read `references/setup-workflows.md` and `references/init-templates.md` first, then follow this flow:

**Step 1 — Instance URL**
If not already provided, ask:
> "What's your ServiceNow instance URL? (e.g. https://dev12345.service-now.com)"

**Step 2 — Auth**
- Recommend OAuth. Ask: "OAuth (recommended) or Basic auth?"
- **Important:** OAuth requires interactive terminal input — Claude Code cannot handle this. See `references/cli-reference.md` → **auth --add (token refresh)** for the Terminal workaround.
- Once they confirm auth succeeded, verify with: `now-sdk auth --list`

**Step 3 — What to build**
Ask one question with examples to guide the answer:
> "What are you building? For example:
> - Business rules, script includes, flows, Service Portal widgets → `typescript.basic`
> - App with a custom React UI page → `typescript.react`
> - App with a custom Vue UI page → `typescript.vue`"

- If they answer → map to the right template, state your reasoning in one sentence, confirm with user, then scaffold.
- If no answer → ask once more: "Does it need a custom UI, or is it server-side only?"
- If still no answer → use `typescript.basic` and say: "Going with `typescript.basic` — works for everything server-side. You can add React later with `partial.typescript.react`."

**Step 4 — Scaffold**
```bash
now-sdk init \
  --template <chosen-template> \
  --appName "<App Name>" \
  --packageName <package-name> \
  --scopeName <x_scope_name> \
  --auth dev
```
Then: `npm install`

**Step 5 — Hand off**
> "Project ready — next step is writing `.now.ts` files." Then continue with the **sn-sdk-fluent** sub-skill (read the main file in `../sn-sdk-fluent/`).

---

### Authentication setup (standalone)
1. Read `references/setup-workflows.md` section 2 (Configure Authentication)
2. Determine Basic vs OAuth — recommend OAuth
3. For full flag reference and alias management, read `references/auth-profiles.md`.
4. **OAuth requires interactive terminal input** — Claude Code cannot handle this. See `references/cli-reference.md` → **auth --add (token refresh)** for the Terminal workaround.
5. Verify with: `now-sdk auth --list`

### Convert existing application
1. Read `references/setup-workflows.md` section 3 (Convert Existing Application)
2. For full 5-step workflow with gotchas, read `references/convert-existing-app.md`.
3. Walk through the full workflow: `init --from` → `transform` → `build` → `install`

### Build & Deploy

**Pre-deploy checklist — always run through this first:**
1. `now-sdk auth --list` → confirm the correct alias is marked as default
2. Ensure source changes are saved and complete
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
| Auth error mid-deploy | Expired OAuth token | OAuth token refresh requires interactive input — see `references/cli-reference.md` → **auth --add (token refresh)** for the Terminal workaround, then retry deploy. |
| "Could not determine app installation status" | Upload processor returns no tracker ID; SDK's `sys_upgrade_history` poll times out after 30s | `--reinstall` can clear it — but it is **DESTRUCTIVE**: it removes instance metadata not present in the local package, irreversibly. First run `now-sdk transform` to pull current instance state into source, confirm nothing only-on-instance will be lost, then `now-sdk install --auth <alias> --reinstall` (see `../sn-sdk-fluent/references/gotchas.md` #3). |
| Install succeeds but UI shows old code | Build was skipped or stale | Re-run `npm run build` then `npm run deploy` |
| Type-check error blocks build | TypeScript error in source | Fix the error reported — do not bypass |
| Scope conflict on install | Another app owns the scope | Check `sys_app` for conflicting scope, resolve before retrying |

---

### Environment validation
1. Direct user to run `scripts/check-environment.sh --offline` (if in CI) or without flag (to also check connectivity)
2. Interpret the JSON output and explain any failed checks
