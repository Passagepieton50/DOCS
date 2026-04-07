![Terraform](../../assets/images/terraform.png)

# 21 – Kubernetes WordPress Part 1

## 21.1 Objectif

Commencer le déploiement d’une stack WordPress sur Kubernetes avec Terraform.

Ce chapitre permet de :

* créer un namespace dédié
* déployer la base de données MySQL
* préparer les ressources nécessaires
* comprendre l’architecture globale



## 21.2 Architecture

La stack WordPress repose sur :

* un pod MySQL (base de données)
* un pod WordPress (application)
* un service pour chaque composant



## 21.3 Namespace

```hcl id="w3p7nx"
resource "kubernetes_namespace" "wordpress" {
  metadata {
    name = "wordpress"
  }
}
```

Permet :

* isoler les ressources
* organiser l’environnement



## 21.4 Déploiement MySQL (Pod)

```hcl id="m9z2kt"
resource "kubernetes_pod" "mysql" {
  metadata {
    name      = "mysql"
    namespace = kubernetes_namespace.wordpress.metadata[0].name

    labels = {
      App = "mysql"
    }
  }

  spec {
    container {
      name  = "mysql"
      image = "mysql:5.7"

      env {
        name  = "MYSQL_ROOT_PASSWORD"
        value = "root"
      }

      env {
        name  = "MYSQL_DATABASE"
        value = "wordpress"
      }

      env {
        name  = "MYSQL_USER"
        value = "wordpress"
      }

      env {
        name  = "MYSQL_PASSWORD"
        value = "wordpress"
      }

      port {
        container_port = 3306
      }
    }
  }
}
```



## 21.5 Explication

env

* variables d’environnement pour MySQL

MYSQL_ROOT_PASSWORD

* mot de passe root

MYSQL_DATABASE

* base créée automatiquement

MYSQL_USER / MYSQL_PASSWORD

* utilisateur WordPress



## 21.6 Service MySQL

```hcl id="q2k6vn"
resource "kubernetes_service" "mysql" {
  metadata {
    name      = "mysql"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  spec {
    selector = {
      App = "mysql"
    }

    port {
      port        = 3306
      target_port = 3306
    }
  }
}
```



## 21.7 Explication

Le service permet :

* d’exposer MySQL dans le cluster
* de rendre MySQL accessible via DNS interne

Adresse interne :

```text id="p7w4sm"
mysql.wordpress.svc.cluster.local
```



## 21.8 Déploiement

```bash id="c8n1rx"
terraform apply
```



## 21.9 Vérification

```bash id="k3v9ts"
kubectl get pods -n wordpress
kubectl get services -n wordpress
```



## 21.10 Résultat

* pod MySQL actif
* service MySQL disponible
* base de données prête



## 21.11 Communication interne

WordPress pourra se connecter à MySQL via :

```text id="f5q2md"
mysql:3306
```

Grâce au service Kubernetes.



## 21.12 Limites

* utilisation de pod direct (non recommandé en production)
* pas de persistance (pas de volume)
* configuration simple



## 21.13 Bonnes pratiques

* utiliser des deployments plutôt que des pods
* utiliser des volumes persistants
* externaliser les secrets



## 21.14 Résumé

Ce chapitre permet de :

* créer un namespace
* déployer MySQL
* exposer MySQL via un service

Il pose les bases de la stack WordPress qui sera complétée dans les chapitres suivants.
