# Changelog

All notable changes to this repository ([homeassistant-dozzle](https://github.com/Erreur32/homeassistant-dozzle)) are documented here. Older **0.2.x** packaging lines are not carried over.

---

## 0.2.4 - 2026-04-09

- **Fix notification/alert persistence:** Dozzle stores data (notifications, webhooks, alerts) using a relative `./data/` path - the working directory was not explicitly set, so data landed outside the persistent `/data` volume and was lost on every restart. Added `cd /` before launch so `./data/` resolves to the Supervisor-managed persistent volume. (#1)

---

## 0.2.3 - 2026-04-08

- **Fix direct access (blank page):** override `DOZZLE_BASE="/"` for the direct-access instance - the global `export DOZZLE_BASE` (ingress token path) was taking priority over the `--base /` CLI flag.
- **Config:** port 8088 now auto-mapped by default.

---

## 0.2.2 - 2026-04-08

- **Icons:** new polygonal Dozzle mascot for `icon.png`, `logo.png` and SVG logo.
- **Docs:** README, DOCS, and addon README now use project SVG logo (`logo.svg`) instead of upstream.

---

## 0.2.1 - 2026-04-08

- **Fix direct access (blank page):** add WebSocket upgrade headers (`Upgrade`, `Connection`) to the direct-access nginx config - Dozzle uses WebSockets for log streaming; without these headers the page loaded but stayed blank because the real-time connection could not be established.
- **Fix direct access startup:** nginx now waits for the direct-access Dozzle instance (`:8082`) to be ready before starting, preventing 502 errors on first load.
- **Icon:** sidebar icon changed from `mdi:text-box-search-outline` to `mdi:docker`.

---

## 0.1.9 - 2026-04-06

- **Fix nginx:** restore `user root;` - reverts 0.1.7/0.1.8 attempts; `initgroups(root, 0) failed` is a harmless cosmetic log line (nginx is already root, no privilege drop occurs); the `chown()` fatal error only happens without `user root;`.

---

## 0.1.8 - 2026-04-05

- **Docs:** badges (stars, issues) added to the add-on info page (`dozzle/README.md`).
- **Cleanup:** replace all em dashes in all project files and scripts.

---

## 0.1.1 - 2026-04-05

- **Security:** enable AppArmor profile (`dozzle/apparmor.txt`) - was `false`, now restricts filesystem, capabilities and network access; improves HA security badge score.
- **Fix ingress:** set `--base /` (Supervisor strips ingress prefix before forwarding to container - passing the full token path caused 404).

---

## 0.1.0 - 2026-04-05

- **Fix build:** Dozzle upstream image tag corrected to `v10.2.1` (tags use `v` prefix; `10.0.6` did not exist on Docker Hub).
- **Bundled Dozzle:** upgraded from `10.0.6` → `v10.2.1`.

---

## 0.0.9 - 2026-04-05

- **Fix CI:** replace `actions/checkout@v6.0.2` (non-existent) with `actions/checkout@v4` - init job was silently failing, build/push jobs were never executed.
- **CI:** builder now triggers on `v*` tags in addition to pushes to `main`.

---

## 0.0.8 - 2026-04-05

- **Fix build:** move `ARG BUILD_FROM` before the first `FROM` (global Docker scope) - fixes `base name should not be blank` CI build error.

---

## 0.0.7 - 2026-04-05

- **Fix:** add `dozzle/icon.png` (128×128) and `dozzle/logo.png` (250×100) - icon now visible in the HA add-on store.
- **Docs:** `DOCS.md` rewritten - logo at top, cleaner option/port tables, 403 GHCR troubleshooting entry.

---

## 0.0.6 - 2026-04-05

- **HA 2026.4 compliance:** `arch` limited to `amd64` and `aarch64` (only architectures built by CI - armv7/i386 removed to prevent broken installs).
- **HA 2026.4 compliance:** remove `panel_admin` from `config.yaml` (undocumented key in the 2026 spec, ignored/dropped by the Supervisor).

---

## 0.0.5 - 2026-04-05

- **CI fix:** remove unused `.github/workflows/docker-image.yml` that referenced a non-existent `Dockerfile` at the repo root and caused build errors on every push. `builder.yaml` is the only workflow needed.

---

## 0.0.4 - 2026-04-05

- **Documentation (English):** root [`README.md`](README.md), [`dozzle/README.md`](dozzle/README.md), [`dozzle/DOCS.md`](dozzle/DOCS.md) - clearer structure (tables, sections), shield badges and My Home Assistant add-repo flow; IMPORTANT block corrected (full Dozzle web UI + Ingress, not the agent-only add-on).
- **Tooling:** [`update_version.sh`](update_version.sh) updates root `README.md` on each bump: `[release-shield]` / `version-vX.Y.Z-blue`, GitHub `releases/tag/vX.Y.Z` URL, and `` `semver` `` for the packaged app version from `dozzle/config.yaml`; the **Bundled Dozzle binary** table row is synced from `ARG DOZZLE_VERSION` in `dozzle/Dockerfile`.
- **Project:** this file at the repository root; [`dozzle/CHANGELOG.md`](dozzle/CHANGELOG.md) kept in sync for the app folder and existing doc links.

---

## 0.0.3 - 2026-04-05

- Root **README** refresh: centered logo, shield-style badges, [My Home Assistant](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/) add-repository button, repository tree, configuration summary.
- Changelog and commit message prepared for release **v0.0.3** (workflow with `update_version.sh` / `commit-message.txt`).

---

## 0.0.2 - 2026-04-05

- **Root README:** repository-style layout (centered logo, shield badges, My Home Assistant add-repo button, tree, config excerpts).
- Commit message and changelog prepared for **v0.0.2** (push via `update_version.sh`).

---

## 0.0.1 - 2026-04-05

- **Dozzle** Home Assistant App: Ingress, `ingress_stream`, optional agent, **GHCR** image `ghcr.io/erreur32/homeassistant-dozzle`, **`builder.yaml`** workflow (BuildKit).
- Manifest **`arch`**: **amd64** and **aarch64** only for CI (required by Home Assistant 2026 `prepare-multi-arch-matrix`; **armv7** / **i386** excluded from CI builds).
