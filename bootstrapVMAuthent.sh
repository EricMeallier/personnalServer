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

#
# Install Ansible (need python and wget)
#

install_using_yum() {
  sudo yum install -y ansible
}

install_using_apt() {  
  sudo apt install -y sshpass python3 python3-pip python3-setuptools
  pip3 install ansible
}

install_sshpass_using_apt() {
  sudo apt-get install -y sshpass
}

install_ansible() {
  _info "Install Ansible"
  if command -v yum >/dev/null 2>&1 ; then
    install_using_yum
  elif command -v apt-get >/dev/null 2>&1 ; then
    install_using_apt
  else
    >&2 echo "only apt-get and yum install are coded"
    return 1
  fi
}

install_sshpass() {
  _info "Install sshPass"
if command -v apt-get >/dev/null 2>&1 ; then
    install_sshpass_using_apt
  else
    >&2 echo "only apt-get install is coded"
    return 1
  fi
}

usage() {
  echo "Usage: $0 [-a <initial_address>] [-p <initial_port>] [-u <initial_user, root ?>] [-k <initial_ssh_key_path>] [-t <server target>]" 1>&2;
  echo "Prerequisite file: ~/.personnalVault must containts the ansible_vault key" 1>&2;
  exit 1;
}

_info "Init Environment and tools for the project"

#
# install Ansible
#

command -v ansible-playbook >/dev/null 2>&1 || install_ansible
command -v sshpass >/dev/null 2>&1 || install_sshpass
checkForError "Install Ansible failed"

#
# Default values
#
server_initial_address=''
server_initial_port=22
server_initial_root='root'
server_initial_key=""
server_target=""

#
# Check arguments
#
while getopts ":a:u:k:p:t:" option; do
    case "${option}" in
        a)
            server_initial_address=${OPTARG}
            server_target="initial_server"
            ;;
        u)
            server_initial_root=${OPTARG}
            ;;
        k)
            server_initial_key=${OPTARG}
            ;;
        p)
            server_initial_port=${OPTARG}
            ;;
        t)
            server_target=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))
if [ -z "${server_target}" ] && [ -z "${server_initial_address}" ] || ! [ -f ~/.personnalVault ]; then
    usage
fi

temp_file_inventory=$(mktemp)
trap 'rm -f "${temp_file_inventory}"' EXIT
cat <<EOF > ${temp_file_inventory}
[initial]
initial_server

[initial:vars]
ansible_ssh_host=${server_initial_address}
ansible_ssh_port=${server_initial_port}
EOF


# run ansible playbook
_info "Launch ansible playbook"
if [ ! -z ${server_initial_address} ]; then
  ANSIBLE_FORCE_COLOR=true \
  ANSIBLE_HOST_KEY_CHECKING=false \
  ANSIBLE_SSH_ARGS="${_ssh_options_light}" \
  ANSIBLE_CONFIG="${dir}/ansible.cfg" \
  ansible-playbook -i "${temp_file_inventory}" -i "${dir}/inventory" -l "${server_target}" --user "${server_initial_root}" \
  --vault-id=user@~/.personnalVault \
  "${dir}/bootstrapPlaybook.yml" --ask-pass
else
  ANSIBLE_FORCE_COLOR=true \
  ANSIBLE_HOST_KEY_CHECKING=false \
  ANSIBLE_SSH_ARGS="${_ssh_options}" \
  ANSIBLE_CONFIG="${dir}/ansible.cfg" \
  ansible-playbook -i "${temp_file_inventory}" -vvv -i "${dir}/inventory" -l "${server_target}" --user "${server_initial_root}" \
  --vault-id=user@~/.personnalVault \
  "${dir}/bootstrapPlaybook.yml"
fi

checkForError "Setup failed"


