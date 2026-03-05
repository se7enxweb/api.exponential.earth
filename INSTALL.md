# Installation Guide — api.exponential.earth

Step-by-step instructions for deploying the Exponential CMS API documentation
site on a fresh server.  Tested on **AlmaLinux 9.7** with **PHP 8.5** and
**Doxygen 1.9.1**.

---

## 1. System requirements

| Component | Tested version | Install |
|-----------|---------------|---------|
| AlmaLinux / RHEL / Rocky | 9.x | — |
| Apache or nginx | any | — |
| PHP | 8.x | `dnf install php` |
| Doxygen | ≥ 1.9.1 | `dnf install doxygen` |
| Git | any | `dnf install git` |
| zip | any | `dnf install zip` |
| tar, bash | system | pre-installed |

Install all at once:

```bash
dnf install -y doxygen git zip php
```

Verify doxygen is available:

```bash
doxygen --version   # should print 1.9.1 or newer
```

---

## 2. Clone this repository

Choose your web root.  The examples below use
`/web/vh/ezpublish.se7enx.com/doc/api.exponential.earth` — substitute your own
path throughout.

```bash
WEBROOT=/web/vh/ezpublish.se7enx.com/doc/api.exponential.earth

git clone https://github.com/se7enxweb/api.exponential.earth.git "$WEBROOT"
cd "$WEBROOT"
```

---

## 3. Clone the CMS source repositories

The three documentation source repos must be cloned into `build/`.  They are
listed in `.gitignore` and are never committed to this repo.

```bash
cd "$WEBROOT/build"

# Legacy Stack (exponential kernel v6.x)
git clone https://github.com/se7enxweb/exponential.git

# New Stack (ezpublish-kernel v7.5)
git clone https://github.com/se7enxweb/ezpublish-kernel.git

# Exponential Basic (2.x modernised kernel)
git clone https://github.com/se7enxweb/exponentialbasic.git
```

Expected result:

```
build/
├── exponential/
├── ezpublish-kernel/
└── exponentialbasic/
```

> **Private repos / SSH keys**  
> If you use an SSH configuration alias (e.g. `github-as-7x`), substitute the
> SSH remote accordingly:  
> `git clone git@github-as-7x:se7enxweb/exponential.git`

---

## 4. Create output directories

```bash
mkdir -p "$WEBROOT/doxygen/trunk/LS"
mkdir -p "$WEBROOT/doxygen/trunk/NS"
mkdir -p "$WEBROOT/doxygen/trunk/Basic"
mkdir -p "$WEBROOT/trunk"
```

---

## 5. Make scripts executable

```bash
chmod +x "$WEBROOT/build/bin/build-exponential.sh"
chmod +x "$WEBROOT/build/bin/pack-docs.sh"
chmod +x "$WEBROOT/build/bin/generate-groups-basic.sh"
chmod +x "$WEBROOT/build/bin/ingroup-filter-basic.sh"
```

---

## 6. Review the Doxyfile paths

Each Doxyfile hard-codes the absolute web root path.  If your web root differs
from `/web/vh/ezpublish.se7enx.com/doc/api.exponential.earth`, update all three:

```bash
WEBROOT=/your/actual/webroot

for f in build/doxygen.config/Doxyfile.exponential build/doxygen.config/Doxyfile.exponential-ns build/doxygen.config/Doxyfile.exponential-basic; do
    sed -i "s|/web/vh/ezpublish.se7enx.com/doc/api.exponential.earth|$WEBROOT|g" "$f"
done

# Also update the filter script path in the Basic Doxyfile
# (INPUT_FILTER and FILTER_PATTERNS lines) — sed above covers these too.

# And update the generator and filter scripts:
sed -i "s|/web/vh/ezpublish.se7enx.com/doc/api.exponential.earth|$WEBROOT|g" \
    build/bin/generate-groups-basic.sh \
    build/bin/ingroup-filter-basic.sh
```

Verify one Doxyfile looks correct:

```bash
grep 'OUTPUT_DIRECTORY\|INPUT ' build/doxygen.config/Doxyfile.exponential | head -6
```

---

## 7. Generate the Basic module group map

The Basic documentation requires a generated `groups-basic.dox` that maps every
PHP class and view file to its kernel module.  Run the generator once (and again
whenever the `exponentialbasic` source changes):

```bash
cd "$WEBROOT/build/bin"
bash generate-groups-basic.sh
```

This writes `build/doxygen.config/groups-basic.dox` (≈ 1,700 lines) from the live source tree.

---

## 8. Build the documentation

```bash
cd "$WEBROOT/build/bin"

# Build all three sets and create download archives
./build-exponential.sh
```

Or build them individually:

```bash
./build-exponential.sh ls       # Legacy Stack only   (~30 s, ~2,100 pages)
./build-exponential.sh ns       # New Stack only      (~60 s, ~10,300 pages)
./build-exponential.sh basic    # Exponential Basic   (~60 s, ~3,700 pages)
```

On success you will see:

```
ALL BUILDS SUCCESSFUL — 2026-03-05 03:11:53
```

Generated HTML lands in:

```
doxygen/trunk/LS/html/index.html
doxygen/trunk/NS/html/index.html
doxygen/trunk/Basic/html/index.html
```

Download archives land in:

```
trunk/exponential-trunk-apidocs-doxygen-LS.tar.gz    (~11 MB)
trunk/exponential-trunk-apidocs-doxygen-LS.zip        (~14 MB)
trunk/exponential-trunk-apidocs-doxygen-NS.tar.gz    (~21 MB)
trunk/exponential-trunk-apidocs-doxygen-NS.zip        (~42 MB)
trunk/exponential-trunk-apidocs-doxygen-Basic.tar.gz (~12 MB)
trunk/exponential-trunk-apidocs-doxygen-Basic.zip    (~20 MB)
```

