![Terraform](../../assets/images/terraform.png)

# 22 – Kubernetes WordPress Part 2

## 22.1 Objectif

Déployer l’application WordPress et la connecter à la base de données MySQL créée précédemment.

Ce chapitre permet de :

* créer le pod WordPress
* configurer la connexion à MySQL
* exposer WordPress via un service



## 22.2 Déploiement WordPress (Pod)

```hcl id="m2v9xt"
resource "kubernetes_pod" "wordpress" {
  metadata {
    name      = "wordpress"
    namespace = kubernetes_namespace.wordpress.metadata[0].name

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
```



## 22.3 Explication

WORDPRESS_DB_HOST

* nom du service MySQL
* permet la résolution DNS interne

WORDPRESS_DB_USER / PASSWORD

* identifiants de connexion

WORDPRESS_DB_NAME

* base utilisée



## 22.4 Service WordPress

```hcl id="k7p3wr"
resource "kubernetes_service" "wordpress" {
  metadata {
    name      = "wordpress"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  spec {
    selector = {
      App = "wordpress"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}
```



## 22.5 Explication

type = "NodePort"

* expose WordPress via un port du node

Accès :

```text id="n4x8zc"
http://IP_NODE:PORT
```



## 22.6 Déploiement

```bash id="p9k1vs"
terraform apply
```



## 22.7 Vérification

```bash id="x3m7bt"
kubectl get pods -n wordpress
kubectl get services -n wordpress
```



## 22.8 Résultat

* pod WordPress actif
* service exposé
* connexion à MySQL fonctionnelle



## 22.9 Test

Accès :

```text id="z6c2qn"
http://IP_NODE:NodePort
```

Interface WordPress :

* page d’installation visible
* connexion à la base OK



## 22.10 Communication

Flux :

* WordPress → MySQL (service)
* client → WordPress (NodePort)



## 22.11 Limites

* utilisation de NodePort
* pas de persistance des données WordPress
* pas de haute disponibilité



## 22.12 Bonnes pratiques

* utiliser Ingress pour exposition HTTP
* utiliser des volumes persistants
* utiliser des deployments
* externaliser les secrets



## 22.13 Résumé

Ce chapitre permet de :

* déployer WordPress
* connecter WordPress à MySQL
* exposer l’application

La stack est maintenant fonctionnelle mais reste basique et sera améliorée dans les chapitres suivants.
