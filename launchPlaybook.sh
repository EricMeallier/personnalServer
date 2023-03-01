#!/usr/bin/env bash

set -o errexit    # always exit on error
set -o pipefail   # honor exit codes when piping
set -o nounset  # fail on unset variables

dir=$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
playbook="personnalServer.yml"

#
# load utilities
#
_utilities="${dir}/utils.sh"
if [ ! -r "${_utilities}" ]; then
  echo "Failed to read file ${_utilities}"
  exit 1
fi
. "${_utilities}"

usage() {
  echo "Usage: $0 [-s <target server>]" 1>&2;
  echo "Prerequisite file: ~/.personnalVault must contains the ansible_vault key" 1>&2;
  exit 1;
}

targetServer=""


while getopts ":s:" option; do
    case "${option}" in
        s)
            targetServer=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))
if [ -z "${targetServer}" ] || ! [ -f ~/.personnalVault ]; then
    usage
fi

ANSIBLE_FORCE_COLOR=true \
ANSIBLE_HOST_KEY_CHECKING=false \
ANSIBLE_SSH_ARGS="${_ssh_options}" \
ANSIBLE_CONFIG="${dir}/ansible.cfg" \
ansible-playbook -i "${dir}/inventory" \
  -l "${targetServer}" --user "${server_user}" \
  --private-key="~/.ssh/${server_user}" "${dir}/${playbook}" \
  --vault-id=user@~/.personnalVault \
  -v
checkForError "Setup failed"

displayDuration