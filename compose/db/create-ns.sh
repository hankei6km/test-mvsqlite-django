#!/bin/bash

set -e

for i in $(seq 10) ; do
  test "${i}" -eq 10 && exit 1

  echo "waiting mvstore..."

  curl -s http://localhost:7001/api/list_namespace | jq -r .nskey | grep test && break
  curl http://localhost:7001/api/create_namespace -i -d '{"key":"test","metadata":""}' || true

  sleep 10
done

cd /opt/mysite

# data_plane は外側に向いているいうので注意.
export RUST_LOG=info MVSQLITE_DATA_PLANE="http://db:7000"
LD_PRELOAD=/opt/libmvsqlite_preload.so python manage.py migrate
