#!/bin/bash
set -euo pipefail

# Generates commit message for workflow deployment
# Usage: generate-commit-msg.sh <target-branch> <automation-core-ref> <github-sha>
# Output: Prints commit message to stdout

TARGET_BRANCH="$1"
AUTOMATION_CORE_REF="$2"
GITHUB_SHA="$3"

cat <<EOF
Deploy automation-core workflows

Deployed from automation-core@${GITHUB_SHA:0:7}

Configuration:
- Automation-core ref: @${AUTOMATION_CORE_REF}
- Target branch: ${TARGET_BRANCH}

This PR was automatically created by the workflow deployment system.
EOF
