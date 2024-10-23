#!/usr/bin/env bash

dir=$(cd -P -- "$(dirname -- "$BASH_SOURCE[0]")" && pwd -P)

#
# load utilities
#
_utilities="${dir}/../utils.sh"
if [ ! -r "${_utilities}" ]; then
  echo "Failed to read file ${_utilities}"
  exit 1
fi
. "${_utilities}"

set +o pipefail # to ignore grep error when nothing is found

cd ${dir}/vm
# Choose provider: if libvirt plugin present => libvirt
libvirt=$(vagrant plugin list | grep libvirt | wc -l)
if [ ${libvirt} -eq 1 ]
then
  PROVIDER=libvirt
else
  PROVIDER=virtualbox
fi

vagrant up --provider=${PROVIDER}

cd ${dir}
../bootstrapVMAuthent.sh -t vagrantHosts

displayDuration