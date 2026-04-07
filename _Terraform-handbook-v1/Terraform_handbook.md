

# Terraform Handbook

Documentation complète structurée autour de 35 chapitres couvrant les fondamentaux, Docker, Kubernetes et KVM avec Terraform.




# Introduction

Terraform est un outil d’Infrastructure as Code (IaC) permettant de définir, provisionner et maintenir une infrastructure de manière déclarative à l’aide de fichiers de configuration.

Contrairement aux approches impératives, Terraform ne décrit pas les étapes à exécuter mais l’état final attendu de l’infrastructure. À partir de cette définition, il construit un graphe de dépendances, calcule les différences entre l’existant et la cible, puis applique uniquement les changements nécessaires.

Ce modèle permet d’obtenir une infrastructure reproductible, versionnable et cohérente, intégrée dans des workflows modernes de type GitOps et CI/CD.

Terraform s’appuie sur des providers pour interagir avec des APIs externes. Ces providers couvrent un large spectre d’usages :

* cloud public (AWS, Azure, GCP)
* virtualisation (KVM, VMware)
* conteneurs (Docker, Kubernetes)
* services réseau, bases de données et plateformes SaaS

Chaque élément d’infrastructure est décrit sous forme de ressource, gérée selon un cycle de vie complet : création, lecture, modification et suppression.

Un élément central du fonctionnement de Terraform est le state. Ce fichier représente l’état courant de l’infrastructure connue par Terraform et permet d’optimiser les opérations, de détecter les dérives et de garantir la cohérence des déploiements.

Dans un contexte DevOps moderne, Terraform est principalement utilisé pour :

* automatiser la création d’infrastructures
* standardiser les environnements (développement, staging, production)
* versionner les changements d’infrastructure
* faciliter la collaboration entre équipes
* intégrer l’infrastructure dans des pipelines CI/CD

Cette documentation propose une approche progressive et orientée production. Elle couvre les concepts fondamentaux, la structuration via les modules, la gestion du state, ainsi que des cas pratiques autour de Docker, Kubernetes et KVM.

L’objectif est de fournir une compréhension claire du fonctionnement interne de Terraform tout en permettant une mise en pratique immédiate dans des contextes réels.





 

# 02 – Installation

## 2.1 Prérequis

Terraform est un binaire autonome écrit en Go. Il ne nécessite pas de dépendances spécifiques côté système, hormis un environnement capable d’exécuter des commandes shell.

Prérequis recommandés :

* système Linux, macOS ou Windows
* accès réseau pour télécharger les providers
* droits suffisants pour installer un binaire
* accès à une plateforme cible (cloud, VM, Docker, etc.)


## 2.2 Installation de Terraform

### Installation sous Linux

```bash
sudo apt update
sudo apt install -y wget unzip

wget https://releases.hashicorp.com/terraform/<VERSION>/terraform_<VERSION>_linux_amd64.zip
unzip terraform_<VERSION>_linux_amd64.zip
sudo mv terraform /usr/local/bin/
sudo chmod +x /usr/local/bin/terraform
```


### Installation via gestionnaire de paquets (recommandé)

#### Debian / Ubuntu

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt install terraform
```


### macOS (Homebrew)

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```


### Windows (Chocolatey)

```powershell
choco install terraform
```


## 2.3 Vérification de l’installation

```bash
terraform version
```

La commande doit afficher la version installée ainsi que les informations sur l’architecture.


## 2.4 Structure d’un projet Terraform

Un projet Terraform est constitué de fichiers `.tf` regroupés dans un répertoire.

Exemple minimal :

```bash
mkdir terraform-project
cd terraform-project
```

Fichier principal :

```hcl
output "example" {
  value = "hello terraform"
}
```


## 2.5 Initialisation d’un projet

Avant toute exécution, Terraform doit être initialisé :

```bash
terraform init
```

Cette commande :

* télécharge les providers nécessaires
* initialise le backend (local ou distant)
* prépare le répertoire `.terraform/`


## 2.6 Cycle de travail initial

Terraform suit un cycle standard :

```bash
terraform fmt       # formatage du code
terraform validate  # validation syntaxique
terraform plan      # aperçu des changements
terraform apply     # application des changements
```


## 2.7 Fichiers générés

Après initialisation et exécution :

* `.terraform/` : plugins et dépendances
* `terraform.tfstate` : état courant
* `terraform.tfstate.backup` : sauvegarde

Ces fichiers ne doivent pas être versionnés (sauf backend distant configuré).


## 2.8 Bonnes pratiques (2026)

* privilégier l’installation via gestionnaire de paquets
* utiliser une version verrouillée (ex : via `.terraform.lock.hcl`)
* ne jamais committer les fichiers de state
* isoler les projets Terraform par répertoire
* initialiser systématiquement avec `terraform init`
* utiliser des environnements reproductibles (containers, CI)


## 2.9 Remarques

Terraform ne nécessite pas d’installation côté machine cible. Toutes les opérations passent par des APIs via les providers.

Cela permet d’exécuter Terraform depuis :

* un poste local
* un runner CI/CD
* un environnement distant

Le binaire Terraform agit uniquement comme orchestrateur.







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







# 06 – Remote exec SSH

## 6.1 Introduction

Le provisioner `remote-exec` permet d’exécuter des commandes directement sur une machine distante via SSH.

Il est utilisé pour :

* installer des services
* configurer une machine
* automatiser des actions après création d’une ressource

Ce mécanisme repose sur une connexion SSH définie dans Terraform.



## 6.2 Principe de fonctionnement

Terraform :

* établit une connexion SSH vers la machine cible
* exécute une liste de commandes
* applique ces actions lors du `terraform apply`

Cela permet de configurer une machine immédiatement après sa création ou indépendamment d’un provider spécifique.



## 6.3 Définition de la connexion SSH

Exemple :

```hcl id="c6u2s2"
connection {
  type        = "ssh"
  user        = var.ssh_user
  host        = var.ssh_host
  private_key = file(var.ssh_key)
}
```

Variables utilisées :

* ssh_host : IP ou hostname de la machine
* ssh_user : utilisateur de connexion
* ssh_key : chemin vers la clé privée

Important :

* les clés SSH doivent être générées au préalable
* adapter selon le système cible



## 6.4 Exemple simple avec remote-exec

```hcl id="j4o1ut"
resource "null_resource" "ssh_target" {

  connection {
    type        = "ssh"
    user        = var.ssh_user
    host        = var.ssh_host
    private_key = file(var.ssh_key)
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Connexion SSH OK'",
      "uname -a"
    ]
  }
}
```



## 6.5 Installation d’un service (exemple nginx)

Objectif : installer nginx sur la machine distante.

```hcl id="hl2z4r"
resource "null_resource" "ssh_target" {

  connection {
    type        = "ssh"
    user        = var.ssh_user
    host        = var.ssh_host
    private_key = file(var.ssh_key)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -qq",
      "sudo apt install -y nginx"
    ]
  }
}
```



## 6.6 Vérification et exécution

Commandes :

```bash id="m9p4w1"
terraform init
terraform plan
terraform apply
```

Terraform va :

* se connecter à la machine
* exécuter les commandes
* installer nginx



## 6.7 Exemple réel (retour d’exécution)

Connexion SSH :

* Host : 172.26.x.x
* User : root
* Private key : utilisée

Logs :

```text id="o3p0s9"
Connecting to remote host via SSH...
Connected!

Mise à jour des référentiels
Installation de nginx
Terminé
```

Résultat :

* nginx installé
* service opérationnel



## 6.8 remote-exec avec plusieurs étapes

Terraform permet d’exécuter plusieurs provisioners :

```hcl id="zn92r1"
provisioner "remote-exec" {
  inline = [
    "sudo apt update",
    "sudo apt install -y nginx"
  ]
}

provisioner "remote-exec" {
  inline = [
    "sudo systemctl enable nginx",
    "sudo systemctl restart nginx"
  ]
}
```



## 6.9 Ajout de commandes système

Exemple :

```hcl id="k91s2x"
inline = [
  "sudo systemctl status nginx",
  "ss -lntp | grep nginx"
]
```

Permet de vérifier que le service écoute correctement.



## 6.10 Bonnes pratiques SSH

* utiliser une clé privée (pas de mot de passe)
* restreindre les accès SSH
* éviter root en production
* vérifier les permissions des clés



## 6.11 Limites de remote-exec

* dépend fortement de l’état de la machine
* non déclaratif
* difficile à maintenir à grande échelle
* fragile en cas d’échec réseau



## 6.12 Alternatives modernes

Dans une approche production :

* cloud-init pour bootstrap VM
* Ansible pour configuration
* images préconfigurées

Terraform doit rester orienté provisioning, pas configuration système.



## 6.13 Résumé

Le provisioner remote-exec permet :

