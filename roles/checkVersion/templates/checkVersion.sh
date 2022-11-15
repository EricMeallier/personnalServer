#!/bin/bash


envoi_mail () {
    mutt -s "Alerte Version $1: $2"  {{ mail.smtp.alertingTo }} < /dev/null
}

check_delta () {
    app_name=$1
    current_version=$2
    available_version=$3

    echo "$app_name avalaible in ${available_version} and is ${current_version}"

    if [ "${available_version}" != "${current_version}" ]; then
        envoi_mail ${app_name} "Nouvelle version ${available_version} pour remplacer ${current_version}"
    fi


}

REDMINE_CURRENT_VERSION=`ls -l /opt/redmine | sed -e 's/.*redmine-\(.*\)/\1/'`
REDMINE_VERSION=`curl -s https://redmine.org/ | grep "Download\" class=\"wiki-page\"" | sed -e "s/.*wiki-page\">\([0-9]*\.[0-9]*\.[0-9]*\)\ .*wiki-page.*/\1/"`
check_delta "Redmine" $REDMINE_CURRENT_VERSION $REDMINE_VERSION

GOGS_CURRENT_VERSION=`ls -l /opt/gogs | sed -e 's/.*gogs-\(.*\)/\1/'`
GOGS_VERSION=`curl -s https://dl.gogs.io/ | grep '\<a href=\"[0-9]?*'| sed -e 's/.*\([0-9]\.[0-9]*\.[0-9]*\).*/\1/' | sort --version-sort | tail -1`
check_delta "Gogs" $GOGS_CURRENT_VERSION $GOGS_VERSION

NEXTCLOUD_CURRENT_VERSION=`ls -l /opt/nextcloud | sed -e 's/.*nextcloud-\(.*\)/\1/'`
NEXTCLOUD_VERSION=`curl -sL https://github.com/nextcloud/server/releases/latest | grep "tag/" | sed -e "s/.*tag\/v\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/" | sort -u | head -1`
check_delta "Nextcloud" $NEXTCLOUD_CURRENT_VERSION $NEXTCLOUD_VERSION

#PICOCMS_CURRENT_VERSION=`ls -l /opt/pico | sed -e 's/.*pico-\(.*\)/\1/'`
#PICOCMS_VERSION=`curl -sL https://github.com/picocms/Pico/releases/latest | grep "tag/v*" | sed -e "s/.*tag\/v\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/"`
#check_delta "PicoCMS" $PICOCMS_CURRENT_VERSION $PICOCMS_VERSION

#ETHERPAD_CURRENT_VERSION=`ls -l /opt/etherpad-lite | sed -e 's/.*etherpad-lite-\(.*\)/\1/'`
#ETHERPAD_VERSION=`curl -sL https://github.com/ether/etherpad-lite/releases/latest | grep "tag/" | sed -e "s/.*tag\/\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/"`
#check_delta "EtherPad" $ETHERPAD_CURRENT_VERSION $ETHERPAD_VERSION

IS_APT_UP_TODATE=`apt update | grep "can be upgraded" | wc -l`
if [ "${IS_APT_UP_TODATE}" != "0" ]; then
    envoi_mail "SYSTEM" "De nouvelles mises à jour sont disponibles pour apt"
fi
