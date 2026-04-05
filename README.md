# homeassistant-dozzle

[![GitHub](https://img.shields.io/badge/GitHub-Erreur32%2Fhomeassistant--dozzle-181717?logo=github)](https://github.com/Erreur32/homeassistant-dozzle)
[![Dozzle upstream](https://img.shields.io/badge/upstream-amir20%2Fdozzle-2496ED?logo=github)](https://github.com/amir20/dozzle)

Application **Home Assistant** (app / ancien « add-on ») qui intègre **[Dozzle](https://github.com/amir20/dozzle)** dans le menu latéral, avec **Ingress** et authentification Home Assistant.

---

## Le projet Dozzle (amont)

**Dozzle** est un outil léger pour **lire les journaux des conteneurs Docker** en temps réel : recherche, filtrage, affichage par flux, multi-hôtes possible (agents). Il se connecte au **moteur Docker** de la machine (socket ou API) et n’a pas vocation à remplacer une stack de logs centralisée (ELK, Loki, etc.), mais à offrir une **vue immédiate et simple** sur ce qui s’affiche dans `stdout` / `stderr` des conteneurs.

- Site et documentation : [dozzle.dev](https://dozzle.dev)  
- Code source : [github.com/amir20/dozzle](https://github.com/amir20/dozzle)

---

## Rôle de cette app Home Assistant

Ce dépôt **embarque** Dozzle dans une image adaptée au **Supervisor** : accès **Docker** pour lister les conteneurs et suivre les logs, interface servie derrière le **proxy Ingress** de Home Assistant (même session que le reste de l’UI), sans exposer Dozzle sur Internet sans contrôle. L’image est publiée sur **GitHub Container Registry** (`ghcr.io/erreur32/homeassistant-dozzle`).

Détails d’usage et prérequis : voir [`dozzle/DOCS.md`](dozzle/DOCS.md).

---

## Ajouter le dépôt et installer l’app

1. **Paramètres** → **Apps** → menu **⋮** → **Dépôts d’applications**.  
2. Ajouter l’URL : `https://github.com/Erreur32/homeassistant-dozzle`  
3. Installer l’app **Dozzle**, puis l’ouvrir depuis le menu (Ingress).

---

## Options configurables (interface Supervisor)

Ces réglages sont disponibles dans la configuration de l’app après installation.

| Option | Description |
|--------|-------------|
| **log_level** | Verbosité des logs du processus Dozzle côté app (`trace`, `debug`, `info`, `warn`, `error`, `fatal`). |
| **filter** | Filtre Docker optionnel (même idée que `docker ps --filter`) pour limiter les conteneurs visibles. |
| **no_analytics** | Si activé, n’envoie pas de statistiques d’usage anonymes à Dozzle. |
| **enable_actions** | Si activé, autorise des actions depuis l’UI (redémarrage / arrêt de conteneurs) — à utiliser avec prudence. |
| **enable_agent** | Lance l’**agent Dozzle** dans l’app : permet à **d’autres** instances Dozzle de se connecter à cet hôte Docker (voir ports). |
| **agent_port** | Port d’écoute de l’agent (défaut **7007**). À mapper côté hôte seulement si vous utilisez l’agent. |
| **agent_hostname** | Nom affiché pour cet agent dans les interfaces distantes (optionnel). |
| **remote_agents** | Liste d’hôtes distants `adresse:port` séparés par des virgules pour afficher des conteneurs d’autres machines via leurs agents. |

**Ports** (optionnels) : **8080** — interface web (accès direct en plus du menu Ingress) ; **7007** — agent Dozzle, uniquement si **Agent intégré** est activé et que vous exposez ce port.

---

## Liens utiles

- Ce dépôt : [github.com/Erreur32/homeassistant-dozzle](https://github.com/Erreur32/homeassistant-dozzle)  
- Dozzle (amont) : [github.com/amir20/dozzle](https://github.com/amir20/dozzle) · [dozzle.dev](https://dozzle.dev)  
- Documentation Home Assistant — **Apps** : [developers.home-assistant.io/docs/apps](https://developers.home-assistant.io/docs/apps/)
