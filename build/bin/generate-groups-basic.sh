#!/bin/bash
# generate-groups-basic.sh
# Generates groups-basic.dox with real class/file cross-references for each module.

BASE=/web/vh/ezpublish.se7enx.com/doc/api.exponential.earth/src/exponentialbasic
OUT=/web/vh/ezpublish.se7enx.com/doc/api.exponential.earth/build/doxygen.config/groups-basic.dox

# ── Helper: emit a Doxygen \ref list for classes in a directory ─────────────
classes_for_dir() {
    local dir="$1"
    [ -d "$dir" ] || return
    grep -rh '^class eZ' "$dir" 2>/dev/null \
        | sed 's/^class \([A-Za-z0-9_]*\).*/\1/' \
        | sort -u
}

# ── Helper: emit filenames (one per line) from a glob ───────────────────────
views_for_dir() {
    local dir="$1"
    [ -d "$dir" ] || return
    ls "$dir"/*.php 2>/dev/null | xargs -I{} basename {}
}

# ── Helper: find datasupplier-style files anywhere in module ─────────────────
suppliers_for_mod() {
    local mod="$1"
    find "$mod" \( -name '*supplier*.php' -o -name '*datasupplier*.php' \) 2>/dev/null \
        | xargs -I{} basename {}  \
        | sort -u
}

# ── Print a class ref line (avoids echo interpreting \r) ────────────────────
ref_line() {
    printf ' * - \\ref %s\n' "$1"
}

# ── Print a file ref line ────────────────────────────────────────────────────
fileref_line() {
    printf ' * - \\ref %s "%s"\n' "$1" "$1"
}

# ── Print source file sections for one module (directly to stdout) ───────────
# file_section <modname> <modpath>
file_section() {
    local modname="$1"
    local modpath="$2"

    local classes adminviews userviews suppliers
    classes=$(classes_for_dir "$modpath/classes")
    adminviews=$(views_for_dir "$modpath/admin")
    userviews=$(views_for_dir "$modpath/user")
    suppliers=$(suppliers_for_mod "$modpath")

    local printed=0

    if [ -n "$classes" ]; then
        printed=1
        printf ' *\n * \\par Key Classes\n'
        while IFS= read -r cls; do
            [ -z "$cls" ] && continue
            ref_line "$cls"
        done <<< "$classes"
    fi

    if [ -n "$suppliers" ]; then
        printed=1
        printf ' *\n * \\par Data Suppliers\n'
        while IFS= read -r f; do
            [ -z "$f" ] && continue
            fileref_line "$f"
        done <<< "$suppliers"
    fi

    if [ -n "$adminviews" ]; then
        printed=1
        printf ' *\n * \\par Admin View Scripts\n'
        while IFS= read -r f; do
            [ -z "$f" ] && continue
            fileref_line "$f"
        done <<< "$adminviews"
    fi

    if [ -n "$userviews" ]; then
        printed=1
        printf ' *\n * \\par Public View Scripts\n'
        while IFS= read -r f; do
            [ -z "$f" ] && continue
            fileref_line "$f"
        done <<< "$userviews"
    fi

    return 0
}

# ── Write the .dox file ─────────────────────────────────────────────────────
{
cat << 'HEADER'
/**
 * \defgroup Libraries Libraries
 * \brief Core support libraries shared across all Exponential Basic modules.
 *
 * \details
 * These libraries provide foundational services that kernel modules build upon.
 * They are framework-independent and can be used in isolation.
 *
 * | Library | Purpose |
 * |---------|---------| 
 * | \ref lib_ezfile  | File I/O, directory traversal, MIME detection |
 * | \ref lib_ezi18n  | Translation, locale, character-set conversion |
 * | \ref lib_ezsession | Session storage abstraction |
 * | \ref lib_ezutils | General helpers, debug, ini parsing, math |
 */

/**
 * \defgroup lib_ezfile File Library (ezfile)
 * \ingroup Libraries
 * \brief File and filesystem utility functions.
 *
 * \details
 * Provides a portable, object-oriented interface for working with the filesystem.
 * Covers file creation, reading, writing, copying, MIME-type detection, directory
 * traversal, compression handlers (gzip, bzip2) and cluster-aware file storage.
 *
 * \par Key Classes
HEADER

# lib_ezfile classes
classes_for_dir "$BASE/lib/ezfile" | while read -r cls; do
    printf ' * - \\ref %s\n' "$cls"
done

cat << 'LIB_EZFILE_END'
 *
 * \see lib_ezutils
 */

/**
 * \defgroup lib_ezi18n Internationalisation Library (ezi18n)
 * \ingroup Libraries
 * \brief Translation, locale and character-set support.
 *
 * \details
 * Manages all language and locale concerns for Exponential Basic:
 * - Translation catalogue loading and string lookup
 * - Locale formatting for dates, numbers and currencies
 * - Character-set conversion via iconv/mbstring
 * - Right-to-left language support
 *
 * \par Key Classes
LIB_EZFILE_END

classes_for_dir "$BASE/lib/ezi18n" | while read -r cls; do
    printf ' * - \\ref %s\n' "$cls"
done

cat << 'LIB_EZI18N_END'
 *
 * \see lib_ezutils
 */

/**
 * \defgroup lib_ezsession Session Library (ezsession)
 * \ingroup Libraries
 * \brief Session management and storage abstraction.
 *
 * \details
 * A thin abstraction over PHP's native session handling that supports pluggable
 * storage backends (database, file, cluster).  Integrates with the kernel user
 * system to bind session data to authenticated users.
 *
 * \par Key Classes
LIB_EZI18N_END

classes_for_dir "$BASE/lib/ezsession" | while read -r cls; do
    printf ' * - \\ref %s\n' "$cls"
done

cat << 'LIB_EZSESSION_END'
 *
 * \see ezuser
 * \see KernelClasses
 */

/**
 * \defgroup lib_ezutils Utilities Library (ezutils)
 * \ingroup Libraries
 * \brief General-purpose helper classes and convenience utilities.
 *
 * \details
 * A broad collection of utilities used throughout the CMS:
 * - Debug output and logging
 * - INI file parsing and settings management
 * - URI parsing and routing
 * - Image conversion and scaling
 * - Mail composition and sending
 * - Cryptography helpers
 *
 * \par Key Classes
LIB_EZSESSION_END

classes_for_dir "$BASE/lib/ezutils" | while read -r cls; do
    printf ' * - \\ref %s\n' "$cls"
done

cat << 'LIB_EZUTILS_END'
 *
 * \see lib_ezfile
 * \see lib_ezi18n
 */

/* ─── Kernel ──────────────────────────────────────────────────────────────── */

/**
 * \defgroup KernelModules Kernel Modules
 * \brief The Exponential Basic 2.x kernel modules.
 *
 * \details
 * Each module is a self-contained functional unit of the CMS.  A module
 * typically contains:
 * - **classes/** — business-logic and data-access classes
 * - **admin/** — administrative view scripts
 * - **user/** — public-facing view scripts
 * - **sql/** — schema and seed data
 *
 * Modules communicate through the kernel dispatch layer (\ref ezmodule) and
 * share infrastructure from the core libraries (\ref Libraries).
 *
 * | Module | Summary |
 * |--------|---------|
 * | \ref ezabout | About / identity pages |
 * | \ref ezad | Advertisement management |
 * | \ref ezaddress | Address book / directory |
 * | \ref ezarticle | Article publishing |
 * | \ref ezbug | Bug / issue tracker |
 * | \ref ezbulkmail | Newsletters and bulk mail |
 * | \ref ezcalendar | Event calendar |
 * | \ref ezcontact | Contact forms |
 * | \ref ezerror | Custom error pages |
 * | \ref ezexample | Tutorial / example module |
 * | \ref ezfilemanager | File upload and downloads |
 * | \ref ezform | Form builder |
 * | \ref ezforum | Discussion forums |
 * | \ref ezgroupeventcalendar | Group-scoped event scheduling |
 * | \ref ezimagecatalogue | Image gallery / catalogue |
 * | \ref ezlink | Link directory |
 * | \ref ezmail | Internal site mail |
 * | \ref ezmediacatalogue | Media asset management |
 * | \ref ezmessage | System notifications |
 * | \ref ezmodule | Module registry and dispatch |
 * | \ref eznewsfeed | RSS / Atom news feeds |
 * | \ref ezpoll | Online polls |
 * | \ref ezquiz | Quiz engine |
 * | \ref ezsearch | Full-text search |
 * | \ref ezsession | Kernel session integration |
 * | \ref ezsitemanager | Multi-site management |
 * | \ref ezstats | Visitor statistics |
 * | \ref ezsurvey | Surveys |
 * | \ref ezsysinfo | System diagnostics |
 * | \ref eztip | Tip-of-the-day |
 * | \ref eztodo | To-do lists |
 * | \ref eztrade | E-commerce / trade |
 * | \ref ezurltranslator | URL aliasing |
 * | \ref ezuser | Users and authentication |
 * | \ref ezxml | XML / structured content |
 * | \ref ezxmlrpc | XML-RPC API |
 */

/**
 * \defgroup KernelClasses Core Kernel Classes
 * \ingroup KernelModules
 * \brief Shared kernel data structures, base classes and framework utilities.
 *
 * \details
 * Everything in `kernel/classes/` that is not specific to one feature module.
 * Includes the content framework, persistent-object layer, workflow engine,
 * caching subsystem and template-variable providers that all other modules rely on.
 *
 * \par Key Classes
LIB_EZUTILS_END

classes_for_dir "$BASE/kernel/classes" | while read -r cls; do
    printf ' * - \\ref %s\n' "$cls"
done

printf ' *\n * \\see Libraries\n * \\see ezmodule\n */\n'

} > "$OUT"

