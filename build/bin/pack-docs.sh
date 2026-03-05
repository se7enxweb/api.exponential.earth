#!/bin/bash
#
# pack-docs.sh — Create compressed download archives from generated doxygen HTML
#
# Produces (into doxygen/trunk/downloads/):
#   exponential-trunk-apidocs-doxygen-LS.tar.gz    Legacy Stack gz
#   exponential-trunk-apidocs-doxygen-LS.zip        Legacy Stack zip
#   exponential-trunk-apidocs-doxygen-NS.tar.gz    New Stack gz
#   exponential-trunk-apidocs-doxygen-NS.zip        New Stack zip
#   exponential-trunk-apidocs-doxygen-Basic.tar.gz  Basic (2.x) gz
#   exponential-trunk-apidocs-doxygen-Basic.zip     Basic (2.x) zip
#
# These filenames match the download hrefs in index.php at /trunk/<file>
#
# Usage:
#   ./pack-docs.sh        # pack LS, NS and Basic
#   ./pack-docs.sh ls     # pack Legacy Stack only
#   ./pack-docs.sh ns     # pack New Stack only
#   ./pack-docs.sh basic  # pack Exponential Basic only

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$(dirname "$SCRIPT_DIR")"
WEBROOT="$(dirname "$BUILD_DIR")"
DOXY_TRUNK="$WEBROOT/doxygen/trunk"
# Download files are served from /trunk/ (web root relative)
DOWNLOAD_DIR="$WEBROOT/trunk"
PACK_LS=1
PACK_NS=1
PACK_BASIC=1

# ── Parse arguments ───────────────────────────────────────────────────────────

for arg in "$@"; do
    case "$arg" in
        ls) PACK_NS=0; PACK_BASIC=0 ;;
        ns) PACK_LS=0; PACK_BASIC=0 ;;
        basic) PACK_LS=0; PACK_NS=0 ;;
        --help|-h)
            echo "Usage: $0 [ls|ns|basic]"
            echo "  ls     Pack Legacy Stack only"
            echo "  ns     Pack New Stack only"
            echo "  basic  Pack Exponential Basic only"
            exit 0 ;;
        *)
            echo "Unknown option: $arg  (use --help)"
            exit 1 ;;
    esac
done

ts() { date '+%Y-%m-%d %H:%M:%S'; }

mkdir -p "$DOWNLOAD_DIR"

echo "========================================"
echo " Exponential CMS — Pack API Docs"
echo " $(ts)"
echo " Downloads dir: $DOWNLOAD_DIR"
echo "========================================"

OVERALL_RESULT=0

# ── Generic pack function ─────────────────────────────────────────────────────
# pack_html <label> <src_html_dir> <archive_basename>
# archive_basename: e.g. exponential-trunk-apidocs-doxygen-LS
pack_html() {
    local LABEL="$1"
    local SRC="$2"
    local BASENAME="$3"
    local TGZ="$DOWNLOAD_DIR/${BASENAME}.tar.gz"
    local ZIP="$DOWNLOAD_DIR/${BASENAME}.zip"
    local INNER_DIR="$BASENAME"   # name of the top-level folder inside the archive

    echo ""
    echo "── $LABEL ──────────────────────────────────────────────"

    if [ ! -d "$SRC" ]; then
        echo "  ERROR: HTML source not found: $SRC"
        OVERALL_RESULT=1
        return
    fi

    local FILE_COUNT
    FILE_COUNT=$(find "$SRC" -name "*.html" | wc -l)
    echo "  Source  : $SRC  ($FILE_COUNT HTML files)"
    echo "  tar.gz  : $TGZ"
    echo "  zip     : $ZIP"

    local START=$SECONDS

    # tar.gz — create a top-level folder <INNER_DIR>/html/ inside the archive
    echo "[$(ts)]   Creating tar.gz..."
    tar -czf "$TGZ" \
        --transform "s|^|${INNER_DIR}/|" \
        -C "$(dirname "$SRC")" \
        "$(basename "$SRC")"

    # zip — same top-level structure
    echo "[$(ts)]   Creating zip..."
    # Use a temp staging dir so the archive has a clean top-level folder
    local TMP_STAGE
    TMP_STAGE=$(mktemp -d)
    mkdir -p "$TMP_STAGE/$INNER_DIR"
    cp -r "$SRC" "$TMP_STAGE/$INNER_DIR/"
    (cd "$TMP_STAGE" && zip -qr "$ZIP" "$INNER_DIR/")
    rm -rf "$TMP_STAGE"

    local ELAPSED=$(( SECONDS - START ))
    local TGZ_SIZE ZIP_SIZE
    TGZ_SIZE=$(du -sh "$TGZ" | cut -f1)
    ZIP_SIZE=$(du -sh "$ZIP" | cut -f1)

    echo "[$(ts)]   Done in ${ELAPSED}s  —  tar.gz: ${TGZ_SIZE}  zip: ${ZIP_SIZE}"
}

# ── Pack LS ───────────────────────────────────────────────────────────────────

if [ "$PACK_LS" -eq 1 ]; then
    pack_html \
        "LS — Legacy Stack (exponential kernel)" \
        "$DOXY_TRUNK/LS/html" \
        "exponential-trunk-apidocs-doxygen-LS"
fi

# ── Pack NS ───────────────────────────────────────────────────────────────────

if [ "$PACK_NS" -eq 1 ]; then
    pack_html \
        "NS — New Stack (ezpublish-kernel 5.x)" \
        "$DOXY_TRUNK/NS/html" \
        "exponential-trunk-apidocs-doxygen-NS"
fi

# ── Pack Basic ───────────────────────────────────────────────────────────

if [ "$PACK_BASIC" -eq 1 ]; then
    pack_html \
        "Basic — Exponential Basic (2.x kernel)" \
        "$DOXY_TRUNK/Basic/html" \
        "exponential-trunk-apidocs-doxygen-Basic"
fi

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "========================================"
if [ "$OVERALL_RESULT" -eq 0 ]; then
    echo " PACKING COMPLETE — $(ts)"
    echo ""
    ls -lh "$DOWNLOAD_DIR"/exponential-trunk-apidocs-doxygen-*.{tar.gz,zip} 2>/dev/null || true
else
    echo " PACKING FAILED — $(ts)"
fi
echo "========================================"

exit $OVERALL_RESULT
