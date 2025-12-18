#!/bin/sh

timestamp=`date +%Y%m%d_%H%M`
timestamp='last'
targetDir='/backup'

auth=$(curl -s "https://eapi.pcloud.com/userinfo?getauth=1&username={{ pcloud.username }}&password={{ pcloud.password }}" | jq -r '.auth')

systemctl stop nginx
systemctl stop etherpad ethercalc
systemctl stop gogs gitea
systemctl stop php{{ php.version }}-fpm.service

##########################################################
# Postgres databases backup
systemctl restart postgresql

sudo su - postgres -c "pg_dump gogs > ${targetDir}/gogs-${timestamp=}.dmp"
gzip -f ${targetDir}/gogs-${timestamp=}.dmp
curl -X POST "https://eapi.pcloud.com/uploadfile?auth=${auth}&folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/gogs-${timestamp=}.dmp.gz
rm -f ${targetDir}/gogs-${timestamp=}.dmp.gz

sudo su - postgres -c "pg_dump gitea > ${targetDir}/gitea-${timestamp=}.dmp"
gzip -f ${targetDir}/gitea-${timestamp=}.dmp
curl -X POST "https://eapi.pcloud.com/uploadfile?auth=${auth}&folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/gitea-${timestamp=}.dmp.gz
rm -f ${targetDir}/gitea-${timestamp=}.dmp.gz

sudo su - postgres -c "pg_dump redmine > ${targetDir}/redmine-${timestamp=}.dmp"
gzip -f ${targetDir}/redmine-${timestamp=}.dmp
curl -X POST "https://eapi.pcloud.com/uploadfile?auth=${auth}&folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/redmine-${timestamp=}.dmp.gz
rm -f ${targetDir}/redmine-${timestamp=}.dmp.gz

sudo su - postgres -c "pg_dump nextcloud > ${targetDir}/nextcloud-${timestamp=}.dmp"
gzip -f ${targetDir}/nextcloud-${timestamp=}.dmp
curl -X POST "https://eapi.pcloud.com/uploadfile?auth=${auth}&folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/nextcloud-${timestamp=}.dmp.gz
rm -f ${targetDir}/nextcloud-${timestamp=}.dmp.gz

sudo su - postgres -c "pg_dump etherpad > ${targetDir}/etherpad-${timestamp=}.dmp"
gzip -f ${targetDir}/etherpad-${timestamp=}.dmp
curl -X POST "https://eapi.pcloud.com/uploadfile?auth=${auth}&folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/etherpad-${timestamp=}.dmp.gz
rm -f ${targetDir}/etherpad-${timestamp=}.dmp.gz
systemctl start etherpad

sudo su - postgres -c "pg_dump spliit > ${targetDir}/spliit-${timestamp=}.dmp"
gzip -f ${targetDir}/spliit-${timestamp=}.dmp
curl -X POST "https://eapi.pcloud.com/uploadfile?auth=${auth}&folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/spliit-${timestamp=}.dmp.gz
rm -f ${targetDir}/spliit-${timestamp=}.dmp.gz
systemctl start spliit

systemctl restart postgresql
##########################################################
# Redis databases backup

systemctl stop redis-server ethercalc
cp /var/lib/redis/dump.rdb ${targetDir}/redis-${timestamp=}.rdb
gzip -f ${targetDir}/redis-${timestamp=}.rdb
systemctl start redis-server ethercalc
curl -X POST "https://eapi.pcloud.com/uploadfile?auth=${auth}&folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/redis-${timestamp=}.rdb.gz
rm -f ${targetDir}/redis-${timestamp=}.rdb.gz

##########################################################
# Application backups

# redmine
tar zcvf ${targetDir}/redmine-${timestamp=}-files.tar.gz /data/redmine-files
systemctl start nginx
curl -X POST "https://eapi.pcloud.com/uploadfile?auth=${auth}&folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/redmine-${timestamp=}-files.tar.gz
rm -f ${targetDir}/redmine-${timestamp=}-files.tar.gz

## gogs
tar zcvf ${targetDir}/gogs-${timestamp=}-data.tar.gz /data/gogs-repositories
systemctl start gogs
curl -X POST "https://eapi.pcloud.com/uploadfile?auth=${auth}&folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/gogs-${timestamp=}-data.tar.gz
rm -f ${targetDir}/gogs-${timestamp=}-data.tar.gz

## gitea
tar zcvf ${targetDir}/gitea-${timestamp=}-data.tar.gz /data/gitea
systemctl start gitea
curl -X POST "https://eapi.pcloud.com/uploadfile?auth=${auth}&folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/gitea-${timestamp=}-data.tar.gz
rm -f ${targetDir}/gitea-${timestamp=}-data.tar.gz

# nextcloud
GZIP=-9; tar zcvf ${targetDir}/nextcloud-${timestamp=}-data.tar.gz --exclude={"nextcloud.log*"} /data/nextcloud
systemctl start php{{ php.version }}-fpm.service
systemctl restart nginx
curl -X POST "https://eapi.pcloud.com/uploadfile?auth=${auth}&folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/nextcloud-${timestamp=}-data.tar.gz
rm -f ${targetDir}/nextcloud-${timestamp=}-data.tar.gz









