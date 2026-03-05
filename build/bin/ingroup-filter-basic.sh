#!/bin/bash
#
# ingroup-filter-basic.sh — Doxygen INPUT_FILTER for exponentialbasic
#
# Wraps each PHP file in \addtogroup ... @{ ... @} so that every documented
# class/function inside is assigned to its module's group in modules.html.
#
# Uses \addtogroup + @{ @} rather than \ingroup because the latter only works
# when placed inside an entity's own docblock; wrapping the whole file is the
# reliable way to group all contents.
#
# Group membership is determined by the file's path within the source tree:
#   kernel/<module>/...   → addtogroup <module>       (e.g. ezarticle, ezforum)
#   kernel/classes/...    → addtogroup KernelClasses
#   kernel/private/...    → addtogroup KernelClasses
#   lib/<libname>/...     → addtogroup lib_<libname>  (e.g. lib_ezfile)

FILE="$1"
KERNEL_BASE="/web/vh/ezpublish.se7enx.com/doc/api.exponential.earth/src/exponentialbasic/kernel"
LIB_BASE="/web/vh/ezpublish.se7enx.com/doc/api.exponential.earth/src/exponentialbasic/lib"

GROUP=""

if [[ "$FILE" == "$KERNEL_BASE/"* ]]; then
    REL="${FILE#$KERNEL_BASE/}"
    MOD="${REL%%/*}"
    case "$MOD" in
        classes|private) GROUP="KernelClasses" ;;
        ez*)             GROUP="$MOD" ;;
    esac
elif [[ "$FILE" == "$LIB_BASE/"* ]]; then
    REL="${FILE#$LIB_BASE/}"
    LIB="${REL%%/*}"
    GROUP="lib_${LIB}"
fi

if [[ -n "$GROUP" ]]; then
    # Read the first line (<?php) separately so the group-open marker is
    # placed INSIDE PHP scope — Doxygen only parses entities after <?php.
    head -1 "$FILE"
    echo "/** \\addtogroup ${GROUP} @{ */"
    tail -n +2 "$FILE"
    echo "/** @} */"
else
    cat "$FILE"
fi
