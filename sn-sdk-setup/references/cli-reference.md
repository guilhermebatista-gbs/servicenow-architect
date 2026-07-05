# CLI Reference — sn-sdk-setup

> **Scope note:** This file covers setup-phase commands: `auth`, `init`, `dependencies`, and `download`. For build, install, transform, clean, and pack commands, see `sn-sdk-fluent/references/cli-reference.md`.

---

## now-sdk auth

Auth subcommands use flags, not positional arguments. The command structure is:

```bash
now-sdk auth --add <instance_url> [--type basic|oauth] [--alias <name>]
```

> **Important:** `now-sdk auth save` does **not** exist. The correct command is `now-sdk auth --add`.

### auth --add

Store credentials in the device keychain or credential manager (macOS Keychain, Windows Credential Manager — not `~/.snc/`).

| Flag | Type | Description |
|------|------|-------------|
| `--add <url>` | string | Instance URL (required) |
| `--type` | string | `basic` or `oauth` (default: `basic`) |
| `--alias <name>` | string | Name for this credential profile (e.g., `dev`, `prod`) |

```bash
now-sdk auth --add https://dev12345.service-now.com --type oauth --alias dev
now-sdk auth --add https://myinstance.service-now.com --type basic --alias prod
```

### auth --list

List all saved aliases (passwords are not returned):

```bash
now-sdk auth --list
```

### auth --use

Set the default alias for all subsequent commands:

```bash
now-sdk auth --use dev
```

### auth --add (token refresh)

Re-running `--add` with the same alias **overwrites** the existing credential — this is how OAuth tokens are refreshed (there is no `--refresh` flag):

```bash
now-sdk auth --add https://dev12345.service-now.com --type oauth --alias dev
```

> **Claude Code note:** OAuth requires interactive terminal input (browser login + paste code). Claude Code's terminal cannot handle this. Open a new Terminal window instead:
> ```bash
> osascript -e 'tell app "Terminal" to do script "now-sdk auth --add https://dev12345.service-now.com --type oauth --alias dev"'
> ```
> On Linux/WSL: run the command directly in your own terminal.

### auth --delete

Remove a saved credential profile:

```bash
now-sdk auth --delete dev
now-sdk auth --delete all
```

### CI/CD Authentication (Non-Interactive)

For CI pipelines, use environment variables instead of saved aliases:

```bash
export SN_SDK_INSTANCE_URL=https://myinstance.service-now.com
export SN_SDK_USER=admin
export SN_SDK_USER_PWD=password
export SN_SDK_NODE_ENV=SN_SDK_CI_INSTALL
```

When these variables are set, `now-sdk install` uses them without requiring a saved alias.

---

## now-sdk init

Scaffolds a new SDK project in the current directory using a template.

| Flag | Type | Description |
|------|------|-------------|
| `--template <name>` | string | Template name (default: `typescript.basic`). See `init-templates.md` for full list. |
| `--appName <name>` | string | Application display name |
| `--packageName <name>` | string | npm package name (lowercase, hyphenated) |
| `--scopeName <name>` | string | ServiceNow scope prefix (e.g., `x_myco_myapp`) — max 18 chars |
| `--auth <alias>` | string | Auth alias for instance connection |
| `--from <sys_id or path>` | string | Initialize from existing app (sys_id or local path) |

Fully non-interactive example:

```bash
npx @servicenow/sdk init \
  --template typescript.basic \
  --appName "My Workflow App" \
  --packageName my-workflow-app \
  --scopeName x_myco_myapp \
  --auth dev
```

Initialize from existing app:

```bash
now-sdk init --from abc123def456 --auth dev
```

**After init: always run `npm install` before `now-sdk build`.**

---

## now-sdk dependencies

Downloads ServiceNow app dependencies and type definitions from an instance.

| Subcommand | Description |
|---|---|
| `dependencies` | Download all dependencies listed in now.config.json |
| `dependencies --fluent-only` | Download only Fluent DSL type definitions |
| `dependencies --type-defs-only` | Download only TypeScript type definitions (to `@types/servicenow/`) |
| `dependencies --add <type> <sys_ids>` | Add a dependency and download it |

```bash
# Download all dependencies
now-sdk dependencies --auth dev

# Add specific dependencies
now-sdk dependencies --add tables incident problem --auth dev
now-sdk dependencies --add roles admin --auth dev
now-sdk dependencies --add sys_security_acl "*" --auth dev

# Download type defs only (for TypeScript intellisense)
now-sdk dependencies --type-defs-only --auth dev
```

**After downloading type defs:** update your `tsconfig.json` include array to add the type def paths at `@types/servicenow/`.

### Fluent dependency import format

After running `dependencies`, import Fluent types using the `-now:` prefix (dash, not `@now:`):

```typescript
import { role as globalRole } from '-now:global/security'
import { role as appRole } from '-now:x_myco_myapp/security'
```

**Required package.json imports config** for dep imports to resolve:

```json
"imports": {
  "-now:*": "./@types/servicenow/fluent/*/index.js"
}
```

---

## now-sdk download

Downloads raw XML metadata from a ServiceNow instance (without converting to Fluent DSL).

> **download vs transform:** `download` fetches raw XML only. `transform` converts XML to Fluent DSL `.now.ts` files. Use `transform` (see sn-sdk-fluent) when you want Fluent source code.

```bash
now-sdk download --auth dev
```

---

## Cross-references

For commands that operate on built/installed apps:

- `now-sdk build` — see `sn-sdk-fluent/references/cli-reference.md`
- `now-sdk install` — see `sn-sdk-fluent/references/cli-reference.md`
- `now-sdk transform` — see `sn-sdk-fluent/references/cli-reference.md`
- `now-sdk clean` — removes build artifacts from `dist/`; see sn-sdk-fluent
- `now-sdk pack` — packages build artifacts into installable ZIP; see sn-sdk-fluent

---

*Cross-reference: For full auth workflow steps, see `auth-profiles.md` and `setup-workflows.md` section 2.*
