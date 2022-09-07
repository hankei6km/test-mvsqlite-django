#!/bin/bash

set -e

echo "waiting namespace..."

for i in $(seq 10) ; do
  test "${i}" -eq 10 && exit 1

  echo "waiting namespace..."

  curl -s http://localhost:7001/api/list_namespace | jq -r .nskey | grep test && break

  sleep 10
done
