![Terraform](../../assets/images/terraform.png)

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
