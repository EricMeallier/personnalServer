#!/usr/bin/env bash

set -o errexit    # always exit on error
set -o pipefail   # honor exit codes when piping
set -o nounset  # fail on unset variables

dir=$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)

#
# load utilities
#
_utilities="${dir}/utils.sh"
if [ ! -r "${_utilities}" ]; then
  echo "Failed to read file ${_utilities}"
  exit 1
fi
. "${_utilities}"

# fake inventory (to gain config as a jenkins slave)
inventoryFile=$(mktemp -t ansible_inventoryXXXXXX)
echo '[remote]' > "${inventoryFile}"
echo "targetServer  ansible_ssh_host=${server_ip} ansible_ssh_port=${server_sshport}" >> "${inventoryFile}"

ANSIBLE_FORCE_COLOR=true ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i "${inventoryFile}" \
  -l "targetServer" --user "${server_user}" \
  --private-key="~/.ssh/${server_user}" "${dir}/${1}.yml" \
  -vvv
checkForError "Setup failed"

# cleanup
rm -f "${inventoryFile}"

displayDuration