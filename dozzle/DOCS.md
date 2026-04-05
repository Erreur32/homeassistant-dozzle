![Dozzle](https://raw.githubusercontent.com/Erreur32/homeassistant-dozzle/main/dozzle/logo.png)

# Dozzle - Real-time Docker log viewer

[Dozzle](https://github.com/amir20/dozzle) streams Docker container logs in real time directly inside Home Assistant via **Ingress** (sidebar shortcut, no extra login).

---

> [!IMPORTANT]
> **Protection mode must be disabled.**
> Dozzle needs direct access to the Docker socket (`docker_api`).
> After installation, go to the add-on page, **toggle OFF "Protection mode"**, then Start.
> The add-on will not work with protection mode enabled.

---

## Getting started

1. Add the [repository](https://github.com/Erreur32/homeassistant-dozzle) in **Settings -> Apps -> Repositories**.
2. Install **Dozzle** - do **not** start it yet.
3. On the add-on page: **disable Protection mode** (toggle in the top-right area).
4. Click **Start**, then open **Dozzle** from the sidebar.
5. *(Optional)* map host port **8080** in the Network tab for direct access outside Ingress.

---

## Configuration options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `log_level` | select | `info` | Verbosity: `trace` `debug` `info` `warn` `error` `fatal` |
| `filter` | string | *(empty)* | Docker filter string (same syntax as `docker ps --filter`) |
| `no_analytics` | bool | `true` | Disable anonymous Dozzle analytics |
| `enable_actions` | bool | `false` | Allow restart/stop actions from the UI *(use with care)* |
| `enable_agent` | bool | `false` | Expose this HA host to a remote Dozzle instance (see Agent section) |
| `agent_hostname` | string | *(empty)* | Display name for this node in remote Dozzle UIs |
| `remote_agents` | string | *(empty)* | Comma-separated `host:port` list of remote agents to aggregate here |

---

## Ports

| Port | Purpose |
|------|---------|
| `8080/tcp` | Web UI - optional direct mapping; Ingress uses this internally |
| `7007/tcp` | Built-in agent - map only when `enable_agent: true` |

---

## Agent - multi-host monitoring

Dozzle supports two complementary agent modes. They are **independent** - you can use one, both, or neither.

### Built-in agent (expose this HA host outward)

> Enable this when **another Dozzle instance** on a different machine needs to see this HA host's containers.

**Steps:**
1. Enable **Built-in agent** in the Options tab.
2. Set an optional **Agent display name** (e.g. `homeassistant`) so the remote UI labels it clearly.
3. Go to the **Network** tab of this add-on and set a host port for `7007/tcp` (e.g. enter `7007`).

   > The port is **not mapped automatically** - you must fill it in manually in the Network tab.

4. Save and restart the add-on.
5. On the **remote** Dozzle instance, add this host: `<ha-ip>:7007` in its `remote_agents` setting.

### Remote agents (pull other hosts into this Dozzle)

> Enable this when you want to see containers from **other machines** alongside HA containers in this add-on.

Set `remote_agents` to a comma-separated list of `host:port` addresses pointing to Dozzle agents already running on other hosts:

```
192.168.1.10:7007,192.168.1.20:7007
```

Each remote host must be running `dozzle agent` (or this same add-on with **Built-in agent** enabled and port mapped).

---

## Authentication

Access goes through **HA Ingress** - your existing Home Assistant session is used. Dozzle itself runs with `--auth-provider none` because authentication is handled at the HA edge.

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| **Add-on won't start / no containers** | **Disable Protection mode** on the add-on page, then restart |
| Blank page / broken stream | Check `ingress_stream: true` in the manifest and reload |
| No containers listed | Docker socket access requires Protection mode OFF |
| 403 pulling image | Make the GHCR package public: GitHub -> Packages -> homeassistant-dozzle -> Package settings -> Public |
| Agent not reachable from outside | Go to Network tab, set a host port for `7007/tcp` (not mapped by default) |

For the full release history see [`CHANGELOG.md`](CHANGELOG.md).
