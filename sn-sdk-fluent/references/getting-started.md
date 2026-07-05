# ServiceNow Fluent — Getting Started

> For full setup workflows including all templates, auth options, and advanced configuration, activate the **sn-sdk-setup** skill.

## Prerequisites

- Node.js v20 or later: https://nodejs.org/
- A ServiceNow instance with the SDK enabled
- Role: **admin** on the target instance

## Creating a New Application

Use the `init` command to scaffold a new application with a guided prompt:

```bash
npx @servicenow/sdk init
```

> Running `npx` executes the SDK's `init` command without a prior global install. After `init` completes, run `npm install` to install the SDK and other `devDependencies` generated in `package.json`.

You'll be prompted for:

| Prompt | Response |
|--------|---------|
| **Select a template** | Choose one (see Templates below) |
| **Name of ServiceNow Application** | Display name, e.g. `Example App` |
| **NPM package name** | Node package name, e.g. `example-app` |
| **Scope name** | Application scope — must begin with `x_<prefix>`, max 18 characters, e.g. `x_snc_example_app` |

### Templates

| Template | Description |
|----------|-------------|
| `now-sdk + basic` | Minimal structure for source code development |
| `JavaScript now-sdk + basic` | ServiceNow Fluent + JavaScript |
| `JavaScript now-sdk + fullstack React` | ServiceNow Fluent + JavaScript + React |
| `TypeScript now-sdk + basic` | ServiceNow Fluent + TypeScript (server files in `src/server/` transpiled to JS) |
| `TypeScript now-sdk + fullstack React` | ServiceNow Fluent + TypeScript + React |

## SDK CLI Commands

| Command | Purpose |
|---------|---------|
| `npx @servicenow/sdk init` | Scaffold a new application with guided prompts |
| `npx @servicenow/sdk init --from <sys_id\|path>` | Convert an existing application to Fluent |
| `now-sdk transform --from <path> --auth <alias>` | Transform XML metadata to Fluent code |
| `now-sdk build` | Compile `.now.ts` files and sync metadata |
| `now-sdk install --auth <alias>` | Install (deploy) the application to a ServiceNow instance |

## Authentication

The SDK uses **auth aliases** — named credential sets stored locally that contain connection details for a ServiceNow instance.

```bash
now-sdk auth --add <instance_url> --type oauth --alias <alias>
```

- Creates a named alias with the instance URL and credentials
- Use `--auth <alias>` flag in commands like `now-sdk install --auth devuser1`
- Aliases avoid hardcoding credentials in scripts

> **Note:** The correct command is `now-sdk auth --add <url>` — not `now-sdk auth save` (does not exist) and not `now-sdk login` (deprecated).

## Scope Name Rules

The scope name (`x_<prefix>`) is used as a prefix on all metadata created by your application:
- Must begin with `x_`
- Maximum 18 characters total
- Must be unique on the instance
- Used as prefix for table names (`x_myapp_tablename`), role names (`x_myapp.rolename`), API names (`x_myapp.ClassName`)

## now.config.json

Created by `npx @servicenow/sdk init`. Controls the application scope:

```json
{
  "scope": "x_snc_example_app",
  "scopeId": "2f6400eb87426118f736e28f69d3017a",
  "name": "ExampleApp",
  "tsconfigPath": "./src/server/tsconfig.json"
}
```

| Field | Description |
|-------|-------------|
| `scope` | Application scope prefix set during `init` |
| `scopeId` | sys_id of the application record in ServiceNow — set after first `now-sdk install` |
| `name` | Application display name |
| `tsconfigPath` | Path to tsconfig for TypeScript modules in `src/server/` |

## First-Run Checklist

1. `npx @servicenow/sdk init` — scaffold the app, answer prompts
2. `npm install` (or `pnpm install`) — install devDependencies
3. Write your first `.now.ts` file in `src/fluent/`
4. `now-sdk build` — compile and validate
5. `now-sdk install --auth <alias>` — deploy to your instance
