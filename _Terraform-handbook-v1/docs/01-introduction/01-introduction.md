![Terraform](../assets/images/terraform.png) 

# Introduction

Terraform est un outil d’Infrastructure as Code (IaC) permettant de définir, provisionner et maintenir une infrastructure de manière déclarative à l’aide de fichiers de configuration.

Contrairement aux approches impératives, Terraform ne décrit pas les étapes à exécuter mais l’état final attendu de l’infrastructure. À partir de cette définition, il construit un graphe de dépendances, calcule les différences entre l’existant et la cible, puis applique uniquement les changements nécessaires.

Ce modèle permet d’obtenir une infrastructure reproductible, versionnable et cohérente, intégrée dans des workflows modernes de type GitOps et CI/CD.

Terraform s’appuie sur des providers pour interagir avec des APIs externes. Ces providers couvrent un large spectre d’usages :

* cloud public (AWS, Azure, GCP)
* virtualisation (KVM, VMware)
* conteneurs (Docker, Kubernetes)
* services réseau, bases de données et plateformes SaaS

Chaque élément d’infrastructure est décrit sous forme de ressource, gérée selon un cycle de vie complet : création, lecture, modification et suppression.

Un élément central du fonctionnement de Terraform est le state. Ce fichier représente l’état courant de l’infrastructure connue par Terraform et permet d’optimiser les opérations, de détecter les dérives et de garantir la cohérence des déploiements.

Dans un contexte DevOps moderne, Terraform est principalement utilisé pour :

* automatiser la création d’infrastructures
* standardiser les environnements (développement, staging, production)
* versionner les changements d’infrastructure
* faciliter la collaboration entre équipes
* intégrer l’infrastructure dans des pipelines CI/CD

Cette documentation propose une approche progressive et orientée production. Elle couvre les concepts fondamentaux, la structuration via les modules, la gestion du state, ainsi que des cas pratiques autour de Docker, Kubernetes et KVM.

L’objectif est de fournir une compréhension claire du fonctionnement interne de Terraform tout en permettant une mise en pratique immédiate dans des contextes réels.