* d’exécuter des commandes sur une machine distante
* de configurer rapidement un environnement
* d’automatiser des tâches via SSH

Il reste utile pour des cas simples ou des environnements de test, mais doit être utilisé avec précaution dans des architectures modernes.







# 07 – Remote exec Installation Docker

## 7.1 Objectif

Installer Docker sur une machine distante via SSH avec Terraform, puis préparer le daemon pour être utilisé par le provider Docker.

L’objectif est de :

* se connecter à une machine distante
* installer Docker
* configurer le service
* préparer le socket Docker
* permettre à Terraform de piloter Docker à distance



## 7.2 Variables utilisées

```hcl
variable "ssh_host" {}
variable "ssh_user" {}
variable "ssh_key" {}
```

Ces variables permettent de :

* définir la machine cible
* définir l’utilisateur SSH
* utiliser une clé privée pour la connexion



## 7.3 Installation de Docker via remote-exec

```hcl
resource "null_resource" "ssh_target" {

  connection {
    type        = "ssh"
    user        = var.ssh_user
    host        = var.ssh_host
    private_key = file(var.ssh_key)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -qq >/dev/null",
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo chmod 755 get-docker.sh",
      "sudo ./get-docker.sh >/dev/null"
    ]
  }
}
```

Terraform va :

* se connecter en SSH
* télécharger le script officiel Docker
* installer Docker automatiquement



## 7.4 Ajout d’une configuration Docker (socket)

Fichier local :

```bash
startup-options.conf
```

Ce fichier permet de configurer Docker pour écouter en TCP (port 2375).



## 7.5 Envoi du fichier vers la machine distante

```hcl
provisioner "file" {
  source      = "startup-options.conf"
  destination = "/tmp/startup-options.conf"
}
```



## 7.6 Application de la configuration

```hcl
provisioner "remote-exec" {
  inline = [
    "sudo mkdir -p /etc/systemd/system/docker.service.d/",
    "sudo cp /tmp/startup-options.conf /etc/systemd/system/docker.service.d/startup_options.conf",
    "sudo systemctl daemon-reload",
    "sudo systemctl restart docker",
    "sudo usermod -aG docker vagrant"
  ]
}
```

Actions réalisées :

* création du répertoire de configuration
* copie du fichier
* rechargement systemd
* redémarrage Docker
* ajout de l’utilisateur au groupe docker



## 7.7 Configuration du provider Docker

```hcl
provider "docker" {
  host = "tcp://${var.ssh_host}:2375"
}
```

Ce bloc indique à Terraform :

“Utilise le daemon Docker distant via TCP sur le port 2375.”



## 7.8 Exemple complet

```hcl
variable "ssh_host" {}
variable "ssh_user" {}
variable "ssh_key" {}

resource "null_resource" "ssh_target" {

  connection {
    type        = "ssh"
    user        = var.ssh_user
    host        = var.ssh_host
    private_key = file(var.ssh_key)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -qq >/dev/null",
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo chmod 755 get-docker.sh",
      "sudo ./get-docker.sh >/dev/null"
    ]
  }

  provisioner "file" {
    source      = "startup-options.conf"
    destination = "/tmp/startup-options.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/systemd/system/docker.service.d/",
      "sudo cp /tmp/startup-options.conf /etc/systemd/system/docker.service.d/startup_options.conf",
      "sudo systemctl daemon-reload",
      "sudo systemctl restart docker",
      "sudo usermod -aG docker vagrant"
    ]
  }
}

provider "docker" {
  host = "tcp://${var.ssh_host}:2375"
}
```



## 7.9 Exécution

```bash
terraform init
terraform plan
terraform apply
```

Résultat :

* Docker installé sur la machine distante
* daemon actif
* socket TCP disponible
* Terraform capable de piloter Docker à distance



## 7.10 Points importants

Terraform ne suit pas l’ordre du fichier mais un graphe de dépendances.

Sans dépendance explicite :

* Terraform peut essayer d’utiliser le provider Docker
* avant que Docker soit installé
* ce qui provoque une erreur de connexion



## 7.11 Problème rencontré

Erreur typique :

* connexion refusée sur tcp://IP:2375
* Docker non encore prêt

Cause :

* absence de dépendance entre installation Docker et provider Docker



## 7.12 Conclusion

Ce module permet de :

* préparer une machine distante
* installer Docker automatiquement
* exposer le daemon Docker
* préparer les étapes suivantes (containers, images, réseaux)

Il constitue la base pour tous les chapitres suivants liés à Docker avec Terraform.







# 08 – Docker provider nginx

## 8.1 Objectif

Créer un conteneur Docker nginx sur une machine distante en utilisant le provider Docker de Terraform.

Ce chapitre s’appuie sur la configuration précédente :

* Docker est installé sur la machine cible
* le daemon est accessible via TCP (port 2375)



## 8.2 Provider Docker

```hcl id="wz3o7y"
provider "docker" {
  host = "tcp://${var.ssh_host}:2375"
}
```

Ce bloc indique à Terraform :

* de se connecter au daemon Docker distant
* d’exécuter les actions via cette API



## 8.3 Téléchargement de l’image nginx

```hcl id="dgn1pg"
resource "docker_image" "nginx" {
  name = "nginx:latest"
}
```

Terraform va :

* vérifier si l’image existe
* sinon effectuer l’équivalent de :

```bash id="y2u0zt"
docker pull nginx:latest
```



## 8.4 Création du conteneur

```hcl id="z9r2tw"
resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "enginecks"

  ports {
    internal = 80
    external = 80
  }
}
```

Terraform va effectuer l’équivalent de :

```bash id="j7p6bt"
docker run -d --name enginecks -p 80:80 nginx:latest
```



## 8.5 Exemple complet

