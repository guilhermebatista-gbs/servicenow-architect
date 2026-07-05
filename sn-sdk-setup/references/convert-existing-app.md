# ServiceNow SDK — Convert Existing Application

Full reference for converting a legacy ServiceNow application to the Fluent DSL project structure using the 5-step workflow.

For the quick 4-step convert workflow overview, see `setup-workflows.md` section 3.

---

## Step 1: Initialize from Existing App

```bash
npx @servicenow/sdk init --from <sys_id or path> --auth <alias>
```

- `<sys_id>` is the sys_id of the application record from the `sys_app` table in the source ServiceNow instance
- Alternatively, pass a local directory path to an existing XML export
- `--auth <alias>` specifies which instance to connect to for metadata download
- This step creates the project scaffold and downloads the application metadata to `metadata/`

Example:

```bash
npx @servicenow/sdk init --from abc123def456ghij --auth dev
```

The command prompts for a package name unless `--packageName` is passed non-interactively.

---

## Step 2: Install Dependencies

```bash
npm install
```

Run `npm install` immediately after `init` completes. This installs SDK type definitions and build tooling. Without this step, TypeScript compilation fails in Step 4.

> The SDK will display a reminder message if you attempt to build without running `npm install` first.

---

## Step 3: Transform XML to Fluent DSL (Optional)

```bash
now-sdk transform --from metadata/update --auth <alias>
```

This converts downloaded XML metadata files to Fluent DSL `.now.ts` files in `src/`.

### Transform variants

| Flag | Behavior |
|---|---|
| `--from metadata/update` | Convert XML update set files to Fluent DSL |
| `--from metadata` | Convert all downloaded metadata to Fluent DSL |
| `--preview true` | Preview Fluent output without writing files |
| `--format true` | Format generated Fluent code (default: true) |

### When to skip transform

Transform is optional. If you only need to build and deploy the app as-is (without converting to Fluent DSL), skip Step 3 and proceed directly to `now-sdk build`. The XML metadata files in `metadata/` will be used.

---

## Step 4: Build

```bash
now-sdk build
```

Compiles the Fluent DSL TypeScript source (or XML metadata) to a deployable bundle in `dist/app/`. Fix any TypeScript errors before proceeding to Step 5.

---

## Step 5: Install to Instance

```bash
now-sdk install --auth <alias>
```

Deploys the compiled application to the target ServiceNow instance. Use `--auth` to specify which instance to deploy to.

---

## Critical Gotchas

### **Critical gotcha: XML takes precedence over source code**

When both XML metadata files (in `metadata/`) AND Fluent DSL source files (`.now.ts` in `src/`) exist for the same metadata:

- `now-sdk build` uses the `.now.ts` source files
- `now-sdk install` installs the compiled source
- **BUT** if you re-run `now-sdk transform` after editing source, it will **overwrite** your `.now.ts` source with XML

**Rule:** After running transform and editing the generated `.now.ts` files, do not re-run transform. If you must re-run transform, back up your edits first. Alternatively, delete the XML source files from `metadata/` after transformation is complete to prevent accidental overwrites.

### **Critical gotcha: Limited types cannot be converted to Fluent**

The following metadata types are **not** converted to Fluent DSL by `now-sdk transform`. They remain as XML in `metadata/` after transformation:

- `sys_metadata_link` — Metadata Snapshots
- `sys_ux_lib_asset` — UX Assets

These types are installed from XML automatically. You cannot author them in Fluent DSL syntax.

### **Gotcha: JS modules are NOT downloaded by transform**

`now-sdk transform` only downloads and converts Fluent metadata (Business Rules, Script Includes, etc.). JavaScript modules in `src/server/` are **not** downloaded from the instance. You must copy those files manually or recreate them.

### **Gotcha: Scope mismatch causes install failure**

The scope configured in `now.config.json` must match the application scope on the ServiceNow instance. If they differ, `now-sdk install` fails.

Verify the scope in your project config:

```bash
cat now.config.json
```

Or extract just the scope field:

```bash
python3 -c "import json,sys; print(json.load(open('now.config.json'))['scope'])"
```

---

## New Metadata After Conversion

After the initial conversion, when you run `now-sdk transform` without `--from`, new metadata from the instance goes to `src/fluent/generated/`. This is where incremental sync output appears.

The `sys_app` record on the instance will have its Package JSON field set to the path of your project's `package.json` after a successful install.

---

*Cross-reference: For the quick 4-step convert workflow overview, see `setup-workflows.md` section 3.*
