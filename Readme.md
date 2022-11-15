# Personnel Server

## Utilisation

* Bootstrap: la connexion au server cible afin d'uniformiser le user, blocage du root + key ssh obligatoire
* Launche du playbook: installation de tous les services NextCloud, Redmine, Gogs (+ supervision + backup)

## Idempotence

Les roles tiennent compte des installations précédentes pour ne restaurer que la partie applicative binaire. Cela permet de jouer les roles lors de mise à jour, sans ce soucier des données présentes sur le serveur

## Restauration

Un role spécifique permet de restaurer les données sauvegarder sur pcloud (par le script de backup)