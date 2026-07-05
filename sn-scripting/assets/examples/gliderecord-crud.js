// Server-side only. Run in Business Rule, Script Include, Scheduled Job, or REST API Script.
// Do NOT use in Client Scripts.

// =============================================================================
// CREATE
// =============================================================================

var grCreate = new GlideRecord('incident');
grCreate.initialize();
grCreate.short_description = 'Network connectivity issue';
grCreate.priority = 2;
grCreate.category = 'network';
var newSysId = grCreate.insert(); // returns sys_id string on success, null on failure
if (newSysId) {
    gs.info('Created incident with sys_id: ' + newSysId);
} else {
    gs.error('Failed to create incident');
}

// =============================================================================
// READ — Multiple Records
// =============================================================================

var grReadMulti = new GlideRecord('incident');
grReadMulti.addQuery('state', 1);
grReadMulti.addQuery('priority', '<=', 2);
grReadMulti.query(); // Always call query() before next() — without it, the loop body never executes
while (grReadMulti.next()) {
    gs.info(grReadMulti.getValue('number'));          // Always use getValue() in loops — gr.field_name returns a pointer, not the value
    gs.info(grReadMulti.getValue('short_description'));
    gs.info(grReadMulti.getValue('sys_id'));          // Always use getValue() in loops — gr.sys_id returns a pointer, not the value
}

// =============================================================================
// READ — Single Record by sys_id
// =============================================================================

var grReadById = new GlideRecord('incident');
if (grReadById.get('a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4')) {
    gs.info('Found: ' + grReadById.getValue('short_description'));
    gs.info('State: ' + grReadById.getValue('state'));
}

// READ — Single Record by field value
var grReadByField = new GlideRecord('incident');
if (grReadByField.get('number', 'INC0001234')) {
    gs.info('Found: ' + grReadByField.getValue('short_description'));
}

// =============================================================================
// UPDATE
// =============================================================================

var grUpdate = new GlideRecord('incident');
if (grUpdate.get('number', 'INC0001234')) {
    grUpdate.state = 2;             // In Progress
    grUpdate.assigned_to = gs.getUserID();
    grUpdate.update();
    gs.info('Updated incident INC0001234');
} else {
    gs.warn('Incident INC0001234 not found');
}

// =============================================================================
// DELETE
// =============================================================================

var grDelete = new GlideRecord('incident');
if (grDelete.get(newSysId)) {
    grDelete.deleteRecord();
    gs.info('Deleted incident: ' + newSysId);
} else {
    gs.warn('Record not found for deletion: ' + newSysId);
}
