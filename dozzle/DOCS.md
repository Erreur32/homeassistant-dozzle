<img src="https://raw.githubusercontent.com/Erreur32/homeassistant-dozzle/main/logo.svg" alt="Dozzle" width="80">

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
5. *(Optional)* enable `enable_direct_access` in options, then map port **8088** in the Network tab for direct access outside Ingress.

---

## Configuration options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `log_level` | select | `info` | Verbosity: `trace` `debug` `info` `warn` `error` `fatal` |
| `filter` | string | *(empty)* | Docker filter string (same syntax as `docker ps --filter`) |
| `no_analytics` | bool | `true` | Disable anonymous Dozzle analytics |
| `enable_actions` | bool | `false` | Allow restart/stop actions from the UI *(use with care)* |
| `enable_direct_access` | bool | `false` | Expose Dozzle on port **8088** for direct browser access without Ingress |
| `enable_agent` | bool | `false` | Expose this HA host to a remote Dozzle instance (see Agent section) |
| `agent_hostname` | string | *(empty)* | Display name for this node in remote Dozzle UIs |
| `remote_agents` | string | *(empty)* | Comma-separated `host:port` list of remote agents to aggregate here |

---

## Ports

| Port | Purpose |
|------|---------|
| `8080/tcp` | Ingress proxy (internal - do not map) |
| `8088/tcp` | Direct web access - map when `enable_direct_access: true` |
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

## Alerts / Log Filters (notifications)

Dozzle has a built-in alert engine that monitors container logs server-side and sends **webhook notifications** when expressions match. This works independently of the log viewer UI.

### How it works

1. **Create a dispatcher** (Settings > Notifications > Dispatchers): add a webhook URL where alerts should be sent (e.g. Home Assistant webhook, Slack, Discord, ntfy...).
2. **Create a notification rule** (Settings > Notifications > Rules):
   - **Container expression** - which containers to monitor, e.g. `name contains "guacamole"`
   - **Log expression** - what to match in the logs, e.g. `message contains "authentication failure"`
3. When a **new** log entry matches both expressions, Dozzle sends a POST to your webhook URL.

### Important notes

- Alerts only match **new** log entries (after the rule is created/loaded). Existing logs are not scanned retroactively.
- A **webhook dispatcher must exist** before alerts can fire. Without one, rules will match but notifications go nowhere.
- The alert engine runs **server-side** via Docker socket - it opens its own log streams, separate from the browser UI.
- To debug alerts, set `log_level: debug` in the add-on config. The logs will show container matching, expression evaluation, and webhook dispatch results.

### Expression syntax

Dozzle uses [expr-lang](https://expr-lang.org/) expressions. Examples:

| Type | Example |
|------|---------|
| Container | `name contains "nginx"` |
| Container | `image contains "guacamole" && state == "running"` |
| Log (text) | `message contains "error"` |
| Log (text) | `message contains "authentication failure"` |
| Log (JSON) | `message.level == "error"` |
| Log (regex) | `message matches "WARN\|ERROR\|FATAL"` |

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| **Add-on won't start / no containers** | **Disable Protection mode** on the add-on page, then restart |
| Blank page / broken stream | Check `ingress_stream: true` in the manifest and reload |
| No containers listed | Docker socket access requires Protection mode OFF |
| 403 pulling image | Make the GHCR package public: GitHub -> Packages -> homeassistant-dozzle -> Package settings -> Public |
| Direct access blank page | Enable `enable_direct_access` in options **and** map port `8088/tcp` in the Network tab |
| Agent not reachable from outside | Go to Network tab, set a host port for `7007/tcp` (not mapped by default) |
| **Alerts not triggering** | 1) Verify a webhook dispatcher exists. 2) Set `log_level: debug` and check addon logs for `[notif-diag]` messages. 3) Alerts only match NEW log entries, not existing ones. |

For the full release history see [`CHANGELOG.md`](CHANGELOG.md).
