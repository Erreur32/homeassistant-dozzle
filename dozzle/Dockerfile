# Home Assistant App (Dockerfile = source unique de vérité pour le build — avril 2026)
# https://developers.home-assistant.io/docs/apps/configuration#app-dockerfile
# https://developers.home-assistant.io/blog/2026/04/02/builder-migration

ARG DOZZLE_VERSION=10.0.6
FROM amir20/dozzle:${DOZZLE_VERSION} AS dozzle_upstream

ARG BUILD_FROM=ghcr.io/home-assistant/base:3.23
FROM ${BUILD_FROM}

ARG BUILD_VERSION=0.0.4
ARG BUILD_ARCH=amd64

RUN apk add --no-cache jq curl

COPY --from=dozzle_upstream /dozzle /usr/local/bin/dozzle
RUN chmod +x /usr/local/bin/dozzle

COPY rootfs /

# Métadonnées registry + champs io.hass.* (le nouveau builder ne les injecte plus automatiquement)
LABEL \
    org.opencontainers.image.title="Home Assistant App: Dozzle" \
    org.opencontainers.image.description="Visionneur de logs Docker — Ingress, agent optionnel." \
    org.opencontainers.image.source="https://github.com/Erreur32/homeassistant-dozzle" \
    org.opencontainers.image.version="${BUILD_VERSION}" \
    org.opencontainers.image.licenses="MIT" \
    io.hass.version="${BUILD_VERSION}" \
    io.hass.type="app" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.name="Dozzle" \
    io.hass.description="Real-time Docker log viewer (Ingress, optional agent)." \
    io.hass.url="https://github.com/Erreur32/homeassistant-dozzle"
