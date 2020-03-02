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
  sudo apt -y install sshpass python3 python3-pip python3-setuptools
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

_info "Init Environment and tools for the project"

#
# install Ansible
#

command -v ansible-playbook >/dev/null 2>&1 || install_ansible
command -v sshpass >/dev/null 2>&1 || install_sshpass
checkForError "Install Ansible failed"

#
# run setup
_info "Setup environment and tools using Ansible"

# ssh key generation
# ssh-keygen -b 4096 -f ~/.ssh/${server_user} -N ''
if [[ ! -f ~/.ssh/${server_user} ]]; then
  ansible-vault decrypt --vault-id=user@~/.personnalVault "${dir}/encryptSshKey"
  cp "${dir}/encryptSshKey" ~/.ssh/${server_user}
  chmod 600 ~/.ssh/${server_user}
  ansible-vault encrypt --vault-id=user@~/.personnalVault "${dir}/encryptSshKey"
fi


# run ansible
if [ -z ${server_initial_key} ]; then
  ANSIBLE_FORCE_COLOR=true \
    ANSIBLE_HOST_KEY_CHECKING=false \
    ANSIBLE_SSH_ARGS="${_ssh_options_light}" \
    ANSIBLE_CONFIG="${dir}/ansible.cfg" \
    ansible-playbook -i "${dir}/inventory/inventory" -l "${targetServer}" --user "${server_initial_root}" \
    --vault-id=user@~/.personnalVault \
    "${dir}/bootstrapPlaybook.yml" --ask-pass
else
  ANSIBLE_FORCE_COLOR=true \
    ANSIBLE_HOST_KEY_CHECKING=false \
    ANSIBLE_SSH_ARGS="${_ssh_options}" \
    ANSIBLE_CONFIG="${dir}/ansible.cfg" \
    ansible-playbook -i "${dir}/inventory/inventory" -l "${targetServer}" --user "${server_initial_root}" \
    --private-key="${server_initial_key}" \
    --vault-id=user@~/.personnalVault \
    "${dir}/bootstrapPlaybook.yml"
fi
checkForError "Setup failed"
