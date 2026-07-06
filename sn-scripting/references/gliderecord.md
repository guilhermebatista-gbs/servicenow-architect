# GlideRecord Reference

GlideRecord is the server-side ORM for ServiceNow. All operations run in server-side scripts only — Business Rules, Script Includes, Scheduled Jobs, and REST API scripts. **Never use GlideRecord in Client Scripts** — it is not available in the browser. Use GlideAjax to call a Script Include for server data from a client script.

---

## CREATE

Use `initialize()` before setting fields. `insert()` returns the `sys_id` string on success, `null` on failure.

```javascript
var gr = new GlideRecord('incident');
gr.initialize();
gr.short_description = 'Network connectivity issue';
gr.priority = 2;
var sys_id = gr.insert();  // returns sys_id string on success, null on failure
```

---

## READ — Multiple Records

Always call `query()` before the `while(gr.next())` loop. Use `getValue()` — not direct field access — inside loops.

```javascript
var gr = new GlideRecord('incident');
gr.addQuery('state', 1);
gr.addQuery('priority', '<=', 2);
gr.query();  // Always call query() before next() — without it, the loop body never executes
while (gr.next()) {
    gs.info(gr.getValue('number'));   // CORRECT: getValue(), not gr.number in loops
    gs.info(gr.getValue('sys_id'));   // CORRECT: getValue('sys_id'), not gr.sys_id in loops
}
```

---

## READ — Single Record

Use `get()` with a `sys_id` or with a field/value pair.

```javascript
// By sys_id
var gr = new GlideRecord('incident');
if (gr.get('a1b2c3d4...')) {
    gs.info(gr.getValue('short_description'));
}

// By field value
var gr2 = new GlideRecord('incident');
if (gr2.get('number', 'INC0001234')) {
    gs.info(gr2.getValue('short_description'));
}
```

---

## UPDATE

Get the record first, set fields, then call `update()`.

```javascript
var gr = new GlideRecord('incident');
if (gr.get('number', 'INC0001234')) {
    gr.state = 2;
    gr.update();
}
```

---

## DELETE

Get the record first, then call `deleteRecord()`.

```javascript
var gr = new GlideRecord('incident');
if (gr.get(sys_id)) {
    gr.deleteRecord();
}
```

---

## Query Operators

| Operator | Description | Example |
|---|---|---|
| `=` (default) | Equals | `gr.addQuery('state', 1)` |
| `!=` | Not equal | `gr.addQuery('state', '!=', 6)` |
| `<` | Less than | `gr.addQuery('priority', '<', 3)` |
| `<=` | Less than or equal | `gr.addQuery('priority', '<=', 2)` |
| `>` | Greater than | `gr.addQuery('priority', '>', 1)` |
| `>=` | Greater than or equal | `gr.addQuery('priority', '>=', 2)` |
| `CONTAINS` | String contains substring | `gr.addQuery('short_description', 'CONTAINS', 'network')` |
| `STARTSWITH` | String starts with | `gr.addQuery('number', 'STARTSWITH', 'INC')` |
| `IN` | Value in comma-separated list | `gr.addQuery('state', 'IN', '1,2,3')` |
| `INSTANCEOF` | Record is instance of class | `gr.addQuery('sys_class_name', 'INSTANCEOF', 'incident')` |

---

## Anti-Patterns

These are the most common hallucination traps when generating GlideRecord code. Each will cause silent failures or wrong values.

### Anti-Pattern 1: Direct field access in loops

Direct field access returns a GlideElement object pointer, not the field value. In loops this produces incorrect output.

```javascript
// WRONG — gr.sys_id returns a GlideElement object, not the sys_id string
while (gr.next()) {
    incidents.push(gr.sys_id);
}

// CORRECT — always use getValue() inside loops
while (gr.next()) {
    incidents.push(gr.getValue('sys_id'));
}
```

### Anti-Pattern 2: Missing gr.query() before the loop

Without calling `query()`, the loop body never executes. This is a silent failure with no error.

```javascript
// WRONG — query() is missing; the while loop never runs
var gr = new GlideRecord('incident');
gr.addQuery('state', 1);
while (gr.next()) {
    gs.info(gr.getValue('number'));
}

// CORRECT — always call query() before the while loop
var gr = new GlideRecord('incident');
gr.addQuery('state', 1);
gr.query();
while (gr.next()) {
    gs.info(gr.getValue('number'));
}
```

