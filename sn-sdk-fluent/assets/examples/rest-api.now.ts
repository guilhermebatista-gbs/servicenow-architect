// Example: Scripted REST API with GET and POST routes using the script tagged template literal.
// Scope prefix x_SCOPE_ is a placeholder — replace with the value from now.config.json.
// Available at: /api/x_SCOPE_/incidents
import { RestApi } from '@servicenow/sdk/core'

RestApi({
  $id: Now.ID['x_SCOPE_incidents_api'],
  name: 'Incidents API',
  service_id: 'incidents',
  consumes: 'application/json',
  routes: [
    {
      $id: Now.ID['x_SCOPE_incidents_get'],
      name: 'get',
      method: 'GET',
      script: script`
        (function process(/*RESTAPIRequest*/ request, /*RESTAPIResponse*/ response) {
          var gr = new GlideRecord('x_SCOPE_incident');
          gr.query();
          var results = [];
          while (gr.next()) {
            results.push({ sys_id: gr.getUniqueValue(), short_description: gr.getValue('short_description') });
          }
          response.setBody({ incidents: results });
        })(request, response)
      `,
    },
    {
      $id: Now.ID['x_SCOPE_incidents_post'],
      name: 'post',
      method: 'POST',
      script: script`
        (function process(/*RESTAPIRequest*/ request, /*RESTAPIResponse*/ response) {
          var body = request.body.data;
          var gr = new GlideRecord('x_SCOPE_incident');
          gr.initialize();
          gr.setValue('short_description', body.short_description);
          var sysId = gr.insert();
          response.setStatus(201);
          response.setBody({ sys_id: sysId });
        })(request, response)
      `,
    },
  ],
})
