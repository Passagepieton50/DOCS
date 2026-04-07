![Terraform](../assets/images/terraform.png) 

# 02 – Installation

## 2.1 Prérequis

Terraform est un binaire autonome écrit en Go. Il ne nécessite pas de dépendances spécifiques côté système, hormis un environnement capable d’exécuter des commandes shell.

Prérequis recommandés :

* système Linux, macOS ou Windows
* accès réseau pour télécharger les providers
* droits suffisants pour installer un binaire
* accès à une plateforme cible (cloud, VM, Docker, etc.)

---

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

---

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

---

### macOS (Homebrew)

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

---

### Windows (Chocolatey)

```powershell
choco install terraform
```

---

## 2.3 Vérification de l’installation

```bash
terraform version
```

La commande doit afficher la version installée ainsi que les informations sur l’architecture.

---

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

---

## 2.5 Initialisation d’un projet

Avant toute exécution, Terraform doit être initialisé :

```bash
terraform init
```

Cette commande :

* télécharge les providers nécessaires
* initialise le backend (local ou distant)
* prépare le répertoire `.terraform/`

---

## 2.6 Cycle de travail initial

Terraform suit un cycle standard :

```bash
terraform fmt       # formatage du code
terraform validate  # validation syntaxique
terraform plan      # aperçu des changements
terraform apply     # application des changements
```

---

## 2.7 Fichiers générés

Après initialisation et exécution :

* `.terraform/` : plugins et dépendances
* `terraform.tfstate` : état courant
* `terraform.tfstate.backup` : sauvegarde

Ces fichiers ne doivent pas être versionnés (sauf backend distant configuré).

---

## 2.8 Bonnes pratiques (2026)

* privilégier l’installation via gestionnaire de paquets
* utiliser une version verrouillée (ex : via `.terraform.lock.hcl`)
* ne jamais committer les fichiers de state
* isoler les projets Terraform par répertoire
* initialiser systématiquement avec `terraform init`
* utiliser des environnements reproductibles (containers, CI)

---

## 2.9 Remarques

Terraform ne nécessite pas d’installation côté machine cible. Toutes les opérations passent par des APIs via les providers.

Cela permet d’exécuter Terraform depuis :

* un poste local
* un runner CI/CD
* un environnement distant

Le binaire Terraform agit uniquement comme orchestrateur.
