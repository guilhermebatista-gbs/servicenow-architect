// Client Script — runs in the browser. GlideRecord is NOT available here.
// Use GlideAjax to call a Script Include for server data.

// =============================================================================
// onLoad handler
// =============================================================================

/**
 * onLoad: Restrict internal notes visibility to ITIL users only.
 * Demonstrates g_user.hasRole() and g_form.setReadOnly().
 */
function onLoad() {
    // g_user.userID   — sys_id of the currently logged-in user
    // g_user.userName — login name (username) of the currently logged-in user

    if (!g_user.hasRole('itil')) {
        // Non-ITIL users can see the field but cannot edit it
        g_form.setReadOnly('work_notes', true);
        g_form.setReadOnly('internal_notes', true);
    }

    // Admin users see an extra section
    if (g_user.hasRole('admin')) {
        g_form.setVisible('admin_override_reason', true);
    } else {
        g_form.setVisible('admin_override_reason', false);
    }
}

// =============================================================================
// onChange handler
// =============================================================================

/**
 * onChange: When state changes to Resolved (6), make resolution notes mandatory.
 * Demonstrates g_form.getValue(), g_form.setMandatory(), g_form.showFieldMsg(), g_form.clearMessages().
 */
function onChange(control, oldValue, newValue, isLoading) {
    if (isLoading) {
        return;  // Do not run on initial page load
    }

    var resolvedState = '6';

    if (newValue == resolvedState) {
        // Require resolution notes before the form can be submitted
        g_form.setMandatory('close_notes', true);
        g_form.showFieldMsg('close_notes', 'Resolution notes are required to resolve this incident.', 'info');

        // Check if a close code is already set
        var currentCloseCode = g_form.getValue('close_code');
        if (!currentCloseCode) {
            g_form.showFieldMsg('close_code', 'Please select a close code.', 'error');
        }
    } else {
        // Revert mandatory fields when state is not Resolved
        g_form.setMandatory('close_notes', false);
        g_form.clearMessages();
    }
}
