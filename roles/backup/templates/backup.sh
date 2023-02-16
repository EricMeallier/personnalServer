#!/bin/sh

timestamp=`date +%Y%m%d_%H%M`
timestamp='last'
targetDir='/backup'

auth=$(curl -s "https://eapi.pcloud.com/userinfo?getauth=1&username={{ pcloud.username }}&password={{ pcloud.password }}" | jq -r '.auth')

systemctl stop nginx
#systemctl stop etherpad
#systemctl stop ethercalc
systemctl stop gogs
systemctl stop php8.0-fpm.service

## gogs
tar zcvf ${targetDir}/gogs-${timestamp=}-data.tar.gz /data/gogs-repositories
curl -X POST "https://eapi.pcloud.com/uploadfile?auth=${auth}&folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/gogs-${timestamp=}-data.tar.gz
rm -f ${targetDir}/gogs-${timestamp=}-data.tar.gz

sudo su - postgres -c "pg_dump gogs > ${targetDir}/gogs-${timestamp=}.dmp"
gzip -f ${targetDir}/gogs-${timestamp=}.dmp
curl -X POST "https://eapi.pcloud.com/uploadfile?auth=${auth}&folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/gogs-${timestamp=}.dmp.gz
rm -f ${targetDir}/gogs-${timestamp=}.dmp.gz

# redmine
tar zcvf ${targetDir}/redmine-${timestamp=}-files.tar.gz /data/redmine-files
curl -X POST "https://eapi.pcloud.com/uploadfile?auth=${auth}&folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/redmine-${timestamp=}-files.tar.gz
rm -f ${targetDir}/redmine-${timestamp=}-files.tar.gz

sudo su - postgres -c "pg_dump redmine > ${targetDir}/redmine-${timestamp=}.dmp"
gzip -f ${targetDir}/redmine-${timestamp=}.dmp
curl -X POST "https://eapi.pcloud.com/uploadfile?auth=${auth}&folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/redmine-${timestamp=}.dmp.gz
rm -f ${targetDir}/redmine-${timestamp=}.dmp.gz

# nextcloud
GZIP=-9; tar zcvf ${targetDir}/nextcloud-${timestamp=}-data.tar.gz --exclude={"nextcloud.log*"} /data/nextcloud
curl -X POST "https://eapi.pcloud.com/uploadfile?auth=${auth}&folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/nextcloud-${timestamp=}-data.tar.gz
rm -f ${targetDir}/nextcloud-${timestamp=}-data.tar.gz

sudo su - postgres -c "pg_dump nextcloud > ${targetDir}/nextcloud-${timestamp=}.dmp"
gzip -f ${targetDir}/nextcloud-${timestamp=}.dmp
curl -X POST "https://eapi.pcloud.com/uploadfile?auth=${auth}&folderid={{ pcloud.folder.id }}" -F update=@${targetDir}/nextcloud-${timestamp=}.dmp.gz
rm -f ${targetDir}/nextcloud-${timestamp=}.dmp.gz

# etherpad
#sudo su - postgres -c "pg_dump etherpad > ${targetDir}/etherpad-${timestamp=}.dmp"
#gzip -f ${targetDir}/etherpad-${timestamp=}.dmp
#curl -X POST "https://eapi.pcloud.com/uploadfile?auth=${auth}" -F update=@${targetDir}/etherpad-${timestamp=}.dmp.gz
#rm -f ${targetDir}/etherpad-${timestamp=}.dmp.gz

# ethercalc
#cp /var/lib/redis/dump.rdb ${targetDir}/ethercalc-${timestamp=}.rdb
#gzip -f ${targetDir}/ethercalc-${timestamp=}.rdb
#curl -X POST "https://eapi.pcloud.com/uploadfile?auth=${auth}" -F update=@${targetDir}/ethercalc-${timestamp=}.rdb.gz
#rm -f ${targetDir}/ethercalc-${timestamp=}.rdb.gz

# picocms
#tar zcvf ${targetDir}/picocms-${timestamp=}-data.tgz /data/picocms
#curl -X POST "https://eapi.pcloud.com/uploadfile?auth=${auth}" -F update=@${targetDir}/picocms-${timestamp=}-data.tgz
#rm -f ${targetDir}/picocms-${timestamp=}-data.tgz

# restart
systemctl restart postgresql
#systemctl start etherpad
#systemctl start ethercalc
systemctl start gogs
systemctl start php8.0-fpm.service
systemctl start nginx
