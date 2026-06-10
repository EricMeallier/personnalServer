#!/bin/sh

timestamp=`date +%Y%m%d_%H%M`
timestamp='last'
targetDir='/backup'

systemctl stop nginx
systemctl stop etherpad
systemctl stop gogs gitea spliit
systemctl stop php{{ php.version }}-fpm.service

##########################################################
# Postgres databases backup
systemctl restart postgresql

sudo su - postgres -c "pg_dump gogs > ${targetDir}/gogs-${timestamp=}.dmp"
gzip -f ${targetDir}/gogs-${timestamp=}.dmp
curl --oauth2-bearer {{pcloud.bearer}} -X POST "https://eapi.pcloud.com/uploadfile?folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/gogs-${timestamp=}.dmp.gz
rm -f ${targetDir}/gogs-${timestamp=}.dmp.gz

sudo su - postgres -c "pg_dump gitea > ${targetDir}/gitea-${timestamp=}.dmp"
gzip -f ${targetDir}/gitea-${timestamp=}.dmp
curl --oauth2-bearer {{pcloud.bearer}} -X POST "https://eapi.pcloud.com/uploadfile?folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/gitea-${timestamp=}.dmp.gz
rm -f ${targetDir}/gitea-${timestamp=}.dmp.gz

sudo su - postgres -c "pg_dump redmine > ${targetDir}/redmine-${timestamp=}.dmp"
gzip -f ${targetDir}/redmine-${timestamp=}.dmp
curl --oauth2-bearer {{pcloud.bearer}} -X POST "https://eapi.pcloud.com/uploadfile?folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/redmine-${timestamp=}.dmp.gz
rm -f ${targetDir}/redmine-${timestamp=}.dmp.gz

sudo su - postgres -c "pg_dump nextcloud > ${targetDir}/nextcloud-${timestamp=}.dmp"
gzip -f ${targetDir}/nextcloud-${timestamp=}.dmp
curl --oauth2-bearer {{pcloud.bearer}} -X POST "https://eapi.pcloud.com/uploadfile?folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/nextcloud-${timestamp=}.dmp.gz
rm -f ${targetDir}/nextcloud-${timestamp=}.dmp.gz

sudo su - postgres -c "pg_dump etherpad > ${targetDir}/etherpad-${timestamp=}.dmp"
gzip -f ${targetDir}/etherpad-${timestamp=}.dmp
curl --oauth2-bearer {{pcloud.bearer}} -X POST "https://eapi.pcloud.com/uploadfile?folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/etherpad-${timestamp=}.dmp.gz
rm -f ${targetDir}/etherpad-${timestamp=}.dmp.gz
systemctl start etherpad

sudo su - postgres -c "pg_dump spliit > ${targetDir}/spliit-${timestamp=}.dmp"
gzip -f ${targetDir}/spliit-${timestamp=}.dmp
curl --oauth2-bearer {{pcloud.bearer}} -X POST "https://eapi.pcloud.com/uploadfile?folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/spliit-${timestamp=}.dmp.gz
rm -f ${targetDir}/spliit-${timestamp=}.dmp.gz
systemctl start spliit

systemctl restart postgresql
##########################################################
# Redis databases backup

systemctl stop redis-server
cp /var/lib/redis/dump.rdb ${targetDir}/redis-${timestamp=}.rdb
gzip -f ${targetDir}/redis-${timestamp=}.rdb
systemctl start redis-server ethercalc
curl --oauth2-bearer {{pcloud.bearer}} -X POST "https://eapi.pcloud.com/uploadfile?folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/redis-${timestamp=}.rdb.gz
rm -f ${targetDir}/redis-${timestamp=}.rdb.gz

##########################################################
# Kuma Sqlite databases backup

systemctl stop kuma
cp /opt/uptime-kuma/data/kuma.db ${targetDir}/kuma-${timestamp=}.db
systemctl start kuma
gzip -f ${targetDir}/kuma-${timestamp=}.db
curl --oauth2-bearer {{pcloud.bearer}} -X POST "https://eapi.pcloud.com/uploadfile?folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/kuma-${timestamp=}.db.gz
rm -f ${targetDir}/kuma-${timestamp=}.db.gz

##########################################################
# Application backups

# redmine phase 1
tar zcvf ${targetDir}/redmine-${timestamp=}-files.tar.gz /data/redmine-files
systemctl start nginx

## gitea phase 1
tar zcvf ${targetDir}/gitea-${timestamp=}-data.tar.gz /data/gitea
systemctl start gitea

## gogs phase 1
tar cvf ${targetDir}/gogs-${timestamp=}-data.tar /data/gogs-repositories
systemctl start gogs

# nextcloud phase 1
tar cvf ${targetDir}/nextcloud-${timestamp=}-data.tar /data/nextcloud
systemctl start php8.4-fpm.service
systemctl restart nginx

############################## All applications are restarted, now compressing and tranfering big files

# redmine phase 2
curl --oauth2-bearer {{pcloud.bearer}} -X POST "https://eapi.pcloud.com/uploadfile?folderid=5436346935" -F update=@${targetDir}/redmine-${timestamp=}-files.tar.gz
rm -f ${targetDir}/redmine-${timestamp=}-files.tar.gz

## gitea phase 2
curl --oauth2-bearer {{pcloud.bearer}} -X POST "https://eapi.pcloud.com/uploadfile?folderid=5436346935" -F update=@${targetDir}/gitea-${timestamp=}-data.tar.gz
rm -f ${targetDir}/gitea-${timestamp=}-data.tar.gz

## gogs phase 2
gzip -9 ${targetDir}/gogs-${timestamp=}-data.tar
curl --oauth2-bearer {{pcloud.bearer}} -X POST "https://eapi.pcloud.com/uploadfile?folderid=5436346935" -F update=@${targetDir}/gogs-${timestamp=}-data.tar.gz
rm -f ${targetDir}/gogs-${timestamp=}-data.tar.gz

# nextcloud phase 2
gzip -9 ${targetDir}/nextcloud-${timestamp=}-data.tar
curl --oauth2-bearer {{pcloud.bearer}} -X POST "https://eapi.pcloud.com/uploadfile?folderid=5436346935" -F update=@${targetDir}/nextcloud-${timestamp=}-data.tar.gz
rm -f ${targetDir}/nextcloud-${timestamp=}-data.tar.gz