```hcl id="m1v0cg"
variable "ssh_host" {}
variable "ssh_user" {}
variable "ssh_key" {}

resource "null_resource" "ssh_target" {

  connection {
    type        = "ssh"
    user        = var.ssh_user
    host        = var.ssh_host
    private_key = file(var.ssh_key)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -qq >/dev/null",
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo chmod 755 get-docker.sh",
      "sudo ./get-docker.sh >/dev/null"
    ]
  }

  provisioner "file" {
    source      = "startup-options.conf"
    destination = "/tmp/startup-options.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/systemd/system/docker.service.d/",
      "sudo cp /tmp/startup-options.conf /etc/systemd/system/docker.service.d/startup_options.conf",
      "sudo systemctl daemon-reload",
      "sudo systemctl restart docker",
      "sudo usermod -aG docker vagrant"
    ]
  }
}

provider "docker" {
  host = "tcp://${var.ssh_host}:2375"
}

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



## 8.6 Problème rencontré

Erreur possible :

* Terraform tente d’utiliser Docker avant son installation
* connexion échoue vers tcp://IP:2375

Cause :

Terraform ne suit pas l’ordre du fichier mais un graphe de dépendances.



## 8.7 Explication

Terraform voit :

* null_resource.ssh_target
* docker_image.nginx
* docker_container.nginx

Mais aucune dépendance entre :

* installation Docker
* utilisation du provider Docker

Donc Terraform peut exécuter :

* docker_image
* docker_container

avant que Docker soit prêt.



## 8.8 Solution (base)

Ajouter une dépendance :

```hcl id="q2k7m9"
resource "docker_image" "nginx" {
  name       = "nginx:latest"
  depends_on = [null_resource.ssh_target]
}
```

Même principe pour docker_container.



## 8.9 Résultat

Après exécution :

```bash id="p7l0xx"
terraform apply
```

Résultat attendu :

* image nginx téléchargée
* conteneur lancé
* port 80 exposé

Test :

```bash id="g0z7sk"
curl http://IP_MACHINE
```



## 8.10 Résumé

Ce chapitre permet de :

* utiliser le provider Docker
* télécharger une image
* créer un conteneur
* comprendre le problème de dépendance Terraform

Il met en évidence un point clé :

Terraform ne suit pas un ordre linéaire, mais un graphe de dépendances.

La gestion correcte des dépendances sera abordée avec les modules dans les chapitres suivants.







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







# 10 – Module premier pas

## 10.1 Objectif

Mettre en place un premier module Terraform permettant d’installer Docker sur une machine distante.

Ce module permet de :

* isoler l’installation Docker
* structurer le projet
* préparer les étapes suivantes (containers, réseau, etc.)



## 10.2 Structure du projet

Arborescence :

```bash id="q8h3zn"
projet-modules/
├── main.tf
├── providers.tf
├── terraform.tfvars
├── docker_install/
│   ├── main.tf
│   ├── variables.tf
│   ├── startup-options.conf
```



## 10.3 Fichier terraform.tfvars

Définition des variables :

```hcl id="k3n2sx"
ssh_host = "IP_MACHINE"
ssh_user = "root"
ssh_key  = "/root/.ssh/id_rsa"
```

Ces variables seront utilisées par le module.



## 10.4 Fichier providers.tf

```hcl id="j7k9op"
provider "docker" {
  host = "tcp://${var.ssh_host}:2375"
}
```

Permet à Terraform de se connecter au daemon Docker distant.



## 10.5 Fichier main.tf (root)

Appel du module :

```hcl id="r2m1vq"
module "docker_install" {
  source   = "./docker_install"
  ssh_host = var.ssh_host
  ssh_user = var.ssh_user
  ssh_key  = var.ssh_key
}
```

Ce bloc :

* appelle le module
* transmet les variables
* exécute le contenu du module



## 10.6 Module docker_install

### variables.tf

```hcl id="p8v4zs"
variable "ssh_host" {}
variable "ssh_user" {}
variable "ssh_key" {}
```



### main.tf

```hcl id="z1n8ux"
resource "null_resource" "ssh_target" {

  connection {
    type        = "ssh"
    user        = var.ssh_user
    host        = var.ssh_host
    private_key = file(var.ssh_key)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -qq >/dev/null",
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo chmod 755 get-docker.sh",
      "sudo ./get-docker.sh >/dev/null"
    ]
  }

  provisioner "file" {
    source      = "startup-options.conf"
    destination = "/tmp/startup-options.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/systemd/system/docker.service.d/",
      "sudo cp /tmp/startup-options.conf /etc/systemd/system/docker.service.d/startup_options.conf",
      "sudo systemctl daemon-reload",
      "sudo systemctl restart docker",
      "sudo usermod -aG docker vagrant"
    ]
  }
}
```



## 10.7 Exécution

```bash id="d6p9wh"
terraform init
terraform plan
terraform apply
```

Résultat :

* connexion SSH
* installation Docker
* configuration du daemon
* Docker prêt à être utilisé



## 10.8 Intérêt du module

Avant :

* tout dans un seul fichier
* difficile à maintenir
* dépendances floues

Maintenant :

* code isolé
* réutilisable
* structuré



## 10.9 Transmission des variables

Le root :

```hcl id="s7f4lz"
ssh_host = var.ssh_host
```

Le module :

```hcl id="x9m2qc"
variable "ssh_host" {}
```

Terraform transmet les valeurs automatiquement.



## 10.10 Résolution du problème précédent

Grâce au module :

* Docker est installé dans un bloc logique
* possibilité de dépendre du module complet

Exemple :

```hcl id="c4t1kj"
depends_on = [module.docker_install]
```



## 10.11 Bonnes pratiques

* un module = une responsabilité
* séparer root et modules
* utiliser variables.tf
* éviter le code dupliqué
* préparer les modules pour être réutilisables



## 10.12 Résumé

Ce premier module permet de :

* structurer un projet Terraform
* isoler une fonctionnalité (installation Docker)
* préparer les dépendances
* rendre le code maintenable

C’est la base pour construire des architectures Terraform propres et évolutives.







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







# 12 – Docker network

## 12.1 Objectif

Comprendre comment créer et utiliser un réseau Docker avec Terraform.

Ce chapitre permet de :

* créer un réseau Docker
* définir une plage IP
* connecter un conteneur à ce réseau
* récupérer l’adresse IP du conteneur



## 12.2 Création d’un réseau Docker

```hcl id="c4n9yq"
resource "docker_network" "pp_network" {
  name   = "mynet2"
  driver = "bridge"

  ipam_config {
    subnet = "192.168.0.0/24"
  }
}
```



## 12.3 Explication

resource "docker_network" "pp_network"

* Terraform crée et gère une ressource
* type : réseau Docker
* nom interne : pp_network

name = "mynet2"

* nom réel côté Docker

driver = "bridge"

* réseau local au host Docker

ipam_config

* configuration des adresses IP

subnet = "192.168.0.0/24"

* plage d’adresses disponibles
* de 192.168.0.1 à 192.168.0.254



## 12.4 Attacher un conteneur au réseau

```hcl id="z8u1ok"
resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "enginecks"

  networks_advanced {
    name = docker_network.pp_network.name
  }
}
```



## 12.5 Explication

networks_advanced

* permet d’attacher un conteneur à un réseau spécifique

name = docker_network.pp_network.name

* référence au réseau créé précédemment

Résultat :

* le conteneur est connecté au réseau
* il reçoit une IP dans le subnet défini



## 12.6 Récupération de l’IP du conteneur

```hcl id="k2m7wr"
output "ip_container" {
  value = docker_container.nginx.network_data[0].ip_address
}
```



## 12.7 Explication

network_data

* contient les informations réseau du conteneur

ip_address

* adresse IP attribuée dans le réseau Docker



## 12.8 Exemple complet

```hcl id="y7p3sd"
resource "docker_network" "pp_network" {
  name   = "mynet2"
  driver = "bridge"

  ipam_config {
    subnet = "192.168.0.0/24"
  }
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "enginecks"

  networks_advanced {
    name = docker_network.pp_network.name
  }
}

output "ip_container" {
  value = docker_container.nginx.network_data[0].ip_address
}
```



## 12.9 Exécution

```bash id="q1c6fp"
terraform apply
```

Résultat :

* réseau créé
* conteneur lancé
* IP attribuée



## 12.10 Vérification

Sur la machine :

```bash id="m8z2vu"
docker network ls
docker network inspect mynet2
docker ps
```



## 12.11 Résultat attendu

* réseau bridge créé
* conteneur connecté
* IP dans la plage définie



## 12.12 Intérêt

Créer un réseau permet :

* isolation des conteneurs
* communication interne
* gestion des IP
* meilleure organisation



## 12.13 Bonnes pratiques

* éviter le réseau par défaut bridge
* définir explicitement les subnets
* utiliser des réseaux dédiés par projet
* isoler les environnements



## 12.14 Résumé

Ce chapitre permet de :

* créer un réseau Docker avec Terraform
* définir une plage IP
* connecter un conteneur
* récupérer son IP

C’est une base essentielle pour les architectures multi-conteneurs.







# 13 – Docker volumes

## 13.1 Objectif

Comprendre comment gérer les volumes Docker avec Terraform.

Ce chapitre permet de :

* créer un volume Docker
* utiliser un bind mount vers un dossier système
* préparer l’environnement côté machine distante
* comprendre le rôle de null_resource et depends_on



## 13.2 Volume Docker simple

```hcl id="r7p3xm"
resource "docker_volume" "ppvol" {
  name = "myvol"
}
```

Ce volume est géré entièrement par Docker :

* stockage dans /var/lib/docker
* aucune configuration côté système nécessaire



## 13.3 Utilisation dans un conteneur

```hcl id="k4n9tw"
resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "enginecks"

  volumes {
    volume_name    = docker_volume.ppvol.name
    container_path = "/usr/share/nginx/html"
  }
}
```



## 13.4 Limite du volume simple

* stockage interne Docker
* difficilement accessible directement
* pas adapté si besoin d’accès au système hôte



## 13.5 Bind mount (volume avancé)

Objectif : utiliser un dossier du système hôte.

```hcl id="z2m7pd"
resource "docker_volume" "ppvol" {
  name   = "myvol"
  driver = "local"

  driver_opts = {
    type   = "none"
    o      = "bind"
    device = "/srv/data"
  }
}
```



## 13.6 Explication

driver = "local"

* driver standard Docker

driver_opts

* configuration avancée du volume

type = "none"

* type générique utilisé pour les bind mounts

o = "bind"

* indique un montage direct du dossier

device = "/srv/data"

* chemin réel sur la machine

Résultat :

* le volume Docker devient un alias de /srv/data



## 13.7 Problème

Docker ne crée pas le dossier /srv/data automatiquement.

Si le dossier n’existe pas :

* erreur lors de la création du volume
* échec Terraform



## 13.8 Solution avec null_resource

Créer le dossier avant :

```hcl id="w5q8vn"
resource "null_resource" "ssh_target" {

  connection {
    type        = "ssh"
    user        = var.ssh_user
    host        = var.ssh_host
    private_key = file(var.ssh_key)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /srv/data",
      "sudo chmod 777 -R /srv/data"
    ]
  }
}
```



## 13.9 Gestion de la dépendance

```hcl id="u3k1xs"
resource "docker_volume" "ppvol" {
  name   = "myvol"
  driver = "local"

  driver_opts = {
    type   = "none"
    o      = "bind"
    device = "/srv/data"
  }

  depends_on = [null_resource.ssh_target]
}
```

Terraform garantit :

1. création du dossier
2. création du volume
3. création du conteneur



## 13.10 Exemple complet

```hcl id="v8p2cz"
resource "null_resource" "ssh_target" {

  connection {
    type        = "ssh"
    user        = var.ssh_user
    host        = var.ssh_host
    private_key = file(var.ssh_key)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /srv/data",
      "sudo chmod 777 -R /srv/data"
    ]
  }
}

