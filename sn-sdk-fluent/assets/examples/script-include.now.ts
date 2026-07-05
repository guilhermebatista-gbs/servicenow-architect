// Example: ScriptInclude defining a reusable server-side utility class.
// Scope prefix x_SCOPE_ is a placeholder — replace with the value from now.config.json.
import { ScriptInclude } from '@servicenow/sdk/core'

ScriptInclude({
  $id: Now.ID['x_SCOPE_my_utility'],
  name: 'MyUtility',
  active: true,
  apiName: 'x_SCOPE_.MyUtility',
  script: Now.include('./MyUtility.server.js'),
})
