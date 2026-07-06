# ServiceNow Fluent — Metadata Types

All constructors import from `@servicenow/sdk/core`. Files use the `.now.ts` extension.

**Types that require `$id`:** Acl, BusinessRule, ClientScript, Record, RestApi (and each route), ScriptInclude, UiAction, UiPage, SPWidget, SPTheme, SPMenu, ServicePortal

**Note:** `SPPage` does NOT require `$id` — it uses `pageId` as the URL identifier instead.

## Table of contents

Jump to the one section you need — do not read this file top to bottom.

Platform basics: [Table](#table) · [Record](#record) · [Role](#role) · [Acl](#acl) · [BusinessRule](#businessrule) · [ClientScript](#clientscript) · [UiAction](#uiaction) · [ScriptInclude](#scriptinclude) · [RestApi](#restapi) · [UiPage](#uipage) · [UIPolicy](#uipolicy) · [ApplicationMenu](#applicationmenu)

Service Portal: [SPWidget](#spwidget) · [SPPage](#sppage) · [SPContainer](#spcontainer) · [SPRow](#sprow) · [SPColumn](#spcolumn) · [SPInstance](#spinstance) · [SPTheme](#sptheme) · [SPMenuItem](#spmenuitem) · [SPMenu](#spmenu) · [ServicePortal](#serviceportal)

Process & data: [Flow](#flow) · [ImportSet](#importset) · [SLA](#sla) · [Workspace](#workspace) · [ATF Test](#atf-test-automatedtestframework)

---

## Table

Defines a database table in ServiceNow.

```typescript
import { Table } from '@servicenow/sdk/core'

export const x_SCOPE_tablename = Table({ ... })
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `name` | `string` | **Yes** | — | Table name — must include scope prefix (e.g. `x_SCOPE_incidents`) |
| `label` | `string` | No | `name` | Display name shown in the UI |
| `extends` | `string` | No | — | Parent table name to extend (e.g. `'task'`) |
| `extensible` | `boolean` | No | `false` | Whether other tables can extend this table |
| `display` | `string` | No | — | The field used as the display value |
| `auto_number.prefix` | `string` | No | — | Prefix for auto-generated numbers (e.g. `'INC'`) |
| `auto_number.number` | `number` | No | — | Starting number |
| `auto_number.number_of_digits` | `number` | No | — | Total digits (zero-padded) |
| `schema` | `Record<string, ColumnType>` | **Yes** | — | Field definitions — see `column-types.md` (sibling file in `references/`) |

**Export the result** so other `.now.ts` files can reference the table in foreign keys and ACLs.

**Example:**
```typescript
import { Table, StringColumn, IntegerColumn, BooleanColumn, DateColumn, DateTimeColumn, ReferenceColumn } from '@servicenow/sdk/core'

export const x_SCOPE_incident = Table({
  name: 'x_SCOPE_incident',
  label: 'My Incident',
  extends: 'task',
  extensible: true,
  auto_number: { prefix: 'MYINC', number: 1000, number_of_digits: 7 },
  schema: {
    short_description: StringColumn({ label: 'Short Description', mandatory: true }),
    priority: IntegerColumn({ label: 'Priority' }),
    active: BooleanColumn({ label: 'Active' }),
    start_date: DateColumn({ label: 'Start Date' }),
    opened_at: DateTimeColumn({ label: 'Opened At' }),
    assigned_to: ReferenceColumn({ label: 'Assigned To', referenceTable: 'sys_user' }),
  },
})
```

---

## Record

Creates a single data record in a table. Requires `$id`.

```typescript
import { Record } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `$id` | `Now.ID` | **Yes** | — | Stable sys_id for this record |
| `table` | `string` | **Yes** | — | Table name to insert the record into |
| `data` | `Record<string, any>` | **Yes** | — | Field values — keys must match column names in the table |

**Example:**
```typescript
Record({
  table: 'x_SCOPE_incident',
  $id: Now.ID['seed_incident_1'],
  data: {
    short_description: 'Initial seed incident',
    priority: 2,
  },
})
```

---

## Role

Defines an application role.

```typescript
import { Role } from '@servicenow/sdk/core'

export const myRole = Role({ ... })
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `name` | `string` | **Yes** | — | Full scoped role name (e.g. `x_SCOPE_.admin`) |

**Export the result** to reference the role in ACL definitions.

**Example:**
```typescript
export const adminRole = Role({ name: 'x_SCOPE_.admin' })
```

---

## Acl

Defines an Access Control List rule. Requires `$id`.

```typescript
import { Acl, Role } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `$id` | `Now.ID` | **Yes** | — | Stable sys_id |
| `localOrExisting` | `'Existing' \| 'Local'` | **Yes** | — | Whether this ACL updates an existing platform ACL or creates a new local one |
| `type` | `'record' \| 'rest_endpoint'` | **Yes** | — | ACL type |
| `operation` | `'create' \| 'read' \| 'write' \| 'delete' \| 'execute'` | **Yes** | — | The operation this ACL controls |
| `table` | `string` | Yes (record) | — | Table the ACL applies to — required when `type` is `'record'` |
| `name` | `string` | Yes (rest) | — | REST endpoint name — required when `type` is `'rest_endpoint'` |
| `roles` | `(Role \| string)[]` | No | — | Roles that satisfy this ACL — can mix exported Role objects and string role names |
| `securityAttribute` | `string` | No | — | Security attribute name that must be true |
| `condition` | `string` | No | — | Condition expression evaluated against the record (e.g. `'active=true'`) |

**Example:**
```typescript
import { Acl, Role } from '@servicenow/sdk/core'
import { adminRole } from './roles.now.ts'

Acl({
  $id: Now.ID['read_acl'],
  localOrExisting: 'Existing',
  type: 'record',
  operation: 'read',
  table: 'x_SCOPE_incident',
  roles: [adminRole, 'itil'],
  condition: 'active=true',
})
```

---

## BusinessRule

Defines a server-side business rule that fires on record events. Requires `$id`.

```typescript
import { BusinessRule } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `$id` | `Now.ID` | **Yes** | — | Stable sys_id |
| `name` | `string` | **Yes** | — | Display name |
| `active` | `boolean` | No | `true` | Whether the rule is active |
| `table` | `string` | **Yes** | — | Table the rule fires on |
| `when` | `'before' \| 'after' \| 'async' \| 'display'` | **Yes** | — | When the rule fires relative to the database operation |
| `script` | `string \| Now.include(...)` | **Yes** | — | The script to execute — use `Now.include('./file.server.js')` for external scripts |
| `insert` | `boolean` | No | `false` | Fire on insert |
| `update` | `boolean` | No | `false` | Fire on update |
| `delete` | `boolean` | No | `false` | Fire on delete |
| `query` | `boolean` | No | `false` | Fire on query |
| `order` | `number` | No | `100` | Execution order — lower numbers run first |

**Example:**
```typescript
BusinessRule({
  $id: Now.ID['set_priority_rule'],
  name: 'Set Default Priority',
  active: true,
  table: 'x_SCOPE_incident',
  when: 'before',
  insert: true,
  script: Now.include('./set_priority_rule.server.js'),
})
```

---

## ClientScript

Defines a client-side script that runs in the browser. Requires `$id`.

```typescript
import { ClientScript } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `$id` | `Now.ID` | **Yes** | — | Stable sys_id |
| `type` | `'onLoad' \| 'onChange' \| 'onSubmit' \| 'onCellEdit'` | **Yes** | — | When the script fires |
| `ui_type` | `'all' \| 'desktop' \| 'mobile'` | **Yes** | — | Which UI the script applies to |
| `table` | `string` | **Yes** | — | Table the script applies to |
| `global` | `boolean` | No | `false` | Whether the script is global or scoped |
| `name` | `string` | **Yes** | — | Script name |
| `active` | `boolean` | No | `true` | Whether the script is active |
| `applies_extended` | `boolean` | No | `false` | Whether the script applies to tables that extend this table |
| `isolate_script` | `boolean` | No | `false` | Whether to run in an isolated scope |
| `script` | `Now.include(...)` | **Yes** | — | The script — MUST use `Now.include('./file.client.js')` (`.client.js` extension) |
| `description` | `string` | No | — | Description |

**Example:**
```typescript
ClientScript({
  $id: Now.ID['onload_incident'],
  type: 'onLoad',
  ui_type: 'all',
  table: 'x_SCOPE_incident',
  global: true,
  name: 'x_SCOPE_onload_incident',
  active: true,
  applies_extended: false,
  isolate_script: false,
  script: Now.include('./onload_incident.client.js'),
})
```

---

## UiAction

Defines a button or link that appears on forms, lists, or workspaces. Requires `$id`.

```typescript
import { UiAction } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `$id` | `Now.ID` | **Yes** | — | Stable sys_id |
| `table` | `string` | **Yes** | — | Table the action applies to |
| `actionName` | `string` | **Yes** | — | Display name |
| `name` | `string` | **Yes** | — | Internal name |
| `active` | `boolean` | No | `true` | Whether the action is active |
| `showInsert` | `boolean` | No | `false` | Show on insert |
| `showUpdate` | `boolean` | No | `false` | Show on update |
| `hint` | `string` | No | — | Tooltip text |
| `condition` | `string` | No | — | Condition expression (e.g. `"current.state == 'open'"`) |
| `script` | `string` | No | — | Server-side script |
| `roles` | `(Role \| string)[]` | No | — | Roles required to see the action |
| `order` | `number` | No | `100` | Display order |
| `showQuery` | `boolean` | No | `false` | Show on query |
| `showMultipleUpdate` | `boolean` | No | `false` | Show for multiple updates |
| `isolateScript` | `boolean` | No | `false` | Isolate script scope |
| `includeInViews` | `string[]` | No | — | View names to include |
| `excludeFromViews` | `string[]` | No | — | View names to exclude |
| `form.showButton` | `boolean` | No | `false` | Show as button on form |
| `form.showLink` | `boolean` | No | `false` | Show as link on form |
| `form.showContextMenu` | `boolean` | No | `false` | Show in form context menu |
| `form.style` | `'primary' \| 'destructive'` | No | — | Button style on form |
| `list.showButton` | `boolean` | No | `false` | Show as button on list |
| `list.showLink` | `boolean` | No | `false` | Show as link on list |
| `list.style` | `'primary' \| 'destructive'` | No | — | Button style on list |
| `list.showContextMenu` | `boolean` | No | `false` | Show in list context menu |
| `list.showListChoice` | `boolean` | No | `false` | Show as list choice |
| `list.showBannerButton` | `boolean` | No | `false` | Show in list banner |
| `list.showSaveWithFormButton` | `boolean` | No | `false` | Show with save on form |
| `workspace.isConfigurableWorkspace` | `boolean` | No | `false` | Show in configurable workspace |
| `workspace.showFormButtonV2` | `boolean` | No | `false` | Show form button (workspace v2) |
| `workspace.showFormMenuButtonV2` | `boolean` | No | `false` | Show form menu button (workspace v2) |
| `workspace.clientScriptV2` | `string` | No | — | Client script for workspace v2 |
| `client.isClient` | `boolean` | No | `false` | Whether this is a client action |
| `client.isUi11Compatible` | `boolean` | No | `false` | Compatible with UI11 |
| `client.isUi16Compatible` | `boolean` | No | `false` | Compatible with UI16 |

> **Nested option groups:** Options prefixed with `form.`, `list.`, `workspace.`, and `client.` are passed as nested objects (e.g. `form: { showButton: true, style: 'primary' }`).

**Example:**
```typescript
UiAction({
  $id: Now.ID['resolve_incident'],
  table: 'x_SCOPE_incident',
  actionName: 'Resolve',
  name: 'resolve_incident',
  active: true,
  showUpdate: true,
  condition: "current.state != 'resolved'",
  form: { showButton: true, style: 'primary' },
  script: `current.state = 'resolved'; current.update();`,
})
```

---

## ScriptInclude

Defines a reusable server-side script class or utility. Requires `$id`.

```typescript
import { ScriptInclude } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `$id` | `Now.ID` | **Yes** | — | Stable sys_id |
| `name` | `string` | **Yes** | — | Class name (e.g. `MyUtility`) |
| `active` | `boolean` | No | `true` | Whether the script include is active |
| `apiName` | `string` | **Yes** | — | Full scoped API name (e.g. `x_SCOPE_.MyUtility`) |
| `script` | `Now.include(...)` | **Yes** | — | The script — use `Now.include('./MyUtility.server.js')` |

**Example:**
```typescript
ScriptInclude({
  $id: Now.ID['my_utility'],
  name: 'MyUtility',
  active: true,
  apiName: 'x_SCOPE_.MyUtility',
  script: Now.include('./MyUtility.server.js'),
})
```

---

## RestApi

Defines a Scripted REST API with multiple routes. Requires `$id` on both the API and each route.

```typescript
import { RestApi } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `$id` | `Now.ID` | **Yes** | — | Stable sys_id for the API |
| `name` | `string` | **Yes** | — | Display name |
| `service_id` | `string` | **Yes** | — | URL path segment (e.g. `my_api` → `/api/x_SCOPE_/my_api`) |
| `consumes` | `string` | **Yes** | — | MIME type consumed (e.g. `'application/json'`) |
| `routes` | `Route[]` | **Yes** | — | Array of route definitions |

> **Note:** Each route object requires its own `$id` — it is not inherited from the parent RestApi `$id`.

**Route options:**

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `$id` | `Now.ID` | **Yes** | — | Stable sys_id for this route |
| `name` | `string` | **Yes** | — | Route name |
| `method` | `'GET' \| 'POST' \| 'PUT' \| 'DELETE' \| 'PATCH'` | **Yes** | — | HTTP method |
| `script` | `string \| Now.include(...) \| tagged template` | **Yes** | — | Route handler — use inline `` script`...` `` tag, `Now.include(...)`, or a direct function reference |
| `relative_path` | `string` | No | `'/'` | URL sub-path relative to the service endpoint (e.g. `'/{sys_id}'`) |

**Example:**
```typescript
RestApi({
  $id: Now.ID['incidents_api'],
  name: 'Incidents API',
  service_id: 'incidents',
  consumes: 'application/json',
  routes: [
    {
      $id: Now.ID['incidents_get'],
      name: 'get',
      method: 'GET',
      script: script`
        (function process(request, response) {
          response.setBody({ message: 'OK' })
        })(request, response)
      `,
    },
  ],
})
```

---

## UiPage

Defines a UI page (sys_ui_page) that serves a custom user interface. Requires `$id`.

```typescript
import { UiPage } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `$id` | `Now.ID` | **Yes** | — | Stable sys_id. Format: `Now.ID['String' or Number]` |
| `endpoint` | `string` | **Yes** | — | URL endpoint — no spaces allowed. Format: `<scope>_<ui_page_name>.do` |
| `description` | `string` | No | — | Description of the UI and its purpose |
| `direct` | `boolean` | No | `false` | When `true`, omits standard HTML/CSS/JavaScript (use for React/custom UI pages that provide their own) |
| `html` | `string \| Now.include(...)` | No | — | Body HTML. Use an alias import from `index.html` for React pages, `Now.include('path/to/file')` for an external file, or an inline string/template literal |
| `category` | `'general' \| 'homepages' \| 'htmleditor' \| 'kb' \| 'cms' \| 'catalog'` | No | — | Type of UI page. `general` for standard pages |
| `clientScript` | `string \| Now.include(...)` | No | — | Client-side script (runs in the browser). Use `Now.include(...)` for external file or inline script string |
| `processingScript` | `string \| Now.include(...)` | No | — | Server-side script (runs on form submit). Use a function from a JS module, `Now.include(...)`, or inline script |
| `$meta` | `object` | No | — | Application metadata options. Supports `installMethod: 'demo' \| 'first install'` |

**Example:**
```typescript
import '@servicenow/sdk/global'
import { UiPage } from '@servicenow/sdk/core'
import indexHtml from '../client/index.html'

UiPage({
  $id: Now.ID['my_page'],
  endpoint: 'x_SCOPE__my_page.do',
  description: 'My Application',
  category: 'general',
  html: indexHtml,
  direct: true,
})
```

---

## UIPolicy

<!-- NOTE: partial - verify against SDK docs -->

Defines a UI Policy that dynamically changes form behavior based on conditions.

```typescript
import { UIPolicy } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `$id` | `Now.ID` | **Yes** | — | Stable sys_id |
| `table` | `string` | **Yes** | — | Table the policy applies to |
| `name` | `string` | **Yes** | — | Display name |
| `active` | `boolean` | No | `true` | Whether the policy is active |
| `conditions` | `string` | No | — | Condition expression that triggers the policy |
| `actions` | `object[]` | No | — | Array of actions: set mandatory, set visible, set readonly, set value |

**Example:**
```typescript
UIPolicy({
  $id: Now.ID['priority_policy'],
  table: 'x_SCOPE_incident',
  name: 'Show Priority on High',
  active: true,
  conditions: "severity=1",
  actions: [
    { field: 'priority', mandatory: true, visible: true, readOnly: false },
  ],
})
```

---

## ApplicationMenu

<!-- NOTE: partial - verify against SDK docs -->

Defines an application menu module for navigation grouping.

```typescript
import { ApplicationMenu } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `name` | `string` | **Yes** | — | Display name |
| `order` | `number` | No | `100` | Display order |
| `roles` | `string[]` | No | — | Roles required to see this menu |

**Example:**
```typescript
ApplicationMenu({
  name: 'x_SCOPE_ Application',
  order: 100,
  roles: ['x_SCOPE_.admin'],
})
```

---

## SPWidget

Defines a Service Portal widget component. Requires `$id`.

```typescript
import { SPWidget } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `$id` | `Now.ID` | **Yes** | — | Stable sys_id |
| `id` | `string` | **Yes** | — | Widget identifier (used to embed the widget) |
| `name` | `string` | **Yes** | — | Display name |
| `htmlTemplate` | `string \| Now.include(...)` | No | — | HTML template (was `template` — wrong) |
| `clientScript` | `string \| Now.include(...)` | No | — | Client controller (MUST start with `api.controller = function($scope)` or `function($scope)`) |
| `serverScript` | `string \| Now.include(...)` | No | — | Server data function script |
| `customCss` | `string \| Now.include(...)` | No | — | Widget CSS (was `css` — wrong) |

**Example:**
```typescript
SPWidget({
  $id: Now.ID['my_widget'],
  id: 'x_SCOPE_-my-widget',
  name: 'My Widget',
  htmlTemplate: Now.include('./my-widget.html'),
  clientScript: Now.include('./my-widget.client.js'),
  serverScript: Now.include('./my-widget.server.js'),
})
```

---

## SPPage

Defines a Service Portal page layout. Does NOT require `$id` — uses `pageId` as the URL identifier.

```typescript
import { SPPage } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `pageId` | `string` | **Yes** | — | URL identifier for the page (e.g. `'x_SCOPE_-home'`). Not `id` — no `$id` required on SPPage |
| `title` | `string` | **Yes** | — | Page display title |
| `containers` | `SPContainer[]` | No | `[]` | Top-level layout sections. Hierarchy: containers → rows → columns → instances |

**Example:**
```typescript
SPPage({
  pageId: 'x_SCOPE_-home',
  title: 'Home',
  containers: [],  // see SPContainer for layout details
})
```

---

## SPContainer

Top-level layout section within an SPPage. Contains rows of columns.

```typescript
import { SPContainer } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `width` | `'container' \| 'container-fluid'` | **Yes** | — | Bootstrap container width |
| `rows` | `SPRow[]` | No | `[]` | Rows within this container |
| `backgroundStyle` | `string` | No | — | CSS background style |
| `backgroundColor` | `string` | No | — | Background color value |

**Example:**
```typescript
SPContainer({
  width: 'container',
  rows: [],
})
```

---

## SPRow

A row within an SPContainer. Contains columns.

```typescript
import { SPRow } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `columns` | `SPColumn[]` | No | `[]` | Columns within this row |
| `order` | `number` | No | — | Display order |
| `cssClass` | `string` | No | — | Additional CSS classes |

---

## SPColumn

A Bootstrap column within an SPRow. Contains widget instances.

```typescript
import { SPColumn } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `size` | `number` | No | — | Bootstrap column width (1-12) |
| `sizeSm` | `number` | No | — | Small breakpoint width |
| `sizeLg` | `number` | No | — | Large breakpoint width |
| `sizeXs` | `number` | No | — | XS breakpoint width |
| `instances` | `SPInstance[]` | No | `[]` | Widget instances placed in this column |
| `nestedRows` | `SPRow[]` | No | `[]` | Nested rows for complex layouts |

---

## SPInstance

A widget instance placed in an SPColumn. References an SPWidget by its `id`.

```typescript
import { SPInstance } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `widget` | `string` | **Yes** | — | Widget `id` field value (e.g. `'x_SCOPE_-my-widget'`) |
| `widgetParameters` | `Record<string, any>` | No | — | Initial widget option values |
| `size` | `number` | No | — | Bootstrap column override (1-12) |
| `order` | `number` | No | — | Display order within the column |
| `color` | `string` | No | — | Widget color variant |
| `roles` | `string[]` | No | — | Roles required to see this instance |

**Example:**
```typescript
SPInstance({
  widget: 'x_SCOPE_-my-widget',
  widgetParameters: { title: 'Hello' },
  size: 12,
})
```

---

## SPTheme

Defines a Service Portal theme. Requires `$id`.

```typescript
import { SPTheme } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `$id` | `Now.ID` | **Yes** | — | Stable sys_id |
| `name` | `string` | **Yes** | — | Theme name |
| `customCss` | `string \| Now.include(...)` | No | — | Custom CSS overrides |
| `header` | `string` | No | — | Header widget id |
| `footer` | `string` | No | — | Footer widget id |
| `fixedHeader` | `boolean` | No | — | Whether header is sticky |
| `fixedFooter` | `boolean` | No | — | Whether footer is sticky |
| `matchingNextExperienceTheme` | `string` | No | — | Next Experience theme to match |
| `cssIncludes` | `string[]` | No | — | CSS file paths to include |
| `jsIncludes` | `string[]` | No | — | JS file paths to include |

**Example:**
```typescript
SPTheme({
  $id: Now.ID['main_theme'],
  name: 'x_SCOPE_ Theme',
  customCss: Now.include('./portal.css'),
})
```

---

## SPMenuItem

A single navigation item within an SPMenu.

```typescript
import { SPMenuItem } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `label` | `string` | **Yes** | — | Display label |
| `type` | `'page' \| 'url' \| 'sc_category' \| 'sc_cat_item' \| 'kb_topic' \| 'kb_article' \| 'kb_category' \| 'filtered' \| 'scripted'` | No | — | Navigation target type |

---

## SPMenu

A navigation menu widget. Extends SPInstance and requires `$id`.

```typescript
import { SPMenu } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `$id` | `Now.ID` | **Yes** | — | Stable sys_id |
| `widget` | `string` | **Yes** | — | Widget id reference (inherited from SPInstance) |
| `items` | `SPMenuItem[]` | No | `[]` | Navigation menu items |

**Example:**
```typescript
SPMenu({
  $id: Now.ID['main_menu'],
  widget: 'x_SCOPE_-nav-bar',
  items: [
    { label: 'Home', type: 'page' },
    { label: 'Catalog', type: 'sc_category' },
  ],
})
```

---

## ServicePortal

The root portal record. Requires `$id`.

```typescript
import { ServicePortal } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `$id` | `Now.ID` | **Yes** | — | Stable sys_id |
| `title` | `string` | **Yes** | — | Portal display title |
| `urlSuffix` | `string` | **Yes** | — | URL path suffix (e.g. `'sp'` → `https://instance.service-now.com/sp`) |
| `homePage` | `string` | No | — | Home page `pageId` |
| `theme` | `string` | No | — | Theme `$id` reference |
| `mainMenu` | `string` | No | — | Main menu `$id` reference |
| `loginPage` | `string` | No | — | Login page `pageId` |
| `notFoundPage` | `string` | No | — | 404 page `pageId` |

**Example:**
```typescript
ServicePortal({
  $id: Now.ID['my_portal'],
  title: 'My Portal',
  urlSuffix: 'myportal',
  homePage: 'x_SCOPE_-home',
})
```

---

## Flow

Defines a Flow Designer flow with triggers and actions. Data pills reference trigger/record data using `{{trigger.current.field_name}}` syntax.

```typescript
import { Flow } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `name` | `string` | **Yes** | — | Display name |
| `active` | `boolean` | No | `true` | Whether the flow is active |
| `trigger` | `object` | **Yes** | — | Trigger definition (see trigger types below) |
| `actions` | `object[]` | No | `[]` | Ordered list of action definitions |

**Trigger types:**

| Trigger type | Description |
|---|---|
| `record.inserted` | Fires when a record is inserted into a table |
| `record.updated` | Fires when a record is updated |
| `record.deleted` | Fires when a record is deleted |
| `scheduled` | Fires on a schedule (cron or interval) |
| `rest` | Fires when a REST call is made to the flow's REST endpoint |

**Data pill syntax:** Reference trigger/record field values in action inputs using `{{trigger.current.field_name}}`.

**Example:**
```typescript
Flow({
  name: 'x_SCOPE_ Notify On Insert',
  active: true,
  trigger: {
    type: 'record.inserted',
    table: 'x_SCOPE_incident',
  },
  actions: [
    {
      name: 'Send Notification',
      action: 'send_email',
      inputs: {
        to: '{{trigger.current.assigned_to.email}}',
        subject: 'New incident: {{trigger.current.short_description}}',
      },
    },
  ],
})
```

---

## ImportSet

<!-- NOTE: partial - verify against SDK docs -->

Defines an import set for loading data from an external source.

```typescript
import { ImportSet } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `name` | `string` | **Yes** | — | Display name |
| `source` | `string` | No | — | Source data location or connection |
| `transformMap` | `string` | No | — | Transform map sys_id or name reference |
| `runTransform` | `boolean` | No | `false` | Whether to run the transform automatically after load |
| `importSetTable` | `string` | No | — | Import set staging table name |

**Example:**
```typescript
ImportSet({
  name: 'x_SCOPE_ User Import',
  importSetTable: 'x_SCOPE_user_import',
  runTransform: true,
})
```

---

## SLA

<!-- NOTE: partial - verify against SDK docs -->

Defines an SLA (Service Level Agreement) definition.

```typescript
import { SLA } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `name` | `string` | **Yes** | — | Display name |
| `table` | `string` | **Yes** | — | Table the SLA applies to (e.g. `'incident'`) |
| `type` | `string` | No | — | SLA type (e.g. `'SLA'`, `'OLA'`, `'UC'`) |
| `duration` | `object` | No | — | Duration object with `days`, `hours`, `minutes` |
| `startCondition` | `string` | No | — | Condition expression that starts the SLA timer |
| `stopCondition` | `string` | No | — | Condition expression that stops the SLA timer |
| `resetCondition` | `string` | No | — | Condition expression that resets the SLA timer |

**Example:**
```typescript
SLA({
  name: 'x_SCOPE_ P1 Response SLA',
  table: 'incident',
  type: 'SLA',
  duration: { hours: 4 },
  startCondition: 'priority=1^state=1',
  stopCondition: 'state=6',
})
```

---

## Workspace

<!-- NOTE: partial - verify against SDK docs -->

Defines a configurable workspace experience.

```typescript
import { Workspace } from '@servicenow/sdk/core'
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `name` | `string` | **Yes** | — | Display name |
| `experienceType` | `string` | No | — | Type of workspace experience |
| `listLayout` | `object` | No | — | List view layout configuration |
| `formLayout` | `object` | No | — | Form view layout configuration |

**Example:**
```typescript
Workspace({
  name: 'x_SCOPE_ Incident Workspace',
  experienceType: 'agent',
})
```

---

## ATF Test (AutomatedTestFramework)

> **No options table provided — intentional deferral.** The ATF Fluent API surface is extensive (record queries, REST calls, impersonation, output variables, test batching, step definitions) and cannot be accurately documented here without risk of hallucination. When working with ATF tests, read the official examples directly: `github.com/ServiceNow/sdk-examples/tree/main/test-atf-sample`. Do not generate ATF test code from memory — use the examples as the structural template.
>
> See sdk-examples. **Do NOT generate ATF code from this reference.**
