![Terraform](../../assets/images/terraform.png)

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
