![Terraform](../../assets/images/terraform.png)

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
