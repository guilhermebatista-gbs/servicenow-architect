// Example: UiPage serving a React application (direct: true omits standard shell HTML).
// Scope prefix x_SCOPE_ is a placeholder — replace with the value from now.config.json.
// Note: React/Vue/Svelte UI pages require a build step configured in now.prebuild.mjs.
// See the react-ui-page-ts-sample in github.com/ServiceNow/sdk-examples for reference.
import '@servicenow/sdk/global'
import { UiPage } from '@servicenow/sdk/core'
import indexHtml from '../../client/index.html'

UiPage({
  $id: Now.ID['x_SCOPE_my_app_page'],
  endpoint: 'x_SCOPE__my_app.do',
  description: 'My Application UI Page',
  category: 'general',
  html: indexHtml,
  direct: true,
})
