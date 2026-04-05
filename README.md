# Home Assistant Add-on Repository: Dozzle

<div align="center">
<img src="https://raw.githubusercontent.com/Erreur32/homeassistant-dozzle-agent/refs/heads/main/dozzle-agent/dozzle.svg" alt="Dozzle" width="128" height="128">

<h2>Dozzle</h2>

<p><strong>Real-time Docker logs in Home Assistant — full web UI, Ingress, optional agent.</strong></p>

</div>

[![Release][release-shield]][release]
![Project Stage][project-stage-shield]
![Project Maintenance][maintenance-shield]
[![License][license-shield]][license]
[![Issues][issues-shield]][issue]
[![Stargazers][stars-shield]][stars]

---

## About

This repository ships the **Dozzle** **Home Assistant App** (formerly “add-on”): the **full Dozzle web interface** in the sidebar, behind **Ingress**, with Home Assistant authentication.

| | |
| --- | --- |
| **Packaged app version** | `0.1.6` (see [`dozzle/config.yaml`](dozzle/config.yaml)) |
| **Bundled Dozzle binary** | `v10.2.1` (see [`dozzle/Dockerfile`](dozzle/Dockerfile)) |
| **Container image** | `ghcr.io/erreur32/homeassistant-dozzle` |

[Dozzle](https://github.com/amir20/dozzle) is a lightweight tool to **stream and search Docker container logs** in real time. This packaging connects to the host Docker engine via the Supervisor (`docker_api`), serves the UI through **Ingress** (`ingress_stream`), and can run an optional **embedded agent** or connect to **remote agents**.

> [!IMPORTANT]
> **Not an official Dozzle project.** Packaging and integration are community-maintained.  
> **This app includes the full Dozzle UI** — it is **not** the standalone “agent-only” add-on.  
> **Repository scope:** Home Assistant packaging for Dozzle only.

---

## Quick start

[![Add this repository to Home Assistant](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2FErreur32%2Fhomeassistant-dozzle)

1. Use the button above **or** add the URL manually under **Settings → Apps → ⋮ → App repositories**.
2. Confirm **Add**; restart Home Assistant if the Supervisor prompts you.
3. Open the [App Store](https://my.home-assistant.io/redirect/supervisor_store/), find **Dozzle**, **Install**, then **Start**.
4. Open **Dozzle** from the sidebar (Ingress).

---

## Repository layout

```
homeassistant-dozzle/
├── repository.yaml          # Supervisor repository metadata
├── README.md                # This file (overview)
├── CHANGELOG.md             # Release notes (mirrored under dozzle/)
└── dozzle/
    ├── config.yaml          # App manifest (version, Ingress, options)
    ├── Dockerfile
    ├── rootfs/              # s6 / Bashio service
    ├── translations/
    ├── README.md            # Short pointer + links
    ├── DOCS.md              # User documentation (detailed)
    └── CHANGELOG.md
```

---

## Features

| | |
| --- | --- |
| Full **Dozzle UI** | Sidebar + **Ingress**; streaming via `ingress_stream` |
| **Docker API** | List containers and tail logs (`docker_api: true`) |
| **Embedded agent** | Optional `dozzle agent` on port **7007** (`enable_agent`) |
| **Remote agents** | Comma-separated `host:port` in `remote_agents` |
| **Image registry** | **GHCR** — see badge / releases |

---

## Configuration (summary)

Configurable in the Supervisor UI after install. Full reference: [`dozzle/DOCS.md`](dozzle/DOCS.md).

| Option | Purpose |
| --- | --- |
| `log_level` | Process log verbosity: `trace` … `fatal` |
| `filter` | Optional Docker filter (same idea as `docker ps --filter`) |
| `no_analytics` | Disable anonymous Dozzle usage stats |
| `enable_actions` | Allow container start/stop from the UI (use carefully) |
| `enable_agent` | Run embedded Dozzle agent for remote instances |
| `agent_port` | Agent listen port (default **7007**) |
| `agent_hostname` | Label for this agent in remote UIs |
| `remote_agents` | Remote `host:port` list (comma-separated) |

**Ports (optional):** **8080** — direct web access in addition to Ingress; **7007** — agent, only if the embedded agent is enabled and you map the port.

---

## Usage

- **Default:** open **Dozzle** from the menu; traffic uses **Ingress** on internal port **8080**.
- **Direct access:** map **8080/tcp** on the host if you want a URL outside the HA UI.
- **Agent:** enable in options, map **7007/tcp**; connect from another Dozzle with `DOZZLE_REMOTE_AGENT=<ha-ip>:<mapped-port>`.

Example environment for a standalone Dozzle container talking to remote agents:

```yaml
environment:
  - DOZZLE_REMOTE_AGENT=192.168.1.10:7007,192.168.1.11:7007
```

---

## Links

| Resource | URL |
| --- | --- |
| This repository | [github.com/Erreur32/homeassistant-dozzle](https://github.com/Erreur32/homeassistant-dozzle) |
| Upstream Dozzle | [github.com/amir20/dozzle](https://github.com/amir20/dozzle) · [dozzle.dev](https://dozzle.dev) |
| Home Assistant Apps | [developers.home-assistant.io/docs/apps](https://developers.home-assistant.io/docs/apps/) |

---

## Support

Report issues on the [GitHub issue tracker][issue].

## Contributing

Pull requests and improvements are welcome.

## Authors

Packaging: [Erreur32][erreur32]. Upstream Dozzle: [Amir Raminfar](https://github.com/amir20) and [contributors](https://github.com/amir20/dozzle/graphs/contributors).  
This repo’s [contributors](https://github.com/Erreur32/homeassistant-dozzle/graphs/contributors).

## License

Repository packaging: see [LICENSE][license] when present in the repo. Upstream Dozzle: [its license](https://github.com/amir20/dozzle/blob/main/LICENSE).

---

[contributors]: https://github.com/Erreur32/homeassistant-dozzle/graphs/contributors
[erreur32]: https://github.com/Erreur32
[issue]: https://github.com/Erreur32/homeassistant-dozzle/issues
[license]: https://github.com/Erreur32/homeassistant-dozzle/blob/main/LICENSE
[maintenance-shield]: https://img.shields.io/maintenance/yes/2026.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-stable-green.svg
[release-shield]: https://img.shields.io/badge/version-v0.1.6-blue.svg
[release]: https://github.com/Erreur32/homeassistant-dozzle/releases/tag/v0.1.6
[license-shield]: https://img.shields.io/badge/license-MIT-blue.svg
[issues-shield]: https://img.shields.io/github/issues/Erreur32/homeassistant-dozzle.svg
[stars-shield]: https://img.shields.io/github/stars/Erreur32/homeassistant-dozzle.svg
[stars]: https://github.com/Erreur32/homeassistant-dozzle/stargazers
