![Terraform](../../assets/images/terraform.png)

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
