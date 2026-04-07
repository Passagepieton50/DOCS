
![Terraform](../../assets/images/terraform.png)

# 05 – Variables et définitions

## 5.1 Introduction

Les variables sont un élément central dans Terraform. Elles permettent de rendre les configurations dynamiques, réutilisables et adaptées à différents contextes.

Elles servent notamment à :

* éviter les valeurs en dur
* paramétrer les ressources
* adapter les déploiements selon l’environnement
* améliorer la lisibilité et la maintenabilité

Une variable est une entrée configurable dont la valeur peut être définie :

* par défaut
* dans un fichier terraform.tfvars
* en ligne de commande



## 5.2 Définition des variables

Exemple :

```hcl
variable "hostname" {
  type    = string
  default = "server01"
}
```

Une variable peut contenir :

* un type
* une valeur par défaut
* une description



## 5.3 Types de variables

### string

Une chaîne de caractères.

Utilisation :

* hostname
* IP
* chemins
* messages

Exemple :

```hcl
variable "ip" {
  type = string
}
```



### list

Une liste ordonnée de valeurs.

Exemple :

```hcl
variable "hosts" {
  type = list(string)
}
```

Utilisation :

* plusieurs serveurs
* ports
* éléments à parcourir



### map

Un dictionnaire clé → valeur.

Exemple :

```hcl
variable "servers" {
  type = map(string)
}
```

Utilisation :

* associer une clé à une valeur
* configuration structurée



## 5.4 Utilisation des variables

Appel :

```hcl
var.nom_variable
```

Exemple :

```hcl
resource "null_resource" "example" {
  triggers = {
    ip = var.ip
  }
}
```



## 5.5 terraform.tfvars

Fichier permettant de définir les valeurs des variables.

Exemple :

```hcl
ip = "192.168.1.10"
hostname = "web01"
```

Avantages :

* séparation configuration / code
* facilité de modification
* adaptation multi-environnements



## 5.6 Exemple pratique avec local-exec

Objectif : générer un fichier hosts à partir d’une variable.

```hcl
variable "hosts" {
  type = list(string)
}

resource "null_resource" "generate_hosts" {
  provisioner "local-exec" {
    command = "printf '%s\n' ${join(\" \", var.hosts)} > hosts"
  }
}
```

Étapes :

* terraform init
* terraform plan
* terraform apply

Résultat :

```bash
cat hosts
```

Le fichier hosts est généré avec le contenu attendu.



## 5.7 null_resource

La ressource null_resource ne crée rien mais permet :

* d’exécuter des scripts
* d’orchestrer des actions

Elle est souvent utilisée avec :

* local-exec
* remote-exec
* triggers



## 5.8 Triggers

Les triggers permettent de forcer la recréation d’une ressource si une valeur change.

Exemple :

```hcl
resource "null_resource" "example" {
  triggers = {
    hosts = join(",", var.hosts)
  }

  provisioner "local-exec" {
    command = "echo updated"
  }
}
```

Si la variable change, Terraform relance la ressource.



## 5.9 Boucles et itérations

### count

```hcl
count = length(var.hosts)
```

Permet de créer plusieurs ressources.

Limite : dépend de l’index.



### for_each

```hcl
for_each = var.servers
```

Accès :

* each.key
* each.value

Recommandé pour :

* stabilité
* lisibilité



## 5.10 Fonctions utiles

### length()

```hcl
length(var.hosts)
```

Retourne la taille d’une liste.



### element()

```hcl
element(var.hosts, count.index)
```

Permet d’accéder à un élément d’une liste.

(aujourd’hui remplacé par var.hosts[count.index])



## 5.11 Interpolation

Ancienne syntaxe :

```hcl
"${var.ip}"
```

Syntaxe moderne :

```hcl
var.ip
```



## 5.12 Rappel des concepts clés

Variable
Entrée configurable permettant de rendre le code dynamique

string
Chaîne de caractères

list
Liste ordonnée

map
Dictionnaire clé → valeur

resource
Bloc décrivant un objet d’infrastructure

null_resource
Ressource utilisée pour exécuter des actions

provisioner
Permet d’exécuter des commandes

local-exec
Commande exécutée localement

remote-exec
Commande exécutée sur une machine distante

for_each
Création de ressources à partir d’une collection

count
Création multiple basée sur un nombre

triggers
Force la recréation d’une ressource



## 5.13 Bonnes pratiques

* utiliser terraform.tfvars pour les variables
* typer les variables
* éviter les valeurs en dur
* privilégier for_each
* limiter l’usage des provisioners
* utiliser triggers uniquement si nécessaire



## 5.14 Résumé

Les variables permettent de rendre Terraform :

* flexible
* réutilisable
* maintenable

Elles sont indispensables pour construire des configurations propres et adaptées à des environnements réels.
