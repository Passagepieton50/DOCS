![Terraform](../../assets/images/terraform.png)

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
