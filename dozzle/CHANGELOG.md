# Changelog

All notable changes to this repository ([homeassistant-dozzle](https://github.com/Erreur32/homeassistant-dozzle)) are documented here. Older **0.2.x** packaging lines are not carried over.

A copy also lives at the repository root: [`CHANGELOG.md`](../CHANGELOG.md).

---

## 0.3.12 - 2026-08-15

- **Fix:** mount the Home Assistant SSL directory (read-only) so the `agent_cert`/`agent_key` options can actually find the certificate files. Thanks to [@maxexcloo](https://github.com/maxexcloo) ([#5](https://github.com/Erreur32/homeassistant-dozzle/pull/5)).
- **Dozzle binary:** upgraded from `v10.6.13` → `v10.7.1` (upstream release).
  <!-- auto-genere depuis les notes de release GitHub (v10.7.1), a relire/nettoyer -->
  - **Bug Fixes:**
    - Stop alpine build from overwriting the latest tag

---

## 0.3.11 - 2026-07-28

- **Dozzle binary:** upgraded from `v10.6.6` → `v10.6.13` (upstream release).
  <!-- auto-genere depuis les notes de release GitHub (v10.6.13), a relire/nettoyer -->
  - **Bug Fixes:**
    - Revert sidebar collapse animation from #4862
    - **deps**: Update all non-major dependencies

---

## 0.3.10 - 2026-06-18

- **Dozzle binary:** upgraded from `v10.6.5` → `v10.6.6` (upstream release).
  <!-- auto-genere depuis les notes de release GitHub (v10.6.6), a relire/nettoyer -->
  - **Bug Fixes:**
    - **deps**:
      - Update all non-major dependencies
      - Update all non-major dependencies
      - Update all non-major dependencies
      - Update all non-major dependencies
    - **notifications**:
      - Match health_status event alerts
    - **ui**:
      - Null in JSON array crashes ComplexLogItem
      - Highlighted URLs staying clickable

---

## 0.3.9 - 2026-06-14

- **Dozzle binary:** upgraded from `v10.6.2` → `v10.6.5` (upstream releases v10.6.3, v10.6.4, v10.6.5).
  - **Features:**
    - Search progress and completion indicator
  - **Bug Fixes:**
    - Add font-src to CSP headers
    - Live log view stalls on busy containers with rotated logs
    - Expand grouped log lines when copying to clipboard
    - Rank log level guesses by confidence
    - Strip control bytes when copying logs to clipboard
    - Normalize CPU by core count in metric alerts
    - Prevent alert card header overflow on mobile
  - **Cloud:**
    - Resolve read-only container tools in one shot (no extra LLM round-trip)
    - Default exit alert ignores graceful shutdowns (143/137)
  - **Dependencies:** routine non-major dependency updates

---

## 0.3.8 - 2026-05-29

- **Dozzle binary:** upgraded from `v10.6.1` → `v10.6.2` (upstream patch release).
  - **Cloud tools accept name or id:** container-scoped cloud tools now resolve a container by name as well as by id.
  - **Stats charts fix:** per-container stats charts no longer stay stale for a few seconds after switching containers.
  - **Secure JWT cookie:** the auth cookie now sets the `Secure` flag on HTTPS requests.
  - **Mobile container table:** CPU / memory are shown as compact pills on small screens.
  - **Cloud notifications:** the dispatcher backs off on an invalid API key instead of retrying tightly.
  - **Cloud search resiliency:** search timeout raised to 3s and the gRPC deadline mapped to HTTP 504.
  - **Log analytics:** DuckDB MAP inference no longer breaks log analytics; the SQL analytics panel UX is improved.

---

## 0.3.7 - 2026-05-25

- **Dozzle binary:** upgraded from `v10.6.0` → `v10.6.1` (upstream patch release).
  - **Paused container state:** the UI now visually distinguishes paused containers from running / stopped ones. (#4731)
  - **Per-container cloud log filtering:** new `dev.dozzle.cloud.min_level` label lets you filter which log levels a given container forwards to Dozzle Cloud. (#4729)
  - **Level guesser:** recognises Zigbee2MQTT-style log levels (useful for Home Assistant users running the Z2M add-on alongside this one). (#4733)
  - **Misc:** non-major dependency updates.

---

## 0.3.6 - 2026-05-22

- **Dozzle binary:** upgraded from `v10.5.3` → `v10.6.0` (upstream minor release).
  - **OOM / kill event notifications:** Dozzle can now fire alerts when a container is OOM-killed or terminated by the runtime.
  - **Disk I/O stats & volume free-space tracking:** per-container disk I/O metrics and volume usage are exposed in the UI.
  - **New `disk-fill` default rule (`mountUsedPercent`):** ships out of the box to warn when a mounted volume nears full.
  - **Runtime detection:** UI shows a Podman or Docker icon depending on the detected runtime.
  - **Cloud setup redesign:** initial link flow now lets you pick which default signals to enable.
  - **Misc:** clearer error messages on older Docker daemons; search toolbar keeps working when `⌘F` is rebound; dependency / security updates.

---

## 0.3.5 - 2026-05-13

- **Dozzle binary:** upgraded from `v10.5.2` → `v10.5.3` (upstream patch release).
  - **Inverse / exclude filter in log search:** match-by-NOT alongside the existing include filter.
  - **MCP server over Streamable HTTP:** exposed on the existing web server (no extra port).
  - **Notifications:** new "duplicate destination" action; SSE connection-error handling improved.

---

## 0.3.4 - 2026-05-06

- **Dozzle binary:** upgraded from `v10.4.1` → `v10.5.2` (three upstream releases bundled).
  - **v10.5.0:** redesigned settings page; gRPC log streaming to Dozzle Cloud; network stats in container stats; ContainerStore data-race fix; parallelized agent initialization.
  - **v10.5.1:** host-grouping improvements; per-replica cloud connections in Swarm mode.
  - **v10.5.2:** **Cloud Search** (native indexed log search in the UI); SSRF hardening of the webhook dispatcher (blocks `0.0.0.0/8` and broadcast addresses); WebSocket cross-origin upgrades rejected on `attach` / `exec`; Docker event handling fix (cancellable context, proper channel closure).

---

## 0.3.3 - 2026-04-21

- **Dozzle binary:** upgraded from `v10.3.3` → `v10.4.1` (upstream minor + patch).
  - **v10.4.0:** native Docker Compose file deployment from the UI.
  - **v10.4.1:** notification-manager support for Kubernetes cluster services; fix container removal on agents and the queue burst tool-call issue.

---

## 0.3.2 - 2026-04-15

- **Dozzle binary:** upgraded from `v10.3.1` → `v10.3.3` (two upstream patch releases).
  - **v10.3.2:** welcome modal after cloud linking; cloud connection re-established after Pro-plan upgrade; fixed agent healthcheck address-file path; clearer distinction between cloud unavailability and authentication errors.
  - **v10.3.3:** healthcheck validation now passes when only agents are configured (relevant to this add-on's agent-only mode introduced in 0.3.0).

---

## 0.3.0 - 2026-04-13

- **Agent-only mode:** new `enable_master` option (default `true`). Set to `false` with `enable_agent: true` to run only the agent on port 7007 (no web UI, no nginx). Replaces the standalone [dozzle-agent](https://github.com/Erreur32/homeassistant-dozzle-agent) add-on. (#5)
- **Custom TLS certificates:** new `agent_cert` / `agent_key` options. Point to cert/key files in `/ssl/` to restrict agent connections to instances sharing the same key pair. By default, Dozzle uses shared certs embedded in the binary (encrypted but not authenticated). (#5)
- **Docs:** new sections in DOCS.md for agent-only mode, TLS certificate setup, and migration from standalone agent add-on.

---

## 0.2.8 - 2026-04-10

- **Docs: alerts / log filters guide:** added documentation section explaining how the notification system works (dispatcher + rule setup), expression syntax with examples, and case-sensitivity gotchas. (#2)
- **Diagnostic: notification system status at startup:** logs whether `/data/notifications.yml` exists with rule/dispatcher counts. In debug mode, queries the notification API after startup and logs detailed rule state (name, enabled, trigger count, expressions) tagged `[notif-diag]`. (#2)

---

## 0.2.7 - 2026-04-09

- **Fix ingress broken by v0.2.5/v0.2.6:** the WebSocket upgrade headers (`Upgrade`, `Connection $connection_upgrade`) added in v0.2.5 broke the HA Supervisor aiohttp ingress proxy, causing `Cannot write to closing transport` errors on SSE streams and a blank Dozzle panel. Reverted to `Connection ''` (keep-alive without upgrade) which is what Dozzle actually needs - it uses SSE, not WebSocket, for log streaming and alert notifications. The `Accept-Encoding ""` fix for gzip-compressed SSE (#2) is preserved. (#2)

---

## 0.2.6 - 2026-04-09

- **Fix SSE streaming through ingress (alerts, log filters):** strip `Accept-Encoding` in the nginx proxy so Dozzle sends plain-text SSE instead of gzip - the HA Supervisor aiohttp proxy cannot handle gzip-encoded SSE streams. (#2)

---

## 0.2.5 - 2026-04-09

- **WebSocket upgrade headers:** added WebSocket upgrade support to the ingress nginx proxy.

---

## 0.2.4 - 2026-04-09

- **Fix notification/alert persistence:** Dozzle stores data (notifications, webhooks, alerts) using a relative `./data/` path - the working directory was not explicitly set, so data landed outside the persistent `/data` volume and was lost on every restart. Added `cd /` before launch so `./data/` resolves to the Supervisor-managed persistent volume. (#1)

---

## 0.2.3 - 2026-04-08

- **Fix direct access (blank page):** override `DOZZLE_BASE="/"` for the direct-access instance - the global `export DOZZLE_BASE` (ingress token path) was taking priority over the `--base /` CLI flag, causing all asset URLs to embed the ingress prefix on port 8088.
- **Config:** port 8088 now auto-mapped by default (no need to manually enter it in the Network tab).

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