resource "docker_volume" "ppvol" {
  name   = "myvol"
  driver = "local"

  driver_opts = {
    type   = "none"
    o      = "bind"
    device = "/srv/data"
  }

  depends_on = [null_resource.ssh_target]
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "enginecks"

  volumes {
    volume_name    = docker_volume.ppvol.name
    container_path = "/usr/share/nginx/html"
  }
}
```



## 13.11 Pourquoi null_resource est nécessaire

Terraform :

* pilote Docker via API
* ne gère pas le système de fichiers de la VM

Le null_resource permet :

* d’exécuter des commandes OS
* de préparer l’environnement



## 13.12 Alternatives

Approches plus propres :

* cloud-init pour créer les dossiers
* Ansible pour configurer la machine
* images préconfigurées



## 13.13 Sécurité

Éviter :

```bash id="a9k2wd"
chmod 777 -R /srv/data
```

Préférer :

* propriétaire dédié
* permissions limitées (755 ou 775)



## 13.14 Résumé

Ce chapitre permet de :

* comprendre les volumes Docker
* utiliser un bind mount
* gérer les dépendances avec Terraform
* préparer le système avec null_resource

Point clé :

Terraform ne peut pas préparer le système hôte, il faut utiliser un mécanisme externe ou un provisioner.







# 14 – Docker WordPress

## 14.1 Objectif

Déployer une stack WordPress complète via Terraform en utilisant Docker sur une machine distante.

Le projet permet de :

* se connecter à une machine via SSH
* préparer l’environnement (Docker déjà installé)
* créer un réseau Docker
* créer un volume persistant
* déployer MySQL
* déployer WordPress
* exposer l’application



## 14.2 Structure du projet

Répertoire root :

```bash id="f3k8zn"
.
├── main.tf
├── providers.tf
├── terraform.tfvars
├── docker_install/
├── docker_run/
├── docker_wordpress/
```

Le root est le point d’entrée :

* terraform init
* terraform apply



## 14.3 terraform.tfvars

```hcl id="j2n6qc"
ssh_host       = "172.26.14.189"
ssh_user       = "root"
ssh_key        = "/root/.ssh/id_rsa"
wordpress_port = 8080
```

Permet de :

* définir la cible SSH
* définir le port d’exposition



## 14.4 providers.tf (root)

```hcl id="k9w1mz"
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}
```

Permet de :

* définir le provider utilisé
* gérer les dépendances Terraform



## 14.5 main.tf (root)

```hcl id="x8p2vr"
module "docker_install" {
  source   = "./docker_install"
  ssh_host = var.ssh_host
  ssh_user = var.ssh_user
  ssh_key  = var.ssh_key
}

module "docker_wordpress" {
  source         = "./docker_wordpress"
  ssh_host       = var.ssh_host
  ssh_user       = var.ssh_user
  ssh_key        = var.ssh_key
  wordpress_port = var.wordpress_port
}

output "docker_ip_db" {
  value = module.docker_wordpress.docker_ip_db
}

output "docker_ip_wordpress" {
  value = module.docker_wordpress.docker_ip_wordpress
}

output "docker_volume" {
  value = module.docker_wordpress.docker_volume
}
```



## 14.6 Module docker_wordpress

Objectif :

* créer la stack complète
* isoler la logique applicative



### 14.6.1 Variables

```hcl id="t7k3od"
variable "ssh_host" {}
variable "ssh_user" {}
variable "ssh_key" {}
variable "wordpress_port" {}
```



### 14.6.2 Connexion Docker

```hcl id="u2x9bz"
provider "docker" {
  host = "tcp://${var.ssh_host}:2375"
}
```



## 14.7 Préparation du système (volume)

```hcl id="v5m1xs"
resource "null_resource" "prepare_volume" {

  connection {
    type        = "ssh"
    user        = var.ssh_user
    host        = var.ssh_host
    private_key = file(var.ssh_key)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /srv/wordpress",
      "sudo chmod 777 -R /srv/wordpress",
      "sleep 5"
    ]
  }
}
```

Objectif :

* créer le dossier utilisé par le volume
* éviter les erreurs Docker



## 14.8 Volume MySQL

```hcl id="p9z6ne"
resource "docker_volume" "mysql_data" {
  name   = "wordpress_db"
  driver = "local"

  driver_opts = {
    type   = "none"
    o      = "bind"
    device = "/srv/wordpress"
  }

  depends_on = [null_resource.prepare_volume]
}
```



## 14.9 Réseau Docker

```hcl id="k4w8rt"
resource "docker_network" "wordpress_net" {
  name   = "wordpress_net"
  driver = "bridge"
}
```



## 14.10 Conteneur MySQL

```hcl id="m2r7xp"
resource "docker_container" "mysql" {
  name  = "mysql"
  image = "mysql:5.7"

  restart = "always"

  env = [
    "MYSQL_ROOT_PASSWORD=root",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=wordpress"
  ]

  volumes {
    volume_name    = docker_volume.mysql_data.name
    container_path = "/var/lib/mysql"
  }

  networks_advanced {
    name = docker_network.wordpress_net.name
  }
}
```



## 14.11 Conteneur WordPress

```hcl id="n8p3vs"
resource "docker_container" "wordpress" {
  name  = "wordpress"
  image = "wordpress:latest"

  restart = "always"

  env = [
    "WORDPRESS_DB_HOST=mysql:3306",
    "WORDPRESS_DB_USER=wordpress",
    "WORDPRESS_DB_PASSWORD=wordpress",
    "WORDPRESS_DB_NAME=wordpress"
  ]

  ports {
    internal = 80
    external = var.wordpress_port
  }

  networks_advanced {
    name = docker_network.wordpress_net.name
  }
}
```



## 14.12 Outputs

```hcl id="q7l2tk"
output "docker_ip_db" {
  value = try(docker_container.mysql.network_data[0].ip_address, null)
}

output "docker_ip_wordpress" {
  value = try(docker_container.wordpress.network_data[0].ip_address, null)
}

