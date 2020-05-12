#!/bin/sh

timestamp=`date +%Y%m%d_%H%M`
timestamp='last'
targetDir='/backup'

auth=$(curl -s "https://api.pcloud.com/userinfo?getauth=1&username=eric@meallier.fr&password=XXXXX" | jq -r '.auth')

## gogs
tar zcvf ${targetDir}/gogs-${timestamp=}-data.tar.gz /data/gogs-repositories
curl -X POST "https://api.pcloud.com/uploadfile?auth=${auth}" -F update=@${targetDir}/gogs-${timestamp=}-data.tar.gz

gzip -f ${targetDir}/gogs-${timestamp=}.dmp
curl -X POST "https://api.pcloud.com/uploadfile?auth=${auth}" -F update=@${targetDir}/gogs-${timestamp=}.dmp.gz


# redmine
tar zcvf ${targetDir}/redmine-${timestamp=}-files.tar.gz /data/redmine-files
curl -X POST "https://api.pcloud.com/uploadfile?auth=${auth}" -F update=@${targetDir}/redmine-${timestamp=}-files.tar.gz

sudo su - postgres -c "pg_dump redmine > ${targetDir}/redmine-${timestamp=}.dmp"
gzip -f ${targetDir}/redmine-${timestamp=}.dmp
curl -X POST "https://api.pcloud.com/uploadfile?auth=${auth}" -F update=@${targetDir}/redmine-${timestamp=}.dmp.gz

# nextcloud
tar zcvf ${targetDir}/nextcloud-${timestamp=}-data.tgz /data/nextcloud
curl -X POST "https://api.pcloud.com/uploadfile?auth=${auth}" -F update=@${targetDir}/nextcloud-${timestamp=}-data.tgz

sudo su - postgres -c "pg_dump nextcloud > ${targetDir}/nextcloud-${timestamp=}.dmp"
gzip -f ${targetDir}/nextcloud-${timestamp=}.dmp
curl -X POST "https://api.pcloud.com/uploadfile?auth=${auth}" -F update=@${targetDir}/nextcloud-${timestamp=}.dmp.gz

# etherpad
sudo su - postgres -c "pg_dump etherpad > ${targetDir}/etherpad-${timestamp=}.dmp"
gzip -f ${targetDir}/etherpad-${timestamp=}.dmp
curl -X POST "https://api.pcloud.com/uploadfile?auth=${auth}" -F update=@${targetDir}/etherpad-${timestamp=}.dmp.gz

# ethercalc
cp /var/lib/redis/dump.rdb ${targetDir}/ethercalc-${timestamp=}.rdb
curl -X POST "https://api.pcloud.com/uploadfile?auth=${auth}" -F update=@${targetDir}/ethercalc-${timestamp=}.rdb
