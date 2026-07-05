// Example: ClientScript (onLoad) using an external .client.js script.
// IMPORTANT: client scripts MUST use the .client.js extension (not .server.js).
// Scope prefix x_SCOPE_ is a placeholder — replace with the value from now.config.json.
import { ClientScript } from '@servicenow/sdk/core'

export default ClientScript({
  $id: Now.ID['x_SCOPE_onload_incident'],
  type: 'onLoad',
  ui_type: 'all',
  table: 'x_SCOPE_incident',
  global: true,
  name: 'x_SCOPE_onload_incident',
  active: true,
  applies_extended: false,
  isolate_script: false,
  description: 'Set default field values when the incident form loads',
  script: Now.include('./onload_incident.client.js'),
})
