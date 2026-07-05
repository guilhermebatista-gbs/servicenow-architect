# ServiceNow Fluent — Column Types

Column type constructors are used inside the `schema` field of a `Table` definition. All are imported from `@servicenow/sdk/core`.

```typescript
import { Table, StringColumn, IntegerColumn, BooleanColumn, DateColumn, DateTimeColumn, ReferenceColumn } from '@servicenow/sdk/core'
```

---

## StringColumn

```typescript
StringColumn(options?)
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `label` | `string` | No | field name | Display label in the ServiceNow UI |
| `mandatory` | `boolean` | No | `false` | Whether the field is required on forms |
| `maxLength` | `number` | No | `40` | Maximum character length |

**Example:**
```typescript
schema: {
  short_description: StringColumn({ label: 'Short Description', mandatory: true, maxLength: 160 }),
}
```

---

## IntegerColumn

```typescript
IntegerColumn(options?)
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `label` | `string` | No | field name | Display label |
| `mandatory` | `boolean` | No | `false` | Whether the field is required |

**Example:**
```typescript
schema: {
  priority: IntegerColumn({ label: 'Priority', mandatory: true }),
}
```

---

## BooleanColumn

```typescript
BooleanColumn(options?)
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `label` | `string` | No | field name | Display label |
| `mandatory` | `boolean` | No | `false` | Whether the field is required |

**Example:**
```typescript
schema: {
  active: BooleanColumn({ label: 'Active', mandatory: true }),
}
```

---

## DateColumn

```typescript
DateColumn(options?)
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `label` | `string` | No | field name | Display label |
| `mandatory` | `boolean` | No | `false` | Whether the field is required |

**Example:**
```typescript
schema: {
  start_date: DateColumn({ label: 'Start Date' }),
}
```

---

## DateTimeColumn

```typescript
DateTimeColumn(options?)
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `label` | `string` | No | field name | Display label |
| `mandatory` | `boolean` | No | `false` | Whether the field is required |

**Example:**
```typescript
schema: {
  opened_at: DateTimeColumn({ label: 'Opened At' }),
}
```

---

## ReferenceColumn

```typescript
ReferenceColumn(options)
```

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| `referenceTable` | `string` | **Yes** | — | The table this column references (e.g. `'sys_user'`, `'incident'`) |
| `label` | `string` | No | field name | Display label |
| `mandatory` | `boolean` | No | `false` | Whether the field is required |

**Example:**
```typescript
schema: {
  assigned_to: ReferenceColumn({ label: 'Assigned To', referenceTable: 'sys_user', mandatory: false }),
}
```

---

## Notes

- Column type names are **exact** — do not use `TextField`, `NumberField`, or any other pattern
- There are exactly **6** column types: StringColumn, IntegerColumn, BooleanColumn, DateColumn, DateTimeColumn, ReferenceColumn
- All column options are optional except `ReferenceColumn.referenceTable`
- Column field names in `schema` become the database column names — use `snake_case`
- Do not prefix column names with the scope — ServiceNow adds the scope prefix automatically
