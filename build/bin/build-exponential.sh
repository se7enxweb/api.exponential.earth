#!/bin/bash
#
# build-exponential.sh — Build Exponential CMS Doxygen PHP class documentation
#
# Builds three documentation sets:
#   LS     Legacy Stack  (exponential kernel)        → doxygen/trunk/LS/html/
#   NS     New Stack     (ezpublish-kernel 5.x/7.5)  → doxygen/trunk/NS/html/
#   Basic  Exponential Basic (2.x kernel)            → doxygen/trunk/Basic/html/
#
# Usage:
#   ./build-exponential.sh           # build LS, NS and Basic
#   ./build-exponential.sh ls        # build Legacy Stack only
#   ./build-exponential.sh ns        # build New Stack only
#   ./build-exponential.sh basic     # build Exponential Basic only
#   ./build-exponential.sh --clean   # wipe previous outputs before building
#
# Logs:
#   log/doxygen-build.log         log/doxygen-ns-build.log         log/doxygen-basic-build.log
#   log/doxygen-warnings.log      log/doxygen-ns-warnings.log      log/doxygen-basic-warnings.log

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$(dirname "$SCRIPT_DIR")"
WEBROOT="$(dirname "$BUILD_DIR")"
CLEAN=0
BUILD_LS=1
BUILD_NS=1
BUILD_BASIC=1

# ── Parse arguments ───────────────────────────────────────────────────────────

for arg in "$@"; do
    case "$arg" in
        ls)      BUILD_NS=0; BUILD_BASIC=0 ;;
        ns)      BUILD_LS=0; BUILD_BASIC=0 ;;
        basic)   BUILD_LS=0; BUILD_NS=0 ;;
        --clean) CLEAN=1 ;;
        --help|-h)
            echo "Usage: $0 [ls|ns|basic] [--clean]"
            echo "  ls       Build Legacy Stack only"
            echo "  ns       Build New Stack only"
            echo "  basic    Build Exponential Basic only"
            echo "  --clean  Wipe previous build before generating"
            exit 0 ;;
        *)
            echo "Unknown option: $arg  (use --help)"
            exit 1 ;;
    esac
done

ts() { date '+%Y-%m-%d %H:%M:%S'; }

# ── Pre-flight ────────────────────────────────────────────────────────────────

if ! command -v doxygen &>/dev/null; then
    echo "ERROR: doxygen not found. Install with: dnf install doxygen"
    exit 1
fi

echo "========================================"
echo " Exponential CMS — Doxygen Build"
echo " $(ts)"
echo " doxygen $(doxygen --version)"
echo "========================================"

OVERALL_RESULT=0

mkdir -p "$BUILD_DIR/log"

# ── Generic build function ────────────────────────────────────────────────────
# run_build <label> <doxyfile> <output_dir> <source_check_dir> <build_log> <warn_log> <url>
run_build() {
    local LABEL="$1"
    local DOXYFILE="$2"
    local OUTPUT_DIR="$3"
    local SOURCE_DIR="$4"
    local BUILD_LOG="$5"
    local WARN_LOG="$6"
    local URL="$7"

    echo ""
    echo "── $LABEL ──────────────────────────────────────────────"
    echo "  Doxyfile : $DOXYFILE"
    echo "  Source   : $SOURCE_DIR"
    echo "  Output   : $OUTPUT_DIR/html"

    if [ ! -f "$DOXYFILE" ]; then
        echo "  ERROR: Doxyfile not found: $DOXYFILE"
        OVERALL_RESULT=1
        return
    fi

    if [ ! -d "$SOURCE_DIR" ]; then
        echo "  ERROR: Source directory not found: $SOURCE_DIR"
        OVERALL_RESULT=1
        return
    fi

    # Backup or clean
    if [ "$CLEAN" -eq 1 ]; then
        [ -d "$OUTPUT_DIR/html" ]      && rm -rf "$OUTPUT_DIR/html"
        rm -rf "$OUTPUT_DIR/html_prev"
    elif [ -d "$OUTPUT_DIR/html" ]; then
        echo "[$(ts)]   Backing up previous build → html_prev"
        rm -rf "$OUTPUT_DIR/html_prev"
        mv "$OUTPUT_DIR/html" "$OUTPUT_DIR/html_prev"
    fi

    mkdir -p "$OUTPUT_DIR"

    echo "[$(ts)]   Running doxygen..."
    local START=$SECONDS
    doxygen "$DOXYFILE" > "$BUILD_LOG" 2>"$WARN_LOG" && true
    local ELAPSED=$(( SECONDS - START ))

    if [ -d "$OUTPUT_DIR/html" ] && [ -f "$OUTPUT_DIR/html/index.html" ]; then
        local HTML_COUNT WARN_COUNT
        HTML_COUNT=$(find "$OUTPUT_DIR/html" -name "*.html" | wc -l)
        WARN_COUNT=$(wc -l < "$WARN_LOG")
        echo "[$(ts)]   SUCCESS — ${HTML_COUNT} pages in ${ELAPSED}s (warnings: ${WARN_COUNT})"
        echo "          URL: $URL"
        rm -rf "$OUTPUT_DIR/html_prev"
    else
        echo "[$(ts)]   FAILED — check $BUILD_LOG"
        [ -d "$OUTPUT_DIR/html_prev" ] && mv "$OUTPUT_DIR/html_prev" "$OUTPUT_DIR/html" || true
        OVERALL_RESULT=1
    fi
}

