# Changelog

All notable changes to this repository ([homeassistant-dozzle](https://github.com/Erreur32/homeassistant-dozzle)) are documented here. Older **0.2.x** packaging lines are not carried over.

---

## 0.0.5 — 2026-04-05

- **CI fix:** remove unused `.github/workflows/docker-image.yml` that referenced a non-existent `Dockerfile` at the repo root and caused build errors on every push. `builder.yaml` is the only workflow needed.

---

## 0.0.4 — 2026-04-05

- **Documentation (English):** root [`README.md`](README.md), [`dozzle/README.md`](dozzle/README.md), [`dozzle/DOCS.md`](dozzle/DOCS.md) — clearer structure (tables, sections), shield badges and My Home Assistant add-repo flow; IMPORTANT block corrected (full Dozzle web UI + Ingress, not the agent-only add-on).
- **Tooling:** [`update_version.sh`](update_version.sh) updates root `README.md` on each bump: `[release-shield]` / `version-vX.Y.Z-blue`, GitHub `releases/tag/vX.Y.Z` URL, and `` `semver` `` for the packaged app version from `dozzle/config.yaml`; the **Bundled Dozzle binary** table row is synced from `ARG DOZZLE_VERSION` in `dozzle/Dockerfile`.
- **Project:** this file at the repository root; [`dozzle/CHANGELOG.md`](dozzle/CHANGELOG.md) kept in sync for the app folder and existing doc links.

---

## 0.0.3 — 2026-04-05

- Root **README** refresh: centered logo, shield-style badges, [My Home Assistant](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/) add-repository button, repository tree, configuration summary.
- Changelog and commit message prepared for release **v0.0.3** (workflow with `update_version.sh` / `commit-message.txt`).

---

## 0.0.2 — 2026-04-05

- **Root README:** repository-style layout (centered logo, shield badges, My Home Assistant add-repo button, tree, config excerpts).
- Commit message and changelog prepared for **v0.0.2** (push via `update_version.sh`).

---

## 0.0.1 — 2026-04-05

- **Dozzle** Home Assistant App: Ingress, `ingress_stream`, optional agent, **GHCR** image `ghcr.io/erreur32/homeassistant-dozzle`, **`builder.yaml`** workflow (BuildKit).
- Manifest **`arch`**: **amd64** and **aarch64** only for CI (required by Home Assistant 2026 `prepare-multi-arch-matrix`; **armv7** / **i386** excluded from CI builds).
