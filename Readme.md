# Personnel Server

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