### Anti-Pattern 3: GlideRecord in a Client Script

GlideRecord is a server-side API. It is not loaded in the browser. Attempting to use it in a Client Script will result in a runtime error (`GlideRecord is not defined`).

```javascript
// WRONG — GlideRecord is not available in client scripts
function onLoad() {
    var gr = new GlideRecord('incident');  // ReferenceError: GlideRecord is not defined
    gr.query();
}

// CORRECT — use GlideAjax to call a Script Include from a client script
function onLoad() {
    var ga = new GlideAjax('MyScriptInclude');
    ga.addParam('sysparm_name', 'getIncidentData');
    ga.getXMLAnswer(function(answer) {
        g_form.setValue('some_field', answer);
    });
}
```

---

## GlideRecord vs GlideRecordSecure

| Class | ACL enforcement | When to use |
|-------|----------------|-------------|
| `GlideRecord` | **Bypasses ACLs** | Background jobs, admin-only scripts, global scope with explicit intent |
| `GlideRecordSecure` | Enforces ACL checks | Scoped apps, any script that runs in user context |

**Rule for scoped apps:** Use `GlideRecordSecure` anywhere the running user's ACL permissions should restrict what records are readable or writable. `GlideRecord` in a scoped app silently bypasses all ACL rules, exposing records the user would not be able to read through the UI.

`GlideRecordSecure` has an identical API to `GlideRecord` — swap the constructor name and all other code remains the same.

```javascript
// In a scoped app Script Include — use GlideRecordSecure
var gr = new GlideRecordSecure('incident');
gr.addQuery('state', 1);
gr.query();
while (gr.next()) {
    gs.info(gr.getValue('number'));  // Only returns records the current user can read
}
```

---

## Common methods beyond CRUD

This reference is a curated subset, not the full platform API (see Hard Rule 5). These are the everyday methods that come up constantly and are safe to use:

| Method | Purpose | Note |
|---|---|---|
| `setLimit(n)` | Cap the number of rows returned | Call before `query()` |
| `orderBy(field)` / `orderByDesc(field)` | Sort results | Call before `query()` |
| `addNullQuery(field)` / `addNotNullQuery(field)` | Match empty / non-empty fields | |
| `addActiveQuery()` | Shortcut for `addQuery('active', true)` | |
| `getDisplayValue(field)` | Display value (reference name, translated choice label) instead of the raw sys_id/value | `getValue()` gives the raw value |
| `getUniqueValue()` | The record's sys_id as a string | Equivalent to `getValue('sys_id')` |
| `getRowCount()` | Row count of an executed query | For counting alone, prefer `GlideAggregate` — far cheaper |
| `hasNext()` | Peek whether another row exists | |
| `setWorkflow(false)` | Skip business rules/engines on the next write | Skips **everything** (rules, notifications, SLAs). Deliberate use only — never a default |
| `autoSysFields(false)` | Don't touch sys_updated_* on the next write | Data-fix scripts only |
| `updateMultiple()` / `deleteMultiple()` | Bulk write/delete for the whole query result | With `updateMultiple()`, set values via `setValue()` and never combine with dot-walked or journal fields |

### Counting: use GlideAggregate

```javascript
var ga = new GlideAggregate('incident');
ga.addQuery('active', true);
ga.addAggregate('COUNT');
ga.query();
var count = ga.next() ? parseInt(ga.getAggregate('COUNT'), 10) : 0;
```

`GlideAggregate` mirrors the GlideRecord query API (`addQuery`, `addEncodedQuery`, `groupBy`) and supports COUNT, SUM, AVG, MIN, MAX — use it whenever you need numbers rather than records.

### Dot-walking reference fields

`getValue()` does **not** dot-walk. To read through a reference, chain the fields and convert explicitly:

```javascript
var company = gr.caller_id.company.getDisplayValue(); // display value through the reference
var companyId = gr.caller_id.company.toString();       // sys_id through the reference
```

Each dot-walk costs a lookup — inside large loops, prefer querying the related table once or using `GlideAggregate`.

### Relative-date queries

Build the filter in the UI (list filter → copy query) and paste it as an encoded query, rather than hand-writing date arithmetic:

```javascript
gr.addEncodedQuery('sys_created_on<javascript:gs.beginningOfLast30Days()');
```

For date math in code, use `GlideDateTime` (see server-side.md).
