#!/usr/bin/env bash
# sn-sdk-fluent/scripts/validate-build.sh
# Usage: bash validate-build.sh [--help]
# Output: JSON to stdout. Diagnostics to stderr.
# Exit code: 0 success, 1 build error, 2 missing prerequisite (now-sdk not found)

set -uo pipefail

HELP=false
for arg in "$@"; do
  [[ "$arg" == "--help" ]] && HELP=true
done

if [[ "$HELP" == "true" ]]; then
  echo "Usage: bash validate-build.sh [--help]"
  echo ""
  echo "  Wraps 'now-sdk build', captures output, returns structured JSON."
  echo ""
  echo "Flags:"
  echo "  --help  Print this message and exit 0"
  echo "  --frozenKeys  Pass --frozenKeys true to now-sdk build (CI mode: validates keys.ts is up to date)"
  echo ""
  echo "Exit codes:"
  echo "  0  Build succeeded"
  echo "  1  Build failed (TypeScript errors or other build errors)"
  echo "  2  Missing prerequisite (now-sdk not found in PATH)"
  echo ""
  echo "Output format:"
  echo "  Success: {\"valid\": true, \"errors\": [], \"details\": {\"exit_code\": 0}}"
  echo "  Failure: {\"valid\": false, \"errors\": [\"TS2345: ...\"], \"details\": {\"exit_code\": 1}}"
  echo "  Missing: {\"valid\": false, \"errors\": [\"now_sdk_not_installed\"], \"details\": {\"message\": \"...\"}}"
  echo ""
  echo "Examples:"
  echo "  bash validate-build.sh"
  echo "  bash validate-build.sh --frozenKeys"
  exit 0
fi

FROZEN_KEYS=false
for arg in "$@"; do
  [[ "$arg" == "--frozenKeys" ]] && FROZEN_KEYS=true
done

# --- Check now-sdk is installed ---
if ! command -v now-sdk &>/dev/null; then
  echo "ERROR: now-sdk not found in PATH. Run: npm install -g @servicenow/sdk" >&2
  cat <<EOF
{"valid": false, "errors": ["now_sdk_not_installed"], "details": {"message": "now-sdk not found. Run: npm install -g @servicenow/sdk"}}
EOF
  exit 2
fi

# --- Run now-sdk build ---
BUILD_CMD="now-sdk build"
if [[ "$FROZEN_KEYS" == "true" ]]; then
  BUILD_CMD="now-sdk build --frozenKeys true"
fi

echo "Running: $BUILD_CMD" >&2
BUILD_OUTPUT=""
BUILD_EXIT=0
BUILD_OUTPUT=$(eval "$BUILD_CMD" 2>&1) || BUILD_EXIT=$?

if [[ $BUILD_EXIT -eq 0 ]]; then
  cat <<EOF
{"valid": true, "errors": [], "details": {"exit_code": 0}}
EOF
  exit 0
fi

# --- Parse error lines (up to 10) ---
ERROR_LINES=$(echo "$BUILD_OUTPUT" | grep -E "(error TS| error )" | head -10 || true)

ERRORS_JSON=""
while IFS= read -r line; do
  if [[ -n "$line" ]]; then
    ESCAPED=$(echo "$line" | sed 's/\\/\\\\/g; s/"/\\"/g')
    [[ -n "$ERRORS_JSON" ]] && ERRORS_JSON="${ERRORS_JSON}, "
    ERRORS_JSON="${ERRORS_JSON}\"${ESCAPED}\""
  fi
done <<< "$ERROR_LINES"

# If no specific error lines found, include a generic message
if [[ -z "$ERRORS_JSON" ]]; then
  FIRST_LINE=$(echo "$BUILD_OUTPUT" | head -1 | sed 's/\\/\\\\/g; s/"/\\"/g')
  ERRORS_JSON="\"build_failed: ${FIRST_LINE}\""
fi

cat <<EOF
{"valid": false, "errors": [$ERRORS_JSON], "details": {"exit_code": $BUILD_EXIT}}
EOF
exit 1
