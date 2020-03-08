#!/bin/sh

timestamp=`date +%Y%m%d_%H%M`
timestamp='last'
targetDir='/backup'

auth=$(curl -s "https://api.pcloud.com/userinfo?getauth=1&username=eric@meallier.fr&password=PmEdSg7DJmnKqj39" | jq -r '.auth')

# trop gros et replique
# tar zcvf ${targetDir}/owncloud-${timestamp=}-data.tgz /opt/owncloud-data/

#cd /opt/owncloud
#owncloudPath=`pwd -P`
#tar cvf ${targetDir}/owncloud-${timestamp=}-bin.tar $owncloudPath
#gzip ${targetDir}/owncloud-${timestamp=}-bin.tar
#curl -X POST "https://api.pcloud.com/uploadfile?auth=pFP4x7ZwXciZklhBiRCP09fwJkMFW393dkXjfQgX" -F update=@${targetDir}/owncloud-${timestamp=}-bin.tar.gz

#export PGPASSWORD="nextcloud"
#pg_dump -w -h localhost -U owncloud > ${targetDir}/owncloud-${timestamp=}.dmp
#gzip ${targetDir}/nextcloud-${timestamp=}.dmp
#curl -X POST "https://api.pcloud.com/uploadfile?auth=pFP4x7ZwXciZklhBiRCP09fwJkMFW393dkXjfQgX" -F update=@${targetDir}/owncloud-${timestamp=}.dmp.gz




tar zcvf ${targetDir}/gogs-${timestamp=}-data.tar.gz /data/gogs-repositories
curl -X POST "https://api.pcloud.com/uploadfile?auth=${auth}" -F update=@${targetDir}/gogs-${timestamp=}-data.tar.gz

#cd /opt/gogs
#gogsPath=`pwd -P`
#tar cvf ${targetDir}/gogs-${timestamp=}-bin.tar $gogsPath
#gzip ${targetDir}/gogs-${timestamp=}-bin.tar
#curl -X POST "https://api.pcloud.com/uploadfile?auth=pFP4x7ZwXciZklhBiRCP09fwJkMFW393dkXjfQgX" -F update=@${targetDir}/gogs-${timestamp=}-bin.tar.gz

sudo su - postgres -c "pg_dump gogs > ${targetDir}/gogs-${timestamp=}.dmp"
gzip ${targetDir}/gogs-${timestamp=}.dmp
curl -X POST "https://api.pcloud.com/uploadfile?auth=${auth}" -F update=@${targetDir}/gogs-${timestamp=}.dmp.gz




#cd /opt/redmine
#redminePath=`pwd -P`
#tar cvf ${targetDir}/redmine-${timestamp=}-bindata.tar $redminePath
#gzip ${targetDir}/redmine-${timestamp=}-bindata.tar
#curl -X POST "https://api.pcloud.com/uploadfile?auth=pFP4x7ZwXciZklhBiRCP09fwJkMFW393dkXjfQgX" -F update=@${targetDir}/redmine-${timestamp=}-bindata.tar.gz

#cd /data/redmine-files
#redminePath=`pwd -P`
tar zcvf ${targetDir}/redmine-${timestamp=}-files.tar.gz /data/redmine-files
curl -X POST "https://api.pcloud.com/uploadfile?auth=${auth}" -F update=@${targetDir}/redmine-${timestamp=}-files.tar.gz

sudo su - postgres -c "pg_dump redmine > ${targetDir}/redmine-${timestamp=}.dmp"
gzip ${targetDir}/redmine-${timestamp=}.dmp
curl -X POST "https://api.pcloud.com/uploadfile?auth=${auth}" -F update=@${targetDir}/redmine-${timestamp=}.dmp.gz