# ── Per-module entries ───────────────────────────────────────────────────────

declare -A MOD_BRIEF=(
    [ezabout]="Site identity and \"about this site\" pages."
    [ezad]="Banner and advertisement management."
    [ezaddress]="Contact address management and directory services."
    [ezarticle]="Article authoring, publishing, versioning and listing."
    [ezbug]="Issue and bug tracking within the CMS."
    [ezbulkmail]="Mass email / newsletter composition and sending."
    [ezcalendar]="Event calendar management and display."
    [ezcontact]="Public contact forms and enquiry handling."
    [ezerror]="Custom error page rendering (404, 403, 500, etc.)."
    [ezexample]="Reference / tutorial module demonstrating the extension API."
    [ezfilemanager]="File upload, storage and download management."
    [ezform]="Configurable web-form builder and submission handling."
    [ezforum]="Threaded discussion boards and topic management."
    [ezgroupeventcalendar]="Group-scoped event and scheduling support."
    [ezimagecatalogue]="Image library, galleries and asset cataloguing."
    [ezlink]="Managed link directory with categories and ranking."
    [ezmail]="Internal site mail between registered users."
    [ezmediacatalogue]="Audio/video and rich-media asset management."
    [ezmessage]="System-level and user-level message notifications."
    [ezmodule]="Core module discovery, registration and request dispatch."
    [eznewsfeed]="RSS/Atom news feed aggregation and publishing."
    [ezpoll]="Online voting polls and result display."
    [ezquiz]="Quiz creation, management and scoring."
    [ezsearch]="Full-text site search indexing and retrieval."
    [ezsession]="Kernel-level session handling and user session persistence."
    [ezsitemanager]="Multi-site configuration, switching and management."
    [ezstats]="Visitor statistics, page-view tracking and reporting."
    [ezsurvey]="Survey creation, distribution and result analysis."
    [ezsysinfo]="Runtime system diagnostics and environment reporting."
    [eztip]="Rotating tips or helpful hints displayed to site visitors."
    [eztodo]="Personal and shared to-do item tracking."
    [eztrade]="Product catalogues, shopping cart and order management."
    [ezurltranslator]="Human-readable URL aliasing and translation."
    [ezuser]="User registration, authentication, profiles and permissions."
    [ezxml]="XML data handling and structured content-type definitions."
    [ezxmlrpc]="XML-RPC server exposing kernel functionality to remote clients."
)

