![Terraform](../../assets/images/terraform.png)

# 20 – Kubernetes Ingress

## 20.1 Objectif

Comprendre comment exposer une application Kubernetes via HTTP en utilisant un Ingress.

Ce chapitre permet de :

* exposer un service via HTTP
* configurer du routing
* éviter l’utilisation de NodePort
* centraliser l’accès aux applications



## 20.2 Limite des services NodePort

Avec NodePort :

* accès via IP + port
* ex : http://IP:30080
* peu lisible
* difficile à maintenir



## 20.3 Ingress

Un Ingress permet de :

* exposer plusieurs services
* utiliser des noms de domaine
* gérer le routage HTTP

Exemple :

* http://app.local → service A
* http://api.local → service B



## 20.4 Prérequis

Un Ingress nécessite :

* un Ingress Controller (nginx, traefik…)
* un cluster configuré

Sans controller :

* l’ingress ne fonctionne pas



## 20.5 Exemple Ingress

```hcl id="g4m9tw"
resource "kubernetes_ingress" "nginx" {
  metadata {
    name      = "nginx-ingress"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    rule {
      host = "nginx.local"

      http {
        path {
          path = "/"

          backend {
            service_name = kubernetes_service.nginx.metadata[0].name
            service_port = 80
          }
        }
      }
    }
  }
}
```



## 20.6 Explication

host

* nom de domaine utilisé

path

* chemin HTTP

backend

* service cible

service_name

* service Kubernetes

service_port

* port du service



## 20.7 Flux complet

Client → Ingress → Service → Pod



## 20.8 Exemple complet

```hcl id="n3p6vx"
resource "kubernetes_namespace" "example" {
  metadata {
    name = "wordpress"
  }
}

resource "kubernetes_pod" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.example.metadata[0].name

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

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    selector = {
      App = "nginx"
    }

    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_ingress" "nginx" {
  metadata {
    name      = "nginx-ingress"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    rule {
      host = "nginx.local"

      http {
        path {
          path = "/"

          backend {
            service_name = kubernetes_service.nginx.metadata[0].name
            service_port = 80
          }
        }
      }
    }
  }
}
```



## 20.9 Configuration locale

Ajouter dans /etc/hosts :

```bash id="k1p9vr"
IP_NODE nginx.local
```



## 20.10 Vérification

```bash id="u2w8xn"
kubectl get ingress -n wordpress
```



## 20.11 Résultat

Accès :

```bash id="p4z6ks"
http://nginx.local
```



## 20.12 Avantages

* accès propre via DNS
* routage centralisé
* gestion de plusieurs services
* extensible (TLS, auth…)



## 20.13 Limites

* nécessite un ingress controller
* configuration plus complexe
* dépend de l’environnement



## 20.14 Bonnes pratiques

* utiliser Ingress en production
* éviter NodePort pour exposition externe
* utiliser des noms de domaine
* centraliser le routing



## 20.15 Résumé

Ce chapitre introduit :

* l’Ingress Kubernetes
* l’exposition HTTP propre
* le routing vers les services

Point clé :

L’Ingress permet de transformer un cluster Kubernetes en plateforme web accessible de manière propre et centralisée.
