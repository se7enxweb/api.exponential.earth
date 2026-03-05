# api.exponential.earth

> Doxygen PHP class reference documentation for the **Exponential CMS** family,
> served at [api.exponential.earth](https://api.exponential.earth).

---

## Overview

This repository contains the build infrastructure, web frontend and
configuration for generating and serving three separate Doxygen documentation
sets from the Exponential CMS source repositories.

| Set | Label | Source repo | Version | Output URL |
|-----|-------|-------------|---------|------------|
| Legacy Stack | **LS** | [exponential](https://github.com/se7enxweb/exponential) | 6.0.13 | `/doxygen/trunk/LS/html/` |
| New Stack | **NS** | [ezpublish-kernel](https://github.com/se7enxweb/ezpublish-kernel) | 7.5.40 | `/doxygen/trunk/NS/html/` |
| Exponential Basic | **Basic** | [exponentialbasic](https://github.com/se7enxweb/exponentialbasic) | 2.4.0.1 | `/doxygen/trunk/Basic/html/` |

Download archives (`.tar.gz` and `.zip`) are generated automatically and served
from `/trunk/`.

---

## Repository layout

```
api.exponential.earth/
├── index.php                      # Landing page (Bootstrap, tab UI)
├── robots.txt
├── favicon.ico
├── rebuild.sh                     # Full clean rebuild shortcut
│
├── design/                        # Static web assets (ezp design structure)
│   ├── images/                    # Site logo + Bootstrap glyphicons
│   ├── stylesheets/               # Bootstrap + custom CSS
│   └── javascript/                # Bootstrap + custom JS
│
├── build/                         # All build tooling lives here
│   ├── bin/                       # Executable scripts
│   │   ├── build-exponential.sh   # Master build + pack script
│   │   ├── pack-docs.sh           # Archive creator (tar.gz + zip)
│   │   ├── generate-groups-basic.sh # Regenerates groups-basic.dox from source
│   │   └── ingroup-filter-basic.sh  # Doxygen INPUT_FILTER for Basic
│   │
│   ├── log/                       # Build and warning logs (git-ignored)
│   │
│   ├── doxygen.config/            # Doxygen configs and content
│   │   ├── Doxyfile.exponential       # Doxygen config — LS
│   │   ├── Doxyfile.exponential-ns    # Doxygen config — NS
│   │   ├── Doxyfile.exponential-basic # Doxygen config — Basic
│   │   ├── mainpage.dox               # LS landing page content
│   │   ├── mainpage-ns.dox            # NS landing page content
│   │   ├── mainpage-basic.dox         # Basic landing page content
│   │   ├── groups-basic.dox           # Doxygen module group definitions for Basic
│   │   └── footer-basic.html          # Custom HTML footer (copyright notice)
│   │
├── src/                           # Source repository clones (git-ignored)
│   ├── exponential/               # ↳ git clone of exponential (LS source)
│   ├── ezpublish-kernel/          # ↳ git clone of ezpublish-kernel (NS source)
│   └── exponentialbasic/          # ↳ git clone of exponentialbasic (Basic source)
│
├── doxygen/
│   └── trunk/
│       ├── LS/html/               # Generated LS docs  (not in git)
│       ├── NS/html/               # Generated NS docs  (not in git)
│       └── Basic/html/            # Generated Basic docs (not in git)
│
└── trunk/                         # Download archives  (not in git)
    ├── exponential-trunk-apidocs-doxygen-LS.tar.gz
    ├── exponential-trunk-apidocs-doxygen-LS.zip
    ├── exponential-trunk-apidocs-doxygen-NS.tar.gz
    ├── exponential-trunk-apidocs-doxygen-NS.zip
    ├── exponential-trunk-apidocs-doxygen-Basic.tar.gz
    └── exponential-trunk-apidocs-doxygen-Basic.zip
```

> **Note:** The `src/exponential/`, `src/ezpublish-kernel/` and
> `src/exponentialbasic/` source clones, all generated HTML under `doxygen/`
> and all archives under `trunk/` are excluded from version control via
> `.gitignore`.

---

## Quick build

```bash
cd build/bin

# Build all three documentation sets + create download archives
./build-exponential.sh

# Build one set only
./build-exponential.sh ls       # Legacy Stack
./build-exponential.sh ns       # New Stack
./build-exponential.sh basic    # Exponential Basic

# Wipe and rebuild from scratch
./build-exponential.sh --clean
./build-exponential.sh basic --clean
```

Build logs are written to `build/log/doxygen-{,ns-,basic-}build.log` and warnings
to `build/log/doxygen-{,ns-,basic-}warnings.log`.

---

## Updating source repositories

The source repositories are plain git clones inside `build/`. To pick up new
commits:

```bash
cd src/exponential      && git pull
cd src/ezpublish-kernel && git pull
cd src/exponentialbasic && git pull
```

Then rebuild the relevant set:

```bash
cd build/bin && ./build-exponential.sh basic --clean
```

---

## Regenerating the Basic module group map

The Basic documentation set uses a generated `groups-basic.dox` file that maps
every PHP class, data supplier and view script to its owning kernel module.
Whenever new modules or classes are added to `exponentialbasic`, regenerate it:

```bash
cd build/bin
bash generate-groups-basic.sh
bash build-exponential.sh basic --clean
```

The generator reads the live source tree and writes `build/doxygen.config/groups-basic.dox` with
correct `\defgroup` / `\ref` entries for all 36+ kernel modules and 4 libraries.

---

## Architecture notes

### Doxygen INPUT_FILTER (Basic)

Because the legacy `exponentialbasic` source uses pre-PHP5 class declarations
without namespaces, Doxygen needs help assigning each file to its module group.
`ingroup-filter-basic.sh` is registered as Doxygen's `INPUT_FILTER` and
`FILTER_PATTERNS` for `*.php`. It:

1. Reads the file's absolute path
2. Determines the owning module from the first `ez*` directory component under
   `kernel/`, or the library name under `lib/`
3. Injects `/** \addtogroup <group> @{ */` on line 2 (after `<?php`) and
   `/** @} */` at the end

This causes every class and function in the file to appear on the module's group
page in `modules.html`.

### Module group definitions (Basic)

`groups-basic.dox` contains `\defgroup` entries for:

- **Libraries** parent group → `lib_ezfile`, `lib_ezi18n`, `lib_ezsession`,
  `lib_ezutils`
- **KernelModules** parent group → 36 `ez*` kernel modules + `KernelClasses`

Each entry includes a `\details` section listing key classes, data suppliers,
admin view scripts and public view scripts with live `\ref` hyperlinks, plus
`\see` cross-references to related modules.

### Download archives

`pack-docs.sh` produces four archives per set by:

1. Using `tar --transform` to give the archive a clean top-level folder name
   (`exponential-trunk-apidocs-doxygen-LS/html/…`)
2. Staging into a temp directory for the zip to replicate the same structure

Archives land in `trunk/` which maps to the web root, matching the download
`href` values in `index.php`.

---

## Dependencies

| Dependency | Minimum version | Notes |
|------------|----------------|-------|
| doxygen | 1.9.1 | `dnf install doxygen` |
| bash | 5.x | Ships with AlmaLinux 9 |
| zip | any | `dnf install zip` |
| tar | any | Ships with AlmaLinux 9 |
| php | 8.x | For `index.php` landing page |
| git | any | To clone / pull source repos |
| web server | — | Apache or nginx, document root = repo root |

---

## Contributing

Pull requests to improve the build tooling, Doxyfile configs in `build/doxygen.config/`, mainpage content
or landing page UI are welcome. Please do **not** commit generated HTML or
archive files.

Maintainer: **se7enxweb** — <https://github.com/se7enxweb>

---

## Credits and Thanks

Special credit to the maintainers of [https://github.com/brookinsconsulting/apidoc.ez.no/](pubsvn/apidocs.ez.no) who inspired this project.

## Copyright & License

Copyright &copy; 1998 – 2026 **7x**. All rights reserved.

Licensed under the **GNU General Public License, version 2 or (at your option) any later version** (GPLv2+).

> This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the [GNU General Public License](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html) for more details.
