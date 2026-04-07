![Terraform](../../assets/images/terraform.png)

# 23 – Kubernetes WordPress Part 3

## 23.1 Objectif

Ajouter la persistance des données à la stack WordPress.

Ce chapitre permet de :

* comprendre les volumes Kubernetes
* créer un Persistent Volume Claim (PVC)
* attacher un volume à MySQL
* conserver les données après redémarrage



## 23.2 Problème sans volume

Actuellement :

* les données MySQL sont stockées dans le pod
* si le pod est supprimé → données perdues

Cela rend l’application inutilisable en production.



## 23.3 Persistent Volume Claim (PVC)

Un PVC permet de :

* demander un espace de stockage
* abstraire la gestion du stockage



## 23.4 Création du PVC

```hcl id="m5v2xn"
resource "kubernetes_persistent_volume_claim" "mysql" {
  metadata {
    name      = "mysql-pvc"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}
```



## 23.5 Explication

access_modes

* ReadWriteOnce : accès en lecture/écriture par un seul node

storage

* taille demandée



## 23.6 Ajout du volume dans MySQL

```hcl id="q8t3wr"
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
```



## 23.7 Explication

volume_mount

* point de montage dans le conteneur

volume

* référence au PVC

Résultat :

* MySQL stocke ses données dans le volume
* les données persistent



## 23.8 Déploiement

```bash id="w2p9ks"
terraform apply
```



## 23.9 Vérification

```bash id="v7n4qc"
kubectl get pvc -n wordpress
kubectl describe pvc mysql-pvc -n wordpress
```



## 23.10 Test de persistance

1. créer une base ou des données
2. supprimer le pod :

```bash id="c8m2zx"
kubectl delete pod mysql -n wordpress
```

3. vérifier :

* pod recréé
* données toujours présentes



## 23.11 Limites

* dépend du storage class du cluster
* pas de réplication
* pas adapté à la haute disponibilité



## 23.12 Bonnes pratiques

* utiliser des PVC pour toutes les données critiques
* éviter le stockage éphémère
* utiliser des storage classes adaptées
* prévoir des sauvegardes



## 23.13 Résumé

Ce chapitre permet de :

* ajouter de la persistance à MySQL
* comprendre les volumes Kubernetes
* sécuriser les données

Point clé :

Sans volume, une application Kubernetes n’est pas viable en production.
