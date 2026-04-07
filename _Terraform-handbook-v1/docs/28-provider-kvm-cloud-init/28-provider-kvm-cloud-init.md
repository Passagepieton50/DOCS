![Terraform](../../assets/images/terraform.png)

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
