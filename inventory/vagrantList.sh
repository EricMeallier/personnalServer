#!/usr/bin/env bash

dir=$(cd -P -- "$(dirname -- "$BASH_SOURCE[0]")" && pwd -P)

vagrant ssh-config > /dev/null 2>&1
if [ $? -eq 0 ]
then

    vagrantIP=`cd ${dir}/../provision/vm;vagrant ssh-config | grep HostName |awk  '{print $2}'`
    vagrantPort=`cd ${dir}/../provision/vm;vagrant ssh-config | grep Port |awk  '{print $2}'`
    vagrantUser=`cd ${dir}/../provision/vm;vagrant ssh-config | grep 'User ' |awk  '{print $2}'`
    vagrantIdentity=`cd ${dir}/../provision/vm;vagrant ssh-config | grep IdentityFile |awk  '{print $2}'`


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
