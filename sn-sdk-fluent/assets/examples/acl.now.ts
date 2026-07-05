// Example: Role definition and ACL rules (create, read, write, delete, REST endpoint).
// Scope prefix x_SCOPE_ is a placeholder — replace with the value from now.config.json.
import { Acl, Role } from '@servicenow/sdk/core'

export const x_SCOPE_admin = Role({
  name: 'x_SCOPE_.admin',
})

Acl({
  $id: Now.ID['x_SCOPE_create_acl'],
  localOrExisting: 'Existing',
  type: 'record',
  operation: 'create',
  table: 'x_SCOPE_incident',
  roles: [x_SCOPE_admin],
})

Acl({
  $id: Now.ID['x_SCOPE_read_acl'],
  localOrExisting: 'Existing',
  type: 'record',
  operation: 'read',
  table: 'x_SCOPE_incident',
  roles: [x_SCOPE_admin, 'itil'],
  condition: 'active=true',
})

Acl({
  $id: Now.ID['x_SCOPE_write_acl'],
  localOrExisting: 'Existing',
  type: 'record',
  operation: 'write',
  table: 'x_SCOPE_incident',
  roles: [x_SCOPE_admin],
})

Acl({
  $id: Now.ID['x_SCOPE_delete_acl'],
  localOrExisting: 'Existing',
  type: 'record',
  operation: 'delete',
  table: 'x_SCOPE_incident',
  securityAttribute: 'has_admin_role',
})

Acl({
  $id: Now.ID['x_SCOPE_rest_acl'],
  localOrExisting: 'Existing',
  name: 'x_SCOPE__incidents_api',
  type: 'rest_endpoint',
  operation: 'execute',
  roles: [x_SCOPE_admin],
})
