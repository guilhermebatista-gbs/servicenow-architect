// Example: UiAction button shown on form and list views with condition and script.
// Scope prefix x_SCOPE_ is a placeholder — replace with the value from now.config.json.
import { UiAction } from '@servicenow/sdk/core'

UiAction({
  $id: Now.ID['x_SCOPE_resolve_incident'],
  table: 'x_SCOPE_incident',
  actionName: 'Resolve Incident',
  name: 'x_SCOPE_resolve_incident',
  active: true,
  showUpdate: true,
  hint: 'Mark this incident as resolved',
  condition: "current.state != 'resolved'",
  form: {
    showButton: true,
    style: 'primary',
  },
  list: {
    showButton: true,
    showListChoice: true,
  },
  script: `current.state = 'resolved'; current.update();`,
  roles: ['x_SCOPE_.admin', 'itil'],
  order: 100,
})
