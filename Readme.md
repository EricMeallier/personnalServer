# Personnel Server

## Pre requisites

* Pour KVM/Libvirt
```
sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils libvirt-dev
sudo apt-get install virt-manager

sudo apt-get install nfs-common nfs-kernel-server # ?

sudo usermod -a -G libvirt $(whoami)

newgrp libvirt # pas serein sur cette commande :)
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