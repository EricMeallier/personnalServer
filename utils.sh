#!/usr/bin/env bash


set -o errexit    # always exit on error
set -o pipefail   # honor exit codes when piping
set -o nounset  # fail on unset variables

#
# Properties
#

  server_user='ovhuser'
  _ssh_options='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o BatchMode=yes -o IdentitiesOnly=yes -o ConnectTimeout=10'
  _ssh_options_light='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectTimeout=10'

if [[ -z ${UseVagrant} ]]; then
  # Remote physical server
  export server_initial_root='root'
  export server_initial_key=''
  export server_ip='51.178.25.89'
  export server_sshport='22'
else
  # Vagrant
  server_initial_root='vagrant'
  server_initial_key="${dir}/vm/.vagrant/machines/default/virtualbox/private_key"
  server_ip='127.0.0.1'
  server_sshport='2222'
fi

#
# Utilities
#
_NC='\e[0m'
_RED='\e[31m'
_CYAN='\e[36m'
_WHITE='\e[37m'
_debug_on=1

# Display debug message
# $1 => message
_debug() {
  if [ ! -z "$_debug_on" ]; then
    echo -e "${_WHITE}$*${_NC}"
  fi
}

# Display info message
# $1 => message
_info() {
  echo -e "${_CYAN}$*${_NC}"
}

# Display error message
# $1 => message
_error() {
  >&2 echo -e "${_RED}$*${_NC}"
}

# Display error message and eventually exit script
# $1 error message
# $2 whatever : if second parameter is present, will not exit
#
checkForError() {
  local _ret=$?
  if [ ! ${_ret} -eq 0 ]; then
      _error "$1"
      if [ $# -eq 1 ]; then
        exit 1
      else
        return 1
      fi
  fi
}

#
# $1 le message d'erreur
# $2 return code to analyse
_fail () {
  local _msg=$1
  local _code=1
  if [ $# -gt 1 ]; then
    _code=$2
  fi
  _error ${_msg}
  exit ${_code}
}

_begin=$(date +%s)
# Display duration since passed timing
# $1 begin time in seconds (date +%s)
displayDuration() {
  local begin=
  if [ $# -gt 0 ]; then
    begin=$1
  else
    begin=_begin
  fi
  local _end=$(date +%s)
  local _diff=$(($_end - $begin))
  local _minutes=$(($_diff / 60))
  local _seconds=$(($_diff % 60))
  _info "Duration : $_minutes m $_seconds s"
}