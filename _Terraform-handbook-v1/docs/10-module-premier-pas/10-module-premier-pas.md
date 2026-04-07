![Terraform](../../assets/images/terraform.png)

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
