![Terraform](../../assets/images/terraform.png)

# 11 – Modules target

## 11.1 Objectif

Comprendre comment utiliser plusieurs modules Terraform et contrôler leur exécution avec la commande `-target`.

Dans ce chapitre :

* séparation de l’installation Docker et du déploiement applicatif
* introduction du module docker_run
* exécution ciblée des modules



## 11.2 Principe de la commande target

La commande target permet de dire à Terraform :

“Applique uniquement cette ressource ou ce module”

Exemple :

```bash id="g1n9xt"
terraform apply -target=module.docker_install
```

Terraform va :

* exécuter uniquement le module ciblé
* ignorer le reste de la configuration



## 11.3 Limites

* ne doit pas être utilisé en production comme workflow principal
* utile pour debug ou exécution progressive
* peut casser la cohérence globale si mal utilisé



## 11.4 Nouvelle structure du projet

Arborescence :

```bash id="y5k8zm"
projet-modules/
├── main.tf
├── providers.tf
├── terraform.tfvars
├── docker_install/
├── docker_run/
```



## 11.5 Mise à jour du main.tf

```hcl id="n7p2sk"
module "docker_install" {
  source   = "./docker_install"
  ssh_host = var.ssh_host
  ssh_user = var.ssh_user
  ssh_key  = var.ssh_key
}

module "docker_run" {
  source   = "./docker_run"
  ssh_host = var.ssh_host
}
```



## 11.6 Module docker_run

Objectif :

* utiliser le provider Docker
* créer un conteneur nginx



### docker_run/variables.tf

```hcl id="t2c9uv"
variable "ssh_host" {}
```



### docker_run/providers.tf

```hcl id="r4k1dx"
provider "docker" {
  host = "tcp://${var.ssh_host}:2375"
}
```



### docker_run/main.tf

```hcl id="q6l3mz"
resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "enginecks"

  ports {
    internal = 80
    external = 80
  }
}
```



## 11.7 Exécution en deux étapes

### Étape 1 : installation Docker

```bash id="a8m3vn"
terraform apply -target=module.docker_install
```

Résultat :

* Docker installé
* daemon actif
* port 2375 accessible



### Étape 2 : déploiement nginx

```bash id="b9q7we"
terraform apply -target=module.docker_run
```

Résultat :

* image nginx téléchargée
* conteneur lancé
* port exposé



## 11.8 Résultat final

```bash id="c2k8op"
curl http://IP_MACHINE
```

Le serveur nginx est accessible.



## 11.9 Pourquoi utiliser target

Permet de :

* découper l’exécution
* éviter les erreurs de dépendance
* valider chaque étape
* faciliter le debug



## 11.10 Problème sous-jacent

Terraform ne garantit pas l’ordre :

* installation Docker
* utilisation Docker

Sans dépendance explicite :

* Terraform peut exécuter docker_run avant docker_install



## 11.11 Solution propre

La bonne approche est d’utiliser :

```hcl id="z1n4vc"
depends_on = [module.docker_install]
```

Cela garantit :

* Docker installé avant utilisation



## 11.12 Comparaison

Approche target :

* exécution manuelle par étape
* utile pour debug

Approche dépendances :

* automatisation complète
* plus propre
* production-ready



## 11.13 Bonnes pratiques

* utiliser target uniquement pour debug
* privilégier depends_on pour la production
* structurer avec des modules
* séparer les responsabilités



## 11.14 Résumé

Ce chapitre introduit :

* l’utilisation de plusieurs modules
* la commande terraform apply -target
* l’exécution progressive d’une infrastructure

Il met en évidence :

* les limites de target
* l’importance des dépendances dans Terraform

C’est une étape clé pour comprendre l’orchestration des modules.
