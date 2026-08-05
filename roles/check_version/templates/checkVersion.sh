#!/bin/bash


envoi_mail () {
    mutt -s "[{{ server.domain.sub }}{{ server.domain.main }}] Alerte Version $1: $2"  {{ mail.smtp.alertingTo }} < /dev/null
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

SPLIIT_CURRENT_VERSION=`ls -l /opt/spliit | sed -e 's/.*spliit-\(.*\)/\1/'`
SPLIIT_VERSION=`{ curl -sL https://github.com/spliit-app/spliit/releases ; curl -sL https://github.com/spliit-app/spliit/releases?page=2 ; } | grep "tag/[0-9]*\.[0-9]*\.[0-9]*\"" | sed -e "s/.*tag\/\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/" | sort --version-sort | tail -1`
check_delta "Spliit" $SPLIIT_CURRENT_VERSION $SPLIIT_VERSION

REDMINE_CURRENT_VERSION=`ls -l /opt/redmine | sed -e 's/.*redmine-\(.*\)/\1/'`
REDMINE_VERSION=`curl -s https://www.redmine.org/ | grep "wiki-page" | grep "Download\"" | sed -e "s/.*Download\">\([0-9]*\.[0-9]*\.[0-9]*\)\ .*/\1/"`
check_delta "Redmine" $REDMINE_CURRENT_VERSION $REDMINE_VERSION

GOGS_CURRENT_VERSION=`ls -l /opt/gogs | sed -e 's/.*gogs-\(.*\)/\1/'`
GOGS_VERSION=`curl -s https://dl.gogs.io/ | grep '\<a href=\"./[0-9]?*'| sed -e 's/.*\([0-9]\.[0-9]*\.[0-9]*\).*/\1/' | sort --version-sort | tail -1`
check_delta "Gogs" $GOGS_CURRENT_VERSION $GOGS_VERSION

GITEA_CURRENT_VERSION=`ls -l /opt/gitea | grep 'gitea-' | sed -e 's/.*gitea-\(.*\)-linux.*/\1/' | sort --version-sort | tail -1`
GITEA_VERSION=`{ curl -sL https://github.com/go-gitea/gitea/releases ; curl -sL https://github.com/go-gitea/gitea/releases?page=2 ; } | grep "tag/v[0-9]*\.[0-9]*\.[0-9]*\"" | sed -e "s/.*tag\/v\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/" | sort --version-sort | tail -1`
check_delta "Gitea" $GITEA_CURRENT_VERSION $GITEA_VERSION

NEXTCLOUD_CURRENT_VERSION=`ls -l /opt/nextcloud | sed -e 's/.*nextcloud-\(.*\)/\1/'`
NEXTCLOUD_VERSION=`{ curl -sL https://github.com/nextcloud/server/releases ; curl -sL https://github.com/nextcloud/server/releases?page=2 ; } | grep "tag/v[0-9]*\.[0-9]*\.[0-9]*\"" | sed -e "s/.*tag\/v\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/" | sort --version-sort | tail -1`
check_delta "Nextcloud" $NEXTCLOUD_CURRENT_VERSION $NEXTCLOUD_VERSION

WHITEBOARD_CURRENT_VERSION=`ls -l /opt/whiteboard | sed -e 's/.*whiteboard-\(.*\)/\1/'`
WHITEBOARD_VERSION=`{ curl -sL https://github.com/nextcloud/whiteboard/releases ; curl -sL https://github.com/nextcloud/whiteboard/releases?page=2 ; } | grep "tag/v[0-9]*\.[0-9]*\.[0-9]*\"" | sed -e "s/.*tag\/v\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/" | sort --version-sort | tail -1`
check_delta "Whiteboard" $WHITEBOARD_CURRENT_VERSION $WHITEBOARD_VERSION

#PICOCMS_CURRENT_VERSION=`ls -l /opt/pico | sed -e 's/.*pico-\(.*\)/\1/'`
#PICOCMS_VERSION=`curl -sL https://github.com/picocms/Pico/releases/latest | grep "tag/v*" | sed -e "s/.*tag\/v\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/"`
#check_delta "PicoCMS" $PICOCMS_CURRENT_VERSION $PICOCMS_VERSION

tempo=`apt info etherpad 2> /dev/null | grep Version`
ETHERPAD_CURRENT_VERSION=$(echo ${tempo##*:} | cut -d '-' -f 1)
ETHERPAD_VERSION=`curl -sL https://github.com/ether/etherpad/releases | grep "tag/v[0-9]*\.[0-9]*\.[0-9]*\"" | sed -e "s/.*tag\/v\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/" | sort --version-sort | tail -1`
check_delta "EtherPad" $ETHERPAD_CURRENT_VERSION $ETHERPAD_VERSION

RUSTDESK_CURRENT_VERSION=`apt show rustdesk-server-hbbr 2> /dev/null | grep Version: | sed -e "s/Version: \([0-9]*\.[0-9]*\.[0-9]*\).*/\1/"`
RUSTDESK_VERSION=`curl -sL https://github.com/rustdesk/rustdesk-server/releases | grep "tag/[0-9]*\.[0-9]*\.[0-9]*-*[0-9]*\"" | sed -e "s/.*tag\/\([0-9]*\.[0-9]*\.[0-9]*-*[0-9]*\).*/\1/" | sort --version-sort | tail -1`
check_delta "Rustdesk" $RUSTDESK_CURRENT_VERSION $RUSTDESK_VERSION

NODEJS_CURRENT_VERSION=`/usr/bin/nodejs -v| tr -d 'v'`
NODEJS_VERSION=`curl -sL https://github.com/nodejs/node/tags | grep "tag\/v24\.[0-9]*\.[0-9]*\"" | sed -e "s/.*tag\/v\(24.[0-9]*\.[0-9]*\).*/\1/" | sort --version-sort | tail -1`
check_delta "NodeJS" $NODEJS_CURRENT_VERSION $NODEJS_VERSION

RUBY_CURRENT_VERSION=`ls -l /usr/local/rvm/gems| grep 'ruby-[0-9]*\.[0-9]*\.[0-9]*$' | sed -e 's/.*ruby-\(.*\)/\1/' | sort --version-sort | tail -1`
RUBY_VERSION=`curl -sL https://www.ruby-lang.org/en/downloads/releases/ | grep 'Ruby 3\.4\.[0-9]*<' | sed -e 's/.*Ruby \([0-9]*\.[0-9]*\.[0-9]*\)<.*/\1/' | sort --version-sort | tail -1`
check_delta "Ruby" $RUBY_CURRENT_VERSION $RUBY_VERSION

# NGINX_CURRENT_VERSION=`/opt/nginx/sbin/nginx -v 2>&1 | sed -e 's/nginx version: nginx\/\([0-9]\.[0-9]*\.[0-9]*\)$/\1/'`
# NGINX_VERSION=`curl -sL https://github.com/nginx/nginx/tags | grep "tag\/release-[0-9]*\.[0-9]*\.[0-9]*\"" | sed -e "s/.*tag\/release-\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/" | sort --version-sort | tail -1`
# check_delta "NGINX" $NGINX_CURRENT_VERSION $NGINX_VERSION

# check_delta "Postgresql (apt)" 17 17
# check_delta "PHP (apt)" 8.4 8.4

UPTIMEKUMA_CURRENT_VERSION='2.5.0'
UPTIMEKUMA_VERSION=`curl -sL https://github.com/louislam/uptime-kuma/tags | grep "tags/[0-9]*\.[0-9]*\.[0-9]*\." | sed -e "s/.*tags\/\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/" | sort --version-sort | tail -1`
check_delta "UptimeKuma" $UPTIMEKUMA_CURRENT_VERSION $UPTIMEKUMA_VERSION

IS_APT_UP_TODATE=`apt update 2> /dev/null | grep "upgradable"`

if [ `echo -n ${IS_APT_UP_TODATE} | wc -w` != "0" ]; then
    echo "`echo -n ${IS_APT_UP_TODATE} |sed -e "s/^\([0-9]*\).*/\1/"` system updates available"
    envoi_mail echo "SYSTEM: `echo -n ${IS_APT_UP_TODATE} |sed -e "s/^\([0-9]*\).*/\1/"` nouvelles mises a jour sont disponibles pour apt"
else
    echo "System up to date"
fi

PATH=/usr/local/rvm/gems/ruby-{{ ruby.version }}/bin:/usr/local/rvm/gems/ruby-{{ ruby.version }}@global/bin:/usr/local/rvm/rubies/ruby-{{ ruby.version }}/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/local/rvm/bin
tempo=`/usr/local/rvm/rubies/default/bin/passenger version`
PASSENGER_CURRENT_VERSION=${tempo##* }
PASSENGER_VERSION=`curl -sL https://github.com/phusion/passenger/releases | grep "tag/release-[0-9]*\.[0-9]*\.[0-9]*\"" | sed -e "s/.*tag\/release-\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/" | sort --version-sort | tail -1`
check_delta "Passenger" $PASSENGER_CURRENT_VERSION $PASSENGER_VERSION

