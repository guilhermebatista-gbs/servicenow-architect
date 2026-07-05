#!/usr/bin/env bash
# sn-sdk-fluent/scripts/validate-project.sh
# Usage: bash validate-project.sh [--help] [PROJECT_DIR]
# Output: JSON to stdout. Diagnostics to stderr.
# Exit code: 0 success, 1 validation error

set -uo pipefail

DIR="."
HELP=false
for arg in "$@"; do
  [[ "$arg" == "--help" ]] && HELP=true
  [[ "$arg" != "--help" ]] && DIR="$arg"
done

if [[ "$HELP" == "true" ]]; then
  echo "Usage: bash validate-project.sh [--help] [PROJECT_DIR]"
  echo ""
  echo "  PROJECT_DIR  Path to SDK project directory (default: current directory)"
  echo ""
  echo "Checks:"
  echo "  1. Node.js >= v20.18.0 (minimum per ServiceNow Australia App Dev PDF)"
  echo "  2. npm >= v8.19.3"
  echo "  3. now.config.json present with scope, scopeId, and name fields"
  echo "  4. package.json present with @servicenow/sdk in devDependencies"
  echo "  5. node_modules/ directory exists (npm install has been run)"
  echo ""
  echo "Output: Single-line JSON to stdout."
  echo "  {\"valid\": true/false, \"errors\": [...], \"details\": {...}}"
  echo ""
  echo "Exit codes:"
  echo "  0  All checks pass"
  echo "  1  One or more checks failed"
  echo ""
  echo "Examples:"
  echo "  bash validate-project.sh"
  echo "  bash validate-project.sh /path/to/my-sn-app"
  exit 0
fi

# --- Node version check (>= v20.18.0) ---
NODE_PASS=false
NODE_VERSION=""
if command -v node &>/dev/null; then
  NODE_VERSION=$(node --version 2>/dev/null | sed 's/^v//' || echo "0.0.0")
  MAJOR=$(echo "$NODE_VERSION" | sed 's/\([0-9]*\).*/\1/' 2>/dev/null || echo "0")
  MINOR=$(echo "$NODE_VERSION" | sed 's/[0-9]*\.\([0-9]*\).*/\1/' 2>/dev/null || echo "0")
  PATCH=$(echo "$NODE_VERSION" | sed 's/[0-9]*\.[0-9]*\.\([0-9]*\).*/\1/' 2>/dev/null || echo "0")
  # Compare: 20.18.0 required
  if [[ "$MAJOR" =~ ^[0-9]+$ ]] && [[ $MAJOR -gt 20 ]]; then
    NODE_PASS=true
  elif [[ "$MAJOR" =~ ^[0-9]+$ ]] && [[ $MAJOR -eq 20 ]]; then
    if [[ "$MINOR" =~ ^[0-9]+$ ]] && [[ $MINOR -gt 18 ]]; then
      NODE_PASS=true
    elif [[ "$MINOR" =~ ^[0-9]+$ ]] && [[ $MINOR -eq 18 ]]; then
      if [[ "$PATCH" =~ ^[0-9]+$ ]] && [[ $PATCH -ge 0 ]]; then
        NODE_PASS=true
      fi
    fi
  fi
  if [[ "$NODE_PASS" == "false" ]]; then
    echo "ERROR: Node v$NODE_VERSION is below minimum required v20.18.0. Install Node 20+ from nodejs.org" >&2
  fi
else
  NODE_VERSION="not_found"
  echo "ERROR: node not found. Install Node 20+ from nodejs.org" >&2
fi

# --- npm version check (>= 8.19.3) ---
NPM_PASS=false
NPM_VERSION=""
if command -v npm &>/dev/null; then
  NPM_VERSION=$(npm --version 2>/dev/null || echo "0.0.0")
  NPM_MAJOR=$(echo "$NPM_VERSION" | sed 's/\([0-9]*\).*/\1/' 2>/dev/null || echo "0")
  NPM_MINOR=$(echo "$NPM_VERSION" | sed 's/[0-9]*\.\([0-9]*\).*/\1/' 2>/dev/null || echo "0")
  NPM_PATCH=$(echo "$NPM_VERSION" | sed 's/[0-9]*\.[0-9]*\.\([0-9]*\).*/\1/' 2>/dev/null || echo "0")
  # Compare: 8.19.3 required
  if [[ "$NPM_MAJOR" =~ ^[0-9]+$ ]] && [[ $NPM_MAJOR -gt 8 ]]; then
    NPM_PASS=true
  elif [[ "$NPM_MAJOR" =~ ^[0-9]+$ ]] && [[ $NPM_MAJOR -eq 8 ]]; then
    if [[ "$NPM_MINOR" =~ ^[0-9]+$ ]] && [[ $NPM_MINOR -gt 19 ]]; then
      NPM_PASS=true
    elif [[ "$NPM_MINOR" =~ ^[0-9]+$ ]] && [[ $NPM_MINOR -eq 19 ]]; then
      if [[ "$NPM_PATCH" =~ ^[0-9]+$ ]] && [[ $NPM_PATCH -ge 3 ]]; then
        NPM_PASS=true
      fi
    fi
  fi
  if [[ "$NPM_PASS" == "false" ]]; then
    echo "ERROR: npm v$NPM_VERSION is below minimum required v8.19.3. Update npm: npm install -g npm@latest" >&2
  fi
