# Personnel Server

## Pre requisites

* Vagrant
```
sudo echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com noble main" > /etc/apt/sources.list.d/hashicorp.list

sudo apt install vagrant

vagrant plugin install vagrant-disksize
```


* VirtualBox 7.0 (on Mint 22)
```
sudo echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] http://download.virtualbox.org/virtualbox/debian jammy contrib" > /etc/apt/sources.list.d/virtualbox.list

wget http://ftp.de.debian.org/debian/pool/main/libv/libvpx/libvpx7_1.12.0-1+deb12u3_amd64.deb
sudo dpkg --install libvpx7_1.12.0-1+deb12u3_amd64.deb

sudo apt install virtualbox-7.0

# + install manually virtualbox Extension Pack
```


* Pour KVM/Libvirt (on Mint 22)
```
sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils libvirt-dev
sudo apt-get install virt-manager

sudo apt-get install nfs-common nfs-kernel-server # to enable sharing between host and VM - not mandatory

sudo usermod -a -G libvirt $(whoami)

newgrp libvirt # to get into libvirt group immediately, not persistent

vagrant plugin install vagrant-libvirt
```

* Revert libvirt installation

```
 # Somtimes, workaround needed: export VAGRANT_DISABLE_STRICT_DEPENDENCY_ENFORCEMENT=1
vagrant plugin uninstall vagrant-libvirt

sudo apt-get remove qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils libvirt-dev virt-manager nfs-common nfs-kernel-server 
```

## Utilisation

* Bootstrap: la connexion au server cible afin d'uniformiser le user, blocage du root + key ssh obligatoire
* Launch du playbook: installation de tous les services NextCloud, Redmine, Gogs (+ supervision + backup)

## Idempotence

Les roles tiennent compte des installations précédentes pour ne restaurer que la partie applicative binaire. Cela permet de jouer les roles lors de mise à jour, sans ce soucier des données présentes sur le serveur

## Restauration

Un role spécifique permet de restaurer les données sauvegarder sur pcloud (par le script de backup)

## Provisionning

`provisionVagrant` is used to provision a local VM using Vagrant, with specific bootstrap configuration for future deploiement
`provisionVultr` is used to provision a VM on Vultr cloud, with specific bootstrap configuration for future deploiement; export VULTR_API_KEY='TZ34ESDFE4S45DFDFTD5SDF443' is mandatory.

## Deploiement

`launchPlaybook` is used to deploy all roles configured in personnalServer.yml

Usage: ./launchPlaybook.sh [-s <target server>]

## Manual bootstraping

`bootstrapVMAuthent.sh` is used to configure basic authentication for future deploiement. It launchs `bootstrapPlaybook.yml` playbook.

Usage: ./bootstrapVMAuthent.sh [-a <initial_address>] [-p <initial_port>] [-u <initial_user, root ?>] [-k <initial_ssh_key_path>]



# Special Windows 10

Pre requisites:
- WSL2 + linux box, like ubuntu
- in windows: dism.exe /online /Enable-Feature /FeatureName:VirtualMachinePlatform /all /NoRestart
- restart windows
- install vagrant and virtual box on Windows host
- install vagrant and ansible in ubuntu box
- before all vagrant scripts  export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
- https://thedatabaseme.de/2022/02/20/vagrant-up-running-vagrant-under-wsl2/