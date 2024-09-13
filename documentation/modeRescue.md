
# How-to switch from normal to rescue

- https://help.ovhcloud.com/csm/fr-dedicated-servers-retrieve-database?id=kb_article_view&sysparm_article=KB0057661
- https://libremaster.com/redemarrer-un-vps-ovh-en-mode-rescue-pour-reparer-le-serveur/

# Commands to bond the working environment

```
mkdir -p /mnt/sdb1
mount /dev/sdb1 /mnt/sdb1
mount -t proc proc /mnt/sdb1/proc/
mount -t sysfs sys /mnt/sdb1/sys/
mount -o bind /dev /mnt/sdb1/dev/
mount -t devpts devpts /mnt/sdb1/dev/pts
mkdir -p /run/chroot/lock
mount -o bind /run/chroot /mnt/sdb1/run
chroot /mnt/sdb1 /bin/bash
source /etc/default/locale
```