else
  NPM_VERSION="not_found"
  echo "ERROR: npm not found. It should be installed with Node." >&2
fi

# --- now.config.json present with required fields ---
CONFIG_PASS=false
CONFIG_SCOPE=""
CONFIG_SCOPE_ID=""
CONFIG_NAME=""
if [[ -f "$DIR/now.config.json" ]]; then
  if command -v python3 &>/dev/null; then
    CONFIG_SCOPE=$(python3 -c "import json,sys; d=json.load(open('$DIR/now.config.json')); print(d.get('scope',''))" 2>/dev/null || echo "")
    CONFIG_SCOPE_ID=$(python3 -c "import json,sys; d=json.load(open('$DIR/now.config.json')); print(d.get('scopeId','__missing__'))" 2>/dev/null || echo "__missing__")
    CONFIG_NAME=$(python3 -c "import json,sys; d=json.load(open('$DIR/now.config.json')); print(d.get('name','__missing__'))" 2>/dev/null || echo "__missing__")
    if [[ -n "$CONFIG_SCOPE" ]] && [[ "$CONFIG_SCOPE_ID" != "__missing__" ]] && [[ "$CONFIG_NAME" != "__missing__" ]]; then
      CONFIG_PASS=true
    else
      [[ -z "$CONFIG_SCOPE" ]] && echo "ERROR: now.config.json missing non-empty 'scope' field" >&2
      [[ "$CONFIG_SCOPE_ID" == "__missing__" ]] && echo "ERROR: now.config.json missing 'scopeId' field" >&2
      [[ "$CONFIG_NAME" == "__missing__" ]] && echo "ERROR: now.config.json missing 'name' field" >&2
    fi
  else
    echo "WARNING: python3 not found — skipping now.config.json field validation (file exists)" >&2
    CONFIG_PASS=true
  fi
else
  echo "ERROR: now.config.json not found in $DIR" >&2
fi

# --- package.json with @servicenow/sdk in devDependencies ---
PKG_PASS=false
if [[ -f "$DIR/package.json" ]]; then
  if command -v python3 &>/dev/null; then
    SDK_DEP=$(python3 -c "import json,sys; d=json.load(open('$DIR/package.json')); dev=d.get('devDependencies',{}); print('yes' if '@servicenow/sdk' in dev else 'no')" 2>/dev/null || echo "no")
    if [[ "$SDK_DEP" == "yes" ]]; then
      PKG_PASS=true
    else
      echo "ERROR: package.json does not have @servicenow/sdk in devDependencies. Run: npm install" >&2
    fi
  else
    echo "WARNING: python3 not found — skipping package.json devDependencies validation (file exists)" >&2
    PKG_PASS=true
  fi
else
  echo "ERROR: package.json not found in $DIR" >&2
fi

# --- node_modules/ exists ---
MODULES_PASS=false
if [[ -d "$DIR/node_modules" ]]; then
  MODULES_PASS=true
else
  echo "ERROR: node_modules/ not found in $DIR. Run: npm install" >&2
fi

# --- Compute overall ---
OVERALL=false
if [[ "$NODE_PASS" == "true" && "$NPM_PASS" == "true" && "$CONFIG_PASS" == "true" && "$PKG_PASS" == "true" && "$MODULES_PASS" == "true" ]]; then
  OVERALL=true
fi

# --- Build errors array (no jq dependency) ---
ERRORS=""
[[ "$NODE_PASS" == "false" ]] && ERRORS="${ERRORS} node_version_too_old"
[[ "$NPM_PASS" == "false" ]] && ERRORS="${ERRORS} npm_version_too_old"
[[ "$CONFIG_PASS" == "false" ]] && {
  if [[ ! -f "$DIR/now.config.json" ]]; then
    ERRORS="${ERRORS} missing_now_config"
  else
    [[ -z "$CONFIG_SCOPE" ]] && ERRORS="${ERRORS} empty_scope"
    [[ "$CONFIG_SCOPE_ID" == "__missing__" ]] && ERRORS="${ERRORS} missing_scope_id"
    [[ "$CONFIG_NAME" == "__missing__" ]] && ERRORS="${ERRORS} missing_name_field"
  fi
}
[[ "$PKG_PASS" == "false" ]] && {
  if [[ ! -f "$DIR/package.json" ]]; then
    ERRORS="${ERRORS} missing_package_json"
  else
    ERRORS="${ERRORS} missing_sdk_devdependency"
  fi
}
[[ "$MODULES_PASS" == "false" ]] && ERRORS="${ERRORS} node_modules_missing"

# Format errors array
ERRORS_JSON=""
for err in $ERRORS; do
  [[ -n "$ERRORS_JSON" ]] && ERRORS_JSON="${ERRORS_JSON}, "
  ERRORS_JSON="${ERRORS_JSON}\"${err}\""
done

# --- Output JSON to stdout ---
cat <<EOF
{"valid": $OVERALL, "errors": [$ERRORS_JSON], "details": {"node_version": "$NODE_VERSION", "npm_version": "$NPM_VERSION", "required_node": "20.18.0+", "required_npm": "8.19.3+", "project_dir": "$DIR"}}
EOF

[[ "$OVERALL" == "true" ]] || exit 1
