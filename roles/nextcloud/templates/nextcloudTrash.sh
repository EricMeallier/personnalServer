#!/bin/sh

cd /opt/nextcloud; sudo -u nobody /usr/bin/php{{ php.version }} occ trashbin:cleanup rickou_412