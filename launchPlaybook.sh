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

ANSIBLE_FORCE_COLOR=true \
ANSIBLE_HOST_KEY_CHECKING=false \
ANSIBLE_SSH_ARGS="${_ssh_options}" \
ANSIBLE_CONFIG="${dir}/ansible.cfg" \
ansible-playbook -i "${dir}/inventory" \
  -l "${targetServer}" --user "${server_user}" \
  --private-key="~/.ssh/${server_user}" "${dir}/${1}.yml" \
  --vault-id=user@~/.personnalVault
checkForError "Setup failed"

displayDuration