output "docker_volume" {
  value = "/srv/wordpress"
}
```



## 14.13 Exécution

```bash id="z5c1kn"
terraform init
terraform apply
```



## 14.14 Résultat

Accès :

```bash id="r9p6vh"
http://172.26.14.189:8080
```

Résultat :

* WordPress accessible
* base de données connectée
* volume persistant actif



## 14.15 Explication globale

Terraform :

* installe Docker (module docker_install)
* prépare le système
* crée un volume
* crée un réseau
* déploie MySQL
* déploie WordPress



## 14.16 Points importants

* dépendance sur null_resource pour le volume
* communication entre containers via réseau Docker
* utilisation des variables pour configurer l’environnement
* outputs pour récupérer les informations



## 14.17 Limites

* Docker en TCP 2375 non sécurisé
* utilisation de provisioners
* configuration basique (non production)



## 14.18 Résumé

Ce chapitre permet de :

* déployer une stack complète avec Terraform
* comprendre l’interaction entre ressources Docker
* utiliser modules, volumes, réseau et variables

C’est un cas concret complet d’utilisation de Terraform pour provisionner une application.







# 15 – Docker registry image

## 15.1 Objectif

Comprendre comment Terraform gère les images Docker :

* téléchargement depuis un registry
* gestion du cache
* mise à jour des images
* comportement lors des changements



## 15.2 Ressource docker_image

```hcl
resource "docker_image" "nginx" {
  name = "nginx:latest"
}
```

Terraform va :

* vérifier si l’image existe localement
* sinon effectuer un pull depuis le registry Docker Hub



## 15.3 Fonctionnement réel

Lors d’un `terraform apply` :

* si l’image n’existe pas → téléchargement
* si l’image existe → aucune action

Terraform considère que :

* l’état est déjà conforme
* donc aucune modification n’est nécessaire



## 15.4 Problème avec latest

Avec :

```hcl
name = "nginx:latest"
```

Terraform ne va pas :

* vérifier si une nouvelle version existe
* re-pull automatiquement l’image

Résultat :

* image potentiellement obsolète
* drift non détecté



## 15.5 Solution : forcer le pull

```hcl
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}
```

Effet :

* l’image est supprimée localement après usage
* Terraform force un nouveau téléchargement



## 15.6 Alternative : versionner les images

```hcl
resource "docker_image" "nginx" {
  name = "nginx:1.25"
}
```

Avantages :

* reproductibilité
* stabilité
* contrôle des versions



## 15.7 Cas d’usage réel

Image personnalisée :

```hcl
resource "docker_image" "custom" {
  name = "myapp:latest"
}
```

Terraform va :

* utiliser une image locale si présente
* sinon tenter un pull



## 15.8 Limite

Terraform ne build pas automatiquement une image Docker.

Pour construire une image :

* utiliser docker build (externe)
* ou pipeline CI/CD



## 15.9 Mise à jour d’une image

Pour forcer une mise à jour :

```bash
terraform taint docker_image.nginx
terraform apply
```

Terraform :

* détruit la ressource
* recrée l’image



## 15.10 Lien avec docker_container

```hcl
resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
}
```

Terraform garantit :

* l’image existe avant le conteneur



## 15.11 Bonnes pratiques

* éviter latest en production
* versionner les images
* utiliser keep_locally si besoin de refresh
* gérer les builds en dehors de Terraform
* utiliser Terraform uniquement pour le run



## 15.12 Résumé

Terraform gère les images Docker de manière simple :

* pull si nécessaire
* pas de mise à jour automatique
* dépend du state

Point clé :

Terraform ne détecte pas les changements distants d’une image sans action explicite.

Il est recommandé de versionner les images pour garantir des déploiements fiables.







# 16 – Docker SSH triggers

## 16.1 Objectif

Comprendre comment utiliser les triggers avec Terraform pour :

* forcer la recréation d’une ressource
* relancer des provisioners
* gérer les changements dynamiques

Les triggers sont principalement utilisés avec `null_resource`.



## 16.2 Problème

Terraform ne relance pas une ressource si :

* sa configuration ne change pas
* son état est considéré comme valide

Exemple :

```hcl
resource "null_resource" "example" {

  provisioner "local-exec" {
    command = "echo Hello"
  }
}
```

Après un premier apply :

* Terraform ne relance plus cette commande



## 16.3 Solution : triggers

```hcl
resource "null_resource" "example" {

  triggers = {
    value = var.example
  }

  provisioner "local-exec" {
    command = "echo ${var.example}"
  }
}
```

Si `var.example` change :

* Terraform détruit la ressource
* puis la recrée
* relance le provisioner



## 16.4 Fonctionnement

Terraform compare :

* l’ancienne valeur du trigger
* la nouvelle valeur

Si changement :

* recreation de la ressource



## 16.5 Exemple avec SSH

```hcl
resource "null_resource" "ssh_exec" {

  triggers = {
    script_version = var.version
  }

  connection {
    type        = "ssh"
    user        = var.ssh_user
    host        = var.ssh_host
    private_key = file(var.ssh_key)
  }

  provisioner "remote-exec" {
    inline = [
      "echo Version ${var.version}",
      "date"
    ]
  }
}
```



## 16.6 Cas concret

Changer une variable :

```hcl
version = "v1"
```

Puis :

```hcl
version = "v2"
```

Terraform :

* détecte le changement
* détruit null_resource
* relance le script



## 16.7 Utilisation avec Docker

Exemple :

```hcl
resource "null_resource" "docker_restart" {

  triggers = {
    image = docker_image.nginx.name
  }

  provisioner "remote-exec" {
    inline = [
      "docker restart enginecks"
    ]
  }
}
```

Permet :

* redémarrer un conteneur
* si l’image change



## 16.8 Trigger basé sur timestamp

```hcl
triggers = {
  always_run = timestamp()
}
```

Effet :

* la ressource est recréée à chaque apply



## 16.9 Cas d’usage

* relancer un script après modification
* redéployer une application
* synchroniser des fichiers
* forcer une action Terraform



## 16.10 Limites

* non déclaratif
* dépend du contexte
* difficile à maintenir
* peut provoquer des effets de bord



## 16.11 Alternatives

Approche moderne :

* CI/CD pour relancer les actions
* Ansible pour configuration
* Kubernetes pour orchestration



## 16.12 Bonnes pratiques

* utiliser triggers uniquement si nécessaire
* éviter timestamp en production
* documenter les triggers
* garder les scripts simples



## 16.13 Résumé

Les triggers permettent de :

* forcer la recréation d’une ressource
* relancer des provisioners
* gérer les changements dynamiques

Ils sont utiles mais doivent être utilisés avec précaution dans une architecture Terraform propre.







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







# 18 – Kubernetes Introduction

## 18.1 Objectif

Introduire l’utilisation de Kubernetes avec Terraform.

Ce chapitre permet de :

* comprendre le changement de modèle (Docker → Kubernetes)
* utiliser le provider Kubernetes
* déployer des ressources dans un cluster
* comprendre les objets de base



## 18.2 Changement de paradigme

Avec Docker :

* Terraform pilote directement le daemon Docker
* création de conteneurs

Avec Kubernetes :

* Terraform envoie des configurations au cluster
* Kubernetes gère les conteneurs

Terraform ne gère plus directement :

* les conteneurs
* leur cycle de vie

Kubernetes devient l’orchestrateur.



## 18.3 Provider Kubernetes

```hcl
provider "kubernetes" {
  config_path = "~/.kube/config"
}
```

Terraform utilise :

* un fichier kubeconfig
* pour se connecter au cluster



## 18.4 Prérequis

* cluster Kubernetes fonctionnel
* kubectl configuré
* accès au fichier kubeconfig

Test :

```bash
kubectl get nodes
```



## 18.5 Ressource Kubernetes

Terraform permet de créer des objets Kubernetes :

* pods
* services
* deployments
* namespaces



## 18.6 Exemple : Pod simple

```hcl
resource "kubernetes_pod" "nginx" {
  metadata {
    name = "nginx"
    labels = {
      App = "nginx"
    }
  }

  spec {
    container {
      image = "nginx:latest"
      name  = "nginx"

      port {
        container_port = 80
      }
    }
  }
}
```



## 18.7 Explication

metadata

* nom de l’objet
* labels pour l’identification

spec

* description du pod

container

* image utilisée
* nom du conteneur

port

* port exposé



## 18.8 Déploiement

```bash
terraform init
terraform apply
```

Terraform :

* envoie la définition au cluster
* Kubernetes crée le pod



## 18.9 Vérification

```bash
kubectl get pods
```

Résultat :

* pod nginx en cours d’exécution



## 18.10 Différence avec Docker provider

Docker provider :

* création directe de containers
* gestion locale

Kubernetes provider :

* envoi de configuration
* orchestration par Kubernetes



## 18.11 Avantages Kubernetes

* haute disponibilité
* scaling automatique
* auto-healing
* gestion des services



## 18.12 Limites Terraform

Terraform :

* décrit l’état initial
* ne remplace pas Kubernetes

Kubernetes gère :

* redémarrage
* scaling
* scheduling



## 18.13 Bonnes pratiques

* utiliser Terraform pour provisionner
* utiliser Kubernetes pour orchestrer
* éviter de gérer trop finement les pods avec Terraform
* préférer les deployments



## 18.14 Résumé

Ce chapitre introduit :

* le provider Kubernetes
* le changement de logique par rapport à Docker
* la création d’un premier pod

Point clé :

Terraform ne gère plus directement les conteneurs, il délègue à Kubernetes.







# 19 – Kubernetes services et namespaces

## 19.1 Objectif

Comprendre les notions de namespace et de service dans Kubernetes avec Terraform.

Ce chapitre permet de :

* isoler des ressources avec les namespaces
* exposer des applications avec les services
* comprendre la communication entre pods



## 19.2 Namespace

Un namespace permet de séparer logiquement les ressources dans un cluster Kubernetes.

Il permet :

* d’isoler les environnements
* d’organiser les ressources
* de gérer les accès



## 19.3 Création d’un namespace

```hcl id="q2f8nv"
resource "kubernetes_namespace" "example" {
  metadata {
    name = "wordpress"
  }
}
```



## 19.4 Utilisation du namespace

Les ressources doivent être associées :

```hcl id="g7n1px"
metadata {
  name      = "nginx"
  namespace = kubernetes_namespace.example.metadata[0].name
}
```



## 19.5 Service Kubernetes

Un service permet d’exposer un ou plusieurs pods.

Il agit comme :

* un point d’accès réseau
* un load balancer interne



## 19.6 Types de services

* ClusterIP (interne)
* NodePort (exposition via un port du node)
* LoadBalancer (cloud)



## 19.7 Exemple de service

```hcl id="z5m3bc"
resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    selector = {
      App = "nginx"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}
```



## 19.8 Explication

selector

* permet de cibler les pods via leurs labels

port

* port exposé par le service

target_port

* port du conteneur

type = "NodePort"

* expose le service sur un port du node



## 19.9 Lien avec les pods

Le pod doit avoir le même label :

```hcl id="y1k7dj"
labels = {
  App = "nginx"
}
```

Sinon :

* le service ne trouve aucun pod
* aucune communication possible



## 19.10 Exemple complet

```hcl id="c8t4wr"
resource "kubernetes_namespace" "example" {
  metadata {
    name = "wordpress"
  }
}

