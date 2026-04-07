![Terraform](../../assets/images/terraform.png)

# 24 – Kubernetes WordPress Part 4

## 24.1 Objectif

Améliorer l’architecture de la stack WordPress en utilisant des Deployments au lieu de Pods.

Ce chapitre permet de :

* remplacer les pods par des deployments
* bénéficier de la gestion automatique des conteneurs
* améliorer la résilience
* préparer une architecture plus proche de la production



## 24.2 Limite des Pods

Dans les chapitres précédents :

* utilisation directe de pods
* pas de redémarrage automatique fiable
* pas de scaling
* pas de gestion d’état

Un pod seul n’est pas adapté en production.



## 24.3 Deployment Kubernetes

Un Deployment permet de :

* gérer plusieurs replicas
* redémarrer automatiquement les pods
* effectuer des mises à jour contrôlées
* garantir un état désiré



## 24.4 Deployment MySQL

```hcl id="m1x7vr"
resource "kubernetes_deployment" "mysql" {
  metadata {
    name      = "mysql"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        App = "mysql"
      }
    }

    template {
      metadata {
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

          port {
            container_port = 3306
          }

          volume_mount {
            mount_path = "/var/lib/mysql"
            name       = "mysql-storage"
          }
        }

        volume {
          name = "mysql-storage"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.mysql.metadata[0].name
          }
        }
      }
    }
  }
}
```



## 24.5 Deployment WordPress

```hcl id="k3n8pz"
resource "kubernetes_deployment" "wordpress" {
  metadata {
    name      = "wordpress"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        App = "wordpress"
      }
    }

    template {
      metadata {
        labels = {
          App = "wordpress"
        }
      }

      spec {
        container {
          name  = "wordpress"
          image = "wordpress:latest"

          env {
            name  = "WORDPRESS_DB_HOST"
            value = "mysql:3306"
          }

          env {
            name  = "WORDPRESS_DB_USER"
            value = "wordpress"
          }

          env {
            name  = "WORDPRESS_DB_PASSWORD"
            value = "wordpress"
          }

          env {
            name  = "WORDPRESS_DB_NAME"
            value = "wordpress"
          }

          port {
            container_port = 80
          }
        }
      }
    }
  }
}
```



## 24.6 Services inchangés

Les services restent identiques :

* kubernetes_service.mysql
* kubernetes_service.wordpress

Ils continuent de fonctionner via les labels.



## 24.7 Déploiement

```bash id="n4p2xz"
terraform apply
```



## 24.8 Vérification

```bash id="w7m9qc"
kubectl get deployments -n wordpress
kubectl get pods -n wordpress
```



## 24.9 Résultat

* pods gérés par les deployments
* redémarrage automatique
* meilleure stabilité



## 24.10 Avantages

* auto-healing (redémarrage automatique)
* scaling possible
* gestion des mises à jour
* architecture standard Kubernetes



## 24.11 Scaling

Modifier :

```hcl id="t9k3vb"
replicas = 2
```

Kubernetes :

* crée plusieurs pods
* répartit la charge



## 24.12 Mise à jour

Changer l’image :

```hcl id="x5m7qp"
image = "wordpress:6"
```

Kubernetes :

* déploie progressivement la nouvelle version
* évite l’interruption



## 24.13 Limites

* MySQL reste en instance unique
* pas de haute disponibilité DB
* secrets non sécurisés



## 24.14 Bonnes pratiques

* utiliser deployments pour toutes les apps
* éviter les pods seuls
* séparer base de données et applicatif
* utiliser des secrets pour les credentials



## 24.15 Résumé

Ce chapitre permet de :

* remplacer les pods par des deployments
* améliorer la stabilité
* préparer une architecture production

Point clé :

Les deployments sont le standard pour gérer des applications dans Kubernetes.
