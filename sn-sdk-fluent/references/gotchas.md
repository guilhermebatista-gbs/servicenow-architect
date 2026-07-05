# Fluent SDK Gotchas

SDK-specific patterns that differ from documentation examples or cause silent failures.

## 1. `auth --add`, not `auth save`

- Wrong: `now-sdk auth save devuser1`
- Correct: `now-sdk auth --add https://myinstance.service-now.com --alias devuser1`

`auth save` does not exist. Cross-reference: `sn-sdk-setup/references/auth-profiles.md` for full auth subcommand docs.

## 2. XML takes precedence over source code

If the same metadata exists as both XML (in `metadata/`) and `.now.ts` (in `src/fluent/`), the XML version wins on `now-sdk install`.

Always run `now-sdk transform` before `now-sdk build` on converted apps to avoid deploying stale XML over Fluent source.

## 3. `--reinstall` destroys instance metadata (DESTRUCTIVE)

> **WARNING:** `now-sdk install --reinstall` removes ALL metadata on the instance that is not in the local package. This is irreversible. Never use without first running `transform` to pull current instance state into source.

`--reinstall` is a boolean flag — no value argument. `--reinstall true` is a CLI parse error.

## 4. `Now.ID` can only define, not reference

`Now.ID['key']` creates a stable sys_id for a metadata object within the current file only. To share it across files in your app, assign it to a `const` and import that variable. `Now.ID` cannot reference metadata defined in another `.now.ts` file.

## 5. `Now.ref` for cross-app references

To reference metadata from another application not in your source code, use `Now.ref('table_name', { column: value })`.

Example: `Now.ref('sys_user_role', { name: 'admin' })` — references the admin role from global without importing it.

## 6. JS modules are NOT downloaded by `transform`

`now-sdk transform` downloads only Fluent/XML metadata. JavaScript/TypeScript files in `src/server/` are not downloaded from the instance — they exist only in your local repository.

## 7. `-now:` import prefix, not `@now:`

- Correct: `import { role } from '-now:global/security'`
- Wrong: `import { role } from '@now:global/security'`

The prefix is a dash (`-now:`), not an at-sign. `@now:` will cause a module resolution error.

## 8. `package.json` `imports` config required for `-now:`

Without this entry in `package.json`, `-now:` imports fail to resolve at build time:

```json
"imports": {
  "-now:*": "./@types/servicenow/fluent/*/index.js"
}
```

Run `now-sdk dependencies` first to populate `@types/servicenow/`, then add this config.

## 9. Some metadata types cannot be Fluentified

`sys_metadata_link` (Metadata Snapshots) and `sys_ux_lib_asset` (UX Assets) cannot be converted to Fluent DSL.

After `transform`, these types remain as XML in `metadata/`. This is expected behavior, not an error.

## 10. `npx @servicenow/sdk` vs `now-sdk`

When the SDK is installed locally (not globally), use `npx @servicenow/sdk <command>` instead of `now-sdk <command>`.

If `now-sdk: command not found` appears, switch to the npx form: `npx @servicenow/sdk build`, `npx @servicenow/sdk install`, etc.

## 11. Browser globals blocked in widget `clientScript`

The build plugin enforces `no-restricted-globals` in widget `clientScript` files. Only two globals are allowed: `console` and `fetch`.

Blocked globals: `window`, `setInterval`, `clearInterval`, `setTimeout`, `clearTimeout`, `document`, and all other browser globals. Use Angular services injected via `$scope` instead: `$timeout`, `$interval`, etc.

Source: `@servicenow/sdk-build-plugins/src/repack/lint/Rules.ts` — `globalsAllowList = ['console', 'fetch']`

## 12. `clientScript` pattern — two forms accepted

The build plugin validates that `clientScript` content matches `/^(function|api\.controller\s?=\s?function)/`.

Both forms are valid: `api.controller = function($scope) { ... }` (preferred) and `function($scope) { ... }`. The build error fires only if the script starts with neither. Named function declarations (`function myCtrl()`) or arrow functions (`($scope) => {}`) will fail.

---
*Related: `sn-sdk-setup/references/auth-profiles.md` for auth command details. `references/cli-reference.md` for full build/install/transform flag reference.*
