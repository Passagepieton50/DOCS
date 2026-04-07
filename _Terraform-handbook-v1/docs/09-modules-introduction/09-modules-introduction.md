![Terraform](../../assets/images/terraform.png)

# 09 – Modules Introduction

## 9.1 Définition

Un module Terraform est un ensemble de fichiers `.tf` permettant de regrouper des ressources ayant une cohérence fonctionnelle.

Un module permet de :

* structurer le code
* réutiliser des configurations
* isoler des parties d’infrastructure
* améliorer la lisibilité

Un module Terraform est équivalent à un rôle dans Ansible.



## 9.2 Structure d’un module

Structure minimale :

```bash id="yq3r8n"
module/
├── main.tf
├── variables.tf
├── outputs.tf
```

Structure avancée :

```bash id="m7u1sj"
module/
├── main.tf
├── variables.tf
├── outputs.tf
├── modules/
│   ├── nestedA/
│   ├── nestedB/
├── examples/
```



## 9.3 Appel d’un module

Exemple :

```hcl id="e8i3x2"
module "docker_install" {
  source = "./docker_install"
}
```

Terraform va :

* lire le module
* exécuter son contenu
* l’intégrer dans le graphe global



## 9.4 Instanciation multiple

Un module peut être utilisé plusieurs fois :

```hcl id="f6y9ps"
module "instance1" {
  source = "./module"
}

module "instance2" {
  source = "./module"
}
```



## 9.5 Registry des modules

Terraform fournit un registry officiel :

* modules publics
* modules versionnés
* réutilisation rapide

Un module peut être utilisé directement depuis le registry.



## 9.6 Problème sans module

Dans le chapitre précédent, tout était dans un seul fichier :

* installation Docker
* provider Docker
* création du conteneur

Terraform construit un graphe :

* null_resource.ssh_target
* docker_image.nginx
* docker_container.nginx

Mais aucune dépendance n’existe entre :

* l’installation Docker
* l’utilisation du provider Docker

Résultat :

Terraform peut exécuter les ressources en parallèle.



## 9.7 Conséquence

Terraform tente :

* d’utiliser le provider Docker
* avant que le daemon Docker soit prêt

Erreur :

* connexion refusée sur tcp://IP:2375

Le problème ne vient pas de l’ordre du fichier, mais du graphe de dépendances.



## 9.8 Apport du module

Avec un module :

```hcl id="v0c8kr"
module "docker_install" {
  source = "./docker_install"
}
```

Terraform crée un nœud logique :

* module.docker_install

Ce module contient :

* null_resource.ssh_target



## 9.9 Gestion des dépendances

Exemple :

```hcl id="z4w2ml"
resource "docker_image" "nginx" {
  name       = "nginx:latest"
  depends_on = [module.docker_install]
}
```

Terraform comprend :

* attendre la fin du module
* avant d’utiliser Docker



## 9.10 Point clé

Le module ne crée pas la dépendance.

C’est depends_on qui crée la dépendance.

Le module sert à :

* regrouper les ressources
* simplifier la dépendance
* rendre le code lisible



## 9.11 Avant / après

Sans module :

* dépendance directe sur une ressource
* code difficile à maintenir

Avec module :

* dépendance sur un bloc logique
* meilleure organisation
* meilleure lisibilité



## 9.12 Analogie

Sans module :

Terraform voit des ressources indépendantes

Avec module :

Terraform voit une étape logique :

“Docker est installé”



## 9.13 Bonnes pratiques

* créer un module par fonction
* isoler les responsabilités
* utiliser variables.tf et outputs.tf
* éviter les gros fichiers monolithiques
* utiliser depends_on si nécessaire



## 9.14 Résumé

Un module permet de :

* structurer le code Terraform
* regrouper des ressources
* simplifier la gestion des dépendances
* améliorer la lisibilité

Il ne gère pas les dépendances automatiquement, mais permet de les exprimer proprement.

Les modules sont essentiels pour construire des projets Terraform maintenables et évolutifs.
