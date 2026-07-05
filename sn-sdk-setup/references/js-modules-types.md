## JS Modules in the SDK

The SDK supports two source directories alongside the Fluent DSL files:

- `src/server/` — Server-side TypeScript or JavaScript modules (Script Includes). These run on the ServiceNow instance and can be called from Fluent workflows.
- `src/client/` — Client-side scripts that execute in the browser (UI Actions, Client Scripts).

Fluent DSL files live directly under `src/` as `.now.ts` files. The `src/server/` and `src/client/` directories are for plain TS/JS modules that complement the Fluent DSL.

## TypeScript in src/server/

To enable TypeScript compilation for server-side modules, add to `now.config.json`:

```json
{
  "tsconfigPath": "./src/server/tsconfig.json"
}
```

Create `src/server/tsconfig.json` with:

```json
{
  "compilerOptions": {
    "module": "es2022",
    "target": "es2022",
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "noEmit": true,
    "strict": true
  }
}
```

Key options: `module` and `target` set to `es2022`, `moduleResolution` set to `bundler`, `allowImportingTsExtensions` enabled (required for cross-file imports), and `noEmit` set to `true` (the SDK handles output, not tsc).

## Cross-File Imports Must Include .ts Extension

When importing from another TypeScript file in `src/server/`, include the `.ts` extension explicitly:

```typescript
// Correct
import { myHelper } from './helpers.ts';

// Wrong — will fail with moduleResolution: bundler + allowImportingTsExtensions
import { myHelper } from './helpers';
```

## Inline Scripts Must Use require()

Scripts embedded inline (e.g., in Script Include body fields) must use `require()` — not ES module `import` syntax. ES module `import` is only valid in `.now.ts` Fluent DSL files and `src/server/` TypeScript files processed by the SDK bundler.

## Module Scope Restrictions

Modules can only access global ServiceNow APIs or objects within the same scope. Cross-scope access requires explicit dependency declarations in `now.config.json`. A module cannot call APIs from another application scope unless that scope is listed as a dependency.

## @servicenow/glide Type Definitions

The `@servicenow/glide` package provides TypeScript types for platform APIs:

```bash
npm install @servicenow/glide
```

This provides types for `GlideRecord`, `GlideSystem` (`gs`), `GlideElement`, and other platform globals. These types are for **IDE autocomplete and compile-time type checking only** — they do not import runtime code. The ServiceNow runtime provides these APIs natively on the instance.

After installing, types are available in `node_modules/@servicenow/glide/`. Reference them in `src/server/tsconfig.json` via `typeRoots` or `types`.

## Importing src/server/ Modules from Fluent DSL

Server-side modules written in `src/server/` are imported in Fluent DSL files using the scope-prefixed module ID pattern. The exact import path is determined by the application scope defined in `now.config.json`.
