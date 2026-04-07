![Terraform](../assets/images/terraform.png) 

# 03 – Notions et définitions

## 3.1 Providers

Un provider est un composant qui permet à Terraform d’interagir avec une API externe.

Il sert d’interface entre Terraform et les plateformes cibles :

* cloud (AWS, Azure, GCP)
* virtualisation (KVM, VMware)
* conteneurs (Docker, Kubernetes)
* services SaaS, réseau, bases de données

Terraform utilise les providers pour effectuer des opérations sur les ressources via des appels API.

Les providers sont distribués via un registry et téléchargés automatiquement lors de l’exécution de `terraform init`.



## 3.2 Resources

Une resource est une unité de base représentant un élément d’infrastructure.

Exemples :

* machine virtuelle
* conteneur
* réseau
* volume
* fichier

Chaque ressource suit un cycle de vie complet :

* Create
* Read
* Update
* Delete

Une ressource est identifiée par :

```hcl
resource "<TYPE>" "<NAME>" {
  ...
}
```

Le nom est unique dans un même module.



## 3.3 Data sources

Les data sources permettent de récupérer des informations existantes sans modifier l’infrastructure.

Exemples d’usage :

* récupérer une image existante
* lire un état distant
* obtenir des informations d’un provider

Contrairement aux resources, elles sont en lecture seule.



## 3.4 State

Le state est un fichier qui représente l’état courant de l’infrastructure connue par Terraform.

Par défaut :

```bash
terraform.tfstate
```

Il contient :

* les ressources gérées
* leurs attributs
* les métadonnées



### Rôle du state

Le state permet de :

* comparer l’état réel et l’état attendu
* éviter de recréer des ressources existantes
* optimiser les performances
* gérer les dépendances



### Remote state

Le state peut être externalisé pour un usage collaboratif :

* S3
* Consul
* PostgreSQL
* GitLab (backend HTTP)

Bonnes pratiques :

* ne pas stocker le state en local en production
* sécuriser l’accès (chiffrement, contrôle d’accès)
* éviter l’exposition de données sensibles



## 3.5 Cycle d’exécution

Terraform suit plusieurs étapes lors de l’exécution :

* refresh : synchronisation avec l’infrastructure réelle
* plan : génération du plan d’exécution
* apply : application des changements
* destroy : suppression des ressources

Commandes principales :

```bash
terraform init
terraform plan
terraform apply
terraform destroy
terraform refresh
terraform show
terraform validate
```



## 3.6 Variables

Les variables permettent de rendre les configurations dynamiques et réutilisables.

Types principaux :

* string : chaîne de caractères
* list : liste ordonnée
* map : dictionnaire clé-valeur

Exemple :

```hcl
variable "instance_name" {
  type    = string
  default = "vm-01"
}
```



## 3.7 Meta-arguments

Terraform fournit des mécanismes pour gérer la répétition et les dépendances.

### count

Permet de créer plusieurs instances d’une ressource :

```hcl
count = 3
```

Limitation : dépend de l’index, sensible aux changements d’ordre.



### for_each

Permet de créer des ressources à partir d’une collection :

```hcl
for_each = var.instances
```

Accès aux valeurs :

* each.key
* each.value

Recommandation : privilégier `for_each` pour une meilleure stabilité.



## 3.8 Provisioners

Les provisioners permettent d’exécuter des commandes pendant la création ou la modification d’une ressource.

Types principaux :

* local-exec : exécution sur la machine Terraform
* remote-exec : exécution sur la machine distante

Exemple :

```hcl
provisioner "remote-exec" {
  inline = ["apt update", "apt install -y nginx"]
}
```



### Limites

Les provisioners ne sont pas considérés comme une bonne pratique en production :

* non déclaratifs
* difficilement idempotents
* compliquent le debug

Alternatives recommandées :

* cloud-init
* images préconfigurées
* outils de configuration (Ansible)



## 3.9 null_resource

La ressource `null_resource` ne crée pas d’infrastructure mais permet :

* d’exécuter des scripts
* d’orchestrer des actions

Souvent utilisée avec :

* provisioners
* triggers



## 3.10 Triggers

Les triggers permettent de forcer la recréation d’une ressource lorsque certaines valeurs changent.

Exemple :

```hcl
triggers = {
  version = var.app_version
}
```

Si la valeur change, la ressource est recréée.



## 3.11 Fonctions utiles

Terraform propose des fonctions intégrées :

* length() : taille d’une liste
* file() : lecture d’un fichier
* lookup() : récupération dans une map

Exemple :

```hcl
length(var.instances)
```



## 3.12 Interpolation

Terraform permet d’insérer des expressions dynamiques.

Ancienne syntaxe :

```hcl
"${var.name}"
```

Syntaxe moderne :

```hcl
var.name
```



## 3.13 Bonnes pratiques (2026)

* typer toutes les variables
* privilégier for_each à count
* limiter l’usage des provisioners
* utiliser des modules pour structurer le code
* externaliser le state
* éviter les valeurs en dur
* sécuriser les données sensibles



## 3.14 Résumé

Terraform repose sur quelques concepts fondamentaux :

* providers pour communiquer avec les APIs
* resources pour définir l’infrastructure
* state pour suivre l’existant
* variables pour rendre le code dynamique
* modules pour structurer les projets

La compréhension de ces éléments est essentielle pour maîtriser Terraform et construire des infrastructures fiables et reproductibles.