declare -A MOD_TITLE=(
    [ezabout]="About"
    [ezad]="Advertisements"
    [ezaddress]="Address Book"
    [ezarticle]="Articles"
    [ezbug]="Bug Tracker"
    [ezbulkmail]="Bulk Mail"
    [ezcalendar]="Calendar"
    [ezcontact]="Contact Forms"
    [ezerror]="Error Pages"
    [ezexample]="Example Module"
    [ezfilemanager]="File Manager"
    [ezform]="Forms"
    [ezforum]="Forums"
    [ezgroupeventcalendar]="Group Event Calendar"
    [ezimagecatalogue]="Image Catalogue"
    [ezlink]="Link Directory"
    [ezmail]="Mail"
    [ezmediacatalogue]="Media Catalogue"
    [ezmessage]="Messages"
    [ezmodule]="Module Registry"
    [eznewsfeed]="News Feed / RSS"
    [ezpoll]="Polls"
    [ezquiz]="Quizzes"
    [ezsearch]="Search"
    [ezsession]="Sessions (Kernel)"
    [ezsitemanager]="Site Manager"
    [ezstats]="Statistics"
    [ezsurvey]="Surveys"
    [ezsysinfo]="System Information"
    [eztip]="Tips / Tip-of-the-day"
    [eztodo]="To-Do Lists"
    [eztrade]="Trade / E-Commerce"
    [ezurltranslator]="URL Translator"
    [ezuser]="Users & Authentication"
    [ezxml]="XML / Content Types"
    [ezxmlrpc]="XML-RPC"
)

