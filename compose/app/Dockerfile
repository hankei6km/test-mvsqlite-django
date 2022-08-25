#ARG VARIANT=ubuntu
#FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}
ARG VARIANT=3-bullseye
FROM mcr.microsoft.com/vscode/devcontainers/python:${VARIANT}

COPY docker-entrypoint* /

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
  # Intall tools
  # * fuse3 - for FUSE mode
  && apt-get -y install --no-install-recommends 2>&1 \
  # Save mcSQLite lib
  && curl -L -o /opt/libmvsqlite_preload.so https://github.com/losfair/mvsqlite/releases/download/v0.1.15/libmvsqlite_preload.so \
  # cleanup
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* \
  # Setup entrypoint
  && chmod u+x /docker-entrypoint.sh \
  && chmod u+x /docker-entrypoint-start.sh

RUN pip3 --disable-pip-version-check --no-cache-dir install Django pylint-django\
   && rm -rf /tmp/pip-tmp

ENTRYPOINT ["/docker-entrypoint.sh"]