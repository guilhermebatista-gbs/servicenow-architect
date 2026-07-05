#!/usr/bin/env bash
# sn-sdk-setup/scripts/check-environment.sh
# Usage: bash check-environment.sh [--offline]
# Output: JSON to stdout with pass/fail per check.
# Diagnostics: to stderr.
# Exit code: 0 if overall pass (node + npm + sdk all pass), 1 otherwise.

set -uo pipefail

OFFLINE=false
for arg in "$@"; do
  [[ "$arg" == "--offline" ]] && OFFLINE=true
done

# --- Node version check (>= 20) ---
NODE_PASS=false
NODE_VERSION=""
NODE_ERROR=""
if command -v node &>/dev/null; then
  NODE_VERSION=$(node --version 2>/dev/null || echo "")
  MAJOR=$(echo "$NODE_VERSION" | sed 's/v\([0-9]*\).*/\1/' 2>/dev/null || echo "0")
  if [[ "$MAJOR" =~ ^[0-9]+$ ]] && [[ $MAJOR -ge 20 ]]; then
    NODE_PASS=true
  else
    NODE_ERROR="Node $NODE_VERSION is below minimum required version 20"
    echo "ERROR: Node version $NODE_VERSION < 20. Install Node 20+ from nodejs.org" >&2
  fi
else
  NODE_ERROR="node not found"
  echo "ERROR: node not found. Install Node 20+ from nodejs.org" >&2
fi

# --- npm check ---
NPM_PASS=false
NPM_ERROR=""
if command -v npm &>/dev/null; then
  NPM_PASS=true
else
  NPM_ERROR="npm not found"
  echo "ERROR: npm not found. It should be installed with Node." >&2
fi

# --- SDK check ---
SDK_PASS=false
SDK_VERSION=""
SDK_ERROR=""
if command -v now-sdk &>/dev/null; then
  SDK_VERSION=$(now-sdk --version 2>/dev/null || echo "")
  SDK_PASS=true
else
  SDK_ERROR="not installed"
  echo "ERROR: now-sdk not found. Run: npm install -g @servicenow/sdk" >&2
fi

# --- now.config.json presence ---
CONFIG_PASS=false
CONFIG_ERROR=""
if [[ -f "now.config.json" ]]; then
  CONFIG_PASS=true
else
  CONFIG_ERROR="now.config.json not found in current directory"
  echo "WARNING: now.config.json not found. Run now-sdk init to create a project." >&2
fi

# --- auth alias configured ---
AUTH_PASS=false
AUTH_ALIAS=""
AUTH_ERROR=""
if command -v now-sdk &>/dev/null; then
  AUTH_LIST=$(now-sdk auth list 2>/dev/null || echo "")
  if [[ -n "$AUTH_LIST" ]]; then
    AUTH_ALIAS=$(echo "$AUTH_LIST" | grep -E '^\s*\S+' | head -1 | awk '{print $1}' || echo "unknown")
    AUTH_PASS=true
  else
    AUTH_ERROR="no auth aliases configured"
    echo "WARNING: No auth aliases found. Run: now-sdk auth --add <instance-url> --alias <name>" >&2
  fi
else
  AUTH_ERROR="sdk not installed"
fi

# --- now.config.json structure check (skipped if --offline) ---
CONFIG_VALID=false
CONFIG_VALID_ERROR=""
if [[ "$OFFLINE" == "true" ]]; then
  CONFIG_VALID=true
  CONFIG_VALID_ERROR="skipped (--offline)"
else
  if [[ -f "now.config.json" ]]; then
    if command -v python3 &>/dev/null; then
      APP_NAME=$(python3 -c "import json,sys; d=json.load(open('now.config.json')); print(d.get('applicationName',''))" 2>/dev/null || echo "")
      SCOPE=$(python3 -c "import json,sys; d=json.load(open('now.config.json')); print(d.get('scope',''))" 2>/dev/null || echo "")
      if [[ -n "$APP_NAME" && -n "$SCOPE" ]]; then
        CONFIG_VALID=true
      else
        CONFIG_VALID_ERROR="now.config.json missing applicationName or scope fields"
        echo "WARNING: now.config.json found but missing applicationName or scope. Run now-sdk init to generate a valid config." >&2
      fi
    else
      CONFIG_VALID=true  # python3 unavailable — skip structure check
      CONFIG_VALID_ERROR="python3 not available — skipped structure check"
    fi
  else
    CONFIG_VALID_ERROR="now.config.json not found"
  fi
fi

# --- Compute overall pass (only node + npm + sdk are hard requirements) ---
OVERALL=false
if [[ "$NODE_PASS" == "true" && "$NPM_PASS" == "true" && "$SDK_PASS" == "true" ]]; then
  OVERALL=true
fi

# --- Helper to build optional JSON fields ---
node_extra=""
[[ -n "$NODE_ERROR" ]] && node_extra=", \"error\": \"$NODE_ERROR\""

npm_extra=""
[[ -n "$NPM_ERROR" ]] && npm_extra=", \"error\": \"$NPM_ERROR\""

sdk_extra=""
[[ -n "$SDK_VERSION" ]] && sdk_extra=", \"version\": \"$SDK_VERSION\""
[[ -n "$SDK_ERROR" ]] && sdk_extra="${sdk_extra}, \"error\": \"$SDK_ERROR\""

config_extra=""
[[ -n "$CONFIG_ERROR" ]] && config_extra=", \"error\": \"$CONFIG_ERROR\""

auth_extra=""
[[ -n "$AUTH_ALIAS" ]] && auth_extra=", \"alias\": \"$AUTH_ALIAS\""
[[ -n "$AUTH_ERROR" ]] && auth_extra="${auth_extra}, \"error\": \"$AUTH_ERROR\""

config_valid_extra=""
[[ -n "$CONFIG_VALID_ERROR" ]] && config_valid_extra=", \"note\": \"$CONFIG_VALID_ERROR\""

# --- Output JSON to stdout ---
cat <<EOF
{
  "node": {"pass": $NODE_PASS, "version": "$NODE_VERSION"${node_extra}},
  "npm": {"pass": $NPM_PASS${npm_extra}},
  "sdk": {"pass": $SDK_PASS${sdk_extra}},
  "config": {"pass": $CONFIG_PASS${config_extra}},
  "auth": {"pass": $AUTH_PASS${auth_extra}},
  "config_structure": {"pass": $CONFIG_VALID${config_valid_extra}},
  "overall": $OVERALL
}
EOF

[[ "$OVERALL" == "true" ]] || exit 1
