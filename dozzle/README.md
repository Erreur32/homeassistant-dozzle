# Dozzle — Home Assistant App

<div align="center">

**Docker log viewer for Home Assistant** — full UI, **Ingress**, optional **Dozzle agent**.

| | |
| --- | --- |
| **Project** | [github.com/Erreur32/homeassistant-dozzle](https://github.com/Erreur32/homeassistant-dozzle) |
| **Manifest** | [`config.yaml`](config.yaml) |
| **User guide** | [`DOCS.md`](DOCS.md) |
| **Changelog** | [`CHANGELOG.md`](CHANGELOG.md) |

</div>

---

## Layout (2026 Apps)

This folder follows the [Home Assistant App layout](https://developers.home-assistant.io/docs/apps/configuration): **`Dockerfile`**, **`rootfs/`**, **`translations/`**. No legacy `build.yaml` — image base and labels live in the Dockerfile (BuildKit / [builder migration](https://developers.home-assistant.io/blog/2026/04/02/builder-migration)).

```
dozzle/
├── config.yaml
├── Dockerfile
├── rootfs/
├── translations/
├── DOCS.md
├── CHANGELOG.md
└── README.md   ← you are here
```

For installation and options, start with the [repository README](../README.md) or [`DOCS.md`](DOCS.md).
