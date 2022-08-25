#ARG VARIANT=ubuntu
#FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}
ARG VARIANT=3-bullseye
FROM mcr.microsoft.com/vscode/devcontainers/python:${VARIANT}

COPY docker-entrypoint* /
COPY create-ns.sh /opt/create-ns.sh
COPY create-superuser.sh /opt/create-superuser.sh
COPY backup.sh /opt/backup.sh
COPY restore.sh /opt/restore.sh

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
  # Intall tools
  && apt-get -y install --no-install-recommends 2>&1 \
  # Isntall FoundationDB
  && wget https://github.com/apple/foundationdb/releases/download/7.1.15/foundationdb-clients_7.1.15-1_amd64.deb \
  && dpkg -i foundationdb-clients_7.1.15-1_amd64.deb \
  && wget https://github.com/apple/foundationdb/releases/download/7.1.15/foundationdb-server_7.1.15-1_amd64.deb \
  && dpkg -i foundationdb-server_7.1.15-1_amd64.deb \
  && rm foundationdb-clients_7.1.15-1_amd64.deb \
  && rm foundationdb-server_7.1.15-1_amd64.deb \
  # Install mvSQLite(mystore)
  && wget https://github.com/losfair/mvsqlite/releases/download/v0.1.16/mvstore_0.1.16_amd64.deb \
  && dpkg -i mvstore_0.1.16_amd64.deb \
  && rm mvstore_0.1.16_amd64.deb \
  # Save mcSQLite lib
  && curl -L -o /opt/libmvsqlite_preload.so https://github.com/losfair/mvsqlite/releases/download/v0.1.16/libmvsqlite_preload.so \
  # cleanup
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* \
  # Setup entrypoint
  && chmod u+x /docker-entrypoint.sh \
  && chmod u+x /docker-entrypoint-start.sh \
  && chmod u+x /docker-entrypoint-node.sh \
  && chmod u+x /docker-entrypoint-test.sh

RUN pip3 --disable-pip-version-check --no-cache-dir install Django pylint-django\
   && rm -rf /tmp/pip-tmp

ENTRYPOINT ["/docker-entrypoint.sh"]