// Example: Table definition demonstrating all 6 column types.
// Scope prefix x_SCOPE_ is a placeholder — replace with the value from now.config.json.
import {
  Table,
  StringColumn,
  IntegerColumn,
  BooleanColumn,
  DateColumn,
  DateTimeColumn,
  ReferenceColumn,
} from '@servicenow/sdk/core'

export const x_SCOPE_incident = Table({
  name: 'x_SCOPE_incident',
  label: 'My Incident',
  extends: 'task',
  extensible: true,
  auto_number: {
    prefix: 'MYINC',
    number: 1000,
    number_of_digits: 7,
  },
  schema: {
    short_description: StringColumn({ label: 'Short Description', mandatory: true, maxLength: 160 }),
    priority: IntegerColumn({ label: 'Priority', mandatory: true }),
    active: BooleanColumn({ label: 'Active' }),
    due_date: DateColumn({ label: 'Due Date' }),
    opened_at: DateTimeColumn({ label: 'Opened At' }),
    assigned_to: ReferenceColumn({ label: 'Assigned To', referenceTable: 'sys_user' }),
  },
})
