// Example: Flow with a record-insert trigger and actions using data pill syntax.
// Data pills reference trigger/record field values: {{trigger.current.field_name}}
// Scope prefix x_SCOPE_ is a placeholder — replace with the value from now.config.json.
// NOTE: Flow constructor details are partial — verify against SDK docs and Flow Designer.
import { Flow } from '@servicenow/sdk/core'

Flow({
  name: 'x_SCOPE_ Notify On Incident Created',
  active: true,
  trigger: {
    type: 'record.inserted',
    table: 'x_SCOPE_incident',
  },
  actions: [
    {
      name: 'Send Email Notification',
      action: 'send_email',
      inputs: {
        to: '{{trigger.current.assigned_to.email}}',
        subject: 'New incident created: {{trigger.current.short_description}}',
        body: 'Priority: {{trigger.current.priority}}\nOpened: {{trigger.current.opened_at}}',
      },
    },
    {
      name: 'Update Priority Field',
      action: 'update_record',
      inputs: {
        table: 'x_SCOPE_incident',
        sys_id: '{{trigger.current.sys_id}}',
        fields: {
          active: true,
        },
      },
    },
  ],
})
