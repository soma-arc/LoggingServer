FROM node:20.12.0-bullseye-slim AS base

LABEL org.opencontainers.image.description="LoggingServer"
LABEL org.opencontainers.image.source="https://github.com/soma-arc/LoggingServer"
LABEL org.opencontainers.image.title="LoggingServer"
LABEL org.opencontainers.image.url="https://github.com/soma-arc/LoggingServer"
LABEL org.opencontainers.image.vendor="soma_arc"

FROM base AS app-builder

WORKDIR /usr/src/app

COPY ./app ./
RUN set -e \
 && npm ci

FROM base AS app

RUN set -e \
    && apt-get update \
    && apt-get install -y wget gnupg procps

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64
RUN chmod +x /usr/local/bin/dumb-init

USER node:node

#WORKDIR /usr/src/app/key
#COPY --chown=node:node ./key/local-dev.json ./

WORKDIR /usr/src/app
COPY --chown=node:node ./app ./
COPY --from=app-builder --chown=node:node /usr/src/app/node_modules /usr/src/app/node_modules

ENV TZ=Asia/Tokyo

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["npm", "start"]
