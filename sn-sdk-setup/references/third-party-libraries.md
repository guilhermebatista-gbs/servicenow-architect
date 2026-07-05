## Adding a Package

Run `npm install <package>` from the project root — same as standard npm workflow. The SDK bundles dependencies into the output artifact at build time.

## Using in Fluent DSL

Import third-party packages using standard ES module syntax inside `.now.ts` files:

```typescript
import { parseISO } from 'date-fns';
```

The SDK bundler resolves and includes the package in the compiled output.

## Supported Library Constraints

Not all npm packages are compatible with the ServiceNow runtime. Constraints to check before adding a dependency:

- **No Node.js built-in APIs**: Libraries must not depend on `fs`, `http`, `https`, `net`, `child_process`, `os`, `path`, or other Node.js core modules — these are not available in ServiceNow's server-side runtime.
- **ECMAScript compatibility**: ServiceNow's runtime supports ES2019 or lower. Libraries that use ES2020+ features (optional chaining, nullish coalescing, BigInt, etc.) may fail at runtime even if they pass TypeScript compilation.
- **No native addons**: Libraries that include C++ bindings (`.node` files) will not work — ServiceNow is not a Node.js process.
- **Pure JS/TS data libraries are generally safe**: Libraries that operate on data structures (parsing, formatting, validation, cryptography in pure JS) are the best candidates.

## Checking Compatibility

Run `now-sdk build` after installing a package. TypeScript errors and unsupported API usage surface during the build step. Runtime failures (e.g., use of `process` or `Buffer`) may only appear at execution time on the instance.

## ServiceNow Application Dependencies vs npm Packages

The `dependencies` field in `now.config.json` is for **ServiceNow application dependencies** — other SN apps that must be installed on the instance before this app can run. It is not for npm packages.

npm packages are managed through `package.json` and resolved by the SDK bundler. They do not need to be listed in `now.config.json`.

## Downloading ServiceNow Dependencies

```bash
now-sdk dependencies download --auth <alias>
```

Pulls ServiceNow application dependencies (listed in `now.config.json` under `dependencies`) from the connected instance. Required when the project depends on types or APIs from another SN application.
