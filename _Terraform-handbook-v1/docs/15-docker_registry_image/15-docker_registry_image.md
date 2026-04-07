![Terraform](../../assets/images/terraform.png)

# 15 – Docker registry image

## 15.1 Objectif

Comprendre comment Terraform gère les images Docker :

* téléchargement depuis un registry
* gestion du cache
* mise à jour des images
* comportement lors des changements



## 15.2 Ressource docker_image

```hcl
resource "docker_image" "nginx" {
  name = "nginx:latest"
}
```

Terraform va :

* vérifier si l’image existe localement
* sinon effectuer un pull depuis le registry Docker Hub



## 15.3 Fonctionnement réel

Lors d’un `terraform apply` :

* si l’image n’existe pas → téléchargement
* si l’image existe → aucune action

Terraform considère que :

* l’état est déjà conforme
* donc aucune modification n’est nécessaire



## 15.4 Problème avec latest

Avec :

```hcl
name = "nginx:latest"
```

Terraform ne va pas :

* vérifier si une nouvelle version existe
* re-pull automatiquement l’image

Résultat :

* image potentiellement obsolète
* drift non détecté



## 15.5 Solution : forcer le pull

```hcl
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}
```

Effet :

* l’image est supprimée localement après usage
* Terraform force un nouveau téléchargement



## 15.6 Alternative : versionner les images

```hcl
resource "docker_image" "nginx" {
  name = "nginx:1.25"
}
```

Avantages :

* reproductibilité
* stabilité
* contrôle des versions



## 15.7 Cas d’usage réel

Image personnalisée :

```hcl
resource "docker_image" "custom" {
  name = "myapp:latest"
}
```

Terraform va :

* utiliser une image locale si présente
* sinon tenter un pull



## 15.8 Limite

Terraform ne build pas automatiquement une image Docker.

Pour construire une image :

* utiliser docker build (externe)
* ou pipeline CI/CD



## 15.9 Mise à jour d’une image

Pour forcer une mise à jour :

```bash
terraform taint docker_image.nginx
terraform apply
```

Terraform :

* détruit la ressource
* recrée l’image



## 15.10 Lien avec docker_container

```hcl
resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
}
```

Terraform garantit :

* l’image existe avant le conteneur



## 15.11 Bonnes pratiques

* éviter latest en production
* versionner les images
* utiliser keep_locally si besoin de refresh
* gérer les builds en dehors de Terraform
* utiliser Terraform uniquement pour le run



## 15.12 Résumé

Terraform gère les images Docker de manière simple :

* pull si nécessaire
* pas de mise à jour automatique
* dépend du state

Point clé :

Terraform ne détecte pas les changements distants d’une image sans action explicite.

Il est recommandé de versionner les images pour garantir des déploiements fiables.
