#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.11"
# dependencies = ["pathlib"]
# ///
"""
sn-sdk-fluent/scripts/check-scope-prefix.py
Usage: uv run check-scope-prefix.py [--help] [PROJECT_DIR]
Output: JSON to stdout. Diagnostics to stderr.
Exit code: 0 success, 1 validation error
"""

import json
import sys
from pathlib import Path

def main():
    args = sys.argv[1:]

    # Handle --help
    if "--help" in args:
        print("Usage: uv run check-scope-prefix.py [--help] [PROJECT_DIR]")
        print("")
        print("  PROJECT_DIR  Path to SDK project directory (default: current directory)")
        print("")
        print("Reads now.config.json to extract the 'scope' field, then checks that")
        print("every *.now.ts file under src/ starts with the scope prefix.")
        print("")
        print("Exit codes:")
        print("  0  All .now.ts files use correct scope prefix (or no .now.ts files found)")
        print("  1  Validation error (missing config, empty scope, or prefix mismatch)")
        print("")
        print("Output format:")
        print('  {"valid": true, "errors": [], "details": {"scope": "x_myapp", "violations": [], "files_checked": 3}}')
        print('  {"valid": false, "errors": ["scope_prefix_mismatch"], "details": {"scope": "x_myapp", "violations": ["wrong_file.now.ts"], "files_checked": 1}}')
        print("")
        print("Examples:")
        print("  uv run check-scope-prefix.py")
        print("  uv run check-scope-prefix.py /path/to/my-sn-app")
        sys.exit(0)

    # Determine project directory
    project_dir = "."
    for arg in args:
        if not arg.startswith("--"):
            project_dir = arg
            break

    config_path = Path(project_dir) / "now.config.json"

    # Check now.config.json exists
    if not config_path.exists():
        print(
            json.dumps({
                "valid": False,
                "errors": ["missing_now_config"],
                "details": {"project_dir": str(project_dir)}
            }),
            flush=True
        )
        sys.exit(1)

    # Load and parse now.config.json
    try:
        with open(config_path) as f:
            config = json.load(f)
    except json.JSONDecodeError as e:
        print(f"ERROR: Could not parse now.config.json: {e}", file=sys.stderr)
        print(
            json.dumps({
                "valid": False,
                "errors": ["invalid_now_config_json"],
                "details": {}
            }),
            flush=True
        )
        sys.exit(1)

    scope = config.get("scope", "")

    # Check scope is non-empty
    if not scope:
        print("ERROR: 'scope' field is empty or missing in now.config.json", file=sys.stderr)
        print(
            json.dumps({
                "valid": False,
                "errors": ["empty_scope"],
                "details": {}
            }),
            flush=True
        )
        sys.exit(1)

    # Find all .now.ts files
    project_path = Path(project_dir)
    now_ts_files = list(project_path.rglob("*.now.ts"))

    # If no files found, return valid (0 files is not an error)
    if not now_ts_files:
        print(
            json.dumps({
                "valid": True,
                "errors": [],
                "details": {
                    "scope": scope,
                    "violations": [],
                    "files_checked": 0
                }
            }),
            flush=True
        )
        sys.exit(0)

    # Check each file's basename starts with the scope prefix
    violations = []
    for f in now_ts_files:
        if not f.name.startswith(scope):
            violations.append(f.name)
            print(
                f"ERROR: {f.name} does not start with scope prefix '{scope}'",
                file=sys.stderr
            )

    files_checked = len(now_ts_files)

    if violations:
        print(
            json.dumps({
                "valid": False,
                "errors": ["scope_prefix_mismatch"],
                "details": {
                    "scope": scope,
                    "violations": violations,
                    "files_checked": files_checked
                }
            }),
            flush=True
        )
        sys.exit(1)

    print(
        json.dumps({
            "valid": True,
            "errors": [],
            "details": {
                "scope": scope,
                "violations": [],
                "files_checked": files_checked
            }
        }),
        flush=True
    )
    sys.exit(0)


if __name__ == "__main__":
    main()
