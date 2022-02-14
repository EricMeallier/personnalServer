#!/bin/bash


REDMINE_CURRENT_VERSION="4.2.3"
REDMINE_VERSION=`curl -s https://redmine.org/ | grep "Download\" class=\"wiki-page\"" | sed -e "s/.*wiki-page\">\([0-9]\.[0-9]\.[0-9]\)\ .*wiki-page.*/\1/"`


echo "Redmine avalaible version: ${REDMINE_VERSION} (${REDMINE_CURRENT_VERSION})"

if [ "${REDMINE_VERSION}" != "${REDMINE_CURRENT_VERSION}" ]; then 
    echo "il faut changer"
fi


GOGS_CURRENT_VERSION="0.12.4"
GOGS_VERSION=`curl -s https://dl.gogs.io/ | grep '\<a href="\.\/[0-9]' | tail -1 | sed -e 's/.*\([0-9]\.[0-9]*\.[0-9]*\).*/\1/'`


echo "Gogs avalaible version: ${GOGS_VERSION} (${GOGS_CURRENT_VERSION})"

if [ "${GOGS_VERSION}" != "${GOGS_CURRENT_VERSION}" ]; then 
    echo "il faut changer"
fi


NEXTCLOUD_CURRENT_VERSION="23.0.0"
NEXTCLOUD_VERSION=`curl -s https://nextcloud.com/install/#instructions-server | grep 'archive' | grep 'Latest stable version' | sed -e 's/.*Latest stable version:\ *\([^ ]*\)\ .*/\1/'`


echo "Nextcloud avalaible version: ${NEXTCLOUD_VERSION} (${NEXTCLOUD_CURRENT_VERSION})"

if [ "${NEXTCLOUD_VERSION}" != "${NEXTCLOUD_CURRENT_VERSION}" ]; then 
    echo "il faut changer"
fi


