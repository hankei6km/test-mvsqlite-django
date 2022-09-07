#!/bin/bash

case "${1}" in
  "start") exec /docker-entrypoint-start.sh ;;
  # "create") exec /docker-entrypoint-create.sh ;;
esac


# echo "USAGE: docker run [OPTIONS] <IMAGE> [start | create]"
echo "USAGE: docker run [OPTIONS] <IMAGE> [start]"