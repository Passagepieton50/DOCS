![Terraform](../../assets/images/terraform.png)

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
