![Terraform](../../assets/images/terraform.png)

# 16 – Docker SSH triggers

## 16.1 Objectif

Comprendre comment utiliser les triggers avec Terraform pour :

* forcer la recréation d’une ressource
* relancer des provisioners
* gérer les changements dynamiques

Les triggers sont principalement utilisés avec `null_resource`.



## 16.2 Problème

Terraform ne relance pas une ressource si :

* sa configuration ne change pas
* son état est considéré comme valide

Exemple :

```hcl
resource "null_resource" "example" {

  provisioner "local-exec" {
    command = "echo Hello"
  }
}
```

Après un premier apply :

* Terraform ne relance plus cette commande



## 16.3 Solution : triggers

```hcl
resource "null_resource" "example" {

  triggers = {
    value = var.example
  }

  provisioner "local-exec" {
    command = "echo ${var.example}"
  }
}
```

Si `var.example` change :

* Terraform détruit la ressource
* puis la recrée
* relance le provisioner



## 16.4 Fonctionnement

Terraform compare :

* l’ancienne valeur du trigger
* la nouvelle valeur

Si changement :

* recreation de la ressource



## 16.5 Exemple avec SSH

```hcl
resource "null_resource" "ssh_exec" {

  triggers = {
    script_version = var.version
  }

  connection {
    type        = "ssh"
    user        = var.ssh_user
    host        = var.ssh_host
    private_key = file(var.ssh_key)
  }

  provisioner "remote-exec" {
    inline = [
      "echo Version ${var.version}",
      "date"
    ]
  }
}
```



## 16.6 Cas concret

Changer une variable :

```hcl
version = "v1"
```

Puis :

```hcl
version = "v2"
```

Terraform :

* détecte le changement
* détruit null_resource
* relance le script



## 16.7 Utilisation avec Docker

Exemple :

```hcl
resource "null_resource" "docker_restart" {

  triggers = {
    image = docker_image.nginx.name
  }

  provisioner "remote-exec" {
    inline = [
      "docker restart enginecks"
    ]
  }
}
```

Permet :

* redémarrer un conteneur
* si l’image change



## 16.8 Trigger basé sur timestamp

```hcl
triggers = {
  always_run = timestamp()
}
```

Effet :

* la ressource est recréée à chaque apply



## 16.9 Cas d’usage

* relancer un script après modification
* redéployer une application
* synchroniser des fichiers
* forcer une action Terraform



## 16.10 Limites

* non déclaratif
* dépend du contexte
* difficile à maintenir
* peut provoquer des effets de bord



## 16.11 Alternatives

Approche moderne :

* CI/CD pour relancer les actions
* Ansible pour configuration
* Kubernetes pour orchestration



## 16.12 Bonnes pratiques

* utiliser triggers uniquement si nécessaire
* éviter timestamp en production
* documenter les triggers
* garder les scripts simples



## 16.13 Résumé

Les triggers permettent de :

* forcer la recréation d’une ressource
* relancer des provisioners
* gérer les changements dynamiques

Ils sont utiles mais doivent être utilisés avec précaution dans une architecture Terraform propre.
