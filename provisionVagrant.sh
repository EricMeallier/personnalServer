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


cd ${dir}/vm
vagrant plugin install vagrant-disksize
vagrant up


cd ${dir}
./bootstrapVMAuthent.sh -t vagrant -u 'vagrant' -k "${dir}/vm/.vagrant/machines/default/virtualbox/private_key"

displayDuration