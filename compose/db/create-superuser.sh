#!/bin/bash

set -e

cd /opt/mysite

export RUST_LOG=info MVSQLITE_DATA_PLANE="http://db:7000"
LD_PRELOAD=/opt/libmvsqlite_preload.so python manage.py createsuperuser
