#!/bin/sh

set -e 

test ! -f /opt/mysite/dump.json && echo "dump file is not exists" && exit 1

cd /opt/mysite

export RUST_LOG=info MVSQLITE_DATA_PLANE="http://db:7000"
LD_PRELOAD=/opt/libmvsqlite_preload.so python manage.py loaddata /opt/mysite/dump.json