declare -A MOD_SEES=(
    [ezabout]="ezsitemanager ezsysinfo"
    [ezad]="ezstats ezlink"
    [ezaddress]="ezcontact ezuser"
    [ezarticle]="eznewsfeed ezforum ezimagecatalogue ezmediacatalogue ezxmlrpc"
    [ezbug]="ezbulkmail ezuser ezsurvey"
    [ezbulkmail]="ezmail ezstats ezuser"
    [ezcalendar]="ezgroupeventcalendar ezuser"
    [ezcontact]="ezform ezmail ezaddress"
    [ezerror]="ezsitemanager KernelClasses"
    [ezexample]="ezmodule KernelClasses"
    [ezfilemanager]="lib_ezfile ezimagecatalogue ezmediacatalogue ezxmlrpc"
    [ezform]="ezcontact ezsurvey ezmail"
    [ezforum]="ezarticle ezbulkmail ezuser ezmessage"
    [ezgroupeventcalendar]="ezcalendar ezuser ezbulkmail"
    [ezimagecatalogue]="lib_ezfile ezfilemanager ezmediacatalogue ezarticle"
    [ezlink]="ezstats eznewsfeed ezad"
    [ezmail]="ezmessage ezbulkmail ezuser"
    [ezmediacatalogue]="ezimagecatalogue ezfilemanager lib_ezfile"
    [ezmessage]="ezmail ezuser KernelClasses"
    [ezmodule]="KernelClasses ezuser ezexample"
    [eznewsfeed]="ezarticle ezlink KernelClasses"
    [ezpoll]="ezsurvey ezquiz ezstats"
    [ezquiz]="ezpoll ezsurvey ezarticle ezuser"
    [ezsearch]="ezarticle ezstats KernelClasses"
    [ezsession]="lib_ezsession ezuser KernelClasses"
    [ezsitemanager]="ezmodule ezabout ezxmlrpc"
    [ezstats]="ezad ezlink ezsearch"
    [ezsurvey]="ezpoll ezquiz ezbulkmail ezuser"
    [ezsysinfo]="KernelClasses ezabout"
    [eztip]="ezarticle KernelClasses"
    [eztodo]="ezuser ezbulkmail ezcalendar"
    [eztrade]="ezimagecatalogue lib_ezsession ezuser ezxmlrpc ezstats"
    [ezurltranslator]="ezmodule ezsitemanager KernelClasses"
    [ezuser]="lib_ezsession ezsession ezmail ezbulkmail ezxmlrpc"
    [ezxml]="ezarticle eznewsfeed ezxmlrpc KernelClasses"
    [ezxmlrpc]="ezxml ezarticle ezuser eztrade"
)

MODLIST=(
    ezabout ezad ezaddress ezarticle ezbug ezbulkmail ezcalendar ezcontact
    ezerror ezexample ezfilemanager ezform ezforum ezgroupeventcalendar
    ezimagecatalogue ezlink ezmail ezmediacatalogue ezmessage ezmodule
    eznewsfeed ezpoll ezquiz ezsearch ezsession ezsitemanager ezstats
    ezsurvey ezsysinfo eztip eztodo eztrade ezurltranslator ezuser ezxml ezxmlrpc
)

for modname in "${MODLIST[@]}"; do
    modpath="$BASE/kernel/$modname"
    title="${MOD_TITLE[$modname]}"
    brief="${MOD_BRIEF[$modname]}"
    sees="${MOD_SEES[$modname]}"

    {
        printf '\n/**\n'
        printf ' * \\defgroup %s %s\n' "$modname" "$title"
        printf ' * \\ingroup KernelModules\n'
        printf ' * \\brief %s\n' "$brief"

        # check content before printing \details header
        has_content="$(classes_for_dir "$modpath/classes")$(suppliers_for_mod "$modpath")$(views_for_dir "$modpath/admin")$(views_for_dir "$modpath/user")"
        if [ -n "$has_content" ]; then
            printf ' *\n * \\details\n'
            file_section "$modname" "$modpath"
        fi

        if [ -n "$sees" ]; then
            printf ' *\n'
            for s in $sees; do
                printf ' * \\see %s\n' "$s"
            done
        fi
        printf ' */\n'
    } >> "$OUT"
done

echo "Done: $OUT"
wc -l "$OUT"