---

## 9. Configure the web server

### Apache (recommended)

Create a virtual host pointing the document root at the repo root.

```apache
<VirtualHost *:80>
    ServerName api.exponential.earth
    DocumentRoot /web/vh/ezpublish.se7enx.com/doc/api.exponential.earth

    <Directory /web/vh/ezpublish.se7enx.com/doc/api.exponential.earth>
        DirectoryIndex index.php index.html
        Options -Indexes +FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    # Doxygen HTML — static, no PHP needed
    <Directory /web/vh/ezpublish.se7enx.com/doc/api.exponential.earth/doxygen>
        Options -Indexes
        Require all granted
    </Directory>

    ErrorLog  /var/log/httpd/api.exponential.earth-error.log
    CustomLog /var/log/httpd/api.exponential.earth-access.log combined
</VirtualHost>
```

Enable and reload:

```bash
apachectl configtest && systemctl reload httpd
```

### nginx

```nginx
server {
    listen 80;
    server_name api.exponential.earth;
    root /web/vh/ezpublish.se7enx.com/doc/api.exponential.earth;
    index index.php index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/run/php-fpm/www.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location /doxygen/ {
        autoindex off;
    }

    location /trunk/ {
        autoindex off;
    }
}
```

---

## 10. Set up automatic daily rebuilds (cron)

Add a crontab entry to rebuild and re-pack every night.  The script pulls the
latest source first (optional — add `git pull` calls if you want automated
source updates).

```bash
# Edit root's crontab
crontab -e
```

Add:

```cron
# Rebuild all Exponential API docs at 02:00 every night
0 2 * * * /web/vh/ezpublish.se7enx.com/doc/api.exponential.earth/build/bin/build-exponential.sh --clean >> /var/log/exponential-apidoc-build.log 2>&1
```

To also pull latest source before building, create a wrapper:

```bash
cat > /web/vh/ezpublish.se7enx.com/doc/api.exponential.earth/build/bin/nightly.sh << 'EOF'
#!/bin/bash
set -euo pipefail
REPO=/web/vh/ezpublish.se7enx.com/doc/api.exponential.earth

cd "$REPO/src/exponential"      && git pull --quiet
cd "$REPO/src/ezpublish-kernel" && git pull --quiet
cd "$REPO/src/exponentialbasic" && git pull --quiet

cd "$REPO/build/bin"
bash generate-groups-basic.sh
bash build-exponential.sh --clean
EOF
chmod +x /web/vh/ezpublish.se7enx.com/doc/api.exponential.earth/build/bin/nightly.sh
```

Then cron:

```cron
0 2 * * * /web/vh/ezpublish.se7enx.com/doc/api.exponential.earth/build/bin/nightly.sh >> /var/log/exponential-apidoc-build.log 2>&1
```

---

## 11. Verify the installation

1. Open `https://api.exponential.earth/` — the Bootstrap tab UI should load.
2. Click **Read Online** for each set — the Doxygen index page should open.
3. Navigate to **Modules** in the Basic docs — 46 entries should be listed with
   classes, view scripts and "See Also" cross-links.
4. Click a download link and confirm the archive downloads correctly.

---

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| `doxygen: command not found` | Doxygen not installed | `dnf install doxygen` |
| Build log shows 0 HTML files | Wrong path in Doxyfile | Re-check `OUTPUT_DIRECTORY` and `INPUT` |
| `modules.html` is empty | `groups-basic.dox` stale or filter not executable | Run `build/bin/generate-groups-basic.sh`; `chmod +x build/bin/ingroup-filter-basic.sh` |
| Classes missing from module page | Filter path mismatch | Check absolute path in `FILTER_PATTERNS` in `build/doxygen.config/Doxyfile.exponential-basic` |
| Download links 404 | `trunk/` dir missing or archives not built | Run `./build/bin/pack-docs.sh` manually |
| Blank `index.html` | No `\mainpage` found | Check `build/doxygen.config/mainpage*.dox` is listed in Doxyfile `INPUT` |
| Warning log very large | Normal for legacy PHP — `WARN_IF_UNDOCUMENTED = NO` is set | Review `build/log/doxygen-*-warnings.log` for genuine errors |

Build log locations:

```
build/log/doxygen-build.log          build/log/doxygen-warnings.log
build/log/doxygen-ns-build.log       build/log/doxygen-ns-warnings.log
build/log/doxygen-basic-build.log    build/log/doxygen-basic-warnings.log
```

---

## Adding a new documentation set

1. Clone the source repo into `src/<name>/`
2. Copy `build/doxygen.config/Doxyfile.exponential` to `build/doxygen.config/Doxyfile.exponential-<name>`
3. Update `PROJECT_NAME`, `PROJECT_NUMBER`, `INPUT`, `OUTPUT_DIRECTORY` in the
   new Doxyfile
4. Create `build/doxygen.config/mainpage-<name>.dox` with a `\mainpage` block
5. Add a `run_build` call in `build/bin/build-exponential.sh` and a `pack_html` call in
   `build/bin/pack-docs.sh`
6. Add a row in `index.php` under the appropriate tab
7. If the source uses path-based module grouping, replicate the
   `build/bin/ingroup-filter-basic.sh` / `build/bin/generate-groups-basic.sh` pattern

---

*Last updated: March 2026 — se7enxweb*

---

## Copyright & License

Copyright &copy; 1998 – 2026 **7x**. All rights reserved.

Licensed under the **GNU General Public License, version 2 or (at your option) any later version** (GPLv2+).

> This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the [GNU General Public License](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html) for more details.
