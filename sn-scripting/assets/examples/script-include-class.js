// Script Include record name in the ServiceNow platform MUST match the variable name 'IncidentUtils'.
// The 'type' property at the end is required — it must also match.

var IncidentUtils = Class.create();
IncidentUtils.prototype = {
    initialize: function() {
        // Constructor — set instance variables here
        this.table = 'incident';
    },

    /**
     * Returns an array of sys_ids for active incidents assigned to the given user.
     * @param {string} assignee - sys_id of the assigned user
     * @returns {string[]} Array of incident sys_ids
     */
    getActiveIncidents: function(assignee) {
        var incidents = [];
        var gr = new GlideRecord(this.table);
        gr.addQuery('state', 'IN', '1,2,3');  // New, In Progress, On Hold
        gr.addQuery('assigned_to', assignee);
        gr.query();
        while (gr.next()) {
            incidents.push(gr.getValue('sys_id'));  // Always use getValue() in loops
        }
        return incidents;
    },

    /**
     * Closes an incident with the given resolution details.
     * @param {string} sysId - sys_id of the incident to close
     * @param {string} closeCode - close_code field value (e.g. 'Solved (Permanently)')
     * @param {string} closeNotes - resolution notes
     * @returns {boolean} true if the update succeeded
     */
    closeIncident: function(sysId, closeCode, closeNotes) {
        var gr = new GlideRecord(this.table);
        if (!gr.get(sysId)) {
            gs.warn('IncidentUtils.closeIncident: incident not found — ' + sysId);
            return false;
        }
        gr.state = 6;                    // Resolved
        gr.close_code = closeCode;
        gr.close_notes = closeNotes;
        gr.update();
        gs.info('IncidentUtils.closeIncident: closed incident ' + gr.getValue('number'));
        return true;
    },

    type: 'IncidentUtils'  // MUST match the Script Include record name in the platform
};