# ── Build LS (Legacy Stack) ───────────────────────────────────────────────────

if [ "$BUILD_LS" -eq 1 ]; then
    run_build \
        "LS — Legacy Stack (exponential kernel)" \
        "$BUILD_DIR/doxygen.config/Doxyfile.exponential" \
        "$WEBROOT/doxygen/trunk/LS" \
        "$WEBROOT/src/exponential" \
        "$BUILD_DIR/log/doxygen-build.log" \
        "$BUILD_DIR/log/doxygen-warnings.log" \
        "https://api.exponential.earth/doxygen/trunk/LS/html/"
fi

# ── Build NS (New Stack) ──────────────────────────────────────────────────────

if [ "$BUILD_NS" -eq 1 ]; then
    run_build \
        "NS — New Stack (ezpublish-kernel 5.x / v7.5)" \
        "$BUILD_DIR/doxygen.config/Doxyfile.exponential-ns" \
        "$WEBROOT/doxygen/trunk/NS" \
        "$WEBROOT/src/ezpublish-kernel" \
        "$BUILD_DIR/log/doxygen-ns-build.log" \
        "$BUILD_DIR/log/doxygen-ns-warnings.log" \
        "https://api.exponential.earth/doxygen/trunk/NS/html/"
fi

# ── Build Basic (Exponential Basic 2.x kernel) ────────────────────────────────

if [ "$BUILD_BASIC" -eq 1 ]; then
    run_build \
        "Basic — Exponential Basic (v2.4.x kernel)" \
        "$BUILD_DIR/doxygen.config/Doxyfile.exponential-basic" \
        "$WEBROOT/doxygen/trunk/Basic" \
        "$WEBROOT/src/exponentialbasic" \
        "$BUILD_DIR/log/doxygen-basic-build.log" \
        "$BUILD_DIR/log/doxygen-basic-warnings.log" \
        "https://api.exponential.earth/doxygen/trunk/Basic/html/"
fi

# ── Pack download archives (only if builds succeeded) ────────────────────────

if [ "$OVERALL_RESULT" -eq 0 ]; then
    PACK_ARGS=()
    # When only one target was requested, pass that label so pack-docs packs only that one
    if [ "$BUILD_LS" -eq 1 ] && [ "$BUILD_NS" -eq 0 ] && [ "$BUILD_BASIC" -eq 0 ]; then
        PACK_ARGS=("ls")
    elif [ "$BUILD_NS" -eq 1 ] && [ "$BUILD_LS" -eq 0 ] && [ "$BUILD_BASIC" -eq 0 ]; then
        PACK_ARGS=("ns")
    elif [ "$BUILD_BASIC" -eq 1 ] && [ "$BUILD_LS" -eq 0 ] && [ "$BUILD_NS" -eq 0 ]; then
        PACK_ARGS=("basic")
    fi
    # Otherwise (any multi-build combination or all) pack-docs.sh defaults to all
    "$SCRIPT_DIR/pack-docs.sh" "${PACK_ARGS[@]}" || OVERALL_RESULT=1
fi

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "========================================"
if [ "$OVERALL_RESULT" -eq 0 ]; then
    echo " ALL BUILDS SUCCESSFUL — $(ts)"
else
    echo " ONE OR MORE BUILDS FAILED — $(ts)"
fi
echo "========================================"

exit $OVERALL_RESULT
