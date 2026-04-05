# Dozzle — Home Assistant App

[Dozzle](https://github.com/amir20/dozzle) streams Docker container logs in real time. This app opens from **Settings → Apps** and the **sidebar** via **Ingress**.

---

## Table of contents

1. [Requirements](#requirements)
2. [Getting started](#getting-started)
3. [Configuration options](#configuration-options)
4. [Ports](#ports)
5. [Authentication](#authentication)
6. [Supervisor communication](#supervisor-communication)
7. [Build & publish (2026)](#build--publish-2026)
8. [Troubleshooting](#troubleshooting)

---

## Requirements

| Topic | Details |
| --- | --- |
| **Architectures** | Images published to GHCR are built for **amd64** and **aarch64** (Home Assistant builder `prepare-multi-arch-matrix`). Other arches may be listed in the manifest for local builds; CI targets these two. |
| **Supervisor** | Prefer **≥ 2026.03.2** (security fixes, including networking for apps using `host_network` — **this image does not use `host_network`**). |
| **Docker access** | Required: Supervisor grants Docker API access (`docker_api: true` in the manifest). |
| **Home Assistant** | **2026.2+** recommended for panel / Ingress behaviour. |

---

## Getting started

1. Add the [app repository](https://github.com/Erreur32/homeassistant-dozzle) and install **Dozzle** from the App Store.
2. **Start** the app; open **Dozzle** from the sidebar (Ingress).
3. **Optional:** map host port **8080** for direct access without Ingress.

---

## Configuration options

| Option | Role |
| --- | --- |
| `log_level` | Verbosity of the Dozzle process logs (`trace` … `fatal`). |
| `filter` | Docker filter string (same idea as `docker ps --filter`). |
| `no_analytics` | When enabled, disables anonymous Dozzle analytics. |
| `enable_actions` | When enabled, allows restart/stop actions from the UI — use with care. |
| `enable_agent` | Runs **dozzle agent** inside the same container. |
| `agent_port` | Agent listen port (default **7007**). |
| `agent_hostname` | Display name for this agent in remote UIs. |
| `remote_agents` | Comma-separated `host:port` list → passed to Dozzle as `DOZZLE_REMOTE_AGENT`. |

If the embedded agent is enabled, map **7007/tcp** on the host so other Dozzle instances can reach it.

---

## Ports

| Port | Purpose |
| --- | --- |
| **8080** | Web UI (optional direct mapping; Ingress uses this internally). |
| **7007** | Embedded Dozzle agent — map only if `enable_agent` is on and you need remote access. |

---

## Authentication

The UI is served through **Ingress**; access follows Home Assistant session rules (`auth_api`). Dozzle is started with `--auth-provider none` because the edge is Home Assistant, not a public Dozzle login.

---

## Supervisor communication

- Supervisor API base: `http://supervisor/` with token **`SUPERVISOR_TOKEN`** (injected automatically).
- Docs: [Apps — communication](https://developers.home-assistant.io/docs/apps/communication).

---

## Build & publish (2026)

### Dockerfile as source of truth

**`build.yaml` is not required.** Base image and OCI labels are defined in the **Dockerfile** (BuildKit). See [Builder migration (April 2026)](https://developers.home-assistant.io/blog/2026/04/02/builder-migration).

### GitHub Actions → GHCR

The repo includes **`.github/workflows/builder.yaml`** (prepare / build / manifest) using **`home-assistant/builder@2026.03.2`**. On push to `main`, images are pushed to the registry URL in the manifest’s **`image`** key (default `ghcr.io/erreur32/homeassistant-dozzle`). Link the GHCR package to [Erreur32/homeassistant-dozzle](https://github.com/Erreur32/homeassistant-dozzle) and grant **`packages: write`** for `GITHUB_TOKEN`.

### Local build on the HA host

If you do not pull from GHCR, remove the **`image:`** line from the manifest so the Supervisor builds from the local `Dockerfile`.

---

## Troubleshooting

| Symptom | What to check |
| --- | --- |
| Blank page or broken WebSocket | Confirm **`ingress_stream: true`** in the app manifest. |
| No containers listed | Docker socket / `docker_api` permissions and Supervisor health. |

For release history, see [`CHANGELOG.md`](CHANGELOG.md).
