![Terraform](../../assets/images/terraform.png)

# 06 – Remote exec SSH

## 6.1 Introduction

Le provisioner `remote-exec` permet d’exécuter des commandes directement sur une machine distante via SSH.

Il est utilisé pour :

* installer des services
* configurer une machine
* automatiser des actions après création d’une ressource

Ce mécanisme repose sur une connexion SSH définie dans Terraform.



## 6.2 Principe de fonctionnement

Terraform :

* établit une connexion SSH vers la machine cible
* exécute une liste de commandes
* applique ces actions lors du `terraform apply`

Cela permet de configurer une machine immédiatement après sa création ou indépendamment d’un provider spécifique.



## 6.3 Définition de la connexion SSH

Exemple :

```hcl id="c6u2s2"
connection {
  type        = "ssh"
  user        = var.ssh_user
  host        = var.ssh_host
  private_key = file(var.ssh_key)
}
```

Variables utilisées :

* ssh_host : IP ou hostname de la machine
* ssh_user : utilisateur de connexion
* ssh_key : chemin vers la clé privée

Important :

* les clés SSH doivent être générées au préalable
* adapter selon le système cible



## 6.4 Exemple simple avec remote-exec

```hcl id="j4o1ut"
resource "null_resource" "ssh_target" {

  connection {
    type        = "ssh"
    user        = var.ssh_user
    host        = var.ssh_host
    private_key = file(var.ssh_key)
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Connexion SSH OK'",
      "uname -a"
    ]
  }
}
```



## 6.5 Installation d’un service (exemple nginx)

Objectif : installer nginx sur la machine distante.

```hcl id="hl2z4r"
resource "null_resource" "ssh_target" {

  connection {
    type        = "ssh"
    user        = var.ssh_user
    host        = var.ssh_host
    private_key = file(var.ssh_key)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -qq",
      "sudo apt install -y nginx"
    ]
  }
}
```



## 6.6 Vérification et exécution

Commandes :

```bash id="m9p4w1"
terraform init
terraform plan
terraform apply
```

Terraform va :

* se connecter à la machine
* exécuter les commandes
* installer nginx



## 6.7 Exemple réel (retour d’exécution)

Connexion SSH :

* Host : 172.26.x.x
* User : root
* Private key : utilisée

Logs :

```text id="o3p0s9"
Connecting to remote host via SSH...
Connected!

Mise à jour des référentiels
Installation de nginx
Terminé
```

Résultat :

* nginx installé
* service opérationnel



## 6.8 remote-exec avec plusieurs étapes

Terraform permet d’exécuter plusieurs provisioners :

```hcl id="zn92r1"
provisioner "remote-exec" {
  inline = [
    "sudo apt update",
    "sudo apt install -y nginx"
  ]
}

provisioner "remote-exec" {
  inline = [
    "sudo systemctl enable nginx",
    "sudo systemctl restart nginx"
  ]
}
```



## 6.9 Ajout de commandes système

Exemple :

```hcl id="k91s2x"
inline = [
  "sudo systemctl status nginx",
  "ss -lntp | grep nginx"
]
```

Permet de vérifier que le service écoute correctement.



## 6.10 Bonnes pratiques SSH

* utiliser une clé privée (pas de mot de passe)
* restreindre les accès SSH
* éviter root en production
* vérifier les permissions des clés



## 6.11 Limites de remote-exec

* dépend fortement de l’état de la machine
* non déclaratif
* difficile à maintenir à grande échelle
* fragile en cas d’échec réseau



## 6.12 Alternatives modernes

Dans une approche production :

* cloud-init pour bootstrap VM
* Ansible pour configuration
* images préconfigurées

Terraform doit rester orienté provisioning, pas configuration système.



## 6.13 Résumé

Le provisioner remote-exec permet :

* d’exécuter des commandes sur une machine distante
* de configurer rapidement un environnement
* d’automatiser des tâches via SSH

Il reste utile pour des cas simples ou des environnements de test, mais doit être utilisé avec précaution dans des architectures modernes.
