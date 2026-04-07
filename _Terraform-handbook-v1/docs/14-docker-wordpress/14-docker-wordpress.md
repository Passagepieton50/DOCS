![Terraform](../../assets/images/terraform.png)

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
