# ServiceNow SDK — Auth Profiles

Complete reference for configuring and managing authentication profiles with the `now-sdk auth` command.

For the step-by-step auth workflow (what order to run commands), see `setup-workflows.md` section 2.

---

## Auth Command Structure

The auth command uses subcommand flags (not positional subcommands):

```bash
now-sdk auth --add <instance_url> [--type basic|oauth] [--alias <name>]
```

> **Important:** `now-sdk auth save` does **not** exist. The correct command is `now-sdk auth --add`.

---

## Auth Subcommands

| Subcommand | Structure | Description |
|---|---|---|
| `--add` | `auth --add <url> [--type basic\|oauth] [--alias <name>]` | Store credentials in device keychain |
| `--delete` | `auth --delete <alias>` or `auth --delete all` | Remove saved credentials |
| `--list` | `auth --list` | View saved aliases (no passwords returned) |
| `--use` | `auth --use <alias>` | Set default credentials for all commands |

---

## Authentication Types

### Basic Auth

Store username and password credentials:

```bash
now-sdk auth --add https://myinstance.service-now.com --type basic --alias dev
```

If `--type` is omitted, `basic` is the default. When using basic auth non-interactively, credentials can be passed via flags (consult `now-sdk auth --help` for exact flag names in your SDK version).

### OAuth 2.0 (Recommended)

Start an OAuth 2.0 flow:

```bash
now-sdk auth --add https://myinstance.service-now.com --type oauth --alias dev
```

OAuth is preferred — credentials are not stored in plaintext.

**Version requirements for OAuth:**
- Requires ServiceNow IDE v1.1 or later installed on the instance
- Australia release and later includes IDE v1.1.4 by default — OAuth works out of the box
- Pre-Australia instances need the ServiceNow IDE plugin installed manually before OAuth can be used

---

## Named Aliases

An alias is a short name you choose (e.g., `dev`, `prod`, `sandbox`) to reference a saved credential profile.

### Add an alias

```bash
now-sdk auth --add https://dev12345.service-now.com --type oauth --alias dev
now-sdk auth --add https://prod99999.service-now.com --type oauth --alias prod
```

### List all aliases

```bash
now-sdk auth --list
```

Returns alias names only — passwords and OAuth tokens are not returned.

### Set a default alias

```bash
now-sdk auth --use dev
```

After this, commands that require auth will use `dev` unless overridden with `--auth`.

### Delete an alias

```bash
now-sdk auth --delete dev
now-sdk auth --delete all
```

---

## Using `--auth` Across Commands

All commands that connect to an instance accept `--auth <alias>`:

```bash
now-sdk init --from <sys_id> --auth dev
now-sdk transform --from metadata/update --auth dev
now-sdk install --auth prod
now-sdk dependencies --auth dev
```

If `--auth` is omitted and only one alias is configured (or a default is set via `--use`), that alias is used automatically.

---

## Credential Storage

- Credentials are stored in the **device keychain or credential manager** (e.g., macOS Keychain, Windows Credential Manager)
- Credentials are **not** stored in the project directory
- Do **not** commit credential files to git — they are not in the project directory by default, but review your `.gitignore` to confirm

---

## Multiple Instance Management

Pattern: save one alias per environment, then pass `--auth <alias>` to each command:

```bash
# Setup
now-sdk auth --add https://dev12345.service-now.com --type oauth --alias dev
now-sdk auth --add https://staging99.service-now.com --type oauth --alias staging
now-sdk auth --add https://prod99999.service-now.com --type oauth --alias prod

# Use per command
now-sdk build
now-sdk install --auth staging   # deploy to staging
now-sdk install --auth prod      # deploy to prod
```

No environment variable switching is needed — the `--auth` flag is the mechanism for switching contexts.

---

## CI/CD Authentication (Non-Interactive)

For CI pipelines where interactive credential entry is not possible, use environment variables instead of aliases:

```bash
export SN_SDK_INSTANCE_URL=https://myinstance.service-now.com
export SN_SDK_USER=admin
export SN_SDK_USER_PWD=password
export SN_SDK_NODE_ENV=SN_SDK_CI_INSTALL
```

When these variables are set, `now-sdk install` uses them without requiring a saved alias.

---

*Cross-reference: For the step-by-step auth workflow, see `setup-workflows.md` section 2.*