resource "kubernetes_pod" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.example.metadata[0].name

    labels = {
      App = "nginx"
    }
  }

  spec {
    container {
      image = "nginx:latest"
      name  = "nginx"

      port {
        container_port = 80
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    selector = {
      App = "nginx"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}
```



## 19.11 Exécution

```bash id="m3v8kp"
terraform apply
```



## 19.12 Vérification

```bash id="n9c2qs"
kubectl get namespaces
kubectl get pods -n wordpress
kubectl get services -n wordpress
```



## 19.13 Résultat

* namespace créé
* pod nginx actif
* service exposé

Accès :

* via IP du node
* port NodePort attribué



## 19.14 Communication interne

Dans Kubernetes :

* les pods communiquent via le service
* pas besoin d’IP directe

Exemple :

```text
nginx.wordpress.svc.cluster.local
```



## 19.15 Bonnes pratiques

* utiliser des namespaces par projet
* utiliser des labels cohérents
* utiliser des services pour exposer les pods
* éviter l’accès direct aux pods



## 19.16 Résumé

Ce chapitre introduit :

* les namespaces pour l’isolation
* les services pour l’exposition
* la communication interne Kubernetes

Point clé :

Kubernetes repose sur les labels et les services pour organiser et exposer les applications.







# 20 – Kubernetes Ingress

## 20.1 Objectif

Comprendre comment exposer une application Kubernetes via HTTP en utilisant un Ingress.

Ce chapitre permet de :

* exposer un service via HTTP
* configurer du routing
* éviter l’utilisation de NodePort
* centraliser l’accès aux applications



## 20.2 Limite des services NodePort

Avec NodePort :

* accès via IP + port
* ex : http://IP:30080
* peu lisible
* difficile à maintenir



## 20.3 Ingress

Un Ingress permet de :

* exposer plusieurs services
* utiliser des noms de domaine
* gérer le routage HTTP

Exemple :

* http://app.local → service A
* http://api.local → service B



## 20.4 Prérequis

Un Ingress nécessite :

* un Ingress Controller (nginx, traefik…)
* un cluster configuré

Sans controller :

* l’ingress ne fonctionne pas



## 20.5 Exemple Ingress

```hcl id="g4m9tw"
resource "kubernetes_ingress" "nginx" {
  metadata {
    name      = "nginx-ingress"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    rule {
      host = "nginx.local"

      http {
        path {
          path = "/"

          backend {
            service_name = kubernetes_service.nginx.metadata[0].name
            service_port = 80
          }
        }
      }
    }
  }
}
```



## 20.6 Explication

host

* nom de domaine utilisé

path

* chemin HTTP

backend

* service cible

service_name

* service Kubernetes

service_port

* port du service



## 20.7 Flux complet

Client → Ingress → Service → Pod



## 20.8 Exemple complet

```hcl id="n3p6vx"
resource "kubernetes_namespace" "example" {
  metadata {
    name = "wordpress"
  }
}

resource "kubernetes_pod" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.example.metadata[0].name

    labels = {
      App = "nginx"
    }
  }

  spec {
    container {
      image = "nginx:latest"
      name  = "nginx"

      port {
        container_port = 80
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    selector = {
      App = "nginx"
    }

    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_ingress" "nginx" {
  metadata {
    name      = "nginx-ingress"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    rule {
      host = "nginx.local"

      http {
        path {
          path = "/"

          backend {
            service_name = kubernetes_service.nginx.metadata[0].name
            service_port = 80
          }
        }
      }
    }
  }
}
```



## 20.9 Configuration locale

Ajouter dans /etc/hosts :

```bash id="k1p9vr"
IP_NODE nginx.local
```



## 20.10 Vérification

```bash id="u2w8xn"
kubectl get ingress -n wordpress
```



## 20.11 Résultat

Accès :

```bash id="p4z6ks"
http://nginx.local
```



## 20.12 Avantages

* accès propre via DNS
* routage centralisé
* gestion de plusieurs services
* extensible (TLS, auth…)



## 20.13 Limites

* nécessite un ingress controller
* configuration plus complexe
* dépend de l’environnement



## 20.14 Bonnes pratiques

* utiliser Ingress en production
* éviter NodePort pour exposition externe
* utiliser des noms de domaine
* centraliser le routing



## 20.15 Résumé

Ce chapitre introduit :

* l’Ingress Kubernetes
* l’exposition HTTP propre
* le routing vers les services

Point clé :

L’Ingress permet de transformer un cluster Kubernetes en plateforme web accessible de manière propre et centralisée.







# 21 – Kubernetes WordPress Part 1

## 21.1 Objectif

Commencer le déploiement d’une stack WordPress sur Kubernetes avec Terraform.

Ce chapitre permet de :

* créer un namespace dédié
* déployer la base de données MySQL
* préparer les ressources nécessaires
* comprendre l’architecture globale



## 21.2 Architecture

La stack WordPress repose sur :

* un pod MySQL (base de données)
* un pod WordPress (application)
* un service pour chaque composant



## 21.3 Namespace

```hcl id="w3p7nx"
resource "kubernetes_namespace" "wordpress" {
  metadata {
    name = "wordpress"
  }
}
```

Permet :

* isoler les ressources
* organiser l’environnement



## 21.4 Déploiement MySQL (Pod)

```hcl id="m9z2kt"
resource "kubernetes_pod" "mysql" {
  metadata {
    name      = "mysql"
    namespace = kubernetes_namespace.wordpress.metadata[0].name

    labels = {
      App = "mysql"
    }
  }

  spec {
    container {
      name  = "mysql"
      image = "mysql:5.7"

      env {
        name  = "MYSQL_ROOT_PASSWORD"
        value = "root"
      }

      env {
        name  = "MYSQL_DATABASE"
        value = "wordpress"
      }

      env {
        name  = "MYSQL_USER"
        value = "wordpress"
      }

      env {
        name  = "MYSQL_PASSWORD"
        value = "wordpress"
      }

      port {
        container_port = 3306
      }
    }
  }
}
```



## 21.5 Explication

env

* variables d’environnement pour MySQL

MYSQL_ROOT_PASSWORD

* mot de passe root

MYSQL_DATABASE

* base créée automatiquement

MYSQL_USER / MYSQL_PASSWORD

* utilisateur WordPress



## 21.6 Service MySQL

```hcl id="q2k6vn"
resource "kubernetes_service" "mysql" {
  metadata {
    name      = "mysql"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  spec {
    selector = {
      App = "mysql"
    }

    port {
      port        = 3306
      target_port = 3306
    }
  }
}
```



## 21.7 Explication

Le service permet :

* d’exposer MySQL dans le cluster
* de rendre MySQL accessible via DNS interne

Adresse interne :

```text id="p7w4sm"
mysql.wordpress.svc.cluster.local
```



## 21.8 Déploiement

```bash id="c8n1rx"
terraform apply
```



## 21.9 Vérification

```bash id="k3v9ts"
kubectl get pods -n wordpress
kubectl get services -n wordpress
```



## 21.10 Résultat

* pod MySQL actif
* service MySQL disponible
* base de données prête



## 21.11 Communication interne

WordPress pourra se connecter à MySQL via :

```text id="f5q2md"
mysql:3306
```

Grâce au service Kubernetes.



## 21.12 Limites

* utilisation de pod direct (non recommandé en production)
* pas de persistance (pas de volume)
* configuration simple



## 21.13 Bonnes pratiques

* utiliser des deployments plutôt que des pods
* utiliser des volumes persistants
* externaliser les secrets



## 21.14 Résumé

Ce chapitre permet de :

* créer un namespace
* déployer MySQL
* exposer MySQL via un service

Il pose les bases de la stack WordPress qui sera complétée dans les chapitres suivants.







# 22 – Kubernetes WordPress Part 2

## 22.1 Objectif

Déployer l’application WordPress et la connecter à la base de données MySQL créée précédemment.

Ce chapitre permet de :

* créer le pod WordPress
* configurer la connexion à MySQL
* exposer WordPress via un service



## 22.2 Déploiement WordPress (Pod)

```hcl id="m2v9xt"
resource "kubernetes_pod" "wordpress" {
  metadata {
    name      = "wordpress"
    namespace = kubernetes_namespace.wordpress.metadata[0].name

    labels = {
      App = "wordpress"
    }
  }

  spec {
    container {
      name  = "wordpress"
      image = "wordpress:latest"

      env {
        name  = "WORDPRESS_DB_HOST"
        value = "mysql:3306"
      }

      env {
        name  = "WORDPRESS_DB_USER"
        value = "wordpress"
      }

      env {
        name  = "WORDPRESS_DB_PASSWORD"
        value = "wordpress"
      }

      env {
        name  = "WORDPRESS_DB_NAME"
        value = "wordpress"
      }

      port {
        container_port = 80
      }
    }
  }
}
```



## 22.3 Explication

WORDPRESS_DB_HOST

* nom du service MySQL
* permet la résolution DNS interne

WORDPRESS_DB_USER / PASSWORD

* identifiants de connexion

WORDPRESS_DB_NAME

* base utilisée



## 22.4 Service WordPress

```hcl id="k7p3wr"
resource "kubernetes_service" "wordpress" {
  metadata {
    name      = "wordpress"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  spec {
    selector = {
      App = "wordpress"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}
```



## 22.5 Explication

type = "NodePort"

* expose WordPress via un port du node

Accès :

```text id="n4x8zc"
http://IP_NODE:PORT
```



## 22.6 Déploiement

```bash id="p9k1vs"
terraform apply
```



## 22.7 Vérification

```bash id="x3m7bt"
kubectl get pods -n wordpress
kubectl get services -n wordpress
```



## 22.8 Résultat

* pod WordPress actif
* service exposé
* connexion à MySQL fonctionnelle



## 22.9 Test

Accès :

```text id="z6c2qn"
http://IP_NODE:NodePort
```

Interface WordPress :

* page d’installation visible
* connexion à la base OK



## 22.10 Communication

Flux :

* WordPress → MySQL (service)
* client → WordPress (NodePort)



## 22.11 Limites

* utilisation de NodePort
* pas de persistance des données WordPress
* pas de haute disponibilité



## 22.12 Bonnes pratiques

* utiliser Ingress pour exposition HTTP
* utiliser des volumes persistants
* utiliser des deployments
* externaliser les secrets



## 22.13 Résumé

Ce chapitre permet de :

* déployer WordPress
* connecter WordPress à MySQL
* exposer l’application

La stack est maintenant fonctionnelle mais reste basique et sera améliorée dans les chapitres suivants.







# 23 – Kubernetes WordPress Part 3

## 23.1 Objectif

Ajouter la persistance des données à la stack WordPress.

Ce chapitre permet de :

* comprendre les volumes Kubernetes
* créer un Persistent Volume Claim (PVC)
* attacher un volume à MySQL
* conserver les données après redémarrage



## 23.2 Problème sans volume

Actuellement :

* les données MySQL sont stockées dans le pod
* si le pod est supprimé → données perdues

Cela rend l’application inutilisable en production.



## 23.3 Persistent Volume Claim (PVC)

Un PVC permet de :

* demander un espace de stockage
* abstraire la gestion du stockage



## 23.4 Création du PVC

```hcl id="m5v2xn"
resource "kubernetes_persistent_volume_claim" "mysql" {
  metadata {
    name      = "mysql-pvc"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
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



## 23.5 Explication

access_modes

* ReadWriteOnce : accès en lecture/écriture par un seul node

storage

* taille demandée



## 23.6 Ajout du volume dans MySQL

```hcl id="q8t3wr"
resource "kubernetes_pod" "mysql" {
  metadata {
    name      = "mysql"
    namespace = kubernetes_namespace.wordpress.metadata[0].name

    labels = {
      App = "mysql"
    }
  }

  spec {
    container {
      name  = "mysql"
      image = "mysql:5.7"

      env {
        name  = "MYSQL_ROOT_PASSWORD"
        value = "root"
      }

      port {
        container_port = 3306
      }

      volume_mount {
        mount_path = "/var/lib/mysql"
        name       = "mysql-storage"
      }
    }

    volume {
      name = "mysql-storage"

      persistent_volume_claim {
        claim_name = kubernetes_persistent_volume_claim.mysql.metadata[0].name
      }
    }
  }
}
```



## 23.7 Explication

volume_mount

* point de montage dans le conteneur

volume

* référence au PVC

Résultat :

* MySQL stocke ses données dans le volume
* les données persistent



## 23.8 Déploiement

```bash id="w2p9ks"
terraform apply
```



## 23.9 Vérification

```bash id="v7n4qc"
kubectl get pvc -n wordpress
kubectl describe pvc mysql-pvc -n wordpress
```



## 23.10 Test de persistance

1. créer une base ou des données
2. supprimer le pod :

```bash id="c8m2zx"
kubectl delete pod mysql -n wordpress
```

3. vérifier :

* pod recréé
* données toujours présentes



## 23.11 Limites

* dépend du storage class du cluster
* pas de réplication
* pas adapté à la haute disponibilité



## 23.12 Bonnes pratiques

* utiliser des PVC pour toutes les données critiques
* éviter le stockage éphémère
* utiliser des storage classes adaptées
* prévoir des sauvegardes



## 23.13 Résumé

Ce chapitre permet de :

* ajouter de la persistance à MySQL
* comprendre les volumes Kubernetes
* sécuriser les données

Point clé :

Sans volume, une application Kubernetes n’est pas viable en production.







# 24 – Kubernetes WordPress Part 4

## 24.1 Objectif

Améliorer l’architecture de la stack WordPress en utilisant des Deployments au lieu de Pods.

Ce chapitre permet de :

* remplacer les pods par des deployments
* bénéficier de la gestion automatique des conteneurs
* améliorer la résilience
* préparer une architecture plus proche de la production



## 24.2 Limite des Pods

Dans les chapitres précédents :

* utilisation directe de pods
* pas de redémarrage automatique fiable
* pas de scaling
* pas de gestion d’état

Un pod seul n’est pas adapté en production.



## 24.3 Deployment Kubernetes

Un Deployment permet de :

* gérer plusieurs replicas
* redémarrer automatiquement les pods
* effectuer des mises à jour contrôlées
* garantir un état désiré



## 24.4 Deployment MySQL

```hcl id="m1x7vr"
resource "kubernetes_deployment" "mysql" {
  metadata {
    name      = "mysql"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        App = "mysql"
      }
    }

    template {
      metadata {
        labels = {
          App = "mysql"
        }
      }

      spec {
        container {
          name  = "mysql"
          image = "mysql:5.7"

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "root"
          }

          port {
            container_port = 3306
          }

          volume_mount {
            mount_path = "/var/lib/mysql"
            name       = "mysql-storage"
          }
        }

        volume {
          name = "mysql-storage"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.mysql.metadata[0].name
          }
        }
      }
    }
  }
}
```



## 24.5 Deployment WordPress

```hcl id="k3n8pz"
resource "kubernetes_deployment" "wordpress" {
  metadata {
    name      = "wordpress"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        App = "wordpress"
      }
    }

    template {
      metadata {
        labels = {
          App = "wordpress"
        }
      }

      spec {
        container {
          name  = "wordpress"
          image = "wordpress:latest"

          env {
            name  = "WORDPRESS_DB_HOST"
            value = "mysql:3306"
          }

          env {
            name  = "WORDPRESS_DB_USER"
            value = "wordpress"
          }

          env {
            name  = "WORDPRESS_DB_PASSWORD"
            value = "wordpress"
          }

          env {
            name  = "WORDPRESS_DB_NAME"
            value = "wordpress"
          }

          port {
            container_port = 80
          }
        }
      }
    }
  }
}
```



## 24.6 Services inchangés

Les services restent identiques :

* kubernetes_service.mysql
* kubernetes_service.wordpress

Ils continuent de fonctionner via les labels.



## 24.7 Déploiement

```bash id="n4p2xz"
terraform apply
```



## 24.8 Vérification

```bash id="w7m9qc"
kubectl get deployments -n wordpress
kubectl get pods -n wordpress
```



## 24.9 Résultat

* pods gérés par les deployments
* redémarrage automatique
* meilleure stabilité



## 24.10 Avantages

* auto-healing (redémarrage automatique)
* scaling possible
* gestion des mises à jour
* architecture standard Kubernetes



## 24.11 Scaling

Modifier :

```hcl id="t9k3vb"
replicas = 2
```

Kubernetes :

* crée plusieurs pods
* répartit la charge



## 24.12 Mise à jour

Changer l’image :

```hcl id="x5m7qp"
image = "wordpress:6"
```

Kubernetes :

* déploie progressivement la nouvelle version
* évite l’interruption



## 24.13 Limites

* MySQL reste en instance unique
* pas de haute disponibilité DB
* secrets non sécurisés



## 24.14 Bonnes pratiques

* utiliser deployments pour toutes les apps
* éviter les pods seuls
* séparer base de données et applicatif
* utiliser des secrets pour les credentials



## 24.15 Résumé

Ce chapitre permet de :

* remplacer les pods par des deployments
* améliorer la stabilité
* préparer une architecture production

Point clé :

Les deployments sont le standard pour gérer des applications dans Kubernetes.







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







# 26 – Installation KVM

## 26.1 Objectif

Préparer un environnement de virtualisation KVM pour être utilisé avec Terraform.

Ce chapitre permet de :

* installer KVM et libvirt
* configurer le service
* vérifier le fonctionnement
* préparer l’utilisation du provider libvirt



## 26.2 KVM

KVM (Kernel-based Virtual Machine) permet de :

* créer des machines virtuelles
* utiliser la virtualisation matérielle
* gérer des ressources (CPU, RAM, disque)

KVM fonctionne avec libvirt, qui fournit une API standard.



## 26.3 Installation des paquets

```bash id="w2k8zp"
sudo apt update
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst
```



## 26.4 Démarrage du service

```bash id="r5p1xc"
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
```



## 26.5 Vérification

```bash id="t9n4vx"
systemctl status libvirtd
```



## 26.6 Accès utilisateur

Ajouter l’utilisateur au groupe libvirt :

```bash id="y3m7qs"
sudo usermod -aG libvirt $USER
```

Puis :

```bash id="k1z8wr"
newgrp libvirt
```



## 26.7 Test libvirt

```bash id="v6c2xp"
virsh list --all
```

Résultat attendu :

* connexion au daemon libvirt
* aucune VM (ou liste existante)



## 26.8 Réseau par défaut

```bash id="b4m9nt"
virsh net-list --all
```

Activer si nécessaire :

```bash id="c8p2vd"
virsh net-start default
virsh net-autostart default
```



## 26.9 Image de base

Télécharger une image cloud :

```bash id="n7w1qx"
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
```



## 26.10 Intérêt de cloud-init

Permet de :

* configurer la VM au démarrage
* injecter SSH
* définir hostname
* configurer réseau



## 26.11 Préparation du stockage

Créer un pool libvirt :

```bash id="x5r3kc"
virsh pool-list --all
```

Créer un pool si nécessaire :

```bash id="p9t6vz"
virsh pool-define-as default dir - - - - "/var/lib/libvirt/images"
virsh pool-start default
virsh pool-autostart default
```



## 26.12 Vérification globale

```bash id="m2k7vs"
virsh list --all
virsh net-list --all
virsh pool-list --all
```



## 26.13 Résultat attendu

* libvirt actif
* réseau disponible
* pool de stockage prêt
* image cloud disponible



## 26.14 Lien avec Terraform

Terraform utilisera :

* provider libvirt
* API libvirt
* ressources VM



## 26.15 Bonnes pratiques

* utiliser des images cloud
* éviter les installations manuelles
* automatiser avec cloud-init
* vérifier les permissions libvirt



## 26.16 Résumé

Ce chapitre permet de :

* installer KVM
* configurer libvirt
* préparer l’environnement

C’est la base nécessaire pour créer des machines virtuelles avec Terraform dans les chapitres suivants.







# 27 – Provider KVM première VM

## 27.1 Objectif

Créer une première machine virtuelle avec Terraform en utilisant le provider libvirt (KVM).

Ce chapitre permet de :

* configurer le provider libvirt
* importer une image cloud
* créer un volume disque
* créer une machine virtuelle



## 27.2 Provider libvirt

```hcl id="p3x7kn"
provider "libvirt" {
  uri = "qemu:///system"
}
```

Ce provider permet à Terraform de :

* communiquer avec libvirt
* gérer les ressources KVM



## 27.3 Volume disque

```hcl id="m9v2qx"
resource "libvirt_volume" "ubuntu" {
  name   = "ubuntu.qcow2"
  source = "jammy-server-cloudimg-amd64.img"
  format = "qcow2"
}
```

Terraform va :

* utiliser l’image cloud téléchargée
* créer un disque pour la VM



## 27.4 Création de la VM

```hcl id="k4n8tp"
resource "libvirt_domain" "vm" {
  name   = "vm-01"
  memory = 1024
  vcpu   = 1

  disk {
    volume_id = libvirt_volume.ubuntu.id
  }

  network_interface {
    network_name = "default"
  }
}
```



## 27.5 Explication

name

* nom de la VM

memory

* mémoire en Mo

vcpu

* nombre de CPU

disk

* disque associé à la VM

network_interface

* réseau libvirt utilisé



## 27.6 Exemple complet

```hcl id="t2k6vw"
provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "ubuntu" {
  name   = "ubuntu.qcow2"
  source = "jammy-server-cloudimg-amd64.img"
  format = "qcow2"
}

resource "libvirt_domain" "vm" {
  name   = "vm-01"
  memory = 1024
  vcpu   = 1

  disk {
    volume_id = libvirt_volume.ubuntu.id
  }

  network_interface {
    network_name = "default"
  }
}
```



## 27.7 Exécution

```bash id="w7m3xs"
terraform init
terraform apply
```



## 27.8 Vérification

```bash id="n4v9qp"
virsh list --all
```

Résultat :

* VM créée
* VM en cours d’exécution



## 27.9 Accès à la VM

Sans cloud-init :

* pas d’utilisateur configuré
* pas d’accès SSH

La VM démarre mais n’est pas utilisable directement.



## 27.10 Limite

Cette VM :

* n’a pas de configuration réseau avancée
* n’a pas d’utilisateur
* n’a pas de clé SSH



## 27.11 Étape suivante

Utiliser cloud-init pour :

* créer un utilisateur
* injecter une clé SSH
* configurer la VM



## 27.12 Bonnes pratiques

* utiliser des images cloud
* automatiser la configuration
* éviter les VMs non configurées



## 27.13 Résumé

Ce chapitre permet de :

* créer une VM avec Terraform
* utiliser le provider libvirt
* comprendre la base du provisioning KVM

Point clé :

Une VM sans cloud-init est inutilisable en pratique, la configuration sera ajoutée dans le chapitre suivant.







# 28 – Provider KVM cloud-init

## 28.1 Objectif

Configurer une machine virtuelle KVM avec cloud-init afin de la rendre utilisable automatiquement.

Ce chapitre permet de :

* injecter une clé SSH
* créer un utilisateur
* configurer la VM au démarrage
* automatiser complètement le provisioning



## 28.2 Problème sans cloud-init

Dans le chapitre précédent :

* VM créée
* aucun accès SSH
* aucun utilisateur configuré

La VM est inutilisable sans configuration manuelle.



## 28.3 Cloud-init

Cloud-init permet de :

* exécuter des scripts au démarrage
* configurer la VM automatiquement
* injecter des clés SSH
* définir hostname, user, packages



## 28.4 Fichier user-data

Exemple :

```yaml id="k3m8vn"
#cloud-config

users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, admin
    ssh-authorized-keys:
      - ssh-rsa AAAAB3...

ssh_pwauth: false
disable_root: false
```



## 28.5 Explication

users

* création d’un utilisateur

sudo

* accès administrateur

ssh-authorized-keys

* clé SSH autorisée

ssh_pwauth

* désactivation du mot de passe



## 28.6 Resource cloud-init Terraform

```hcl id="v5n2xp"
resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  user_data = file("user-data")
}
```

Terraform :

* crée une image ISO
* injecte la configuration cloud-init



## 28.7 Mise à jour de la VM

```hcl id="p9k4wr"
resource "libvirt_domain" "vm" {
  name   = "vm-01"
  memory = 1024
  vcpu   = 1

  disk {
    volume_id = libvirt_volume.ubuntu.id
  }

  network_interface {
    network_name = "default"
  }

  cloudinit = libvirt_cloudinit_disk.commoninit.id
}
```



## 28.8 Exemple complet

```hcl id="z7x3mt"
provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "ubuntu" {
  name   = "ubuntu.qcow2"
  source = "jammy-server-cloudimg-amd64.img"
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  user_data = file("user-data")
}

resource "libvirt_domain" "vm" {
  name   = "vm-01"
  memory = 1024
  vcpu   = 1

  disk {
    volume_id = libvirt_volume.ubuntu.id
  }

  network_interface {
    network_name = "default"
  }

  cloudinit = libvirt_cloudinit_disk.commoninit.id
}
```



## 28.9 Exécution

```bash id="q4n8vx"
terraform apply
```



## 28.10 Vérification

Récupérer l’IP :

```bash id="n2k7zp"
virsh domifaddr vm-01
```

Connexion SSH :

```bash id="m6p3xt"
ssh ubuntu@IP_VM
```



## 28.11 Résultat

* utilisateur créé
* clé SSH active
* accès direct à la VM
* configuration automatique



## 28.12 Avantages

* automatisation complète
* reproductibilité
* aucune configuration manuelle
* prêt pour production



## 28.13 Bonnes pratiques

* utiliser cloud-init pour toutes les VMs
* ne jamais configurer à la main
* versionner les fichiers user-data
* sécuriser les clés SSH



## 28.14 Résumé

Ce chapitre permet de :

* rendre une VM utilisable automatiquement
* configurer SSH
* automatiser le provisioning

Point clé :

Cloud-init est indispensable pour exploiter correctement Terraform avec des machines virtuelles.







Chapitre 29 en cours






Chapitre 30 en cours






Chapitre 31 en cours






Chapitre 32 en cours






Chapitre 33 en cours






Chapitre 34 en cours






Chapitre 35 en cours



