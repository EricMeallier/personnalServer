#!/bin/bash


envoi_mail () {
    mutt -s "[{{ server.domain.sub}}{{server.domain.main }}] Alerte Version $1: $2"  {{ mail.smtp.alertingTo }} < /dev/null
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
REDMINE_VERSION=`curl -s https://www.redmine.org/ | grep "wiki-page" | grep "Download\"" | sed -e "s/.*Download\">\([0-9]*\.[0-9]*\.[0-9]*\)\ .*wiki-page.*/\1/"`
check_delta "Redmine" $REDMINE_CURRENT_VERSION $REDMINE_VERSION

GOGS_CURRENT_VERSION=`ls -l /opt/gogs | sed -e 's/.*gogs-\(.*\)/\1/'`
GOGS_VERSION=`curl -s https://dl.gogs.io/ | grep '\<a href=\"[0-9]?*'| sed -e 's/.*\([0-9]\.[0-9]*\.[0-9]*\).*/\1/' | sort --version-sort | tail -1`
check_delta "Gogs" $GOGS_CURRENT_VERSION $GOGS_VERSION

NEXTCLOUD_CURRENT_VERSION=`ls -l /opt/nextcloud | sed -e 's/.*nextcloud-\(.*\)/\1/'`
NEXTCLOUD_VERSION=`{ curl -sL https://github.com/nextcloud/server/releases ; curl -sL https://github.com/nextcloud/server/releases?page=2 ; } | grep "tag/v[0-9]*\.[0-9]*\.[0-9]*\"" | sed -e "s/.*tag\/v\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/" | sort --version-sort | tail -1`
check_delta "Nextcloud" $NEXTCLOUD_CURRENT_VERSION $NEXTCLOUD_VERSION

WHITEBOARD_CURRENT_VERSION=`ls -l /opt/whiteboard | sed -e 's/.*whiteboard-\(.*\)/\1/'`
WHITEBOARD_VERSION=`{ curl -sL https://github.com/nextcloud/whiteboard/releases ; curl -sL https://github.com/nextcloud/whiteboard/releases?page=2 ; } | grep "tag/v[0-9]*\.[0-9]*\.[0-9]*\"" | sed -e "s/.*tag\/v\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/" | sort --version-sort | tail -1`
check_delta "Whiteboard" $WHITEBOARD_CURRENT_VERSION $WHITEBOARD_VERSION

#PICOCMS_CURRENT_VERSION=`ls -l /opt/pico | sed -e 's/.*pico-\(.*\)/\1/'`
#PICOCMS_VERSION=`curl -sL https://github.com/picocms/Pico/releases/latest | grep "tag/v*" | sed -e "s/.*tag\/v\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/"`
#check_delta "PicoCMS" $PICOCMS_CURRENT_VERSION $PICOCMS_VERSION

ETHERPAD_CURRENT_VERSION=`ls -l /opt/etherpad-lite | sed -e 's/.*etherpad-lite-\(.*\)/\1/'`
ETHERPAD_VERSION=`curl -sL https://github.com/ether/etherpad-lite/releases | grep "tag/v[0-9]*\.[0-9]*\.[0-9]*\"" | sed -e "s/.*tag\/v\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/" | sort --version-sort | tail -1`
check_delta "EtherPad" $ETHERPAD_CURRENT_VERSION $ETHERPAD_VERSION

RUSTDESK_CURRENT_VERSION=`apt show rustdesk-server-hbbr 2> /dev/null | grep Version: | sed -e "s/Version: \([0-9]*\.[0-9]*\.[0-9]*\).*/\1/"`
RUSTDESK_VERSION=`curl -sL https://github.com/rustdesk/rustdesk-server/releases | grep "tag/[0-9]*\.[0-9]*\.[0-9]*-*[0-9]*\"" | sed -e "s/.*tag\/\([0-9]*\.[0-9]*\.[0-9]*-*[0-9]*\).*/\1/" | sort --version-sort | tail -1`
check_delta "Rustdesk" $RUSTDESK_CURRENT_VERSION $RUSTDESK_VERSION

PASSENGER_CURRENT_VERSION='6.0.23'
PASSENGER_VERSION=`curl -sL https://github.com/phusion/passenger/releases | grep "tag/release-[0-9]*\.[0-9]*\.[0-9]*\"" | sed -e "s/.*tag\/release-\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/" | sort --version-sort | tail -1`
check_delta "Passenger" $PASSENGER_CURRENT_VERSION $PASSENGER_VERSION

PG_CURRENT_VERSION='1.5.9'
PG_VERSION=`curl -sL https://rubygems.org/gems/pg/versions | grep 'pg\/versions\/[0-9]*\.[0-9]*\.[0-9]*\">' | sed -e 's/.*pg\/versions\/\([0-9]\.[0-9]*\.[0-9]*\)">.*/\1/' | sort --version-sort | tail -1`
check_delta "PG" $PG_CURRENT_VERSION $PG_VERSION

RMAGICK_CURRENT_VERSION='6.0.1'
RMAGICK_VERSION=`curl -sL https://rubygems.org/gems/rmagick/versions | grep 'rmagick\/versions\/[0-9]*\.[0-9]*\.[0-9]*\">' | sed -e 's/.*rmagick\/versions\/\([0-9]\.[0-9]*\.[0-9]*\)">.*/\1/' | sort --version-sort | tail -1`
check_delta "RMAGICK" $RMAGICK_CURRENT_VERSION $RMAGICK_VERSION

STRSCAN_CURRENT_VERSION='3.1.0'
STRSCAN_VERSION=`curl -sL https://rubygems.org/gems/strscan/versions | grep 'strscan\/versions\/[0-9]*\.[0-9]*\.[0-9]*\">' | sed -e 's/.*strscan\/versions\/\([0-9]\.[0-9]*\.[0-9]*\)">.*/\1/' | sort --version-sort | tail -1`
check_delta "STRSCAN" $STRSCAN_CURRENT_VERSION $STRSCAN_VERSION

NODEJS_CURRENT_VERSION=`/usr/bin/nodejs -v| tr -d 'v'`
NODEJS_VERSION=`curl -sL https://nodejs.org/en/about/previous-releases | grep 'data-label="Version"' | sed -e 's/.*\(22\.[0-9]*\.[0-9]*\).*/\1/'`
check_delta "NODEJS (apt)" $NODEJS_CURRENT_VERSION $NODEJS_VERSION

NPM_CURRENT_VERSION=`/usr/bin/npm -v`
NPM_VERSION=`curl -sL https://nodejs.org/en/about/previous-releases | grep 'data-label="npm"' | sed -e 's/.*\(10\.9\.[0-9]*\).*/\1/'`
check_delta "NPM (apt)" $NPM_CURRENT_VERSION $NPM_VERSION

RUBY_CURRENT_VERSION=`ls -l /usr/local/rvm/gems| grep 'ruby-[0-9]*\.[0-9]*\.[0-9]*$' | sed -e 's/.*ruby-\(.*\)/\1/' | sort --version-sort | tail -1`
RUBY_VERSION=`curl -sL https://www.ruby-lang.org/en/downloads/releases/ | grep 'Ruby 3\.2\.[0-9]*<' | sed -e 's/.*Ruby \([0-9]*\.[0-9]*\.[0-9]*\)<.*/\1/' | sort --version-sort | tail -1`
check_delta "RUBY" $RUBY_CURRENT_VERSION $RUBY_VERSION

NGINX_CURRENT_VERSION=`/opt/nginx/sbin/nginx -v 2>&1 | sed -e 's/nginx version: nginx\/\([0-9]\.[0-9]*\.[0-9]*\)$/\1/'`
NGINX_VERSION=`curl -sL https://github.com/nginx/nginx/tags | grep "tag\/release-[0-9]*\.[0-9]*\.[0-9]*\"" | sed -e "s/.*tag\/release-\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/" | sort --version-sort | tail -1`
check_delta "NGINX" $NGINX_CURRENT_VERSION $NGINX_VERSION

check_delta "Postgresql (apt)" 15 15
check_delta "PHP (apt)" 8.3 8.3

UPTIMEKUMA_CURRENT_VERSION='1.23.16'
UPTIMEKUMA_VERSION=`curl -sL https://github.com/louislam/uptime-kuma/tags | grep "tags/[0-9]*\.[0-9]*\.[0-9]*\." | sed -e "s/.*tags\/\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/" | sort --version-sort | tail -1`
check_delta "Passenger" $UPTIMEKUMA_CURRENT_VERSION $UPTIMEKUMA_VERSION

IS_APT_UP_TODATE=`apt update 2> /dev/null | grep "can be upgraded" | wc -l`
if [ "${IS_APT_UP_TODATE}" != "0" ]; then
    echo "System updates available"
    envoi_mail "SYSTEM" "De nouvelles mises a jour sont disponibles pour apt"
else
    echo "System up to date"
fi

