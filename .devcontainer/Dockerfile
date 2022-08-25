FROM ghcr.io/hankei6km/h6-dev-containers:2022-08-24-topic-python-python

RUN pip3 --disable-pip-version-check --no-cache-dir install Django pylint-django\
   && rm -rf /tmp/pip-tmp

USER root

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
  # Intall tools
  # * build-essential - make sqlite3(dynamic link ver)
  # * fuse3 libfuse3-dev - for FUSE mode
  # * sqlite3 - use to try FUSE mode
  && apt-get -y install --no-install-recommends build-essential fuse3 sqlite3 2>&1 \
  # Isntall FoundationDB
  &&  wget https://github.com/apple/foundationdb/releases/download/7.1.15/foundationdb-clients_7.1.15-1_amd64.deb \
  && dpkg -i foundationdb-clients_7.1.15-1_amd64.deb \
  && wget https://github.com/apple/foundationdb/releases/download/7.1.15/foundationdb-server_7.1.15-1_amd64.deb \
  && dpkg -i foundationdb-server_7.1.15-1_amd64.deb \
  # cleanup
  && rm foundationdb-clients_7.1.15-1_amd64.deb foundationdb-server_7.1.15-1_amd64.deb \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*

ARG USERNAME=vscode
WORKDIR "/home/${USERNAME}"
USER ${USERNAME}

# Install mvSQLite into user env
RUN mkdir -p "/home/${USERNAME}/mvsqlite" \
  && cd "/home/${USERNAME}/mvsqlite" \
  && curl -L -o ./libmvsqlite_preload.so https://github.com/losfair/mvsqlite/releases/download/v0.1.15/libmvsqlite_preload.so \
  && curl -L -o ./mvstore https://github.com/losfair/mvsqlite/releases/download/v0.1.15/mvstore \
  && chmod +x ./mvstore \
  # && curl -L -o ./mvsqlite-fuse https://github.com/losfair/mvsqlite/releases/download/v0.1.15/mvsqlite-fuse \
  # && chmod +x ./mvsqlite-fuse \
  # Build sqlite(dynamic link)
  # && wget https://www.sqlite.org/2022/sqlite-amalgamation-3390200.zip \
  # && unzip sqlite-amalgamation-3390200.zip \
  # && cd sqlite-amalgamation-3390200 \
  # && gcc -O2 -fPIC --shared -o libsqlite3.so ./sqlite3.c -lpthread -ldl -lm \
  # && gcc -O2 -o sqlite3 ./shell.c -L. -lsqlite3
  # Write scripts
  && echo $'sudo service foundationdb start\n\
RUST_LOG=info ~/mvsqlite/mvstore \\\n\
  --data-plane 127.0.0.1:7000 \\\n\
  --admin-api 127.0.0.1:7001 \\\n\
  --metadata-prefix mvstore-test \\\n\
  --raw-data-prefix m' > start_mvsql.sh \
  && echo 'curl http://localhost:7001/api/create_namespace -i -d '"'"'{"key":"test","metadata":""}'"'" > create_test_ns.sh \
  && echo $'export RUST_LOG=info MVSQLITE_DATA_PLANE="http://localhost:7000"\n\
LD_PRELOAD=~/mvsqlite/libmvsqlite_preload.so python manage.py "${@}"' > run_manage.sh 
