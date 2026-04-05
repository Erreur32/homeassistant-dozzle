# Changelog

Historique reparti proprement avec le dépôt [homeassistant-dozzle](https://github.com/Erreur32/homeassistant-dozzle) (les anciennes versions 0.2.x ne sont pas reportées ici).

## 0.0.3 — 2026-04-05

- À compléter lors de la release (correctifs, documentation, mise à jour éventuelle du binaire Dozzle amont).

## 0.0.2 — 2026-04-05

- **README** racine : présentation type dépôt officiel (logo Dozzle centré, badges shields.io, bouton [My Home Assistant](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/) pour ajouter le dépôt, arborescence, extraits de configuration).
- Message de commit et changelog préparés pour la release **v0.0.2** (push via `update_version.sh`).

## 0.0.1 — 2026-04-05

- App **Dozzle** pour Home Assistant : Ingress, `ingress_stream`, agent optionnel, image **GHCR** `ghcr.io/erreur32/homeassistant-dozzle`, workflow **builder.yaml** (BuildKit).
- Manifest **`arch`** : uniquement **amd64** et **aarch64** (requis par l’action `prepare-multi-arch-matrix` du builder Home Assistant 2026 ; `armv7` / `i386` exclus du build CI).
