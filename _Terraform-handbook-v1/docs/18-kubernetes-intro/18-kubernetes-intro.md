![Terraform](../../assets/images/terraform.png)

# 18 – Kubernetes Introduction

## 18.1 Objectif

Introduire l’utilisation de Kubernetes avec Terraform.

Ce chapitre permet de :

* comprendre le changement de modèle (Docker → Kubernetes)
* utiliser le provider Kubernetes
* déployer des ressources dans un cluster
* comprendre les objets de base



## 18.2 Changement de paradigme

Avec Docker :

* Terraform pilote directement le daemon Docker
* création de conteneurs

Avec Kubernetes :

* Terraform envoie des configurations au cluster
* Kubernetes gère les conteneurs

Terraform ne gère plus directement :

* les conteneurs
* leur cycle de vie

Kubernetes devient l’orchestrateur.



## 18.3 Provider Kubernetes

```hcl
provider "kubernetes" {
  config_path = "~/.kube/config"
}
```

Terraform utilise :

* un fichier kubeconfig
* pour se connecter au cluster



## 18.4 Prérequis

* cluster Kubernetes fonctionnel
* kubectl configuré
* accès au fichier kubeconfig

Test :

```bash
kubectl get nodes
```



## 18.5 Ressource Kubernetes

Terraform permet de créer des objets Kubernetes :

* pods
* services
* deployments
* namespaces



## 18.6 Exemple : Pod simple

```hcl
resource "kubernetes_pod" "nginx" {
  metadata {
    name = "nginx"
    labels = {
      App = "nginx"
    }
  }

  spec {
    container {
      image = "nginx:latest"
      name  = "nginx"

      port {
        container_port = 80
      }
    }
  }
}
```



## 18.7 Explication

metadata

* nom de l’objet
* labels pour l’identification

spec

* description du pod

container

* image utilisée
* nom du conteneur

port

* port exposé



## 18.8 Déploiement

```bash
terraform init
terraform apply
```

Terraform :

* envoie la définition au cluster
* Kubernetes crée le pod



## 18.9 Vérification

```bash
kubectl get pods
```

Résultat :

* pod nginx en cours d’exécution



## 18.10 Différence avec Docker provider

Docker provider :

* création directe de containers
* gestion locale

Kubernetes provider :

* envoi de configuration
* orchestration par Kubernetes



## 18.11 Avantages Kubernetes

* haute disponibilité
* scaling automatique
* auto-healing
* gestion des services



## 18.12 Limites Terraform

Terraform :

* décrit l’état initial
* ne remplace pas Kubernetes

Kubernetes gère :

* redémarrage
* scaling
* scheduling



## 18.13 Bonnes pratiques

* utiliser Terraform pour provisionner
* utiliser Kubernetes pour orchestrer
* éviter de gérer trop finement les pods avec Terraform
* préférer les deployments



## 18.14 Résumé

Ce chapitre introduit :

* le provider Kubernetes
* le changement de logique par rapport à Docker
* la création d’un premier pod

Point clé :

Terraform ne gère plus directement les conteneurs, il délègue à Kubernetes.
