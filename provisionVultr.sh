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


cd ${dir}/terraform
terraform apply -auto-approve -var "vultr_api_key=${VULTR_API_KEY}"
initial_address=$(cat terraform.tfstate | jq -r '.resources[]|select( .type == "vultr_instance")|.instances[0].attributes.main_ip')

# Ugly but usefull
sleep 60

cd ${dir}
./bootstrapVMAuthent.sh -a ${initial_address} -k "~/.ssh/${server_user}"

displayDuration