![Terraform](../../assets/images/terraform.png)

# 25 – Kubernetes WordPress Module

## 25.1 Objectif

Transformer la stack WordPress Kubernetes en module Terraform réutilisable.

Ce chapitre permet de :

* factoriser toute la configuration
* rendre le code réutilisable
* simplifier le projet principal
* appliquer les bonnes pratiques Terraform



## 25.2 Principe

Jusqu’à présent :

* toutes les ressources sont dans le même fichier
* difficile à maintenir
* difficile à réutiliser

Objectif :

* créer un module wordpress
* isoler toute la logique Kubernetes



## 25.3 Structure du projet

```bash id="k2n7xp"
project/
├── main.tf
├── terraform.tfvars
├── providers.tf
├── modules/
│   └── wordpress/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
```



## 25.4 Root main.tf

```hcl id="v8p3rm"
module "wordpress" {
  source = "./modules/wordpress"
}
```

Le root devient :

* simple
* lisible
* maintenable



## 25.5 Module variables.tf

```hcl id="t4x9qk"
variable "namespace" {
  default = "wordpress"
}

variable "wordpress_port" {
  default = 30080
}
```



## 25.6 Module main.tf

Le module contient toute la stack :

* namespace
* PVC
* deployment MySQL
* deployment WordPress
* services

Exemple simplifié :

```hcl id="m7k2zd"
resource "kubernetes_namespace" "wordpress" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_persistent_volume_claim" "mysql" {
  metadata {
    name      = "mysql-pvc"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}
```



## 25.7 Outputs du module

```hcl id="p1v6tx"
output "namespace" {
  value = var.namespace
}
```

Permet au root :

* de récupérer des informations
* d’interagir avec le module



## 25.8 Avantages

* réutilisation du module
* séparation des responsabilités
* code plus propre
* maintenance simplifiée



## 25.9 Exemple d’utilisation

```hcl id="c3w8pn"
module "wordpress_prod" {
  source = "./modules/wordpress"

  namespace      = "prod"
  wordpress_port = 30080
}

module "wordpress_dev" {
  source = "./modules/wordpress"

  namespace      = "dev"
  wordpress_port = 30081
}
```



## 25.10 Résultat

Terraform crée :

* plusieurs environnements
* isolés par namespace
* avec la même configuration



## 25.11 Bonnes pratiques

* un module = une application
* utiliser variables.tf pour paramétrer
* utiliser outputs.tf pour exposer
* éviter les valeurs en dur
* structurer les modules dans un dossier dédié



## 25.12 Limites

* gestion des secrets non traitée
* dépend du cluster Kubernetes
* pas de versionning des modules



## 25.13 Évolution possible

* ajout de secrets Kubernetes
* ajout d’Ingress
* versionning des modules
* registry Terraform privé



## 25.14 Résumé

Ce chapitre permet de :

* transformer une configuration en module
* rendre le code Terraform réutilisable
* améliorer la structure globale du projet

Point clé :

Les modules sont indispensables pour construire des architectures Terraform propres, maintenables et évolutives.
