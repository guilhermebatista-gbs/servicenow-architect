#!/usr/bin/env bash
# sn-scripting/scripts/validate-script.sh
# Usage: bash validate-script.sh <file> [--type client|server]
# Output: JSON to stdout with valid/warnings/errors.
# Diagnostics: to stderr.
# Exit code: 0 valid (no errors; warnings allowed), 1 validation errors found, 2 cannot run.

set -uo pipefail

usage() {
  cat >&2 <<'USAGE'
Usage: validate-script.sh <file> [--type <client|server>]

Validates a ServiceNow script file for common issues.

Arguments:
  <file>              Path to the script file to validate (required)
  --type client|server  Explicit context declaration (optional)
                      If not provided, inferred from file path:
                        path contains "client" → client context
                        otherwise → server context
  --help              Print this usage and exit 0

Output (JSON to stdout):
  {"valid": true/false, "warnings": [...], "errors": [...], "details": {"file": "path", "context": "client|server"}}

Exit codes:
  0  valid (no errors; warnings are allowed)
  1  validation errors found
  2  cannot run (file argument missing or file not found)

Examples:
  validate-script.sh ./src/client-scripts/onLoad.js
  validate-script.sh ./src/business-rules/approve.js --type server
  validate-script.sh ./scripts/client-onChange.js --type client
USAGE
}

FILE=""
EXPLICIT_TYPE=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --help)
      usage
      exit 0
      ;;
    --type)
      if [[ -z "${2:-}" ]]; then
        echo "ERROR: --type requires an argument (client or server)" >&2
        usage
        exit 2
      fi
      EXPLICIT_TYPE="$2"
      shift 2
      ;;
    -*)
      echo "ERROR: Unknown option: $1" >&2
      usage
      exit 2
      ;;
    *)
      if [[ -z "$FILE" ]]; then
        FILE="$1"
      else
        echo "ERROR: Unexpected argument: $1" >&2
        usage
        exit 2
      fi
      shift
      ;;
  esac
done

# --- Check FILE argument is provided ---
if [[ -z "$FILE" ]]; then
  echo '{"valid": false, "warnings": [], "errors": ["missing_file_argument"], "details": {"file": "", "context": ""}}'
  exit 2
fi

# --- Check FILE exists ---
if [[ ! -f "$FILE" ]]; then
  echo "{\"valid\": false, \"warnings\": [], \"errors\": [\"file_not_found\"], \"details\": {\"file\": \"$FILE\", \"context\": \"\"}}"
  exit 2
fi

# --- Determine context ---
CONTEXT=""
if [[ -n "$EXPLICIT_TYPE" ]]; then
  CONTEXT="$EXPLICIT_TYPE"
elif [[ "$FILE" == *client* ]]; then
  CONTEXT="client"
else
  CONTEXT="server"
fi

# --- Run checks ---
ERRORS=""
WARNINGS=""

if [[ "$CONTEXT" == "client" ]]; then
  # Check for GlideRecord usage in client scripts
  if grep -q "new GlideRecord\|GlideRecord(" "$FILE" 2>/dev/null; then
    ERRORS="gliderecord_in_client_script"
    echo "ERROR: GlideRecord usage found in client script context — use GlideAjax instead" >&2
  fi
fi

if [[ "$CONTEXT" == "server" ]]; then
  # Check for g_form usage in server context
  if grep -q "g_form\." "$FILE" 2>/dev/null; then
    WARNINGS="${WARNINGS:+$WARNINGS }gform_in_server_context"
    echo "WARNING: g_form usage found in server context — g_form is client-side only" >&2
  fi
fi

# Check for bare setAbortAction (without current.) — all contexts
if grep -q "setAbortAction" "$FILE" 2>/dev/null; then
  if ! grep -q "current\.setAbortAction" "$FILE" 2>/dev/null; then
    WARNINGS="${WARNINGS:+$WARNINGS }bare_setAbortAction"
    echo "WARNING: bare setAbortAction() found — should be current.setAbortAction()" >&2
  fi
fi

# --- Build JSON output ---
# Convert space-separated lists to JSON arrays
errors_json="[]"
if [[ -n "$ERRORS" ]]; then
  errors_json="["
  first=true
  for e in $ERRORS; do
    if [[ "$first" == "true" ]]; then
      errors_json="${errors_json}\"${e}\""
      first=false
    else
      errors_json="${errors_json}, \"${e}\""
    fi
  done
  errors_json="${errors_json}]"
fi

warnings_json="[]"
if [[ -n "$WARNINGS" ]]; then
  warnings_json="["
  first=true
  for w in $WARNINGS; do
    if [[ "$first" == "true" ]]; then
      warnings_json="${warnings_json}\"${w}\""
      first=false
    else
      warnings_json="${warnings_json}, \"${w}\""
    fi
  done
  warnings_json="${warnings_json}]"
fi

# valid is false if errors array is non-empty
VALID="true"
[[ -n "$ERRORS" ]] && VALID="false"

cat <<EOF
{"valid": $VALID, "warnings": $warnings_json, "errors": $errors_json, "details": {"file": "$FILE", "context": "$CONTEXT"}}
EOF

# Exit code
if [[ "$VALID" == "false" ]]; then
  exit 1
fi
exit 0
