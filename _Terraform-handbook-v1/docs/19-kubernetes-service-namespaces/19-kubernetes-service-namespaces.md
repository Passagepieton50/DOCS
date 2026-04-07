![Terraform](../../assets/images/terraform.png)

# 19 – Kubernetes services et namespaces

## 19.1 Objectif

Comprendre les notions de namespace et de service dans Kubernetes avec Terraform.

Ce chapitre permet de :

* isoler des ressources avec les namespaces
* exposer des applications avec les services
* comprendre la communication entre pods



## 19.2 Namespace

Un namespace permet de séparer logiquement les ressources dans un cluster Kubernetes.

Il permet :

* d’isoler les environnements
* d’organiser les ressources
* de gérer les accès



## 19.3 Création d’un namespace

```hcl id="q2f8nv"
resource "kubernetes_namespace" "example" {
  metadata {
    name = "wordpress"
  }
}
```



## 19.4 Utilisation du namespace

Les ressources doivent être associées :

```hcl id="g7n1px"
metadata {
  name      = "nginx"
  namespace = kubernetes_namespace.example.metadata[0].name
}
```



## 19.5 Service Kubernetes

Un service permet d’exposer un ou plusieurs pods.

Il agit comme :

* un point d’accès réseau
* un load balancer interne



## 19.6 Types de services

* ClusterIP (interne)
* NodePort (exposition via un port du node)
* LoadBalancer (cloud)



## 19.7 Exemple de service

```hcl id="z5m3bc"
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

    type = "NodePort"
  }
}
```



## 19.8 Explication

selector

* permet de cibler les pods via leurs labels

port

* port exposé par le service

target_port

* port du conteneur

type = "NodePort"

* expose le service sur un port du node



## 19.9 Lien avec les pods

Le pod doit avoir le même label :

```hcl id="y1k7dj"
labels = {
  App = "nginx"
}
```

Sinon :

* le service ne trouve aucun pod
* aucune communication possible



## 19.10 Exemple complet

```hcl id="c8t4wr"
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

    type = "NodePort"
  }
}
```



## 19.11 Exécution

```bash id="m3v8kp"
terraform apply
```



## 19.12 Vérification

```bash id="n9c2qs"
kubectl get namespaces
kubectl get pods -n wordpress
kubectl get services -n wordpress
```



## 19.13 Résultat

* namespace créé
* pod nginx actif
* service exposé

Accès :

* via IP du node
* port NodePort attribué



## 19.14 Communication interne

Dans Kubernetes :

* les pods communiquent via le service
* pas besoin d’IP directe

Exemple :

```text
nginx.wordpress.svc.cluster.local
```



## 19.15 Bonnes pratiques

* utiliser des namespaces par projet
* utiliser des labels cohérents
* utiliser des services pour exposer les pods
* éviter l’accès direct aux pods



## 19.16 Résumé

Ce chapitre introduit :

* les namespaces pour l’isolation
* les services pour l’exposition
* la communication interne Kubernetes

Point clé :

Kubernetes repose sur les labels et les services pour organiser et exposer les applications.
