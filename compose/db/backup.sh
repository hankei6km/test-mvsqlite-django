#!/bin/sh

set -e 

test -z "${1}" && echo "require snapshot(version) string(ie. bash backup.sh 0003af..." && exit 1

cd /opt/mysite

export RUST_LOG=info MVSQLITE_DATA_PLANE="http://db:7000"
NS_SNAPSHOT="${1}" LD_PRELOAD=/opt/libmvsqlite_preload.so python manage.py dumpdata > /opt/mysite/dump.json