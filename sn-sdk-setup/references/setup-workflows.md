# ServiceNow SDK — Setup Workflows

All `now-sdk` commands require the ServiceNow SDK installed globally:

```bash
npm install -g @servicenow/sdk
```

---

## 1. Scaffold New Project (SET-01, SET-04)

Default template: `typescript.basic`

### Non-interactive scaffold:

```bash
now-sdk init --name <project-name> --template <template-name>
```

Example using the default template:

```bash
now-sdk init --name my-app --template typescript.basic
```

Run `now-sdk init --help` to see all available flags for your SDK version.

### All known init templates:

| Template name | Description |
|---|---|
| `typescript.basic` | Default. Server-side TypeScript with Fluent DSL (no UI framework) |
| `typescript.server-side` | Server-side only TypeScript project |
| `typescript.client-side` | Client-side only TypeScript project |
| `typescript.angular-ui-page` | TypeScript with Angular UI page |
| `typescript.react-ui-page` | TypeScript with React UI page (added SDK 4.4.0) |
| `typescript.vue-ui-page` | TypeScript with Vue UI page (added SDK 4.4.0) |

**Note:** Run `now-sdk init --help` to see all available templates and flags for your specific SDK version. SDK 4.4.0 adds front-end framework variants (React, Vue, Svelte, SolidJS).

### What scaffold creates:

- `now.config.json` — project config with scope, scopeId, name, tsconfigPath
- `src/` — TypeScript source tree for Fluent DSL code
- `tsconfig.json` and build config files

### now.config.json schema:

```json
{
  "scope": "x_snc_example_app",
  "scopeId": "2f6400eb87426118f736e28f69d3017a",
  "name": "ExampleApp",
  "tsconfigPath": "./src/server/tsconfig.json"
}
```

> The `scope` field (e.g. `x_snc_example_app`) is used as a prefix throughout Fluent DSL code. Activate the **sn-sdk-fluent** skill for Fluent DSL authoring.

---

## 2. Configure Authentication (SET-02)

Use `now-sdk auth --add` to store credentials under a named alias. Do **not** use `now-sdk auth save` — that command does not exist. Do **not** use `now-sdk login` — that command is deprecated.

### OAuth 2.0 (recommended):

```bash
now-sdk auth --add <instance_url> --type oauth --alias <alias>
```

Example:

```bash
now-sdk auth --add https://dev12345.service-now.com --type oauth --alias dev
```

This starts an interactive OAuth 2.0 flow in your browser. The alias `dev` can then be passed to deploy commands.

### Basic auth:

```bash
now-sdk auth --add <instance_url> --type basic --alias <alias>
```

Example:

```bash
now-sdk auth --add https://dev12345.service-now.com --type basic --alias dev
```

For full flag reference and alias management, read `references/auth-profiles.md`.

### List configured aliases:

```bash
now-sdk auth --list
```

### Use alias in deploy commands:

```bash
now-sdk install --auth dev
```

---

## 3. Convert Existing Application (SET-03)

Full workflow to migrate a legacy ServiceNow application to the Fluent DSL structure:

**Step 1: Initialize from existing app XML**

```bash
now-sdk init --from <path-to-existing-app>
```

This reads the existing app's XML and creates the SDK directory structure.

**Step 2: Transform legacy scripts to Fluent DSL**

```bash
now-sdk transform
```

Converts legacy GlideRecord scripts and business rules to Fluent DSL syntax.

**Step 3: Build the deployment bundle**

```bash
now-sdk build
```

Compiles TypeScript and bundles the app for deployment.

**Step 4: Deploy to instance**

```bash
now-sdk install --auth <alias>
```

Deploys the bundle to your ServiceNow instance. Use the alias configured via `now-sdk auth --add`.

---

## 4. Environment Validation (SET-05)

Run the environment check script before starting SDK work:

```bash
# Full check (includes instance connectivity)
bash scripts/check-environment.sh

# Offline / CI mode (skips connectivity check)
bash scripts/check-environment.sh --offline
```

Output is JSON to stdout with pass/fail per component. Diagnostics go to stderr.

**Example output (all passing):**

```json
{
  "node": {"pass": true, "version": "v20.11.0"},
  "npm": {"pass": true},
  "sdk": {"pass": true, "version": "4.4.0"},
  "config": {"pass": true},
  "auth": {"pass": true, "alias": "dev"},
  "connectivity": {"pass": true, "instance": "https://dev12345.service-now.com"},
  "overall": true
}
```

**Example output (SDK not installed):**

```json
{
  "node": {"pass": true, "version": "v20.11.0"},
  "npm": {"pass": true},
  "sdk": {"pass": false, "error": "not installed"},
  "config": {"pass": false, "error": "now.config.json not found in current directory"},
  "auth": {"pass": false, "error": "sdk not installed"},
  "connectivity": {"pass": false, "error": "no instance URL in now.config.json"},
  "overall": false
}
```

**Overall pass criteria:** `node`, `npm`, and `sdk` must all pass. `config`, `auth`, and `connectivity` are advisory (do not affect `overall`).

**Use `--offline` in CI pipelines** — instance connectivity cannot be checked in CI without VPN/credentials. The `--offline` flag sets `connectivity.pass: true` and `connectivity.instance: "skipped (--offline)"`.
