#!/bin/bash
# Check status of all coccinella-labs repos

ORG="coccinella-labs"

echo "Coccinella Labs Repository Status"
echo "============================"
echo ""

# Get repos from config
REPOS=$(curl -s "https://raw.githubusercontent.com/$ORG/config/main/repos.json" | jq -r '.repos[]')

for repo in $REPOS; do
  # Get latest workflow run
  RUN=$(gh run list --repo "$ORG/$repo" --limit 1 2>/dev/null | head -1)
  if [ -n "$RUN" ]; then
    STATUS=$(echo "$RUN" | awk '{print $1}')
    WORKFLOW=$(echo "$RUN" | awk '{print $2}')
    echo "  $repo: $STATUS ($WORKFLOW)"
  else
    echo "  $repo: no runs"
  fi
done

echo ""
echo "Total repos: $(echo $REPOS | wc -w)"