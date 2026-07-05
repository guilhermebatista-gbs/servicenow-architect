# CLI Reference — sn-sdk-fluent

> This file covers build-phase commands: `build`, `install`, `transform`, `clean`, and `pack`. For setup-phase commands (auth, init, dependencies, download), see `sn-sdk-setup/references/cli-reference.md`.

## now-sdk build

Compiles `.now.ts` files and JavaScript modules into XML metadata installable on a ServiceNow instance.

```bash
now-sdk build [source] [--frozenKeys <true|false>]
```

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `source` | path | current directory | Source directory to build |
| `--frozenKeys` | boolean | `false` | CI mode: validates that `src/fluent/generated/keys.ts` is up to date. Fails the build if keys are stale. Do not use in local development. |

Build output goes to `dist/app/`. XML metadata is written to `dist/app/update/`.

Examples:

```bash
now-sdk build                    # build current directory
now-sdk build ./my-app           # build specific directory
now-sdk build --frozenKeys true  # CI mode — fails if keys.ts is stale
```

## now-sdk install

Installs the built application onto a ServiceNow instance.

```bash
now-sdk install [--auth <alias>] [--reinstall <true|false>]
```

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--auth <alias>` | string | - | Auth alias to use (from `now-sdk auth --add`) |
| `--reinstall` | boolean | `false` | **DESTRUCTIVE.** Removes ALL metadata on the instance not in the local package before installing. |

> **WARNING:** `--reinstall true` removes ALL application metadata from the instance that is not present in your local package. This cannot be undone. Only use after running `now-sdk transform` to ensure your local package is complete. Never use on a production instance.

**When to use `--reinstall` for error recovery:**
If `now-sdk install` fails with `"Could not determine app installation status"`, use `--reinstall` to recover:
```bash
now-sdk install --auth dev --reinstall
```
This happens when the upload processor doesn't return a tracker ID and the SDK's `sys_upgrade_history` poll times out after 30s. `--reinstall` uninstalls the existing app first, then reinstalls cleanly via a path that succeeds. Safe to use on PDI instances where local source and instance are in sync.

CI/CD — use environment variables instead of `--auth` in pipelines:

```bash
export SN_SDK_INSTANCE_URL=https://myinstance.service-now.com
export SN_SDK_USER=admin
export SN_SDK_USER_PWD=password
export SN_SDK_NODE_ENV=SN_SDK_CI_INSTALL
now-sdk install
```

## now-sdk transform

Downloads XML metadata from a ServiceNow instance and converts it to Fluent DSL `.now.ts` files.

```bash
now-sdk transform [--from <path>] [--auth <alias>] [--preview <true|false>] [--format <true|false>]
```

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--from <path>` | path | - | Source XML directory (e.g., `metadata/update`). Omit to download from instance. |
| `--auth <alias>` | string | - | Auth alias for instance connection |
| `--preview` | boolean | `false` | Preview Fluent output without writing files |
| `--format` | boolean | `true` | Format the generated Fluent code |

Note: JS modules in `src/server/` are NOT downloaded by transform. See `references/gotchas.md` Gotcha 6. New Fluent output goes to `src/fluent/generated/`.

## now-sdk clean

Removes build artifacts from the `dist/` directory.

```bash
now-sdk clean
```

No flags. Run before a fresh build to clear stale artifacts. Does not affect source files or instance metadata.

## now-sdk pack

Packages build artifacts into an installable ZIP file.

```bash
now-sdk pack
```

No flags. Run after `now-sdk build`. Output ZIP can be imported manually via ServiceNow Studio or the Update Sets import UI.

---
*Cross-reference: For setup-phase commands (auth, init, dependencies, download), see `sn-sdk-setup/references/cli-reference.md`.*
*Cross-reference: For --reinstall and XML precedence gotchas, see `references/gotchas.md`.*
