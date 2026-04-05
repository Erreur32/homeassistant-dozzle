# Dozzle — App Home Assistant

[Dozzle](https://github.com/amir20/dozzle) affiche les journaux Docker en direct. Cette app s’ouvre depuis **Paramètres → Apps** (anciennement add-ons) et dans le menu latéral grâce à **Ingress**.

## Prérequis

- **Architectures** : l’image publiée sur GHCR est construite pour **amd64** et **aarch64** uniquement (limite de l’outil de build Home Assistant 2026).
- **Supervisor** à jour — idéalement **≥ 2026.03.2** (correctifs de sécurité, dont la gestion du réseau pour les apps en `host_network` ; cette image **n’utilise pas** `host_network`).
- Accès **Docker** accordé par le Supervisor (`docker_api: true` dans le manifest).
- Home Assistant **2026.2+** recommandé pour l’intégration panel / Ingress côté frontend.

## Utilisation

1. Installez l’app depuis votre dépôt d’apps.
2. Démarrez-la ; ouvrez **Dozzle** depuis le menu (Ingress).
3. Optionnel : mappez le port **8080** pour un accès direct sans passer par Ingress.

## Options

| Option | Rôle |
|--------|------|
| `log_level` | Verbosité des logs du processus Dozzle. |
| `filter` | Filtre Docker (comme `docker ps --filter`). |
| `no_analytics` | Désactive les statistiques anonymes Dozzle. |
| `enable_actions` | Autorise redémarrage / arrêt depuis l’UI. |
| `enable_agent` | Lance **dozzle agent** dans le même conteneur. |
| `agent_port` | Port d’écoute de l’agent (défaut 7007). |
| `agent_hostname` | Nom affiché pour cet agent. |
| `remote_agents` | Liste `hôte:port,hôte:port` → variable `DOZZLE_REMOTE_AGENT`. |

Si **Agent intégré** est activé, mappez le port **7007/tcp** vers l’hôte pour joindre l’agent depuis une autre instance Dozzle.

## Authentification

L’UI est servie via **Ingress** : l’accès est celui de Home Assistant (`auth_api`). Dozzle est lancé avec `--auth-provider none`.

## Communication avec le Supervisor

- API Supervisor : `http://supervisor/` avec le jeton `SUPERVISOR_TOKEN` (injecté automatiquement).
- Documentation : [Apps — communication](https://developers.home-assistant.io/docs/apps/communication).

## Build (2026)

Le fichier **`build.yaml` n’est plus nécessaire** : la base d’image et les labels sont définis dans le **Dockerfile** (BuildKit / [migration builder avril 2026](https://developers.home-assistant.io/blog/2026/04/02/builder-migration)).

### Publication GitHub (GHCR)

Le dépôt inclut **`.github/workflows/builder.yaml`** (tout le pipeline : prepare / build / manifest) avec les actions **`home-assistant/builder@2026.03.2`**. Sur **push** vers `main`, les images sont poussées vers l’URL de la clé **`image`** dans `config.yaml` (par défaut `ghcr.io/erreur32/homeassistant-dozzle`). Le package GHCR doit être **lié au dépôt** [Erreur32/homeassistant-dozzle](https://github.com/Erreur32/homeassistant-dozzle) avec **`packages: write`** pour le `GITHUB_TOKEN`.

### Build local sur l’hôte HA

Si vous ne publiez pas sur GHCR, supprimez la ligne **`image:`** du manifest pour que le Supervisor construise l’image à partir du `Dockerfile`.

## Dépannage

- Page blanche ou WebSocket cassé : vérifiez que **`ingress_stream: true`** est bien présent dans le manifest.
- Pas de conteneurs : vérifiez le socket Docker et les droits `docker_api`.
