export NEW_VERSION=3.7.1

sudo rm -f /opt/Nextcloud-${NEW_VERSION}-x86_64.AppImage

sudo curl -L https://github.com/nextcloud/desktop/releases/download/v${NEW_VERSION}/Nextcloud-${NEW_VERSION}-x86_64.AppImage -o /opt/Nextcloud-${NEW_VERSION}-x86_64.AppImage
sudo chmod a+x /opt/Nextcloud-${NEW_VERSION}-x86_64.AppImage
sudo rm -f /opt/Nextcloud
sudo ln -s /opt/Nextcloud-${NEW_VERSION}-x86_64.AppImage /opt/Nextcloud