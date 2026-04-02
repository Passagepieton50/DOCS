![Ansible](../assets/images/ansible.png)
# 01 Ansible - Introductions

Documentation : https://docs.ansible.com/

## 1. Contexte et positionnement d’Ansible

### Ansible : origine et principes fondamentaux

Ansible est un outil d’automatisation open source introduit en 2012, conçu pour simplifier la gestion des infrastructures et des déploiements applicatifs.

Il repose sur plusieurs principes fondamentaux :

* simplicité (syntaxe YAML lisible)
* absence d’agent (agentless)
* exécution via SSH
* approche déclarative
* idempotence

L’objectif est de décrire un état cible et de laisser Ansible appliquer les actions nécessaires pour atteindre cet état.



### Ansible : histoire et positionnement dans l’écosystème DevOps

Ansible a été conçu comme une alternative plus simple aux outils de configuration management tels que Puppet ou Chef, souvent jugés complexes et lourds à maintenir.

Aujourd’hui, Ansible est utilisé dans des contextes variés :

* configuration de serveurs
* déploiement applicatif
* orchestration de tâches
* automatisation opérationnelle

Dans une chaîne DevOps moderne :

* Terraform (ou équivalent) gère le provisioning
* Ansible gère la configuration

Ansible s’intègre donc dans une approche globale d’automatisation des infrastructures.



### Ansible : concept et fonctionnement général

Ansible fonctionne selon un modèle simple :

1. description de l’infrastructure (inventory)
2. définition des actions (playbooks)
3. exécution via un nœud de contrôle

Lors de l’exécution :

* connexion aux machines cibles via SSH
* transfert temporaire des modules
* exécution des tâches
* récupération des résultats

Aucun agent persistant n’est requis sur les machines distantes.



### Présentation d’Ansible et de son modèle d’automatisation

Le modèle d’Ansible repose sur plusieurs composants :

* **Inventory** : liste des hôtes et groupes
* **Playbooks** : orchestration des actions
* **Tasks** : unités d’exécution
* **Modules** : actions techniques
* **Roles** : structuration et réutilisation

Ce modèle permet de construire des automatisations modulaires, maintenables et réutilisables.



### Ansible dans l’Infrastructure as Code

Ansible s’inscrit dans une démarche d’Infrastructure as Code (IaC) :

* les configurations sont versionnées
* les déploiements sont reproductibles
* les changements sont traçables

Contrairement à certains outils, Ansible est **stateless** :

* il ne maintient pas d’état interne
* chaque exécution dépend de l’état réel des systèmes

Cela simplifie l’usage mais nécessite une bonne maîtrise de l’idempotence.



## 2. Fonctionnement et concepts clés d’Ansible

### Architecture et concepts fondamentaux d’Ansible

Une architecture Ansible standard comprend :

* un **control node** (machine d’exécution)
* des **managed nodes** (machines cibles)
* un **inventory** (description de l’infrastructure)

Le control node pilote l’ensemble des opérations et exécute les playbooks.



### Principes de fonctionnement et composants d’Ansible

Le cycle d’exécution d’Ansible est le suivant :

1. lecture de l’inventory
2. sélection des hôtes
3. exécution des tâches
4. collecte des résultats

Les composants principaux sont :

* inventory
* playbooks
* modules
* plugins
* rôles



### Les éléments essentiels d’Ansible : inventory, playbooks et rôles

**Inventory**

* définit les machines et groupes
* permet la gestion des variables

**Playbooks**

* décrivent les actions à exécuter
* orchestrent les opérations

**Rôles**

* structurent le code
* facilitent la réutilisation
* standardisent les déploiements

Ces trois éléments constituent la base de tout projet Ansible.



### Architecture opérationnelle d’Ansible

En environnement professionnel, un projet Ansible est généralement structuré autour de :

* un dépôt Git
* des inventaires par environnement (dev, staging, production)
* des rôles réutilisables
* une exécution via CLI ou CI/CD

Les pipelines permettent :

* l’exécution automatisée
* le contrôle qualité (lint, tests)
* la reproductibilité des déploiements



### Concepts clés et outils de l’écosystème Ansible

L’écosystème Ansible inclut :

* **ansible-core** : moteur principal
* **collections** : distribution de modules et plugins
* **Ansible Galaxy** : partage de rôles et collections
* **ansible-lint** : validation des bonnes pratiques
* **Molecule** : tests de rôles

Ces outils permettent de structurer et industrialiser l’usage d’Ansible.



## 3. Installation et écosystème technique

### Installation et environnement technique d’Ansible

Prérequis :

* Python (version récente)
* accès SSH aux machines cibles
* système Linux ou macOS recommandé pour le control node

Installation recommandée :

```bash
pip install ansible-core
```

Il est conseillé d’utiliser un environnement virtuel Python pour isoler les dépendances.



### Écosystème technique et extensibilité d’Ansible

Ansible est extensible via :

* modules personnalisés
* plugins
* collections

Les collections regroupent :

* modules
* rôles
* plugins

Elles permettent de standardiser les dépendances d’un projet.



### Mise en place d’Ansible et gestion des modules

Les modules sont les briques d’exécution d’Ansible.

Ils permettent de :

* gérer des paquets
* manipuler des fichiers
* configurer des services
* interagir avec des API

Bonne pratique :

* privilégier les modules natifs (`ansible.builtin.*`)
* limiter l’usage de `shell` et `command`



### Installation et intégrations avec l’infrastructure

Ansible s’intègre avec différents environnements :

* cloud (AWS, Azure, GCP)
* virtualisation
* conteneurs
* systèmes CI/CD

Les inventaires peuvent être :

* statiques (fichiers YAML/INI)
* dynamiques (API cloud, scripts)



### Modules et système de templating d’Ansible

Ansible utilise :

* des modules pour exécuter des actions
* Jinja2 pour générer des fichiers dynamiques

Exemple :

```jinja2
server_name {{ inventory_hostname }};
```

Le templating permet :

* d’adapter les configurations
* de factoriser les fichiers
* de gérer les environnements



## Conclusion

Ce chapitre introduit les bases d’Ansible :

* son positionnement dans l’écosystème DevOps
* son modèle d’automatisation
* ses composants principaux
* son fonctionnement général

Ces éléments constituent le socle nécessaire pour aborder les chapitres suivants et construire des automatisations robustes et maintenables.
