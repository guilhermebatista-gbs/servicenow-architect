# Client-Side Scripting Reference

**GlideRecord is a SERVER-SIDE API. It is not available in Client Scripts. To access server data from a client script, use GlideAjax to call a Script Include.**

Client Scripts run in the user's browser. The available global objects are provided by the ServiceNow form/list framework — not the server-side Rhino engine.

---

## g_form — Form Manipulation API

`g_form` is available in **onLoad**, **onChange**, and **onSubmit** Client Scripts attached to form views.

Note: `g_form` is **not** available in List Client Scripts — use `g_list` instead.

### Key Methods

| Method | Signature | Description |
|---|---|---|
| `getValue` | `g_form.getValue(fieldName)` → `string` | Returns the current value of a field |
| `setValue` | `g_form.setValue(fieldName, value)` | Sets the value of a field |
| `setMandatory` | `g_form.setMandatory(fieldName, mandatory)` | Makes a field required (`true`) or optional (`false`) |
| `setVisible` | `g_form.setVisible(fieldName, visible)` | Shows (`true`) or hides (`false`) a field |
| `setReadOnly` | `g_form.setReadOnly(fieldName, readOnly)` | Makes a field read-only (`true`) or editable (`false`) |
| `addErrorMessage` | `g_form.addErrorMessage(message)` | Displays an error banner at the top of the form |
| `clearMessages` | `g_form.clearMessages()` | Removes all error/info messages from the form |
| `showFieldMsg` | `g_form.showFieldMsg(fieldName, message, type)` | Shows an inline message below a field; `type` is `'error'`, `'info'`, or `'warning'` |

```javascript
// Example: onChange handler — make resolution_notes mandatory when state = Resolved
function onChange(control, oldValue, newValue, isLoading) {
    if (isLoading) return;
    if (newValue == '6') {  // 6 = Resolved
        g_form.setMandatory('close_notes', true);
        g_form.showFieldMsg('close_notes', 'Resolution notes required to close this incident.', 'info');
    } else {
        g_form.setMandatory('close_notes', false);
        g_form.clearMessages();
    }
}
```

---

## g_user — Current User Information

`g_user` is available in **all** Client Script types (onLoad, onChange, onSubmit, List).

### Properties

| Property | Type | Description |
|---|---|---|
| `g_user.userID` | `string` | sys_id of the currently logged-in user |
| `g_user.userName` | `string` | Login name (username) of the currently logged-in user |
| `g_user.firstName` | `string` | First name of the currently logged-in user |
| `g_user.lastName` | `string` | Last name of the currently logged-in user |

### Methods

| Method | Signature | Returns | Description |
|---|---|---|---|
| `hasRole` | `g_user.hasRole(roleName)` | `boolean` | Returns `true` if the current user has the specified role |

```javascript
// Example: hide a field from non-admin users
function onLoad() {
    if (!g_user.hasRole('admin')) {
        g_form.setVisible('internal_notes', false);
    }
    // g_user.userID   — sys_id of current user
    // g_user.userName — login name of current user
}
```

---

## g_list — List Manipulation API

`g_list` is available in **List Client Scripts only** — it is not available in Form Client Scripts.

### Methods

| Method | Returns | Description |
|---|---|---|
| `g_list.getTableName()` | `string` | Returns the name of the table the list is displaying |
| `g_list.getListName()` | `string` | Returns the name of the list (view name) |

Note: `g_form` is not available in List Client Scripts. Use `g_list` instead.

---

## GlideAjax — Accessing Server Data from a Client Script

When you need server-side data in a client script, use GlideAjax to call a Script Include asynchronously. Do **not** attempt to use GlideRecord — it will throw a `ReferenceError` at runtime.

The Script Include must have `Client callable` checked in the platform record.

```javascript
// Pattern: call a Script Include method from a client script
function onLoad() {
    var ga = new GlideAjax('MyScriptInclude');
    ga.addParam('sysparm_name', 'getAssigneeData');
    ga.addParam('sysparm_user_id', g_user.userID);
    ga.getXMLAnswer(function(answer) {
        // answer is the string returned by the Script Include method
        if (answer) {
            g_form.setValue('assignment_group', answer);
        }
    });
}
```
