sudo rm -f /opt/pcloud


PCLOUD_CLIENT_VERSION=`curl -s https://www.pcloud.com/release-notes/linux.html | grep '<b>[0-9]*\.[0-9]*\.[0-9]*<\/b>' | grep '20[2-9][0-9])' | sed -e 's/.*\([0-9]\.[0-9]*\.[0-9]*\).*/\1/' | sort --version-sort | tail -1`
PCLOUD_CLIENT_LANDING_PAGE=`curl -s https://www.pcloud.com/release-notes/linux.html | grep "$PCLOUD_CLIENT_VERSION" | sed -e 's/.*a href="\(.*\)" .*/\1/'`

echo "Upgrade to $PCLOUD_CLIENT_VERSION"
PCLOUD_CLIENT_URL=`curl -s $PCLOUD_CLIENT_LANDING_PAGE | grep downloadlink | sed -e 's/.*downloadlink": "\(.*\)".*/\1/' | tr -d '\\'`

curl -s $PCLOUD_CLIENT_URL -o /tmp/pcloud

sudo mv /tmp/pcloud /opt/pcloud
sudo chmod a+x /opt/pcloud

# because of the many threads launch by pcloud client, the safetiest way is to click on Exit in pcloud client
echo "===> STOP and RESTART manually <==="