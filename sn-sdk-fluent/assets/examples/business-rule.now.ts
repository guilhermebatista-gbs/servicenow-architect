// Example: BusinessRule firing before insert and update, using an external .server.js script.
// Scope prefix x_SCOPE_ is a placeholder — replace with the value from now.config.json.
import { BusinessRule } from '@servicenow/sdk/core'

BusinessRule({
  $id: Now.ID['x_SCOPE_set_priority_rule'],
  name: 'Set Default Priority',
  active: true,
  table: 'x_SCOPE_incident',
  when: 'before',
  insert: true,
  update: true,
  order: 100,
  script: Now.include('./set_priority_rule.server.js'),
})
