![Dozzle](https://raw.githubusercontent.com/Erreur32/homeassistant-dozzle/main/dozzle/logo.png)

# Dozzle — Real-time Docker log viewer

[Dozzle](https://github.com/amir20/dozzle) streams Docker container logs in real time directly inside Home Assistant via **Ingress** (sidebar shortcut, no extra login).

---

> [!IMPORTANT]
> **Protection mode must be disabled.**
> Dozzle needs direct access to the Docker socket (`docker_api`).
> After installation, go to the add-on page → **toggle OFF "Protection mode"** → then Start.
> The add-on will not work with protection mode enabled.

---

## Getting started

1. Add the [repository](https://github.com/Erreur32/homeassistant-dozzle) in **Settings → Apps → Repositories**.
2. Install **Dozzle** — do **not** start it yet.
3. On the add-on page: **disable Protection mode** (toggle in the top-right area).
4. Click **Start**, then open **Dozzle** from the sidebar.
5. *(Optional)* map host port **8080** for direct access outside Ingress.

---

## Configuration options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `log_level` | select | `info` | Verbosity: `trace` `debug` `info` `warn` `error` `fatal` |
| `filter` | string | *(empty)* | Docker filter string (same syntax as `docker ps --filter`) |
| `no_analytics` | bool | `true` | Disable anonymous Dozzle analytics |
| `enable_actions` | bool | `false` | Allow restart/stop actions from the UI *(use with care)* |
| `enable_agent` | bool | `false` | Run a built-in Dozzle agent for remote monitoring |
| `agent_port` | port | `7007` | Agent listen port (requires `enable_agent: true`) |
| `agent_hostname` | string | *(empty)* | Display name for this node in remote Dozzle UIs |
| `remote_agents` | string | *(empty)* | Comma-separated `host:port` list of remote agents to aggregate |

> **Tip:** if `enable_agent` is on and you want remote Dozzle instances to reach this one, map port **7007** in the network tab.

---

## Ports

| Port | Purpose |
|------|---------|
| `8080/tcp` | Web UI — optional direct mapping; Ingress uses this internally |
| `7007/tcp` | Built-in agent — map only when `enable_agent: true` |

---

## Authentication

Access goes through **HA Ingress** — your existing Home Assistant session is used. Dozzle itself runs with `--auth-provider none` because authentication is handled at the HA edge.

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| **Add-on won't start / no containers** | **Disable Protection mode** on the add-on page, then restart |
| Blank page / broken stream | Check `ingress_stream: true` in the manifest and reload |
| No containers listed | Docker socket access requires Protection mode OFF |
| 403 pulling image | Make the GHCR package public: GitHub → Packages → homeassistant-dozzle → Package settings → Public |

For the full release history see [`CHANGELOG.md`](CHANGELOG.md).
