#!/usr/bin/env bash

dir=$(cd -P -- "$(dirname -- "$BASH_SOURCE[0]")" && pwd -P)

#
# load utilities
#
_utilities="${dir}/utils.sh"
if [ ! -r "${_utilities}" ]; then
  echo "Failed to read file ${_utilities}"
  exit 1
fi
. "${_utilities}"


cd ${dir}/docker
docker compose -f docker-compose.yml -p test up --scale "app=3" --build -d

cd ${dir}
./bootstrapVMAuthent.sh -t dockerHosts -u admin

displayDuration