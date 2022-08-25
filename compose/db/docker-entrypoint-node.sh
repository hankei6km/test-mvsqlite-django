#!/bin/bash

set -e

IP_ADDR="$(ip -4 -o -br a | grep eth0 | awk '{print $3}' | cut -d/ -f1)"

for i in $(seq 10) ; do
  test "${i}" -eq 10 && exit 1

  echo "waiting cluster..."

  #ls /opt/mysite
  test -f /opt/mysite/cluster_ready.tmp && break

  sleep 10
done

cp /opt/mysite/fdb.cluster /etc/foundationdb/fdb.cluster
# fdbserver を直接起動しないと cluster には 1 台しか追加されない.
# (利用は不明、IF が外向きでないから？)
# service foundationdb start
fdbserver -p "${IP_ADDR}:4500"
