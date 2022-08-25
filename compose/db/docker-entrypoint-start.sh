#!/bin/bash

set -e

IP_ADDR="192.168.10.10"

## とりあえず
## create-ns.sh の中でファイルを作っている
test -f /opt/mysite/cluster_ready.tmp && rm /opt/mysite/cluster_ready.tmp
trap 'test -f /opt/mysite/cluster_ready.tmp && rm /opt/mysite/cluster_ready.tmp' EXIT

grep 127.0.0.1 /etc/foundationdb/fdb.cluster > /dev/null && python3 /usr/lib/foundationdb/make_public.py -a "${IP_ADDR}"
service foundationdb start

cp /etc/foundationdb/fdb.cluster /opt/mysite/
touch /opt/mysite/cluster_ready.tmp

for i in $(seq 10) ; do
  test "${i}" -eq 10 && exit 1

  fdbcli --exec 'configure triple' && break;

  sleep 10
  echo retry...
done

echo running...

# namespace 作成(mvSQLite が使えるようになるまで待機している)
sh /opt/create-ns.sh &

RUST_LOG=info mvstore \
  --data-plane "${IP_ADDR}:7000" \
  --admin-api 127.0.0.1:7001 \
  --metadata-prefix mvstore-test \
  --raw-data-prefix m