sudo rm -f /opt/pCloud.AppImage

sudo mv Downloads/pCloud.AppImage /opt/pCloud.AppImage
sudo chmod a+x /opt/pCloud.AppImage

# because of the many threads launch by pcloud client, the safetiest way is to click on Exit in pcloud client
echo "===> STOP and RESTART manually <==="