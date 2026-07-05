# ServiceNow Fluent — Now Globals

These are special globals available in `.now.ts` files. They are not imported — they are provided by the SDK at compile time.

## Now.ID

```typescript
Now.ID['descriptive_key']
```

Generates a stable, deterministic sys_id for a metadata record. The key must be:
- Unique within your application scope
- A string literal (not a variable)
- Descriptive of the record it identifies

**When to use:** Any metadata constructor that accepts a `$id` field requires `Now.ID`. See `references/metadata-types.md` for which types require it.

**Example:**
```typescript
BusinessRule({
  $id: Now.ID['my_business_rule'],
  name: 'My Rule',
  // ...
})
```

**Do not:** Use `Now.ID` with a dynamic or computed key. It must be a string literal.

---

## Now.include

```typescript
Now.include('./relative/path.ext')
```

Includes the content of an external file as the value of a field. Used to keep server-side scripts, client scripts, and HTML in separate files with proper syntax highlighting.

**When to use:** The `script` field of BusinessRule, ClientScript, ScriptInclude, and RestApi routes. The `html` field of UiPage. Any field that accepts a script string or HTML string may use `Now.include` — the list above covers the most common cases.

**Path:** Relative to the current `.now.ts` file.

**Extension conventions:**
- Server-side scripts: `.server.js`
- Client-side scripts: `.client.js`
- HTML files: `.html`

**Example (server script):**
```typescript
BusinessRule({
  $id: Now.ID['my_rule'],
  name: 'My Rule',
  table: 'x_SCOPE_incident',
  when: 'before',
  script: Now.include('./my_rule.server.js'),
})
```

**Example (client script):**
```typescript
ClientScript({
  $id: Now.ID['onload_incident'],
  // ...
  script: Now.include('./onload_incident.client.js'),
})
```

---

## script tagged template literal

```typescript
script`
  (function process(request, response) {
    response.setBody({ message: 'Hello' })
  })(request, response)
`
```

An alternative to `Now.include` for inline server-side scripts. The `script` tag is a TypeScript tagged template literal that:
- Enables syntax highlighting in IDEs that support it
- Keeps the script inline in the `.now.ts` file
- Is compiled by the SDK the same way as `Now.include`

**When to use:** RestApi route scripts where the script is short and inline is preferable to a separate file.

**Note:** For longer scripts or scripts shared across multiple metadata definitions, prefer `Now.include` with a dedicated `.server.js` file.
