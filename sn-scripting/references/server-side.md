# Server-Side Scripting Reference

Covers Script Includes (Class.create() pattern) and Business Rule script context for server-side ServiceNow scripting.

---

## Script Include — Class.create() Pattern

Use `Class.create()` for all Script Includes. This is the standard ServiceNow OOP pattern for scoped and global applications.

Rules:
- `initialize()` is the constructor — set instance variables here
- The `type` property at the end **must match the Script Include record name** exactly
- The variable name (e.g., `MyUtility`) **must match the Script Include record name** in the ServiceNow platform
- All methods are defined on the `prototype` object

```javascript
var MyUtility = Class.create();
MyUtility.prototype = {
    initialize: function() {
        // constructor — set instance variables here
        this.table = 'incident';
    },
    getActiveIncidents: function(assignee) {
        var incidents = [];
        var gr = new GlideRecord('incident');
        gr.addQuery('state', 'IN', '1,2,3');
        gr.addQuery('assigned_to', assignee);
        gr.query();
        while (gr.next()) {
            incidents.push(gr.getValue('sys_id'));
        }
        return incidents;
    },
    type: 'MyUtility'  // MUST match the Script Include record name in the platform
};
```

---

## Business Rule Script Context

Business Rules run server-side before or after a database operation. The script context provides these pre-defined variables:

| Variable | Type | Description |
|---|---|---|
| `current` | GlideRecord | The record being inserted, updated, or deleted |
| `previous` | GlideRecord | Read-only snapshot of the record **before** the change (update/delete only) |
| `g_scratchpad` | Object | Shared key-value store for passing data from a Business Rule to a Client Script on the same form load |

### Timing

Business Rules fire at specific points in the database lifecycle:

| Timing | Trigger | Description |
|---|---|---|
| `before insert` | On insert | Runs before the record is written to the database |
| `before update` | On update | Runs before the record change is saved |
| `before delete` | On delete | Runs before the record is removed |
| `after insert` | On insert | Runs after the record is saved |
| `after update` | On update | Runs after the record change is saved |
| `after delete` | On delete | Runs after the record is removed |
| `async` | Insert/update | Runs asynchronously after the operation |

### Aborting an Operation

Use `current.setAbortAction(true)` in a **before** rule to prevent the database operation from completing.

```javascript
// Before Business Rule — abort if priority is invalid
if (current.priority < 1 || current.priority > 4) {
    current.setAbortAction(true);
    gs.addErrorMessage('Priority must be between 1 and 4.');
}
```

**Critical:** `current.setAbortAction(true)` only works in `before` rules. Calling it in an `after` rule has no effect.

**Critical:** Do NOT call `current.update()` inside a Business Rule. In a **before** rule the platform writes `current` for you — just set the fields. In an **after/async** rule the record is already saved: changes to `current` are silently lost, and "fixing" that with `current.update()` re-runs the rule stack (recursion). Move record-modifying logic to a before rule; use after/async rules to act on *other* records via their own GlideRecord. See gotchas.md #3 for the full pattern.

---

## GlideSystem (gs) — Logging and User Methods

`gs` (GlideSystem) is available in all server-side scripts.

### Logging

| Method | Description |
|---|---|
| `gs.info(msg)` | Logs at INFO level — visible in system logs |
| `gs.warn(msg)` | Logs at WARN level |
| `gs.error(msg)` | Logs at ERROR level |
| `gs.log(msg, source)` | Legacy logging with optional source label |

### User Context

| Method | Returns | Description |
|---|---|---|
| `gs.getUserID()` | `string` | sys_id of the currently logged-in user |
| `gs.getUserName()` | `string` | Login name (username) of the currently logged-in user |
| `gs.hasRole('role_name')` | `boolean` | Whether the current user has the role (admin always returns true) |

```javascript
// Example: log the current user's login name
gs.info('Script running as user: ' + gs.getUserName());
```

### Other everyday gs methods

| Method | Description |
|---|---|
| `gs.getProperty('name', 'default')` | Read a system property — the right home for configurable values (never hard-code sys_ids/URLs) |
| `gs.addInfoMessage(msg)` / `gs.addErrorMessage(msg)` | Show a message banner to the user on the next form load (UI sessions only — invisible in background jobs) |
| `gs.eventQueue('event.name', current, parm1, parm2)` | Fire a registered event (drives notifications and script actions) — the event must exist in the Event Registry |
| `gs.nil(value)` | True if null, undefined, or empty string — safer than truthiness checks on GlideElements |

### Dates: GlideDateTime

```javascript
var gdt = new GlideDateTime();          // now
gdt.addDaysUTC(-30);                    // 30 days ago
gr.addQuery('sys_created_on', '<', gdt); // usable directly in queries
```

For relative-date filters, building the query in the UI and copying the encoded query is the most reliable route (see gliderecord.md).

This gs list is a curated subset (Hard Rule 5 applies): never invent `gs.*` method names; if you need something not listed, confirm it in the official GlideSystem docs and say so.
