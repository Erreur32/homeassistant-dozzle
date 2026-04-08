# Changelog

All notable changes to this repository ([homeassistant-dozzle](https://github.com/Erreur32/homeassistant-dozzle)) are documented here. Older **0.2.x** packaging lines are not carried over.

A copy also lives at the repository root: [`CHANGELOG.md`](../CHANGELOG.md).

---

## 0.2.2 - 2026-04-08

- **Icons:** new polygonal Dozzle mascot for `icon.png`, `logo.png` and SVG logo.
- **Docs:** README, DOCS, and addon README now use project SVG logo (`logo.svg`) instead of upstream.

---

## 0.2.1 - 2026-04-08

- **Fix direct access (blank page):** add WebSocket upgrade headers (`Upgrade`, `Connection`) to the direct-access nginx config - Dozzle uses WebSockets for log streaming; without these headers the page loaded but stayed blank because the real-time connection could not be established.
- **Fix direct access startup:** nginx now waits for the direct-access Dozzle instance (`:8082`) to be ready before starting, preventing 502 errors on first load.
- **Icon:** sidebar icon changed from `mdi:text-box-search-outline` to `mdi:docker` (closer to Dozzle's purpose).

---

## 0.2.0 - 2026-04-06

- **New option `enable_direct_access`:** expose Dozzle on port 8088 for direct browser access without the Ingress token prefix. When enabled, a second Dozzle instance starts on `:8082` with `--base /`; nginx serves it on `:8088` without the ingress rewrite. Map port 8088 in the Network tab to use it. Ingress continues to work normally alongside this.
- **Fix direct port (blank page):** root cause documented - the ingress nginx rewrite adds the token prefix, but asset URLs in the HTML already contain the token, so subsequent requests double-prefix and return 404. The new separate-port architecture avoids this entirely.
- **New port `8088/tcp`:** added to manifest and translations (fr/en).

---

## 0.1.9 - 2026-04-06

- **Fix nginx:** restore `user root;` - reverts 0.1.7/0.1.8 attempts; `initgroups(root, 0) failed` is a harmless cosmetic log line (nginx is already root, no privilege drop occurs); the `chown()` fatal error only happens without `user root;`.

---

## 0.1.8 - 2026-04-05

- **Docs:** badges (stars, issues) added to the add-on info page.
- **Cleanup:** replace all em dashes in all project files and scripts.

---

## 0.1.7 - 2026-04-06

- **Fix nginx:** remove `user root;` directive - `initgroups()` is blocked in the HA sandbox; the container already runs as root so the directive is unnecessary.
- **Fix log warning:** rename `DOZZLE_VERSION` env var to `HA_DOZZLE_BIN_VERSION` - Dozzle treats any `DOZZLE_*` env var as its own config and logged a warning.

---

## 0.1.6 - 2026-04-06

- **Restore `agent_hostname`** option (removed by mistake in 0.1.5) - sets the display name for the built-in agent as seen by remote Dozzle UIs.

---

## 0.1.5 - 2026-04-06

- **Fix Ingress (blank page):** use Dozzle's native `--base` flag with the full ingress token path instead of nginx `sub_filter`. Dozzle rewrites all asset and API URLs to include the token; nginx adds the prefix back (Supervisor strips it before forwarding). No HTML patching needed.
- **Fix nginx 502:** add wait loop in nginx startup - nginx now waits for Dozzle (:8081) to accept connections before starting.
- **Simplify agent config:** remove `agent_port` and `agent_hostname` options (port 7007 is hardcoded, hostname label was rarely useful). Updated option descriptions to make the difference between Built-in agent (expose HA outward) and Remote agents (pull in other hosts) explicit.

---

## 0.1.4 - 2026-04-05

- **Fix nginx:** move `client_body_temp_path` / `proxy_temp_path` inside `http {}` block - were incorrectly placed at main context level, causing `directive is not allowed here` fatal error.
- **Logs:** expose `BUILD_VERSION` and `DOZZLE_VERSION` as runtime env vars (`ENV` in Dockerfile); startup banner now shows app version, Dozzle binary version, ingress URL, proxy layout, and all active options.

---

## 0.1.3 - 2026-04-05

- **Fix nginx startup:** redirect all temp files to `/tmp` (avoids `Permission denied` on `/var/lib/nginx/tmp`); add `-e /dev/stderr` flag so the compiled-in early log path is never hit.
- **Fix nginx warning:** remove `sub_filter_types text/html` (duplicate of nginx default).

---

## 0.1.2 - 2026-04-05

- **Fix Ingress blank page:** add nginx reverse proxy in front of Dozzle.
  Dozzle now listens on `:8081` (internal); nginx on `:8080` patches HTML responses:
  - Replaces absolute asset paths (`="/assets/`) with relative ones (`="./assets/`) so the browser resolves them through the Ingress URL instead of the HA root.
  - Injects a small JavaScript shim before `</head>` that rewrites `fetch()`, `XMLHttpRequest`, `WebSocket`, and `history.pushState` calls at runtime so all absolute API paths are transparently prefixed with the Ingress base path.
  - SSE log-streaming endpoints (`/api/*`) bypass buffering (`proxy_buffering off`) to preserve real-time delivery.

---

## 0.1.1 - 2026-04-05

- **Security:** enable AppArmor profile (`apparmor.txt`) - was `false`, now restricts filesystem, capabilities and network access; improves HA security badge score.
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

- **Fix:** add `icon.png` (128×128) and `logo.png` (250×100) - icon now visible in the HA add-on store.
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

- **Documentation (English):** repository [`README.md`](../README.md), [`dozzle/README.md`](README.md), [`DOCS.md`](DOCS.md) - clearer structure (tables, sections), shield badges and My Home Assistant add-repo flow; IMPORTANT block corrected (full Dozzle web UI + Ingress, not the agent-only add-on).
- **Tooling:** [`update_version.sh`](../update_version.sh) updates root `README.md` on each bump: `[release-shield]` / `version-vX.Y.Z-blue`, GitHub `releases/tag/vX.Y.Z` URL, and `` `semver` `` for the packaged app version from `config.yaml`; the **Bundled Dozzle binary** table row is synced from `ARG DOZZLE_VERSION` in `Dockerfile`.
- **Project:** [`CHANGELOG.md`](../CHANGELOG.md) at the repository root; this file updated in parallel for app-folder links.

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
