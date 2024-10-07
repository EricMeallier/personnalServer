#!/usr/bin/env bash

dir=$(cd -P -- "$(dirname -- "$BASH_SOURCE[0]")" && pwd -P)


# User for ssh connection
defaultUser=ovhuser
defaultIdentity=~/.ssh/ovhuser

vagrantSshConfig=$(mktemp)
trap 'rm -f "${vagrant_ssh_config_XXXX}"' EXIT


cd ${dir}/../provision/vm;vagrant ssh-config > ${vagrantSshConfig} 2>&1
if [ $? -eq 0 ]
then

    vagrantIP=`cat ${vagrantSshConfig} | grep HostName |awk  '{print $2}'`
    vagrantPort=`cat ${vagrantSshConfig} | grep Port |awk  '{print $2}'`

    ps -f | grep bootstrapVMAuthent | grep -v grep  >/dev/null 2>&1
    if [ $? -eq 0 ]
    then
        vagrantUser=`cat ${vagrantSshConfig} | grep 'User ' |awk  '{print $2}'`
        vagrantIdentity=`cat ${vagrantSshConfig} | grep IdentityFile |awk  '{print $2}'`
    else
        vagrantUser=${defaultUser}
        vagrantIdentity=${defaultIdentity}
    fi

    # inventory building
    printf "{\"vagrantHosts\":{\"hosts\":[\"vagrant\"]},"

    printf "\"_meta\":{\"hostvars\":{"

    printf "\"vagrant\":"
    printf "{\"ansible_host\":\"${vagrantIP}\","
    printf "\"ansible_port\":\"${vagrantPort}\","

    printf "\"ansible_user\":\"${vagrantUser}\","
    printf "\"ansible_ssh_private_key_file\":\"${vagrantIdentity}\" }"

    printf "}}"
    printf "}"
else
    printf "{\"vagrantHosts\":{\"hosts\":[]},\"_meta\":{\"hostvars\":{}}}"
fi
