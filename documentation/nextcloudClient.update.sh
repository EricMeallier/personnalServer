export NEW_VERSION=3.3.3

sudo rm -f /opt/Nextcloud-${NEW_VERSION}-x86_64.AppImage

sudo mv ~/Downloads/Nextcloud-${NEW_VERSION}-x86_64.AppImage /opt
sudo chmod a+x /opt/Nextcloud-${NEW_VERSION}-x86_64.AppImage
sudo rm -f /opt/Nextcloud
sudo ln -s /opt/Nextcloud-${NEW_VERSION}-x86_64.AppImage /opt/Nextcloud