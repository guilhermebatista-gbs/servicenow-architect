// Example: Service Portal with SPWidget, SPPage, SPTheme, SPMenu, and ServicePortal.
// Scope prefix x_SCOPE_ is a placeholder — replace with the value from now.config.json.
import {
  SPWidget,
  SPPage,
  SPContainer,
  SPColumn,
  SPInstance,
  SPTheme,
  SPMenu,
  SPMenuItem,
  ServicePortal,
} from '@servicenow/sdk/core'

// Widget — the content building block
export const myWidget = SPWidget({
  $id: Now.ID['my_widget'],
  id: 'x_SCOPE_-my-widget',
  name: 'My Widget',
  htmlTemplate: Now.include('./my-widget.html'),
  clientScript: Now.include('./my-widget.client.js'),
  serverScript: Now.include('./my-widget.server.js'),
  customCss: Now.include('./my-widget.css'),
})

// Theme — visual style for the portal
export const myTheme = SPTheme({
  $id: Now.ID['my_theme'],
  name: 'x_SCOPE_ Theme',
  customCss: Now.include('./portal.css'),
  fixedHeader: true,
})

// Page — layout container (no $id — uses pageId for URL routing)
SPPage({
  pageId: 'x_SCOPE_-home',
  title: 'Home',
  containers: [
    SPContainer({
      width: 'container',
      rows: [
        {
          columns: [
            SPColumn({
              size: 12,
              instances: [
                SPInstance({
                  widget: 'x_SCOPE_-my-widget',
                  widgetParameters: { title: 'Welcome' },
                }),
              ],
            }),
          ],
        },
      ],
    }),
  ],
})

// Menu — navigation items
export const mainMenu = SPMenu({
  $id: Now.ID['main_menu'],
  widget: 'x_SCOPE_-nav-bar',
  items: [
    SPMenuItem({ label: 'Home', type: 'page' }),
    SPMenuItem({ label: 'Service Catalog', type: 'sc_category' }),
  ],
})

// Portal root — ties everything together
ServicePortal({
  $id: Now.ID['my_portal'],
  title: 'My Portal',
  urlSuffix: 'myportal',
  homePage: 'x_SCOPE_-home',
  theme: myTheme.$id,
  mainMenu: mainMenu.$id,
})
