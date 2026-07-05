# ServiceNow Scripting Gotchas

> **Note:** gliderecord.md Anti-Patterns 1-3 cover the field-pointer loop issue (use `getValue()`), missing `query()`, and GlideRecord in client scripts. This file covers additional traps not addressed there.

---

## Gotcha 1: `addQuery` vs `addEncodedQuery` confusion

AI frequently conflates these two methods. They accept different argument forms and are not interchangeable.

**Wrong — treating an encoded query string as addQuery arguments:**
```javascript
// WRONG — addQuery does not parse an encoded query string
gr.addQuery("state=1^priority=1");
```

**Wrong — using addEncodedQuery to build a programmatic condition:**
```javascript
// WRONG — addEncodedQuery is for pre-built strings, not programmatic triplets
gr.addEncodedQuery("state", 1);
```

**Correct usage side by side:**
```javascript
// CORRECT — addEncodedQuery: use when you have a query string from a List View filter URL
var gr = new GlideRecord('incident');
gr.addEncodedQuery("state=1^priority=1^active=true");
gr.query();

// CORRECT — addQuery: use when building conditions programmatically in code
var gr2 = new GlideRecord('incident');
gr2.addQuery('state', 1);
gr2.addQuery('priority', '<=', 2);
gr2.query();
```

**Rule:** If you have a query string copied from a URL or filter breadcrumb, use `addEncodedQuery`. If building conditions with field names and values in code, use `addQuery('field', 'operator', 'value')`.

---

## Gotcha 2: Bare `setAbortAction(true)` in Business Rules

AI frequently omits the `current.` receiver, generating a bare function call that does not exist.

**Wrong:**
```javascript
// WRONG — setAbortAction is not a global function; this is a ReferenceError
setAbortAction(true);
```

**Correct:**
```javascript
// CORRECT — setAbortAction is a method on the current GlideRecord
current.setAbortAction(true);
```

`setAbortAction` is a method on the `current` GlideRecord object in Business Rules. Calling it without a receiver throws a `ReferenceError`. See server-side.md for the full Business Rule current object API.

---

## Gotcha 3: `current.update()` inside a Business Rule causes infinite loop

Calling `current.update()` inside a Business Rule re-triggers that same Business Rule, creating infinite recursion.

**Wrong:**
```javascript
// WRONG — inside an "after" Business Rule; this triggers the rule again
current.state = 2;
current.update();  // infinite loop
```

**Correct:**
```javascript
// CORRECT — Business Rules do not need current.update(); the platform saves current automatically
current.state = 2;
// No update() call needed — the platform commits current after the rule completes
```

**Rule:** Never call `current.update()` inside a Business Rule. The platform automatically saves `current` after rule execution completes. Use `current.update()` only in Script Includes or background scripts operating on records other than `current`. If you must update inside a rule, add a condition guard (e.g., check a flag on `current` to prevent re-triggering).

---

## Gotcha 4: `g_form` in background scripts or Script Includes

AI occasionally uses `g_form` in server-side contexts where it cannot exist.

**Wrong:**
```javascript
// WRONG — g_form does not exist in server-side scripts
// Business Rule, Script Include, Background Script — none of these have g_form
var value = g_form.getValue('priority');  // ReferenceError: g_form is not defined
g_form.setMandatory('category', true);
```

**Correct:**
```javascript
// CORRECT — g_form is only available in client-side execution contexts:
// Client Scripts (onLoad, onChange, onSubmit), UI Policies (client-side), UI Actions (client-side)
function onLoad() {
    var value = g_form.getValue('priority');  // valid here
    g_form.setMandatory('category', true);    // valid here
}
```

See client-side.md for full `g_form` API documentation and scope restrictions.

---

## Gotcha 5: Inventing non-existent GlideRecord methods

AI frequently generates plausible-sounding method names that do not exist in the GlideRecord API.

**Wrong — methods that do not exist:**
```javascript
gr.getField('field_name');    // does not exist
gr.setQuery('active=true');   // does not exist
gr.addOrder('name');          // does not exist — use orderBy()
gr.getTableName();            // does not exist — use getRecordClassName()
```

**Correct — documented methods:**
```javascript
gr.getValue('field_name');         // read a field value as string
gr.setValue('field_name', val);    // set a field value
gr.addQuery('field', 'op', val);   // add a query condition
gr.addEncodedQuery('state=1');     // add a pre-built encoded query
gr.orderBy('name');                // sort ascending
gr.orderByDesc('sys_created_on'); // sort descending
gr.getRecordClassName();           // returns the table name (e.g. 'incident')
```

**Rule (SKILL.md Hard Rule 5):** Only use GlideRecord methods documented in gliderecord.md. If a method name is not listed there, do not use it — ask for the correct method instead of guessing.
