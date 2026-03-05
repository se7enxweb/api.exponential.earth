#!/bin/bash
#
# rebuild.sh — Full clean rebuild of all Exponential CMS API docs
#
# Usage:
#   bash rebuild.sh            # rebuild all three sets
#   bash rebuild.sh ls         # rebuild Legacy Stack only
#   bash rebuild.sh ns         # rebuild New Stack only
#   bash rebuild.sh basic      # rebuild Basic only

set -euo pipefail

WEBROOT="$(cd "$(dirname "$0")" && pwd)"

echo "========================================"
echo " Exponential API Docs — Full Rebuild"
echo " $(date '+%Y-%m-%d %H:%M:%S')"
echo " Webroot: $WEBROOT"
echo "========================================"

# Regenerate the Basic module group map from live source
echo ""
echo "── Regenerating groups-basic.dox ───────────────────────────────────────"
bash "$WEBROOT/build/bin/generate-groups-basic.sh"

# Build docs (and pack archives)
# Pass an optional set name (ls|ns|basic) as first arg to rebuild only that set
echo ""
if [ "${1:-}" != "" ]; then
    bash "$WEBROOT/build/bin/build-exponential.sh" "$1" --clean
else
    bash "$WEBROOT/build/bin/build-exponential.sh" --clean
fi
