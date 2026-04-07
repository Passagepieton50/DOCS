![Terraform](../../assets/images/terraform.png)

# 17 – Destroy

## 17.1 Objectif

Comprendre comment Terraform supprime une infrastructure et gère le cycle de vie des ressources.

Ce chapitre permet de :

* supprimer une infrastructure complète
* comprendre l’ordre de destruction
* identifier les dépendances
* éviter les erreurs lors du destroy



## 17.2 Commande destroy

```bash
terraform destroy
```

Terraform va :

* lire le state
* identifier les ressources existantes
* supprimer toutes les ressources



## 17.3 Fonctionnement

Terraform ne lit pas les fichiers `.tf` pour supprimer.

Il utilise :

* le fichier terraform.tfstate

Le state contient :

* les ressources existantes
* leurs relations



## 17.4 Ordre de suppression

Terraform utilise le graphe de dépendances.

Exemple :

* docker_container dépend de docker_image
* docker_container dépend de docker_network

Ordre :

1. suppression du container
2. suppression du réseau
3. suppression de l’image



## 17.5 Exemple concret

Infrastructure :

* conteneur nginx
* réseau docker
* volume

Commande :

```bash
terraform destroy
```

Terraform :

* stop le conteneur
* supprime le conteneur
* supprime le réseau
* supprime le volume



## 17.6 Destruction ciblée

```bash
terraform destroy -target=docker_container.nginx
```

Permet de :

* supprimer une seule ressource
* laisser le reste intact



## 17.7 Attention au target

Comme pour apply :

* peut casser la cohérence
* ne respecte pas toujours toutes les dépendances

Usage :

* debug uniquement



## 17.8 Problème fréquent

Volume utilisé par un container :

Erreur :

* volume busy
* ressource non supprimée

Cause :

* dépendance non respectée
* container encore actif



## 17.9 Solution

* vérifier les dépendances
* utiliser depends_on si nécessaire
* supprimer dans le bon ordre



## 17.10 State et destroy

Terraform supprime :

* uniquement ce qui est dans le state

Si une ressource est supprimée manuellement :

* Terraform ne la connaît plus
* incohérence possible



## 17.11 Commandes utiles

Afficher le state :

```bash
terraform state list
```

Afficher une ressource :

```bash
terraform state show docker_container.nginx
```



## 17.12 Cas particulier : provisioners

Les provisioners ne sont pas rejoués lors du destroy.

Terraform :

* ne relance pas remote-exec
* ne nettoie pas le système distant

Exemple :

* dossier /srv/data reste présent
* fichiers non supprimés



## 17.13 Bonnes pratiques

* utiliser destroy dans des environnements contrôlés
* éviter en production sans validation
* vérifier les dépendances
* externaliser les données critiques
* ne pas dépendre des provisioners pour cleanup



## 17.14 Sécurité

Avant un destroy :

* vérifier le workspace
* vérifier l’environnement cible
* valider les ressources impactées



## 17.15 Résumé

Terraform permet de :

* supprimer une infrastructure complète
* gérer l’ordre via les dépendances
* s’appuyer sur le state

Point clé :

Terraform détruit uniquement ce qu’il connaît dans le state, et ne nettoie pas les éléments hors de son périmètre.
