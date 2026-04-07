![Terraform](../../assets/images/terraform.png)

# 04 – Variables et local-exec

## 4.1 Introduction

Les variables permettent de rendre les configurations Terraform dynamiques, réutilisables et adaptables à différents environnements.

Elles sont utilisées pour :

* paramétrer les ressources
* éviter les valeurs en dur
* faciliter la réutilisation du code
* adapter les déploiements (dev, staging, production)



## 4.2 Déclaration des variables

Une variable est définie dans un fichier `.tf` :

```hcl
variable "example" {
  type        = string
  description = "Example variable"
  default     = "value"
}
```

Éléments principaux :

* type : type de la variable
* description : documentation
* default : valeur par défaut (optionnelle)



## 4.3 Types de variables

### string

```hcl
variable "hostname" {
  type = string
}
```

Utilisé pour :

* noms
* IP
* chemins
* messages



### list

```hcl
variable "servers" {
  type = list(string)
}
```

Utilisé pour :

* plusieurs éléments du même type
* boucles
* configurations multiples



### map

```hcl
variable "tags" {
  type = map(string)
}
```

Utilisé pour :

* associer des clés à des valeurs
* configuration structurée



## 4.4 Utilisation des variables

Les variables sont appelées avec la syntaxe :

```hcl
var.nom_variable
```

Exemple :

```hcl
resource "null_resource" "example" {
  triggers = {
    name = var.hostname
  }
}
```



## 4.5 Fichier terraform.tfvars

Les variables peuvent être définies dans un fichier dédié :

```hcl
hostname = "server01"
```

Avantages :

* séparation configuration / logique
* adaptation facile selon l’environnement
* évite la modification du code principal



## 4.6 Ordre de priorité des variables

Terraform applique les variables selon un ordre de priorité :

1. variables passées en CLI (`-var`)
2. fichiers `.tfvars`
3. variables d’environnement (`TF_VAR_*`)
4. valeurs par défaut



## 4.7 local-exec

Le provisioner `local-exec` permet d’exécuter des commandes sur la machine locale (celle qui exécute Terraform).

Exemple :

```hcl
resource "null_resource" "local" {
  provisioner "local-exec" {
    command = "echo Hello Terraform"
  }
}
```



### Cas d’usage

* génération de fichiers
* appel d’API
* exécution de scripts
* intégration avec d’autres outils (Ansible, scripts shell)



## 4.8 Exemple pratique

Création d’un fichier local à partir d’une variable :

```hcl
variable "content" {
  type = string
}

resource "null_resource" "generate_file" {
  provisioner "local-exec" {
    command = "echo ${var.content} > output.txt"
  }
}
```



## 4.9 Triggers avec local-exec

Pour relancer une commande si une variable change :

```hcl
resource "null_resource" "example" {
  triggers = {
    content = var.content
  }

  provisioner "local-exec" {
    command = "echo ${var.content} > output.txt"
  }
}
```

Si la valeur change, la ressource est recréée.



## 4.10 Limites de local-exec

* dépend de l’environnement local
* non portable
* difficile à maintenir à grande échelle
* non déclaratif



## 4.11 Bonnes pratiques (2026)

* éviter local-exec pour des actions critiques

* préférer des solutions déclaratives

* utiliser local-exec pour :

  * debug
  * génération ponctuelle
  * intégration externe

* utiliser triggers pour contrôler l’exécution

* ne pas dépendre de l’état local pour des workflows critiques



## 4.12 Alternatives modernes

Selon le besoin :

* cloud-init : configuration initiale des VM
* Ansible : configuration système
* scripts CI/CD : orchestration
* modules Terraform : structuration propre



## 4.13 Résumé

Les variables sont essentielles pour :

* rendre le code flexible
* faciliter la réutilisation
* adapter les déploiements

Le provisioner local-exec permet d’exécuter des commandes locales, mais doit être utilisé avec précaution dans une approche moderne et orientée production.
