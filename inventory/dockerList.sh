#!/usr/bin/env bash

dir=$(cd -P -- "$(dirname -- "$BASH_SOURCE[0]")" && pwd -P)
if [ -x "/etc/profile.d/dockerEnv.sh" ] ; then
  . "/etc/profile.d/dockerEnv.sh"
fi

# Name container pattern
PATTERN='test_app_*'

# container list following the pattern
containers_id=$(docker ps  -f "name=${PATTERN}" -f "status=running" --format '{{.ID}}')

# get addresses and port from docker
index=0
for id in ${containers_id}
do
  ports[index]=`docker inspect --format='{{(index (index .NetworkSettings.Ports "22/tcp") 0).HostPort}}' ${id}`
  address[index]=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${id}`
  ((index = index+1))
done
count=$index

# inventory building
printf "{\"dockerHosts\":{\"hosts\":["
for (( i=0; i<${count}; i++ ))
do
  if [ $i != 0 ]; then
    printf ","
  fi
  printf "\"docker${i}\""
done
printf "]},"

printf "\"_meta\":{\"hostvars\":{"
for (( i=0; i<$count; i++ ))
do
  if [ $i != 0 ]; then
    printf ","
  fi
  printf "\"docker${i}\":"
  printf "{\"ansible_ssh_host\":\"${address[i]}\","
  #printf "\"ansible_port\":\"${ports[i]}\"}"
  printf "\"ansible_port\":\"22\"}"
done
printf "}}"
printf "}"