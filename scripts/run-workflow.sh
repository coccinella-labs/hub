#!/bin/bash
# Run workflow on all coccinella-labs repos

ORG="coccinella-labs"
WORKFLOW="${1:-ci.yml}"
ACTION="${2:-}"

if [ -z "$ACTION" ]; then
  echo "Usage: ./run-workflow.sh <workflow> <action>"
  echo "Example: ./run-workflow.sh release.yml patch"
  exit 1
fi

# Get repos from config
REPOS=$(curl -s "https://raw.githubusercontent.com/$ORG/config/main/repos.json" | jq -r '.repos[]')

echo "Running $WORKFLOW on all repos..."

for repo in $REPOS; do
  echo "  → $repo"
  gh workflow run "$WORKFLOW" -f version="$ACTION" -R "$ORG/$repo" 2>/dev/null || true
done

echo "Done!"