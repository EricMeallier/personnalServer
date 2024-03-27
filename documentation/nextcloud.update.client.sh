
NEW_VERSION=`{ curl -sL https://github.com/nextcloud/desktop/releases ; curl -sL https://github.com/nextcloud/desktop/releases?page=2 ; } | grep "tag/v[0-9]*\.[0-9]*\.[0-9]*\"" | sed -e "s/.*tag\/v\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/" | sort --version-sort | tail -1`
echo "Upgrade to $NEW_VERSION"
sudo rm -f /opt/Nextcloud*

sudo curl -sL https://github.com/nextcloud-releases/desktop/releases/download/v${NEW_VERSION}/Nextcloud-${NEW_VERSION}-x86_64.AppImage -o /opt/Nextcloud-${NEW_VERSION}-x86_64.AppImage
sudo chmod a+x /opt/Nextcloud-${NEW_VERSION}-x86_64.AppImage
sudo ln -s /opt/Nextcloud-${NEW_VERSION}-x86_64.AppImage /opt/Nextcloud

ps -ef | grep '\/opt\/Nextcloud' | awk '{print $2}' | xargs kill

/opt/Nextcloud > /dev/null 2>&1&