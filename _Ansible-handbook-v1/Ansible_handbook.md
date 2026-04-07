# Ansible Handbook

---
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


---

# 02 Ansible - Notions & Bonnes pratiques



## 1. Principes fondamentaux d’Ansible

### Idempotence et gestion de l’état

L’idempotence est un principe central d’Ansible.

Une tâche idempotente garantit que :

* l’état final est atteint sans effets de bord
* plusieurs exécutions successives produisent le même résultat

Exemple :

```yaml
- name: Installer nginx
  ansible.builtin.apt:
    name: nginx
    state: present
```

Si nginx est déjà installé, aucune modification n’est effectuée.

Implications :

* sécurité en production
* automatisation fiable
* possibilité de relancer sans risque



### Approche déclarative vs impérative

Ansible privilégie une approche déclarative :

* on décrit l’état cible
* pas les étapes détaillées

Déclaratif :

```yaml
- name: Installer nginx
  ansible.builtin.apt:
    name: nginx
    state: present
```

Impératif (à éviter) :

```yaml
- name: Installer nginx
  ansible.builtin.command: apt install -y nginx
```

Bonne pratique :

* privilégier les modules natifs
* éviter `shell` et `command` sauf cas spécifique



### Simplicité et lisibilité du code

Un playbook doit être :

* lisible
* explicite
* compréhensible rapidement

Bonnes pratiques :

* noms de tâches explicites
* indentation claire
* structure cohérente
* éviter la complexité inutile

Exemple :

```yaml
- name: Créer un utilisateur applicatif
  ansible.builtin.user:
    name: appuser
    state: present
```



## 2. Organisation d’un projet Ansible

### Structure recommandée

Un projet Ansible doit être structuré pour être maintenable.

Exemple :

```bash
project/
├── inventory/
├── group_vars/
├── host_vars/
├── roles/
├── playbooks/
└── ansible.cfg
```

Objectifs :

* séparation des responsabilités
* réutilisabilité
* lisibilité



### Utilisation des rôles

Les rôles permettent de structurer le code.

Un rôle contient :

* tasks
* handlers
* templates
* variables
* fichiers

Avantages :

* modularité
* réutilisation
* standardisation



### Séparation des environnements

Il est recommandé de séparer les environnements :

* dev
* staging
* production

Exemple :

```bash
inventory/
├── dev/
├── staging/
└── prod/
```

Cela permet :

* d’éviter les erreurs de déploiement
* de tester avant production
* d’isoler les configurations



## 3. Gestion des variables

### Hiérarchie des variables

Ansible possède un système de priorité des variables.

Exemples de sources :

* defaults (rôles)
* group_vars
* host_vars
* variables de playbook
* extra vars (`-e`)

Bonne pratique :

* centraliser les variables
* éviter les redéfinitions inutiles



### Bon usage des variables

Bonnes pratiques :

* noms explicites
* cohérence de nommage
* éviter les valeurs en dur

Exemple :

```yaml
nginx_port: 80
```



### Sécurité des variables

Les données sensibles doivent être protégées.

Utiliser :

* **ansible-vault**

Exemple :

```bash
ansible-vault encrypt secrets.yml
```



## 4. Bonnes pratiques d’écriture

### Nommage des tâches

Chaque tâche doit avoir un nom clair :

```yaml
- name: Installer les paquets système requis
```

Cela permet :

* debugging plus simple
* logs lisibles



### Découpage des playbooks

Éviter les playbooks monolithiques.

Préférer :

* rôles
* includes
* organisation modulaire



### Utilisation des handlers

Les handlers permettent d’exécuter des actions uniquement si nécessaire.

Exemple :

```yaml
- name: Redémarrer nginx
  ansible.builtin.service:
    name: nginx
    state: restarted
```

Déclenché uniquement si une tâche change un état.



## 5. Performance et optimisation

### Limiter les tâches inutiles

Utiliser :

* `when`
* `changed_when`
* `failed_when`



### Désactiver gather_facts si inutile

```yaml
gather_facts: false
```

Permet d’accélérer l’exécution.



### Exécution parallèle

Ansible exécute les tâches en parallèle.

Paramètre :

```ini
forks = 10
```

Bonne pratique :

* ajuster selon l’infrastructure



## 6. Tests et validation

### Vérification syntaxique

```bash
ansible-playbook playbook.yml --syntax-check
```



### Mode dry-run

```bash
ansible-playbook playbook.yml --check
```

Permet de simuler l’exécution.



### Linting

Utiliser :

```bash
ansible-lint
```

Permet de détecter :

* mauvaises pratiques
* erreurs potentielles



## 7. Anti-patterns à éviter

* utilisation excessive de `shell` et `command`
* playbooks trop longs
* variables en dur
* absence de rôles
* duplication de code
* absence de tests
* mélange des environnements



## Conclusion

Les bonnes pratiques Ansible permettent :

* une meilleure maintenabilité
* une réduction des erreurs
* une automatisation fiable
* une meilleure lisibilité du code

Un projet bien structuré est essentiel pour une utilisation en production et une intégration dans un environnement DevOps.


---

# 03 Ansible - Installations

Documentation : 

https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

https://releases.ansible.com/ansible/

https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#ansible-python-interpreter


## 1. Installation et environnement technique d’Ansible

### Prérequis

Avant d’installer Ansible, plusieurs éléments sont nécessaires :

* Python (version 3.9 ou supérieure recommandée)
* accès SSH aux machines cibles
* système Linux ou macOS pour le control node (Windows possible via WSL)

Sur les machines cibles :

* Python doit être présent (souvent installé par défaut sur Linux)



### Installation d’Ansible

Méthode recommandée (2026) : installation via `pip` avec environnement virtuel.

Création d’un environnement :

```bash id="f7c2x1"
python3 -m venv venv
source venv/bin/activate
```

Installation :

```bash id="p9a4kl"
pip install ansible-core
```

Vérification :

```bash id="u3m8zp"
ansible --version
```



### Alternative via gestionnaire de paquets

Installation possible via APT :

```bash id="d4n8ws"
sudo apt update
sudo apt install ansible
```

Limites :

* version souvent en retard
* moins flexible que `pip`



### Bonnes pratiques d’installation

* utiliser un environnement virtuel Python
* versionner les dépendances (`requirements.txt`)
* éviter les installations globales
* standardiser la version d’Ansible dans l’équipe



## 2. Configuration de l’environnement Ansible

### Fichier de configuration `ansible.cfg`

Ansible utilise un fichier de configuration pour définir son comportement.

Ordre de priorité :

1. variable d’environnement `ANSIBLE_CONFIG`
2. fichier local `./ansible.cfg`
3. `~/.ansible.cfg`
4. `/etc/ansible/ansible.cfg`

Exemple minimal :

```ini id="s7n2fk"
[defaults]
inventory = ./inventory
remote_user = ubuntu
host_key_checking = False
retry_files_enabled = False
```



### Configuration SSH

Ansible utilise SSH pour communiquer avec les machines.

Bonne pratique :

* utiliser des clés SSH
* éviter les mots de passe

Génération de clé :

```bash id="v6k9qz"
ssh-keygen -t ed25519
```

Copie de la clé :

```bash id="c2j7lx"
ssh-copy-id user@host
```



### Test de connectivité

Commande simple :

```bash id="k1r9xm"
ansible all -m ping
```

Permet de vérifier :

* connectivité réseau
* accès SSH
* fonctionnement d’Ansible



## 3. Gestion des modules et collections

### Modules Ansible

Les modules sont les unités d’exécution.

Exemples :

* gestion de paquets (`apt`, `yum`)
* fichiers (`copy`, `template`)
* services (`systemd`)

Bonne pratique :

* utiliser les modules officiels
* éviter les commandes shell



### Collections

Les collections regroupent :

* modules
* plugins
* rôles

Installation :

```bash id="y9l2qp"
ansible-galaxy collection install community.general
```

Bonne pratique :

* déclarer les collections dans un fichier `requirements.yml`

Exemple :

```yaml id="o2x6ct"
collections:
  - name: community.general
```

Installation :

```bash id="l8f3rm"
ansible-galaxy collection install -r requirements.yml
```



### ansible-core vs ansible

* **ansible-core** : moteur minimal
* **ansible** : package complet avec collections incluses

Bonne pratique :

* utiliser `ansible-core`
* gérer les dépendances explicitement



## 4. Mise en place d’un environnement de travail

### Structure initiale

Exemple minimal :

```bash id="t4w8ds"
project/
├── inventory/
├── playbook.yml
├── ansible.cfg
└── requirements.yml
```



### Exemple d’inventory

```yaml id="b7n3qe"
all:
  hosts:
    node1:
      ansible_host: 192.168.1.10
```



### Exemple de playbook

```yaml id="z1k8hf"
- name: Test Ansible
  hosts: all
  tasks:
    - name: Ping
      ansible.builtin.ping:
```

Exécution :

```bash id="r5p2mv"
ansible-playbook playbook.yml
```



## 5. Intégration avec l’infrastructure

### Environnements cloud

Ansible peut s’intégrer avec :

* AWS
* Azure
* GCP

Via :

* modules dédiés
* inventaires dynamiques



### Intégration CI/CD

Ansible peut être exécuté dans :

* GitLab CI
* GitHub Actions
* Jenkins

Utilisations :

* déploiement automatisé
* configuration post-provisioning
* orchestration



### Environnement de développement

Pour tester localement :

* utiliser Docker
* utiliser des machines virtuelles
* utiliser Vagrant

Objectif :

* reproduire un environnement proche de la production



## 6. Bonnes pratiques d’installation et d’environnement

* isoler l’environnement (virtualenv)
* versionner les dépendances
* standardiser la configuration (`ansible.cfg`)
* utiliser des clés SSH
* tester la connectivité avant exécution
* séparer les environnements



## 7. Erreurs fréquentes

* installation globale non maîtrisée
* versions différentes entre équipes
* absence de configuration `ansible.cfg`
* mauvaise gestion des clés SSH
* dépendances non versionnées



## Conclusion

Une installation maîtrisée d’Ansible est essentielle pour :

* garantir la reproductibilité
* éviter les erreurs d’environnement
* faciliter la collaboration
* assurer une exécution fiable

Un environnement propre et standardisé est une base indispensable avant d’aller plus loin dans l’automatisation.


---

# 04 Ansible - SSH



## 1. Fonctionnement SSH dans Ansible

### Utilisation de SSH par Ansible

Ansible utilise SSH comme mécanisme principal pour communiquer avec les machines distantes.

Lors de l’exécution :

* connexion SSH au serveur cible
* transfert temporaire du module
* exécution de la tâche
* récupération du résultat

Aucune installation d’agent n’est nécessaire sur les machines distantes.



### Avantages du modèle SSH

* pas d’agent à maintenir
* sécurité basée sur SSH
* intégration native avec les systèmes Linux
* facilité de mise en place



### Prérequis côté cible

Les machines doivent :

* être accessibles en SSH
* disposer de Python (sauf cas spécifiques)
* avoir un utilisateur avec les droits nécessaires



## 2. Authentification SSH

### Authentification par clé (recommandée)

Ansible fonctionne idéalement avec des clés SSH.

Génération :

```bash
ssh-keygen -t ed25519
```

Copie vers la machine cible :

```bash
ssh-copy-id user@host
```



### Configuration dans l’inventory

```yaml
all:
  hosts:
    node1:
      ansible_host: 192.168.1.10
      ansible_user: ubuntu
      ansible_ssh_private_key_file: ~/.ssh/id_ed25519
```



### Authentification par mot de passe (non recommandée)

Possible via :

```bash
ansible all -m ping --ask-pass
```

Limites :

* moins sécurisé
* difficile à automatiser
* non adapté CI/CD



## 3. Gestion des accès et élévation de privilèges

### Utilisation de become (sudo)

Ansible permet d’exécuter des commandes avec élévation de privilèges.

Exemple :

```yaml
- name: Installer nginx
  hosts: all
  become: true
  tasks:
    - name: Installer nginx
      ansible.builtin.apt:
        name: nginx
        state: present
```



### Configuration de become

Dans l’inventory :

```yaml
ansible_become: true
ansible_become_method: sudo
ansible_become_user: root
```



### Gestion du mot de passe sudo

```bash
ansible-playbook playbook.yml --ask-become-pass
```

Bonne pratique :

* privilégier sudo sans mot de passe pour automatisation



## 4. Configuration SSH avancée

### Fichier ~/.ssh/config

Permet de simplifier les connexions.

Exemple :

```sshconfig
Host node1
    HostName 192.168.1.10
    User ubuntu
    IdentityFile ~/.ssh/id_ed25519
```

Ensuite dans l’inventory :

```yaml
node1:
```



### Désactivation du host key checking

Dans `ansible.cfg` :

```ini
[defaults]
host_key_checking = False
```

Permet d’éviter les prompts interactifs.



### Paramètres SSH personnalisés

```ini
[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s
```

Optimisation :

* réutilisation des connexions
* meilleure performance



## 5. Bastion et ProxyJump

### Accès via bastion

Dans certains environnements, l’accès aux serveurs passe par un bastion.

Configuration :

```sshconfig
Host bastion
    HostName bastion.example.com
    User ubuntu

Host node1
    HostName 10.0.0.10
    User ubuntu
    ProxyJump bastion
```



### Intégration avec Ansible

Ansible utilise automatiquement cette configuration SSH.

Alternative dans inventory :

```yaml
ansible_ssh_common_args: '-o ProxyJump=bastion'
```



## 6. Optimisation des connexions SSH

### Connexions persistantes

Ansible peut réutiliser les connexions SSH.

```ini
[ssh_connection]
pipelining = True
```

Avantages :

* réduction du temps d’exécution
* moins de connexions ouvertes



### Désactivation de sudo requiretty

Sur certaines distributions :

```bash
sudo visudo
```

Ajouter ou modifier :

```bash
Defaults:ansible !requiretty
```



## 7. Debug et troubleshooting SSH

### Test de connexion

```bash
ansible all -m ping
```



### Mode verbose

```bash
ansible all -m ping -vvv
```

Permet de voir :

* les connexions SSH
* les erreurs
* les commandes exécutées



### Erreurs fréquentes

* permission denied (clé SSH incorrecte)
* mauvais utilisateur
* problème de sudo
* host key non validée
* port SSH incorrect



## 8. Bonnes pratiques

* utiliser des clés SSH
* éviter les mots de passe
* centraliser la config SSH
* utiliser ProxyJump pour les bastions
* activer pipelining
* tester la connectivité avant exécution



## 9. Anti-patterns

* utilisation de mot de passe en production
* duplication des configs SSH dans l’inventory
* absence de gestion des accès
* désactivation globale de la sécurité sans contrôle



## Conclusion

SSH est le pilier du fonctionnement d’Ansible.

Une configuration correcte permet :

* une automatisation fiable
* une sécurité maîtrisée
* de meilleures performances

Une mauvaise configuration SSH est l’une des principales causes d’échec dans les déploiements Ansible.


---

# 05 Ansible - Fichier cfg, configuration et tuning

Documentation : 

https://docs.ansible.com/ansible/2.3/intro_configuration.html

https://www.blog-libre.org/2019/05/11/loption-controlmaster-de-ssh_config/

https://mitogen.networkgenomics.com/ansible_detailed.html

## 1. Introduction au fichier ansible.cfg

### Rôle du fichier de configuration

Le fichier `ansible.cfg` permet de définir le comportement global d’Ansible :

* gestion des connexions
* paramètres SSH
* performance
* chemins par défaut
* options d’exécution

Il permet de standardiser l’environnement d’exécution dans un projet.



### Ordre de priorité des configurations

Ansible charge la configuration selon cet ordre :

1. variable d’environnement `ANSIBLE_CONFIG`
2. fichier local `./ansible.cfg`
3. fichier utilisateur `~/.ansible.cfg`
4. fichier global `/etc/ansible/ansible.cfg`

Bonne pratique :

* utiliser un `ansible.cfg` au niveau du projet



## 2. Configuration minimale recommandée

Exemple de configuration de base :

```ini id="r2k9vx"
[defaults]
inventory = ./inventory
remote_user = ubuntu
host_key_checking = False
retry_files_enabled = False
stdout_callback = yaml

[ssh_connection]
pipelining = True
```



### Explication des paramètres

* `inventory` : chemin vers l’inventory
* `remote_user` : utilisateur SSH par défaut
* `host_key_checking` : désactive la validation interactive SSH
* `retry_files_enabled` : désactive les fichiers `.retry`
* `stdout_callback` : améliore la lisibilité des sorties
* `pipelining` : optimise les connexions SSH



## 3. Paramètres importants

### Gestion des connexions

```ini id="d3h7qp"
[defaults]
timeout = 30
forks = 10
```

* `timeout` : délai de connexion SSH
* `forks` : nombre de connexions parallèles

Bonne pratique :

* adapter `forks` selon l’infrastructure



### Optimisation SSH

```ini id="w9m2ts"
[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s
pipelining = True
```

Avantages :

* connexions persistantes
* réduction du temps d’exécution



### Gestion des logs

```ini id="g5k1xz"
[defaults]
log_path = ./ansible.log
```

Permet :

* traçabilité
* audit des exécutions



### Gestion des privilèges

```ini id="p4z8qn"
[privilege_escalation]
become = True
become_method = sudo
become_user = root
```



## 4. Configuration avancée

### Désactivation de gather_facts par défaut

```ini id="y6f2kr"
[defaults]
gathering = explicit
```

Permet :

* gain de performance
* contrôle des faits collectés



### Gestion des callbacks

```ini id="t3j9vd"
[defaults]
stdout_callback = yaml
bin_ansible_callbacks = True
```

Permet :

* sortie plus lisible
* debug facilité



### Gestion des erreurs

```ini id="q8c4lw"
[defaults]
retry_files_enabled = False
```

Évite la génération de fichiers inutiles.



## 5. Performance et tuning

### Ajustement des forks

```ini id="v1p7nb"
forks = 20
```

Impact :

* plus de parallélisme
* plus de charge CPU



### Activation du pipelining

```ini id="s9m3xe"
pipelining = True
```

Réduit :

* nombre de connexions SSH
* latence



### Désactivation du host key checking

```ini id="k7x2fa"
host_key_checking = False
```

Attention :

* améliore l’automatisation
* réduit la sécurité



## 6. Bonnes pratiques

* versionner le fichier `ansible.cfg`
* utiliser une configuration projet
* activer pipelining
* ajuster les forks
* centraliser les paramètres
* documenter les choix



## 7. Anti-patterns

* utiliser la configuration globale système
* ne pas maîtriser les forks
* désactiver la sécurité sans justification
* ne pas versionner la configuration
* dupliquer les paramètres dans plusieurs fichiers



## 8. Exemple de configuration production

```ini id="b8k2vn"
[defaults]
inventory = ./inventory
remote_user = ubuntu
timeout = 30
forks = 20
host_key_checking = False
retry_files_enabled = False
stdout_callback = yaml
log_path = ./ansible.log
gathering = explicit

[ssh_connection]
pipelining = True
ssh_args = -o ControlMaster=auto -o ControlPersist=60s

[privilege_escalation]
become = True
become_method = sudo
become_user = root
```



## Conclusion

Le fichier `ansible.cfg` est un élément central de l’écosystème Ansible.

Une bonne configuration permet :

* d’améliorer les performances
* de standardiser les exécutions
* de sécuriser les opérations
* de faciliter le debugging

Un mauvais paramétrage peut entraîner :

* des lenteurs
* des erreurs difficiles à diagnostiquer
* des comportements incohérents

La maîtrise de ce fichier est essentielle pour une utilisation avancée d’Ansible.


---

# 06 Ansible - Commande ansible CLI



## 1. Introduction aux commandes Ansible

### Qu’est-ce que la commande ansible

La commande `ansible` permet d’exécuter des actions ponctuelles sur un ou plusieurs hôtes, sans utiliser de playbook.

On parle de **commandes ad-hoc**.

Usage typique :

* test de connectivité
* exécution rapide d’une commande
* debug
* opérations simples



### Syntaxe générale

```bash
ansible <pattern> -m <module> -a "<arguments>"
```

* `<pattern>` : groupe ou hôte cible
* `-m` : module utilisé
* `-a` : arguments du module



## 2. Commandes de base

### Test de connectivité

```bash
ansible all -m ping
```

Permet de vérifier :

* accès SSH
* fonctionnement d’Ansible
* disponibilité des hôtes



### Exécution d’une commande

```bash
ansible all -m command -a "uptime"
```



### Utilisation du module shell

```bash
ansible all -m shell -a "echo hello"
```

Différence :

* `command` : sécurisé, sans shell
* `shell` : permet pipes, redirections



### Gestion des paquets

```bash
ansible all -m ansible.builtin.apt -a "name=nginx state=present" --become
```



### Gestion des fichiers

```bash
ansible all -m copy -a "src=./file.txt dest=/tmp/file.txt"
```



## 3. Ciblage des hôtes

### Utilisation des groupes

```bash
ansible webservers -m ping
```



### Ciblage spécifique

```bash
ansible node1 -m ping
```



### Combinaison de groupes

```bash
ansible "webservers:dbservers" -m ping
```



### Exclusion

```bash
ansible "all:!node1" -m ping
```



## 4. Gestion des privilèges

### Exécution avec sudo

```bash
ansible all -m apt -a "name=nginx state=present" --become
```



### Demande de mot de passe

```bash
ansible all -m ping --ask-become-pass
```



## 5. Gestion des variables

### Variables inline

```bash
ansible all -m shell -a "echo {{ var }}" -e "var=hello"
```



### Variables depuis fichier

```bash
ansible all -m shell -a "echo {{ var }}" -e "@vars.yml"
```



## 6. Options utiles

### Mode verbose

```bash
ansible all -m ping -vvv
```

Permet :

* debug avancé
* analyse des connexions SSH



### Limiter le nombre d’hôtes

```bash
ansible all -m ping --limit node1
```



### Spécifier un inventory

```bash
ansible all -m ping -i inventory.yml
```



### Exécution parallèle

```bash
ansible all -m ping -f 20
```

* `-f` : nombre de forks



## 7. Bonnes pratiques

* utiliser les commandes ad-hoc pour :

  * debug
  * tests rapides
* ne pas remplacer les playbooks
* privilégier les modules natifs
* éviter `shell` si possible
* tester avant exécution en production



## 8. Anti-patterns

* automatiser via commandes ad-hoc répétées
* utiliser `shell` pour tout
* exécuter sans contrôle sur `all`
* ne pas utiliser `--limit`



## 9. Cas d’usage réels

### Vérifier tous les serveurs

```bash
ansible all -m ping
```



### Redémarrer un service

```bash
ansible webservers -m systemd -a "name=nginx state=restarted" --become
```



### Vérifier l’espace disque

```bash
ansible all -m command -a "df -h"
```



### Copier un fichier

```bash
ansible all -m copy -a "src=./config.conf dest=/etc/config.conf" --become
```



## Conclusion

La commande `ansible` est un outil puissant pour :

* le debug
* les actions rapides
* les opérations ponctuelles

Cependant, elle doit rester complémentaire aux playbooks, qui restent la méthode principale pour des automatisations structurées et maintenables.


---
# 07 Ansible - Module CLI



## 1. Introduction aux modules Ansible

### Qu’est-ce qu’un module

Un module est une unité d’exécution dans Ansible.

Chaque module réalise une action spécifique :

* installer un paquet
* gérer un fichier
* démarrer un service
* interagir avec une API

Ansible envoie le module sur la machine distante, l’exécute, puis récupère le résultat.



### Fonctionnement des modules

Lors de l’exécution :

1. Ansible se connecte à la machine
2. envoie le module (temporaire)
3. exécute le module
4. supprime le module
5. récupère le résultat JSON

Ce fonctionnement explique :

* l’absence d’agent
* le besoin de Python sur la cible
* le comportement idempotent



## 2. Utilisation des modules en CLI

### Syntaxe générale

```bash
ansible <pattern> -m <module> -a "<arguments>"
```

Exemple :

```bash id="x8k3pn"
ansible all -m ansible.builtin.ping
```



### Passage d’arguments

```bash id="u3y7lb"
ansible all -m ansible.builtin.apt -a "name=nginx state=present" --become
```



### Format clé=valeur

Arguments classiques :

```bash id="n7q2fw"
name=nginx state=present
```



### Format JSON (plus avancé)

```bash id="v9d5zk"
ansible all -m copy -a '{"src": "file.txt", "dest": "/tmp/file.txt"}'
```



## 3. Types de modules

### Modules système

* `apt`
* `yum`
* `package`



### Modules fichiers

* `copy`
* `template`
* `file`



### Modules services

* `systemd`
* `service`



### Modules réseau / API

* `uri`
* modules cloud (AWS, Azure)



### Modules utilitaires

* `command`
* `shell`
* `debug`



## 4. Modules built-in et collections

### Modules natifs

Ansible fournit des modules intégrés :

```bash id="d4g9qk"
ansible-doc -l
```



### Utilisation recommandée

Toujours utiliser le namespace complet :

```bash id="w2k6je"
ansible.builtin.apt
```

Avantages :

* explicite
* évite les conflits
* compatible avec les collections



### Documentation des modules

```bash id="t7z1rm"
ansible-doc ansible.builtin.apt
```

Permet de voir :

* paramètres
* exemples
* comportement



## 5. Résultat des modules

### Structure de sortie

Les modules retournent un JSON contenant :

* `changed`
* `failed`
* `stdout`
* `stderr`

Exemple :

```json id="j2m8xp"
{
  "changed": false,
  "stdout": "",
  "stderr": ""
}
```



### Interprétation

* `changed: true` → modification effectuée
* `changed: false` → rien à faire
* `failed: true` → erreur



## 6. Bon usage des modules

### Privilégier les modules natifs

```bash
ansible all -m apt -a "name=nginx state=present"
```



### Éviter shell et command

```bash
ansible all -m shell -a "apt install -y nginx"
```

À éviter sauf cas spécifique.



### Utiliser des modules idempotents

Les modules sont conçus pour :

* éviter les actions inutiles
* garantir la cohérence



## 7. Debug avec les modules

### Module debug

```bash id="z6p1xt"
ansible all -m debug -a "msg='hello world'"
```



### Affichage de variables

```bash id="u9k3rb"
ansible all -m debug -a "var=ansible_hostname"
```



### Mode verbose

```bash id="k8x1pm"
ansible all -m ping -vvv
```



## 8. Bonnes pratiques

* utiliser les modules officiels
* utiliser les namespaces complets
* lire la documentation (`ansible-doc`)
* éviter les commandes shell
* comprendre les retours (`changed`, `failed`)
* tester en CLI avant playbook



## 9. Anti-patterns

* utiliser `shell` pour tout
* ignorer les modules existants
* ne pas vérifier les retours
* ne pas documenter les usages
* copier/coller sans comprendre



## Conclusion

Les modules sont le cœur d’Ansible.

Une bonne maîtrise permet :

* des playbooks propres
* une automatisation fiable
* une meilleure maintenabilité

Comprendre leur fonctionnement est essentiel pour passer d’un usage basique à une utilisation professionnelle d’Ansible.


---
# 08 Ansible - Inventory



## 1. Définition et rôle de l’inventory

L’inventory est l’élément central d’Ansible.

Il correspond à :

* la liste des machines
* leur organisation
* les variables associées

Il décrit l’infrastructure :

* serveurs
* rôles des serveurs
* organisation logique



### Concepts fondamentaux

Un inventory contient deux types d’objets :

* **hosts** : machines
* **groupes** : ensembles de machines



### Formats disponibles

Ansible supporte plusieurs formats :

* INI : format historique, simple mais limité
* YAML : format recommandé (lisible et structuré)
* JSON : utilisé pour les inventaires dynamiques



### Composants d’un inventory

Un inventory peut inclure :

* un fichier d’inventaire
* un répertoire `group_vars`
* un répertoire `host_vars`



## 2. Structure logique d’un inventory

### Groupe racine

Le groupe racine est toujours :

```yaml
all
```

Tous les hôtes appartiennent implicitement à ce groupe.



### Hiérarchie des groupes

Un inventory peut être structuré en :

* groupes parents
* groupes enfants
* sous-groupes



### Exemple logique

Structure souhaitée :

* parent1

  * enfant1 → srv1, srv2
  * enfant2 → srv3

    * enfant3 → srv5
  * parent1 contient aussi srv4



## 3. Format INI

Exemple :

```ini
[parent1]
srv4

[enfant1]
srv1
srv2

[enfant2]
srv3

[enfant3]
srv5

[parent1:children]
enfant1
enfant2

[enfant2:children]
enfant3
```



### Limites du format INI

* peu structuré
* difficile à maintenir
* erreurs fréquentes



## 4. Format YAML (recommandé)

### Exemple équivalent

```yaml
all:
  children:
    parent1:
      hosts:
        srv4:
      children:
        enfant1:
          hosts:
            srv1:
            srv2:
        enfant2:
          hosts:
            srv3:
          children:
            enfant3:
              hosts:
                srv5:
```



### Avantages du YAML

* structure claire
* lisibilité
* extensibilité
* compatible avec variables complexes



## 5. Appartenance multiple à des groupes

Un host peut appartenir à plusieurs groupes.

Exemple :

```yaml
all:
  children:
    parent1:
      hosts:
        srv4:
    parent2:
      hosts:
        srv4:
        srv6:
        srv7:
        srv8:
        srv9:
```

Ici :

* `srv4` appartient à **parent1 et parent2**



## 6. Utilisation des patterns

Les patterns permettent de générer plusieurs hosts rapidement.

### Exemple

```yaml
all:
  children:
    parent1:
      children:
        enfant1:
          hosts:
            srv[1:2]:
        enfant2:
          hosts:
            srv3:
          children:
            enfant3:
              hosts:
                srv5:
    parent2:
      hosts:
        srv[6:9]:
```



### Avantages

* réduction de duplication
* génération rapide
* utile en environnement homogène



## 7. Organisation réelle (approche DevOps)

### Exemple d’architecture

```yaml
all:
  children:
    common:
      children:
        webserver:
          hosts:
            srv[1:4]:
        dbserver:
          hosts:
            srv[5:6]:
        app:
          hosts:
            srv[7:10]:
        appdock:
          hosts:
            srv[11:15]

    monitoring:
      children:
        common:
```



### Lecture de cette structure

* `common` : couche partagée
* `webserver` : serveurs web (nginx)
* `dbserver` : bases de données
* `app` : applications
* `appdock` : applications dockerisées
* `monitoring` : couche transverse



### Logique DevOps

Cette organisation permet :

* séparation par rôle
* factorisation des configurations
* déploiement ciblé

Exemples :

```bash
ansible webserver -m ping
ansible dbserver -m ping
```



## 8. Bonnes pratiques

* utiliser YAML
* structurer les groupes logiquement
* éviter les inventaires plats
* séparer les rôles (web, db, app)
* utiliser des patterns intelligemment
* éviter la duplication



## 9. Anti-patterns

* tout mettre dans `all`
* ne pas utiliser de groupes
* dupliquer les hosts
* mélanger les environnements
* utiliser uniquement des IP sans abstraction



## Conclusion

L’inventory est la base de tout projet Ansible.

Une bonne conception permet :

* une automatisation claire
* une meilleure maintenabilité
* une évolutivité du projet

Un inventory mal structuré devient rapidement difficile à maintenir et à faire évoluer.


---

# 09 Ansible - Inventory variables

Documentation : 

https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html

## 1. Introduction aux variables d’inventaire

Les variables d’inventaire permettent de définir des valeurs associées :

* à un groupe
* à un hôte
* à l’ensemble de l’infrastructure

Elles permettent :

* d’éviter les valeurs en dur
* d’adapter les configurations selon les environnements
* de factoriser les déploiements



## 2. Principe de précédence des variables

### Notion de priorité

Dans Ansible, plusieurs variables peuvent définir la même clé.

La valeur finale dépend d’un système de priorité appelé **précedence**.



### Test avec extra vars

Les variables passées avec `-e` ont la priorité la plus élevée.

#### Commande

```bash
ansible -i "node2," all -b -e "var1=pp" -m debug -a "msg={{ var1 }}"
```



#### Résultat

```json
node2 | SUCCESS => {
    "msg": "pp"
}
```



### Conclusion

Une variable définie avec `-e` écrase toutes les autres :

* inventory
* group_vars
* host_vars



## 3. Variables dans le fichier d’inventaire

### Principe

Les variables peuvent être définies directement dans le fichier d’inventory.



### Exemple

```yaml
all:
  children:
    common:
      children:
        webserver:
          hosts:
            node2:
            node3:
          vars:
            var1: "webserver"

        dbserver:
          hosts:
            node4:
            node5:
              var1: "node5"
          vars:
            var1: "dbserver"

    monitoring:
      children:
        webserver:
        dbserver:
```



### Commande

```bash
ansible -i inventory.yml all -m debug -a "msg={{ var1 }}"
```



### Résultat

```json
node2 => webserver
node3 => webserver
node4 => dbserver
node5 => node5
```



### Règle

* une variable définie au niveau groupe s’applique à tous les hosts
* une variable définie au niveau host écrase celle du groupe



## 4. Variables avec group_vars

### Principe

Les variables peuvent être externalisées dans un répertoire `group_vars/`.

Chaque fichier correspond à un groupe.



### Arborescence

```bash
.
├── inventory.yml
└── group_vars/
    ├── webserver.yml
    └── dbserver.yml
```



### Configuration

```yaml
# group_vars/webserver.yml
var1: "gp_webserver"
```

```yaml
# group_vars/dbserver.yml
var1: "gp_dbserver"
```



### Résultat

```json
node2 => gp_webserver
node3 => gp_webserver
node4 => gp_dbserver
node5 => gp_dbserver
```



### Avantages

* meilleure organisation
* séparation des responsabilités
* facilité de maintenance



## 5. Variables avec host_vars

### Principe

Les variables définies dans `host_vars/` sont spécifiques à une machine.

Elles ont une priorité plus élevée que celles définies dans `group_vars`.



### Arborescence

```bash
.
├── inventory.yml
├── group_vars/
│   ├── webserver.yml
│   └── dbserver.yml
└── host_vars/
    ├── node2.yml
    └── node5.yml
```



### Configuration

```yaml
# host_vars/node2.yml
var1: "host_node2"
```

```yaml
# host_vars/node5.yml
var1: "host_node5"
```



### Résultat

```json
node2 => host_node2
node3 => gp_webserver
node4 => gp_dbserver
node5 => host_node5
```



### Règle

* host_vars > group_vars



## 6. Variables globales avec group_vars/all

### Principe

Un host qui n’appartient qu’au groupe `all` récupère les variables définies dans :

```bash
group_vars/all.yml
```



### Exemple

```yaml
# group_vars/all.yml
var1: "gp_all"
```



### Cas d’usage

Host sans groupe spécifique :

```yaml
monitoring:
  hosts:
    node6:
```



### Résultat

```json
node6 => gp_all
```



## 7. Résumé de la précédence

Ordre de priorité (du plus faible au plus fort) :

```text
group_vars/all
↓
group_vars/groupe
↓
host_vars/host
↓
extra vars (-e)
```



## 8. Bonnes pratiques

* centraliser les variables dans `group_vars`
* utiliser `host_vars` uniquement pour des cas spécifiques
* éviter les variables en dur dans les playbooks
* nommer clairement les variables
* documenter les variables importantes



## 9. Anti-patterns

* définir les variables partout (confusion)
* dupliquer les variables
* utiliser excessivement `-e` en production
* mélanger logique et configuration
* ne pas comprendre la précédence



## Conclusion

La gestion des variables est un élément clé dans Ansible.

Une bonne maîtrise permet :

* des playbooks plus propres
* une meilleure maintenabilité
* une configuration flexible et évolutive

La compréhension de la précédence est indispensable pour éviter des comportements inattendus.


---

# 10 Ansible - Inventory commande



## 1. Introduction à ansible-inventory

La commande `ansible-inventory` permet d’inspecter et de comprendre comment Ansible interprète un inventory.

Elle permet de :

* visualiser les groupes
* voir les hosts
* afficher les variables
* vérifier la structure réelle

C’est un outil essentiel pour :

* debug
* validation
* compréhension d’un inventory complexe



## 2. Afficher tout l’inventaire en JSON

### Principe

L’option `--list` affiche l’inventory complet :

* groupes
* hosts
* variables

Le format par défaut est JSON.



### Arborescence

```bash
.
└── 00_inventory.yml
```



### Configuration

```yaml
all:
  children:
    common:
      children:
        webserver:
          hosts:
            node2:
            node3:
          vars:
            var1: "webserver"

        dbserver:
          hosts:
            node4:
            node5:
              var1: "node5"
          vars:
            var1: "dbserver"

    monitoring:
      children:
        webserver:
        dbserver:
```



### Commande

```bash
ansible-inventory -i 00_inventory.yml --list
```



### Résultat

```json
{
  "_meta": {
    "hostvars": {
      "node2": { "var1": "webserver" },
      "node3": { "var1": "webserver" },
      "node4": { "var1": "dbserver" },
      "node5": { "var1": "node5" }
    }
  }
}
```



## 3. Afficher l’inventaire en YAML

### Principe

L’option `--yaml` affiche le même contenu dans un format plus lisible.



### Commande

```bash
ansible-inventory -i 00_inventory.yml --yaml
```



### Résultat

```yaml
all:
  children:
    common:
      children:
        webserver:
          hosts:
            node2:
              var1: webserver
            node3:
              var1: webserver
        dbserver:
          hosts:
            node4:
              var1: dbserver
            node5:
              var1: node5
```



### Intérêt

* plus lisible que JSON
* adapté à l’analyse humaine



## 4. Affichage compact avec --export

### Principe

L’option `--export` simplifie la sortie :

* moins de détails internes
* structure plus propre



### Commande

```bash
ansible-inventory -i 00_inventory.yml --list --export
```



### Résultat

```json
{
  "webserver": {
    "hosts": ["node2", "node3"],
    "vars": { "var1": "webserver" }
  }
}
```



### Intérêt

* export
* audit rapide
* compréhension simplifiée



## 5. Afficher l’arbre des groupes

### Principe

L’option `--graph` affiche la hiérarchie :

* groupes
* sous-groupes
* hosts



### Commande

```bash
ansible-inventory -i 00_inventory.yml --graph
```



### Résultat

```text
@all:
  |--@common:
  |  |--@webserver:
  |  |  |--node2
  |  |  |--node3
  |  |--@dbserver:
  |  |  |--node4
  |  |  |--node5
```



### Intérêt

* visualiser la structure
* comprendre les relations



## 6. Afficher l’arbre avec les variables

### Principe

Ajout de `--vars` :

* affiche les variables associées



### Commande

```bash
ansible-inventory -i 00_inventory.yml --graph --vars
```



### Résultat

```text
@webserver:
  |--{var1 = webserver}
  |--node2
  |--node3
```



### Intérêt

* comprendre la propagation des variables
* debug des conflits



## 7. Exporter l’inventaire vers un fichier

### Principe

L’option `--output` permet d’écrire dans un fichier.



### Commande

```bash
ansible-inventory -i 00_inventory.yml --list --output inventory_export.json
```



### Résultat

Fichier créé :

```text
inventory_export.json
```



### Intérêt

* sauvegarde
* audit
* intégration dans d’autres outils



## 8. Formats alternatifs (exemple TOML)

### Principe

Ansible peut exporter dans d’autres formats.



### Commandes

```bash
pip3 install toml
ansible-inventory -i 00_inventory.yml --toml
```



### Résultat

```toml
[webserver]
hosts = ["node2", "node3"]
```



### Intérêt

* interopérabilité
* intégration avec d’autres outils



## 9. Visualisation avancée avec grapher

Dépôt : https://github.com/willthames/ansible-inventory-grapher

### Principe

Utiliser un outil externe pour générer un vrai diagramme.



### Commandes

```bash
pip3 install ansible-inventory-grapher
sudo apt install graphviz

ansible-inventory-grapher -i inventory.yml all | dot -Tpng | display png:-
```



### Résultat

* génération d’un schéma graphique
* représentation complète de l’inventory



### Intérêt

* documentation
* présentation
* compréhension globale



## 10. Commandes essentielles

```bash
ansible-inventory -i inventory.yml --list
ansible-inventory -i inventory.yml --yaml
ansible-inventory -i inventory.yml --graph
ansible-inventory -i inventory.yml --graph --vars
ansible-inventory -i inventory.yml --list --export
```



## 11. Bonnes pratiques

* toujours vérifier un inventory avec `--list`
* utiliser `--graph` pour comprendre la structure
* utiliser `--vars` pour debug les variables
* exporter pour audit
* valider avant exécution en production



## 12. Anti-patterns

* ne pas vérifier son inventory
* ignorer les conflits de variables
* travailler sans visualisation
* utiliser un inventory complexe sans validation



## Conclusion

La commande `ansible-inventory` est indispensable pour :

* comprendre l’état réel de l’inventory
* diagnostiquer les problèmes
* valider les configurations

Elle doit être utilisée systématiquement lors du développement et du debug.


---

# 11 Ansible - Playbook introductions


## Introduction

Un playbook est le point d’entrée principal d’une automatisation Ansible.

Il permet de :

* cibler des hosts ou des groupes
* définir des tâches
* appeler des rôles
* préciser le contexte d’exécution
* orchestrer des actions de manière reproductible

Un playbook est écrit en YAML et exécuté avec la commande `ansible-playbook`.

Dans un projet bien structuré :

* le playbook orchestre
* les rôles portent la logique métier
* l’inventory décrit l’infrastructure
* les variables sont externalisées autant que possible


## Lab associé

Code et fichiers d’exemple :

```text
../labs/11-ansible-playbook-introductions/
```

Dans ton dépôt, cela correspond au lab :

[Voir le lab 11-ansible-playbook-introductions](../labs/11-ansible-playbook-introductions)


## 1 — Définition d’un playbook

### Explication

Un playbook est un fichier YAML qui permet de décrire les actions à exécuter sur les machines gérées par Ansible.

Il sert à :

* déclencher des actions
* cibler des hosts ou des groupes
* articuler l’inventory avec les rôles
* exécuter des tâches

En pratique :

* un playbook peut contenir des tasks
* un playbook peut contenir des variables
* mais, en bonne pratique, on évite d’y mettre trop de logique
* ce sont surtout les rôles qui doivent porter le vrai contenu métier

Un playbook permet aussi de préciser :

* quel utilisateur distant utiliser
* si on doit faire une élévation de privilèges (`become`)


### Arborescence

```text
.
├── 00_inventory.yml
└── playbook.yml
```


### Configuration

```yaml
# playbook.yml
- name: Mon Playbook
  hosts: all
  remote_user: vagrant
  become: true
  tasks:
    - name: Afficher la variable var1
      ansible.builtin.debug:
        msg: "{{ var1 }}"
```


### Commande

```bash
ansible-playbook -i 00_inventory.yml playbook.yml
```


### Résultat attendu

Le résultat dépend de l’inventory et de la variable `var1`.

Si `var1` est définie correctement pour les hosts, on obtient par exemple :

```text
PLAY [Mon Playbook] **********************************************************

TASK [Gathering Facts] *******************************************************
ok: [node2]
ok: [node3]

TASK [Afficher la variable var1] *********************************************
ok: [node2] => {
    "msg": "webserver"
}
ok: [node3] => {
    "msg": "webserver"
}

PLAY RECAP *******************************************************************
node2 : ok=2 changed=0 unreachable=0 failed=0
node3 : ok=2 changed=0 unreachable=0 failed=0
```


## 2 — Commande de base : ansible-playbook

### Explication

La commande utilisée pour lancer un playbook est :

```bash
ansible-playbook
```

C’est la commande principale pour exécuter des automatisations écrites dans un fichier YAML.


### Arborescence

```text
.
├── 00_inventory.yml
└── playbook.yml
```


### Configuration

```yaml
# playbook.yml
- name: Mon Playbook
  hosts: all
  remote_user: vagrant
  become: true
  tasks:
    - name: Afficher un message
      ansible.builtin.debug:
        msg: "Hello Ansible"
```


### Commande

```bash
ansible-playbook -i 00_inventory.yml playbook.yml
```


### Résultat attendu

```text
PLAY [Mon Playbook] **********************************************************

TASK [Gathering Facts] *******************************************************
ok: [node2]
ok: [node3]
ok: [node4]

TASK [Afficher un message] ***************************************************
ok: [node2] => {
    "msg": "Hello Ansible"
}
ok: [node3] => {
    "msg": "Hello Ansible"
}
ok: [node4] => {
    "msg": "Hello Ansible"
}

PLAY RECAP *******************************************************************
node2 : ok=2 changed=0 unreachable=0 failed=0
node3 : ok=2 changed=0 unreachable=0 failed=0
node4 : ok=2 changed=0 unreachable=0 failed=0
```


## 3 — Option -i : spécifier l’inventory

### Explication

L’option `-i` permet de préciser quel inventaire utiliser.

C’est important quand on a :

* plusieurs inventaires
* plusieurs environnements
* plusieurs fichiers d’inventaire


### Arborescence

```text
.
├── dev/
│   └── 00_inventory.yml
├── prod/
│   └── 00_inventory.yml
└── playbook.yml
```


### Configuration

```yaml
# playbook.yml
- name: Mon Playbook
  hosts: all
  remote_user: vagrant
  become: true
  tasks:
    - name: Afficher le contexte d’inventory
      ansible.builtin.debug:
        msg: "Test inventory"
```


### Commande

```bash
ansible-playbook -i dev/00_inventory.yml playbook.yml
```


### Résultat attendu

Le playbook est exécuté uniquement sur les hosts présents dans `dev/00_inventory.yml`.

```text
PLAY [Mon Playbook] **********************************************************

TASK [Gathering Facts] *******************************************************
ok: [srv1]
ok: [srv2]

TASK [Afficher le contexte d’inventory] **************************************
ok: [srv1] => {
    "msg": "Test inventory"
}
ok: [srv2] => {
    "msg": "Test inventory"
}

PLAY RECAP *******************************************************************
srv1 : ok=2 changed=0 unreachable=0 failed=0
srv2 : ok=2 changed=0 unreachable=0 failed=0
```


## 4 — Option -l : limiter l’exécution

### Explication

L’option `-l` signifie `limit`.

Elle permet de restreindre l’exécution à :

* un groupe
* un host
* plusieurs hosts
* un pattern


### Arborescence

```text
.
├── 00_inventory.yml
└── playbook.yml
```


### Configuration

```yaml
# 00_inventory.yml
all:
  children:
    webserver:
      hosts:
        node2:
        node3:
    dbserver:
      hosts:
        node4:
        node5:
```

```yaml
# playbook.yml
- name: Mon Playbook
  hosts: all
  remote_user: vagrant
  become: true
  tasks:
    - name: Tester la limitation
      ansible.builtin.debug:
        msg: "limit test"
```


### Commande

```bash
ansible-playbook -i 00_inventory.yml playbook.yml -l webserver
```


### Résultat attendu

```text
PLAY [Mon Playbook] **********************************************************

TASK [Gathering Facts] *******************************************************
ok: [node2]
ok: [node3]

TASK [Tester la limitation] **************************************************
ok: [node2] => {
    "msg": "limit test"
}
ok: [node3] => {
    "msg": "limit test"
}

PLAY RECAP *******************************************************************
node2 : ok=2 changed=0 unreachable=0 failed=0
node3 : ok=2 changed=0 unreachable=0 failed=0
```


## 5 — Option -u : préciser l’utilisateur distant

### Explication

L’option `-u` permet de définir l’utilisateur utilisé pour la connexion SSH.

C’est utile si on ne veut pas utiliser :

* celui défini dans le playbook
* celui défini dans l’inventory
* celui par défaut


### Arborescence

```text
.
├── 00_inventory.yml
└── playbook.yml
```


### Configuration

```yaml
# playbook.yml
- name: Mon Playbook
  hosts: all
  tasks:
    - name: Tester l’utilisateur distant
      ansible.builtin.debug:
        msg: "remote user test"
```


### Commande

```bash
ansible-playbook -i 00_inventory.yml playbook.yml -u vagrant
```


### Résultat attendu

Si l’utilisateur `vagrant` peut se connecter correctement :

```text
PLAY [Mon Playbook] **********************************************************

TASK [Gathering Facts] *******************************************************
ok: [node2]

TASK [Tester l’utilisateur distant] ******************************************
ok: [node2] => {
    "msg": "remote user test"
}

PLAY RECAP *******************************************************************
node2 : ok=2 changed=0 unreachable=0 failed=0
```

Si l’utilisateur n’a pas accès :

```text
PLAY [Mon Playbook] **********************************************************

TASK [Gathering Facts] *******************************************************
fatal: [node2]: UNREACHABLE! => {
    "changed": false,
    "msg": "Failed to connect to the host via ssh: Permission denied",
    "unreachable": true
}

PLAY RECAP *******************************************************************
node2 : ok=0 changed=0 unreachable=1 failed=0
```


## 6 — Option -b : become / sudo

### Explication

L’option `-b` active l’élévation de privilèges.

C’est l’équivalent de :

```yaml
become: true
```

dans le playbook.


### Arborescence

```text
.
├── 00_inventory.yml
└── playbook.yml
```


### Configuration

```yaml
# playbook.yml
- name: Mon Playbook
  hosts: all
  remote_user: vagrant
  tasks:
    - name: Tester become
      ansible.builtin.debug:
        msg: "become test"
```


### Commande

```bash
ansible-playbook -i 00_inventory.yml playbook.yml -b
```


### Résultat attendu

```text
PLAY [Mon Playbook] **********************************************************

TASK [Gathering Facts] *******************************************************
ok: [node2]

TASK [Tester become] *********************************************************
ok: [node2] => {
    "msg": "become test"
}

PLAY RECAP *******************************************************************
node2 : ok=2 changed=0 unreachable=0 failed=0
```


## 7 — Option -k : demander le mot de passe SSH

### Explication

L’option `-k` demande le mot de passe SSH au lancement.

C’est pratique en laboratoire, mais dans un contexte réel on préfère les clés SSH.


### Arborescence

```text
.
├── 00_inventory.yml
└── playbook.yml
```


### Configuration

```yaml
# playbook.yml
- name: Mon Playbook
  hosts: all
  tasks:
    - name: Tester le mot de passe SSH
      ansible.builtin.debug:
        msg: "ssh password test"
```


### Commande

```bash
ansible-playbook -i 00_inventory.yml playbook.yml -k
```


### Résultat attendu

```text
SSH password:

PLAY [Mon Playbook] **********************************************************

TASK [Gathering Facts] *******************************************************
ok: [node2]

TASK [Tester le mot de passe SSH] ********************************************
ok: [node2] => {
    "msg": "ssh password test"
}

PLAY RECAP *******************************************************************
node2 : ok=2 changed=0 unreachable=0 failed=0
```


## 8 — Option -K : demander le mot de passe sudo

### Explication

L’option `-K` demande le mot de passe sudo utilisé avec `become`.


### Arborescence

```text
.
├── 00_inventory.yml
└── playbook.yml
```


### Configuration

```yaml
# playbook.yml
- name: Mon Playbook
  hosts: all
  become: true
  tasks:
    - name: Tester le mot de passe sudo
      ansible.builtin.debug:
        msg: "sudo password test"
```


### Commande

```bash
ansible-playbook -i 00_inventory.yml playbook.yml -K
```


### Résultat attendu

```text
BECOME password:

PLAY [Mon Playbook] **********************************************************

TASK [Gathering Facts] *******************************************************
ok: [node2]

TASK [Tester le mot de passe sudo] *******************************************
ok: [node2] => {
    "msg": "sudo password test"
}

PLAY RECAP *******************************************************************
node2 : ok=2 changed=0 unreachable=0 failed=0
```


## 9 — Option -C : mode check / dry run

### Explication

L’option `-C` lance un dry run.

Ansible vérifie ce qu’il ferait, sans appliquer réellement les changements.


### Arborescence

```text
.
├── 00_inventory.yml
└── playbook.yml
```


### Configuration

```yaml
# playbook.yml
- name: Mon Playbook
  hosts: all
  tasks:
    - name: Créer un fichier
      ansible.builtin.file:
        path: /tmp/demo_ansible
        state: touch
```


### Commande

```bash
ansible-playbook -i 00_inventory.yml playbook.yml -C
```


### Résultat attendu

```text
PLAY [Mon Playbook] **********************************************************

TASK [Gathering Facts] *******************************************************
ok: [node2]

TASK [Créer un fichier] ******************************************************
changed: [node2]

PLAY RECAP *******************************************************************
node2 : ok=2 changed=1 unreachable=0 failed=0
```


### Remarque

En mode check, Ansible peut afficher `changed`, sans réellement créer le fichier.


## 10 — Option -D : afficher les différences

### Explication

L’option `-D` affiche les différences avant/après quand un module supporte le diff.

Elle est particulièrement utile avec :

* `copy`
* `template`
* `lineinfile`


### Arborescence

```text
.
├── 00_inventory.yml
├── playbook.yml
└── files/
    └── motd.txt
```


### Configuration

```yaml
# playbook.yml
- name: Mon Playbook
  hosts: all
  tasks:
    - name: Copier un fichier
      ansible.builtin.copy:
        src: files/motd.txt
        dest: /tmp/motd.txt
```

```text
# files/motd.txt
Bienvenue sur le serveur
```


### Commande

```bash
ansible-playbook -i 00_inventory.yml playbook.yml -D
```


### Résultat attendu

```text
PLAY [Mon Playbook] **********************************************************

TASK [Gathering Facts] *******************************************************
ok: [node2]

TASK [Copier un fichier] *****************************************************
--- before
+++ after
@@ -0,0 +1 @@
+Bienvenue sur le serveur

changed: [node2]

PLAY RECAP *******************************************************************
node2 : ok=2 changed=1 unreachable=0 failed=0
```


## 11 — Option --syntax-check

### Explication

Cette option permet de vérifier uniquement la syntaxe du playbook, sans l’exécuter.


### Arborescence

```text
.
└── playbook.yml
```


### Configuration

```yaml
# playbook.yml
- name: Mon Playbook
  hosts: all
  tasks:
    - name: Tester la syntaxe
      ansible.builtin.debug:
        msg: "test syntax"
```


### Commande

```bash
ansible-playbook playbook.yml --syntax-check
```


### Résultat attendu

```text
playbook: playbook.yml
```

Si la syntaxe est incorrecte, Ansible affiche une erreur YAML ou une erreur d’interprétation.


## 12 — Option -e : surcharger une variable

### Explication

L’option `-e` permet d’écraser une variable définie ailleurs.

Elle possède une priorité très élevée.


### Arborescence

```text
.
├── 00_inventory.yml
└── playbook.yml
```


### Configuration

```yaml
# playbook.yml
- name: Mon Playbook
  hosts: all
  tasks:
    - name: Afficher var1
      ansible.builtin.debug:
        msg: "{{ var1 }}"
```

```yaml
# 00_inventory.yml
all:
  hosts:
    node2:
      var1: "inventory_value"
```


### Commande

```bash
ansible-playbook -i 00_inventory.yml playbook.yml -e "var1=cli_value"
```


### Résultat attendu

```text
PLAY [Mon Playbook] **********************************************************

TASK [Gathering Facts] *******************************************************
ok: [node2]

TASK [Afficher var1] *********************************************************
ok: [node2] => {
    "msg": "cli_value"
}

PLAY RECAP *******************************************************************
node2 : ok=2 changed=0 unreachable=0 failed=0
```


## 13 — Option -t : filtrer par tags

### Explication

Les tags permettent d’exécuter seulement certaines tâches.


### Arborescence

```text
.
├── 00_inventory.yml
└── playbook.yml
```


### Configuration

```yaml
# playbook.yml
- name: Mon Playbook
  hosts: all
  tasks:
    - name: Debug web
      ansible.builtin.debug:
        msg: "web task"
      tags: web

    - name: Debug db
      ansible.builtin.debug:
        msg: "db task"
      tags: db
```


### Commande

```bash
ansible-playbook -i 00_inventory.yml playbook.yml -t web
```


### Résultat attendu

```text
PLAY [Mon Playbook] **********************************************************

TASK [Debug web] *************************************************************
ok: [node2] => {
    "msg": "web task"
}

PLAY RECAP *******************************************************************
node2 : ok=1 changed=0 unreachable=0 failed=0
```


## 14 — Option --list-tags

### Explication

Cette option affiche les tags présents dans le playbook.


### Arborescence

```text
.
└── playbook.yml
```


### Configuration

```yaml
# playbook.yml
- name: Mon Playbook
  hosts: all
  tasks:
    - name: Debug web
      ansible.builtin.debug:
        msg: "web task"
      tags: web

    - name: Debug db
      ansible.builtin.debug:
        msg: "db task"
      tags: db
```


### Commande

```bash
ansible-playbook playbook.yml --list-tags
```


### Résultat attendu

```text
playbook: playbook.yml

  play #1 (all): Mon Playbook  TAGS: []
      TASK TAGS: [db, web]
```


## 15 — Option --list-tasks

### Explication

Cette option affiche les tâches qui seraient exécutées, sans lancer le playbook.


### Arborescence

```text
.
└── playbook.yml
```


### Configuration

```yaml
# playbook.yml
- name: Mon Playbook
  hosts: all
  tasks:
    - name: Debug web
      ansible.builtin.debug:
        msg: "web task"

    - name: Debug db
      ansible.builtin.debug:
        msg: "db task"
```


### Commande

```bash
ansible-playbook playbook.yml --list-tasks
```


### Résultat attendu

```text
playbook: playbook.yml

  play #1 (all): Mon Playbook  TAGS: []
    tasks:
      Debug web  TAGS: []
      Debug db   TAGS: []
```


## 16 — Premier playbook complet

### Explication

Voici un premier playbook simple :

* il cible tous les hosts
* il se connecte avec l’utilisateur `vagrant`
* il utilise `become`
* il affiche la variable `var1`


### Arborescence

```text
.
├── 00_inventory.yml
└── playbook.yml
```


### Configuration

```yaml
# playbook.yml
- name: Mon Playbook
  hosts: all
  remote_user: vagrant
  become: true
  tasks:
    - name: Afficher var1
      ansible.builtin.debug:
        msg: "{{ var1 }}"
```

```yaml
# 00_inventory.yml
all:
  children:
    webserver:
      hosts:
        node2:
        node3:
      vars:
        var1: "webserver"

    dbserver:
      hosts:
        node4:
        node5:
          var1: "node5"
      vars:
        var1: "dbserver"
```


### Commande

```bash
ansible-playbook -i 00_inventory.yml playbook.yml
```


### Résultat attendu

```text
PLAY [Mon Playbook] **********************************************************

TASK [Gathering Facts] *******************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node5]

TASK [Afficher var1] *********************************************************
ok: [node2] => {
    "msg": "webserver"
}
ok: [node3] => {
    "msg": "webserver"
}
ok: [node4] => {
    "msg": "dbserver"
}
ok: [node5] => {
    "msg": "node5"
}

PLAY RECAP *******************************************************************
node2 : ok=2 changed=0 unreachable=0 failed=0
node3 : ok=2 changed=0 unreachable=0 failed=0
node4 : ok=2 changed=0 unreachable=0 failed=0
node5 : ok=2 changed=0 unreachable=0 failed=0
```


## Bonnes pratiques

* garder les playbooks courts
* utiliser les rôles pour porter la logique métier
* externaliser les variables
* nommer clairement les tâches
* utiliser `--syntax-check` avant exécution
* utiliser `--check` avant un déploiement sensible


## Anti-patterns

* mettre toute la logique dans un seul playbook
* dupliquer les tâches au lieu de créer des rôles
* utiliser excessivement `-e` en production
* exécuter sur `all` sans contrôle
* ne pas utiliser `--limit` sur des environnements sensibles


## Conclusion

Le playbook est le point d’orchestration principal d’Ansible.

Il relie :

* l’inventory
* les variables
* les tâches
* les rôles

Une bonne maîtrise de `ansible-playbook` et de ses options est indispensable pour développer, tester et exécuter des automatisations de manière propre et sûre.


---

# 12 Ansible - Playbook et module


## Documentation

https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html
Commande utile :

```bash
ansible-doc ansible.builtin.file
```


## Lab associé

[Voir le lab 12-ansible-playbook-et-module](../labs/12-ansible-playbook-et-module/)


## 1 — Introduction aux modules

### Définition

Un module est une brique d’exécution dans Ansible.

Il permet de :

* gérer des fichiers
* installer des paquets
* manipuler des services
* interagir avec le système

Chaque tâche dans un playbook utilise un module.


### Exemple simple

```yaml
- name: Tester la connexion
  ansible.builtin.ping:
```


### Remarque

Equivalent en CLI :

```bash
ansible -i inventory all -m ping
```


## 2 — Module file : introduction

### Objectif

Le module `file` permet de gérer :

* fichiers
* répertoires
* liens symboliques
* permissions


### Périmètre

* création
* suppression
* modification
* gestion des droits


## 3 — Options principales du module file

### path

Chemin du fichier ou répertoire :

```yaml
path: /tmp/test
```


### state

Définit le type d’objet :

* `file` : vérifie l’existence
* `directory` : crée un dossier
* `touch` : crée un fichier vide
* `link` : lien symbolique
* `hard` : lien physique
* `absent` : suppression


### owner / group

Définir le propriétaire :

```yaml
owner: root
group: root
```


### mode

Permissions :

```yaml
mode: "0755"
```

ou

```yaml
mode: u=rwx,g=rx,o=rx
```


### recurse

Permet de créer les dossiers intermédiaires (uniquement directory) :

```yaml
recurse: true
```


### src

Utilisé pour les liens :

```yaml
src: /source/path
```


### force

Utilisé pour forcer la création d’un lien :

* si destination existe
* ou si source absente


### attributes

Permet de définir des attributs système (ex : immuable).


## 4 — Exemple de base avec playbook

### Inventory

```yaml
all:
  children:
    common:
      hosts:
        node2:
```


### Playbook

```yaml
- name: Je débute avec Ansible
  hosts: all
  remote_user: vagrant
  tasks:
    - name: Tester la connexion
      ansible.builtin.ping:
```


## 5 — Création d’un répertoire

```yaml
- name: Création du répertoire /tmp/pp
  ansible.builtin.file:
    path: /tmp/pp/
    state: directory
```


### Remarque

Le dossier est créé avec l’utilisateur de connexion.


## 6 — Gestion du propriétaire

```yaml
- name: Création du répertoire avec owner root
  ansible.builtin.file:
    path: /tmp/pp/
    state: directory
    owner: root
```


### Remarque

Nécessite des droits sudo.


## 7 — Utilisation de become

```yaml
- name: Création du répertoire avec privilèges
  ansible.builtin.file:
    path: /tmp/pp/
    state: directory
    owner: root
  become: true
```


### Bonnes pratiques

* utiliser `become` plutôt que changer d’utilisateur
* attention à l’indentation YAML


## 8 — Gestion des permissions

```yaml
- name: Création avec droits
  ansible.builtin.file:
    path: /tmp/pp/
    state: directory
    owner: root
    group: root
    mode: "0755"
  become: true
```


## 9 — Création récursive

```yaml
- name: Création récursive
  ansible.builtin.file:
    path: /tmp/pp/1/2/3/4
    state: directory
    recurse: true
    owner: root
    group: root
    mode: "0755"
  become: true
```


## 10 — Création d’un fichier (touch)

```yaml
- name: Création fichier
  ansible.builtin.file:
    path: /tmp/pp/1/2/3/4/fichier.txt
    state: touch
    owner: root
    group: root
    mode: "0755"
  become: true
```


## 11 — Lien symbolique

```yaml
- name: Création lien symbolique
  ansible.builtin.file:
    src: /tmp/pp/1/2/3/4/
    dest: /tmp/symlink
    state: link
  become: true
```


### Remarque

* `link` = lien symbolique
* `hard` = lien physique (inode)


## 12 — Suppression de fichier

```yaml
- name: Suppression fichier
  ansible.builtin.file:
    path: /tmp/pp.txt
    state: absent
```


## 13 — Suppression de répertoire

```yaml
- name: Suppression répertoire
  ansible.builtin.file:
    path: /tmp/pp/
    state: absent
```


## 14 — Idempotence

Le module `file` est idempotent :

* ne recrée pas ce qui existe déjà
* n’applique pas de changement inutile
* garantit un état stable


## Bonnes pratiques

* utiliser `ansible.builtin.file` (namespace complet)
* toujours définir `state`
* utiliser `become` pour les opérations système
* définir explicitement les permissions
* tester avec `--check`


## Anti-patterns

* oublier `state`
* utiliser `shell` pour gérer les fichiers
* ne pas gérer les permissions
* exécuter sans contrôle sur des chemins sensibles


## Conclusion

Le module `file` est fondamental dans Ansible.

Il permet :

* de gérer l’état du système
* de garantir la cohérence
* d’appliquer des configurations reproductibles

Sa maîtrise est indispensable pour construire des playbooks propres et fiables.


---

![Ansible](../assets/images/ansible.png) ![Terraform](../assets/images/terraform.png) 

# 13 Ansible - Idempotence Ansible vs Terraform


## Documentation

https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html

Commande utile :

```bash
ansible-doc ansible.builtin.file
```


## Lab associé

[Voir le lab 13-ansible-idempotence](../labs/13-ansible-idempotence/)


## 1 — Notions fondamentales

### Idempotence

L’idempotence est un principe clé d’Ansible.

Une tâche idempotente garantit que :

* l’état final est toujours le même
* plusieurs exécutions ne changent pas le résultat
* aucune action inutile n’est effectuée


### Stateful vs Stateless

Deux concepts importants :

* **stateful** : système avec mémoire de l’état
* **stateless** : système sans mémoire


### Positionnement

* Terraform : idempotent + stateful
* Ansible : idempotent + stateless


## 2 — Différence Ansible vs Terraform

### Terraform

* maintient un fichier `.tfstate`
* connaît l’état de l’infrastructure
* compare état réel vs état attendu

Exemple :

* création d’une VM → ajout dans le state
* suppression du code → Terraform supprime la VM


### Ansible

* ne conserve aucun état
* agit uniquement sur l’état actuel du système

Exemple :

* création d’une VM → Ansible l’exécute
* suppression du code → Ansible ne fait rien


### Résumé

* Terraform : gestion complète du cycle de vie
* Ansible : configuration et orchestration


## 3 — Idempotence avec le module file

### Exemple idempotent

```yaml
- name: touch idempotent
  ansible.builtin.file:
    path: /tmp/pp.txt
    state: touch
    mode: "0755"
    modification_time: preserve
    access_time: preserve
```


### Comportement

* le fichier est créé s’il n’existe pas
* aucune modification si déjà présent
* exécution répétable sans effet


## 4 — Exemple non idempotent

```yaml
- name: touch non idempotent
  ansible.builtin.file:
    path: /tmp/pp/1/2/3
    state: touch
    mode: "0755"
    modification_time: now
    access_time: now
```


### Comportement

* modification à chaque exécution
* timestamp toujours mis à jour
* perte d’idempotence


## 5 — Comprendre l’idempotence

### Idempotence stricte

* état final identique
* aucune modification inutile


### Cas problématiques

Certaines options cassent l’idempotence :

* `modification_time: now`
* `command`
* `shell`
* scripts externes


## 6 — Limites du modèle stateless

### Problème

Ansible ne sait pas :

* ce qu’il a créé auparavant
* ce qui doit être supprimé
* l’état global de l’infrastructure


### Exemple concret

Création d’une VM :

* Terraform : stocke dans `.tfstate`
* Ansible : exécute sans mémoire

Suppression du code :

* Terraform : supprime la VM
* Ansible : ne fait rien


### Conséquence

Avec Ansible :

* il faut gérer explicitement les états
* utiliser des inventaires dynamiques
* structurer correctement les playbooks


## 7 — Bonnes pratiques

* privilégier les modules idempotents
* éviter `shell` et `command`
* utiliser `--check` pour valider
* comprendre l’impact des paramètres
* tester plusieurs exécutions


## 8 — Anti-patterns

* utiliser des actions non idempotentes sans contrôle
* dépendre d’un état implicite
* mélanger provisioning et configuration
* supposer qu’Ansible “se souvient”


## Conclusion

L’idempotence est au cœur d’Ansible.

Cependant :

* Ansible est stateless
* Terraform est stateful

Comprendre cette différence permet :

* d’éviter des erreurs de conception
* de choisir le bon outil
* de construire des automatisations robustes

En pratique :

* Terraform provisionne
* Ansible configure



---

# 14 Ansible - Plateforme dev Docker


## Documentation

https://docs.podman.io/
https://docs.ansible.com/


## Lab associé

[Voir le lab 14-ansible-plateforme-dev-docker](../labs/14-ansible-plateforme-dev-docker/)


## 1 — Objectif de la plateforme

L’objectif de cette plateforme est de fournir un environnement de test Ansible :

* reproductible
* isolé
* automatisé
* proche d’un environnement réel

Elle permet de :

* créer des machines (conteneurs)
* tester des playbooks
* simuler une infrastructure


## 2 — Principe de fonctionnement

La plateforme repose sur :

* Podman (alternative à Docker)
* des conteneurs Debian avec SSH
* un script de provisioning


### Fonctionnement global

1. création de conteneurs
2. configuration SSH
3. ajout d’un utilisateur
4. déploiement des clés SSH
5. génération d’un inventory Ansible


## 3 — Script de déploiement

Le script fourni permet de gérer toute la plateforme :




### Commandes disponibles

```bash
-c <n>   # créer n conteneurs
-i       # afficher les informations (IP + nom)
-s       # démarrer les conteneurs
-t       # arrêter les conteneurs
-d       # supprimer les conteneurs
-a       # générer un inventory Ansible
```


## 4 — Création des conteneurs

### Commande

```bash
./new_deploy.sh -c 3
```


### Comportement

Le script :

* crée des conteneurs Debian
* active systemd
* démarre SSH
* crée un utilisateur
* configure sudo sans mot de passe
* injecte la clé SSH


### Exemple interne

```bash
sudo podman run -d --systemd=true ...
```


## 5 — Configuration des accès SSH

Le script configure automatiquement :

* `~/.ssh/authorized_keys`
* permissions sécurisées
* accès sans mot de passe


### Avantage

Permet à Ansible de fonctionner immédiatement :

```bash
ansible all -m ping
```


## 6 — Gestion des utilisateurs

Chaque conteneur :

* crée un utilisateur identique à l’utilisateur local
* ajoute cet utilisateur dans sudoers


### Configuration sudo

```bash
NOPASSWD: ALL
```


### Avantage

* compatible avec `become`
* pas besoin de mot de passe


## 7 — Génération automatique de l’inventory

### Commande

```bash
./new_deploy.sh -a
```


### Résultat

Création du dossier :

```bash
ansible_dir/
├── 00_inventory.yml
├── group_vars/
└── host_vars/
```


### Exemple d’inventory généré

```yaml
all:
  vars:
    ansible_python_interpreter: /usr/bin/python3
  hosts:
    10.0.0.2:
    10.0.0.3:
```


### Avantage

* pas besoin de créer l’inventory à la main
* prêt à être utilisé immédiatement


## 8 — Gestion du cycle de vie

### Démarrage

```bash
./new_deploy.sh -s
```


### Arrêt

```bash
./new_deploy.sh -t
```


### Suppression

```bash
./new_deploy.sh -d
```


### Inspection

```bash
./new_deploy.sh -i
```

Affiche :

* nom du conteneur
* adresse IP


## 9 — Utilisation avec Ansible

### Test de connectivité

```bash
ansible -i ansible_dir/00_inventory.yml all -m ping
```


### Exécution d’un playbook

```bash
ansible-playbook -i ansible_dir/00_inventory.yml playbook.yml
```


## 10 — Avantages de cette approche

* environnement jetable
* reproductible
* rapide à créer
* idéal pour tests et formation
* compatible CI/CD


## 11 — Limites

* pas un environnement de production
* réseau simplifié
* persistance limitée
* dépendance à Podman/Docker


## 12 — Bonnes pratiques

* recréer les environnements régulièrement
* ne pas tester directement en production
* versionner les scripts
* automatiser la création d’inventory
* utiliser des clés SSH


## 13 — Anti-patterns

* utiliser des environnements manuels
* ne pas automatiser la création
* tester directement en production
* mélanger environnement de test et production


## Conclusion

Cette plateforme permet de :

* simuler une infrastructure
* tester des playbooks
* valider des configurations

Elle constitue une base essentielle pour :

* l’apprentissage
* le développement
* la validation avant production

Elle s’intègre parfaitement dans une démarche DevOps orientée automatisation et reproductibilité.


---

# 15 Ansible - Module user


## Documentation

https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html
Commande utile :

```bash
ansible-doc ansible.builtin.user
```


## Lab associé

[Voir le lab 15-ansible-module-user](../labs/15-ansible-module-user/)


## 1 — Introduction au module user

### Objectif

Le module `user` permet de gérer les utilisateurs système.

Il remplace les commandes Linux :

* `useradd`
* `adduser`
* `userdel`
* `deluser`


### Périmètre

* création d’utilisateur
* suppression
* gestion des groupes
* gestion des mots de passe
* gestion des clés SSH
* gestion des permissions


## 2 — Paramètres principaux

### name

Nom de l’utilisateur :

```yaml
name: pp
```


### state

Définit l’état :

* `present` : créer
* `absent` : supprimer


### password

Mot de passe (hash obligatoire) :

```yaml
password: "{{ 'password' | password_hash('sha512') }}"
```


### uid

Fixer l’UID :

```yaml
uid: 1200
```


### group / groups

* `group` : groupe principal
* `groups` : groupes secondaires

```yaml
groups: sudo
```


### append

Permet d’ajouter sans écraser :

```yaml
append: true
```


### home

Définir la home :

```yaml
home: /home/pp
```


### shell

Définir le shell :

```yaml
shell: /bin/bash
```


### create_home

Créer la home :

```yaml
create_home: true
```


### system

Créer un utilisateur système :

```yaml
system: true
```


### password_lock

Verrouiller le compte :

```yaml
password_lock: true
```


### remove

Supprimer le home avec l’utilisateur :

```yaml
remove: true
```


### generate_ssh_key

Générer une clé SSH :

```yaml
generate_ssh_key: true
```


### ssh_key_type / ssh_key_bits

Configuration de la clé :

```yaml
ssh_key_type: rsa
ssh_key_bits: 2048
```


### expires

Date d’expiration (epoch) :

```bash
date "+%s" -d "10/06/2040 10:00:00"
```


## 3 — Création d’un utilisateur

```yaml
- name: Création de l'utilisateur pp
  ansible.builtin.user:
    name: pp
    state: present
    password: "{{ 'password' | password_hash('sha512') }}"
```


## 4 — Ajout à un groupe

```yaml
- name: Création avec groupe sudo
  ansible.builtin.user:
    name: pp
    state: present
    groups: sudo
    append: true
    password: "{{ 'password' | password_hash('sha512') }}"
```


## 5 — Fixer un UID

```yaml
- name: Création avec UID
  ansible.builtin.user:
    name: pp
    state: present
    uid: 1200
    groups: sudo
    append: true
    password: "{{ 'password' | password_hash('sha512') }}"
```


## 6 — Génération de clé SSH

```yaml
- name: Création avec clé SSH
  ansible.builtin.user:
    name: pp
    state: present
    uid: 1200
    groups: sudo
    append: true
    generate_ssh_key: true
    password: "{{ 'password' | password_hash('sha512') }}"
```


## 7 — Utilisation de register

### Objectif

Récupérer le résultat d’une tâche.


### Exemple

```yaml
- name: Création du user pp
  ansible.builtin.user:
    name: pp
    state: present
    generate_ssh_key: true
    uid: 1200
    groups: sudo
    append: true
    password: "{{ 'password' | password_hash('sha512') }}"
  register: mavar

- name: Affichage du résultat
  ansible.builtin.debug:
    msg: "{{ mavar }}"
```


### Intérêt

* debug
* compréhension des retours Ansible
* exploitation dans d’autres tâches


## 8 — Compte sans login

```yaml
- name: Création user sans login
  ansible.builtin.user:
    name: pp
    state: present
    shell: /sbin/nologin
    generate_ssh_key: true
    uid: 1200
    groups: sudo
    append: true
    password: "{{ 'password' | password_hash('sha512') }}"
    password_lock: true
```


### Cas d’usage

* comptes techniques
* sécurité renforcée


## 9 — Suppression d’un utilisateur

```yaml
- name: Suppression du user pp
  ansible.builtin.user:
    name: pp
    state: absent
```


### Suppression complète

```yaml
- name: Suppression complète
  ansible.builtin.user:
    name: pp
    state: absent
    remove: true
```


## 10 — Bonnes pratiques

* toujours hasher les mots de passe
* utiliser `append: true` pour éviter les pertes
* définir explicitement les groupes
* utiliser `register` pour debug
* privilégier les comptes sans login pour les services
* utiliser `become` si nécessaire


## 11 — Anti-patterns

* utiliser des mots de passe en clair
* écraser les groupes sans append
* ne pas gérer les UID
* créer des utilisateurs sans contrôle
* ne pas sécuriser les comptes techniques


## Conclusion

Le module `user` est essentiel pour :

* gérer les accès
* sécuriser les systèmes
* automatiser l’administration Linux

Il permet une gestion propre, reproductible et idempotente des utilisateurs dans un environnement automatisé.


---

# 16 Ansible - Register - Stat


## Documentation

https://docs.ansible.com/ansible/latest/collections/ansible/builtin/stat_module.html

Commande utile :

```bash
ansible-doc ansible.builtin.stat
```


## Lab associé

[Voir le lab 16-ansible-stat-et-register](../labs/16-ansible-stat-et-register/)


## 1 — Introduction au module stat

### Objectif

Le module `stat` permet d’inspecter un fichier ou un répertoire sur une machine cible.

Il permet notamment de vérifier :

* l’existence
* le type
* les permissions
* le propriétaire
* la checksum
* le type MIME

C’est un module très utile pour :

* faire des vérifications avant action
* conditionner l’exécution d’une tâche
* construire une logique de contrôle dans un playbook


## 2 — Paramètres principaux

### path

Chemin du fichier ou du répertoire à inspecter :

```yaml
path: /tmp/pp.txt
```


### follow

Permet de suivre les liens symboliques :

```yaml
follow: true
```


### get_checksum

Permet de récupérer la checksum du fichier :

```yaml
get_checksum: true
```


### checksum_algorithm

Permet de choisir l’algorithme de hash :

```yaml
checksum_algorithm: sha256
```


### get_mime

Permet de récupérer le type MIME :

```yaml
get_mime: true
```


## 3 — Création d’un fichier

Avant d’utiliser `stat`, on peut créer un fichier de test.

```yaml
- name: Création d'un fichier
  ansible.builtin.file:
    path: /tmp/pp.txt
    state: touch
    owner: pp
```


## 4 — Utilisation simple de stat

```yaml
- name: Vérification avec stat
  ansible.builtin.stat:
    path: /tmp/pp.txt
```

Cette tâche récupère les informations sur le fichier, mais ne les stocke pas encore dans une variable réutilisable.


## 5 — Utilisation de register

### Principe

Le mot-clé `register` permet de stocker le résultat d’une tâche dans une variable.

```yaml
- name: Vérification avec stat
  ansible.builtin.stat:
    path: /tmp/pp.txt
  register: __fichier_pp
```


### Affichage du contenu

```yaml
- name: Affichage du retour complet
  ansible.builtin.debug:
    var: __fichier_pp
```


### Intérêt

`register` permet de :

* récupérer les données retournées par un module
* les afficher pour debug
* les réutiliser dans des conditions


## 6 — Accès à une clé précise

Le module `stat` retourne une structure contenant plusieurs informations.

Pour vérifier si le fichier existe :

```yaml
- name: Vérification de l'existence
  ansible.builtin.debug:
    var: __fichier_pp.stat.exists
```

Autres clés fréquemment utiles :

* `__fichier_pp.stat.exists`
* `__fichier_pp.stat.isdir`
* `__fichier_pp.stat.islnk`
* `__fichier_pp.stat.pw_name`
* `__fichier_pp.stat.mode`


## 7 — Utilisation conditionnelle avec when

Le résultat de `stat` peut être utilisé dans une condition.

```yaml
- name: Création du répertoire pp
  ansible.builtin.file:
    path: /tmp/pp
    state: directory
  when: __fichier_pp.stat.exists
```

Ici, le répertoire n’est créé que si le fichier `/tmp/pp.txt` existe.


## 8 — Exemple complet

```yaml
tasks:
  - name: Création d'un fichier
    ansible.builtin.file:
      path: /tmp/pp.txt
      state: touch
      owner: root
    when: pp_file is defined

  - name: Vérification avec stat
    ansible.builtin.stat:
      path: /tmp/pp.txt
    register: __fichier_pp

  - name: Affichage de l'existence du fichier
    ansible.builtin.debug:
      var: __fichier_pp.stat.exists

  - name: Création du répertoire pp
    ansible.builtin.file:
      path: /tmp/pp
      state: directory
    when: __fichier_pp.stat.exists and pp_file is defined
```


## 9 — Logique de fonctionnement

Dans cet exemple :

1. un fichier est créé seulement si `pp_file` est défini
2. `stat` vérifie ensuite si ce fichier existe
3. `debug` affiche le résultat
4. un répertoire est créé uniquement si :

   * le fichier existe
   * et `pp_file` est défini

Ce schéma est très courant dans les playbooks réels.


## 10 — Cas d’usage fréquents

Le couple `stat` + `register` est très utile pour :

* vérifier si un fichier de configuration existe
* contrôler la présence d’un binaire
* éviter un téléchargement inutile
* lancer une action seulement si une ressource est présente
* vérifier l’état d’un lien symbolique
* contrôler les permissions avant correction


## 11 — Bonnes pratiques

* utiliser `register` avec un nom explicite
* debugger d’abord le retour complet si besoin
* utiliser ensuite une clé précise
* éviter les conditions trop complexes sans debug préalable
* utiliser `stat` avant les opérations sensibles


## 12 — Anti-patterns

* tester l’existence d’un fichier avec `shell` ou `command`
* utiliser une variable `register` mal nommée
* écrire des `when` complexes sans avoir inspecté le retour
* supposer qu’un fichier existe sans vérification


## Conclusion

Le module `stat` permet d’inspecter l’état réel du système.

Associé à `register`, il devient un outil central pour :

* contrôler l’exécution
* fiabiliser les playbooks
* introduire une logique conditionnelle propre

La maîtrise de `stat` et `register` est essentielle pour écrire des automatisations Ansible robustes et maintenables.


---

# 17 Ansible - With item & boucle


## Documentation

https://docs.ansible.com/ansible/latest/collections/ansible/builtin/items_lookup.html

Commande utile :

```bash
ansible-doc -t lookup ansible.builtin.items
```


## Lab associé

[Voir le lab 17-ansible-with-item-et-boucle](../labs/17-ansible-with-item-et-boucle/)


## 1 — Introduction aux boucles

Les boucles permettent de répéter une même tâche sur plusieurs éléments.

Elles sont utilisées pour :

* créer plusieurs fichiers
* parcourir des listes
* parcourir des dictionnaires
* travailler sur des groupes d’hôtes
* éviter la duplication de tâches

Dans les anciens playbooks, on retrouve souvent la syntaxe `with_*`.

Cette syntaxe reste importante à connaître pour :

* lire du code existant
* maintenir des projets plus anciens
* comprendre l’évolution d’Ansible

En pratique moderne, on privilégie souvent `loop`, mais `with_items` et les autres formes historiques restent très répandues.


## 2 — Liste des boucles courantes

Les principales boucles historiques sont :

* `with_items` : parcours d’une liste simple ou d’une liste de dictionnaires
* `with_nested` : croisement de plusieurs listes
* `with_dict` : parcours d’un dictionnaire
* `with_fileglob` : parcours de fichiers via un pattern non récursif
* `with_filetree` : parcours d’une arborescence
* `with_together` : parcours parallèle de plusieurs listes
* `with_sequence` : génération de séquences
* `with_random_choice` : choix aléatoire dans une liste
* `with_first_found` : premier élément trouvé dans une liste
* `with_lines` : parcours ligne par ligne du résultat d’une commande
* `with_ini` : lecture d’un fichier INI
* `with_inventory_hostnames` : parcours des hôtes de l’inventory


## 3 — Boucle simple avec with_items

### Principe

`with_items` permet de parcourir une liste simple.


### Exemple

```yaml
- name: Boucle création de répertoires
  ansible.builtin.file:
    path: /tmp/pp/{{ item }}
    state: directory
    recurse: true
  with_items:
    - pp1
    - pp2
    - pp3
    - pp4
```


### Explication

À chaque itération :

* `item` prend une valeur différente
* un répertoire est créé pour chaque valeur

Résultat attendu :

* `/tmp/pp/pp1`
* `/tmp/pp/pp2`
* `/tmp/pp/pp3`
* `/tmp/pp/pp4`


## 4 — Liste composée avec with_items

### Principe

`with_items` peut aussi parcourir une liste de dictionnaires.


### Exemple

```yaml
- name: Création de fichiers
  ansible.builtin.file:
    path: /tmp/pp/{{ item.dir }}/{{ item.file }}
    state: touch
  with_items:
    - { dir: "pp1", file: "fichierA" }
    - { dir: "pp2", file: "fichierB" }
    - { dir: "pp3", file: "fichierC" }
    - { dir: "pp4", file: "fichierD" }
```


### Explication

Ici, chaque `item` est un dictionnaire contenant :

* `dir`
* `file`

Cela permet de construire des chemins plus riches et plus structurés.


## 5 — Version condensée avec variable

### Principe

On peut externaliser la liste dans une variable pour améliorer la lisibilité.


### Exemple

```yaml
vars:
  fichiers:
    - { dir: "pp1", file: "fichierA" }
    - { dir: "pp2", file: "fichierB" }
    - { dir: "pp3", file: "fichierC" }
    - { dir: "pp4", file: "fichierD" }

tasks:
  - name: Création de fichiers
    ansible.builtin.file:
      path: /tmp/pp/{{ item.dir }}/{{ item.file }}
      state: touch
    with_items: "{{ fichiers }}"
```


### Intérêt

Cette approche permet :

* de mieux séparer données et logique
* de réutiliser la liste ailleurs
* de simplifier les tâches


## 6 — Parcourir les hôtes de l’inventory

### Exemple avec groups

```yaml
with_items:
  - "{{ groups['all'] }}"
```


### Explication

Cette boucle permet de parcourir la liste des hôtes présents dans l’inventory.

Elle est utile pour :

* générer des fichiers par host
* construire des templates
* exécuter des tâches basées sur la structure de l’inventory


## 7 — Version plus simple avec with_inventory_hostnames

### Exemple

```yaml
- name: Création de fichiers
  ansible.builtin.file:
    path: /tmp/{{ item }}
    state: touch
  with_inventory_hostnames:
    - all
```


### Explication

Ici, la boucle parcourt directement les hôtes du groupe `all`.

Cette syntaxe est plus explicite que l’accès manuel à `groups['all']`.


## 8 — Cas d’usage typiques

Les boucles sont très utiles pour :

* créer plusieurs répertoires
* créer plusieurs utilisateurs
* copier plusieurs fichiers
* parcourir des serveurs
* traiter plusieurs entrées de configuration

Elles évitent de dupliquer plusieurs tâches presque identiques.


## 9 — Écriture moderne

Dans les versions modernes d’Ansible, on préfère souvent `loop` à `with_items`.

### Exemple moderne

```yaml
- name: Boucle création de répertoires
  ansible.builtin.file:
    path: /tmp/pp/{{ item }}
    state: directory
    recurse: true
  loop:
    - pp1
    - pp2
    - pp3
    - pp4
```


### Pourquoi privilégier loop

* syntaxe plus homogène
* meilleure lisibilité
* plus cohérent avec les versions récentes d’Ansible


## 10 — Bonnes pratiques

* privilégier `loop` dans les nouveaux playbooks
* garder `with_*` pour comprendre ou maintenir l’existant
* externaliser les listes complexes dans des variables
* utiliser des noms de variables explicites
* éviter les boucles trop complexes dans une seule tâche


## 11 — Anti-patterns

* dupliquer manuellement plusieurs tâches identiques
* imbriquer trop de boucles sans lisibilité
* mélanger données et logique de manière confuse
* utiliser des structures de données non documentées
* ne pas tester le résultat d’une boucle complexe


## Conclusion

Les boucles sont une fonctionnalité essentielle d’Ansible.

Elles permettent de :

* factoriser les tâches
* simplifier les playbooks
* gérer plusieurs objets de manière propre

La compréhension de `with_items` et des autres formes historiques reste importante, même si les développements récents privilégient désormais `loop`.


---

# 18 Ansible - Module APT


## Documentation

https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html

Commande utile :

```bash
ansible-doc ansible.builtin.apt
```


## Lab associé

[Voir le lab 18-ansible-module-apt](../labs/18-ansible-module-apt/)


## 1 — Introduction au module apt

### Objectif

Le module `apt` permet de gérer les paquets sur les systèmes Debian / Ubuntu.

Il remplace les commandes :

* `apt`
* `apt-get`
* `dpkg`


### Périmètre

* installation de paquets
* mise à jour
* suppression
* gestion du cache
* gestion des versions


## 2 — Paramètres principaux

### name

Nom du paquet :

```yaml
name: haproxy
```


### state

Définit l’état du paquet :

* `present` : installé
* `absent` : supprimé
* `latest` : dernière version
* `fixed` : réparer les dépendances
* `build-dep` : dépendances de build


### update_cache

Met à jour le cache APT :

```yaml
update_cache: true
```


### cache_valid_time

Durée de validité du cache (en secondes) :

```yaml
cache_valid_time: 3600
```


### upgrade

Gestion des upgrades :

* `yes`
* `safe`
* `dist`
* `full`


### purge

Supprime aussi les fichiers de configuration :

```yaml
purge: true
```


### autoremove

Supprime les dépendances inutiles :

```yaml
autoremove: true
```


### default_release

Permet d’utiliser une version spécifique :

```yaml
default_release: stretch-backports
```


### force / allow_unauthenticated

Options avancées :

* installation sans vérification
* désactivation des signatures

À utiliser avec précaution.


### install_recommends

Activer ou non les paquets recommandés :

```yaml
install_recommends: false
```


## 3 — Mise à jour du cache

```yaml
- name: Mise à jour du cache APT
  ansible.builtin.apt:
    update_cache: true
    cache_valid_time: 3600
```


### Explication

* évite de refaire un `apt update` inutilement
* améliore les performances


## 4 — Installation d’un paquet

```yaml
- name: Installation de haproxy
  ansible.builtin.apt:
    name: haproxy
    state: present
    update_cache: true
    cache_valid_time: 60
```


## 5 — Installation avec version spécifique

```yaml
- name: Installation depuis backports
  ansible.builtin.apt:
    name: haproxy
    default_release: stretch-backports
    update_cache: true
    cache_valid_time: 60
```


### Commandes utiles côté système

```bash
apt list -a haproxy
apt list -i haproxy
```


## 6 — Mise à jour d’un paquet

```yaml
- name: Mise à jour de haproxy
  ansible.builtin.apt:
    name: haproxy
    state: latest
    update_cache: true
    cache_valid_time: 60
```


## 7 — Suppression d’un paquet

```yaml
- name: Suppression de haproxy
  ansible.builtin.apt:
    name: haproxy
    state: absent
```


## 8 — Suppression complète

```yaml
- name: Suppression complète de haproxy
  ansible.builtin.apt:
    name: haproxy
    state: absent
    purge: true
    autoremove: true
```


## 9 — Bonnes pratiques

* toujours utiliser `update_cache` avec `cache_valid_time`
* éviter les mises à jour inutiles
* utiliser `state: present` pour installation stable
* utiliser `state: latest` avec prudence en production
* toujours tester avec `--check`


## 10 — Anti-patterns

* lancer `apt update` à chaque tâche
* utiliser `shell` pour installer des paquets
* utiliser `latest` sans contrôle
* désactiver la sécurité des paquets sans raison
* ne pas gérer les dépendances


## Conclusion

Le module `apt` est essentiel pour :

* gérer les paquets
* automatiser les installations
* maintenir les systèmes à jour

Il permet une gestion idempotente et propre des paquets dans les environnements Debian et Ubuntu.

Sa maîtrise est indispensable pour tout projet Ansible en production.


---

# 19 Ansible - Check & Reboot


## Documentation

https://docs.ansible.com/ansible/latest/collections/ansible/builtin/reboot_module.html

Commande utile :

```bash
ansible-doc ansible.builtin.reboot
```


## Lab associé

[Voir le lab 19-ansible-check-et-reboot](../labs/19-ansible-check-et-reboot/)


## 1 — Introduction au module reboot

### Objectif

Le module `reboot` permet de :

* redémarrer une machine
* attendre son retour en ligne
* vérifier que le système est opérationnel

Il est essentiel pour :

* mises à jour système
* changements critiques (kernel, config)
* automatisations nécessitant un reboot contrôlé


## 2 — Principe de fonctionnement

Contrairement à un simple `shutdown -r`, le module :

* déclenche le reboot
* attend la coupure de connexion
* attend le retour SSH
* exécute une commande de test

Cela garantit que :

* la machine est bien redémarrée
* elle est prête à recevoir des tâches suivantes


## 3 — Paramètres principaux

### msg

Message affiché avant reboot :

```yaml
msg: "Reboot via ansible"
```


### connect_timeout

Timeout de connexion SSH :

```yaml
connect_timeout: 5
```


### reboot_timeout

Temps maximum pour le reboot :

```yaml
reboot_timeout: 300
```


### pre_reboot_delay

Délai avant reboot :

```yaml
pre_reboot_delay: 0
```


### post_reboot_delay

Délai après reboot :

```yaml
post_reboot_delay: 30
```


### test_command

Commande utilisée pour valider le reboot :

```yaml
test_command: uptime
```


### boot_time_command

Permet de vérifier que le reboot est effectif via un identifiant système.


## 4 — Exemple simple avec condition

### Playbook

```yaml
- name: Mon premier playbook
  hosts: all
  remote_user: vagrant
  become: true
  tasks:

    - name: Création fichier
      ansible.builtin.file:
        path: /tmp/pp.txt
        state: touch

    - name: Vérification du fichier
      ansible.builtin.stat:
        path: /tmp/pp.txt
      register: __file_exist

    - name: Reboot conditionnel
      ansible.builtin.reboot:
        msg: "Reboot via ansible"
        connect_timeout: 5
        reboot_timeout: 300
        pre_reboot_delay: 0
        post_reboot_delay: 30
        test_command: uptime
      when: __file_exist.stat.exists

    - name: Création second fichier
      ansible.builtin.file:
        path: /tmp/pp2.txt
        state: touch
```


### Explication

1. création d’un fichier
2. vérification avec `stat`
3. reboot seulement si le fichier existe
4. reprise normale du playbook après reboot


## 5 — Cas réel : reboot après mise à jour

### Mise à jour système

```yaml
- name: Mise à jour du cache
  ansible.builtin.apt:
    update_cache: true
    force_apt_get: true
    cache_valid_time: 3600

- name: Upgrade système
  ansible.builtin.apt:
    upgrade: dist
    force_apt_get: true
```


### Vérification reboot requis

```yaml
- name: Vérification reboot requis
  ansible.builtin.stat:
    path: /var/run/reboot-required
  register: reboot_required_file
```


### Reboot conditionnel

```yaml
- name: Reboot si nécessaire
  ansible.builtin.reboot:
    msg: "Reboot via ansible"
    connect_timeout: 5
    reboot_timeout: 300
    pre_reboot_delay: 0
    post_reboot_delay: 30
    test_command: uptime
  when: reboot_required_file.stat.exists
```


### Explication

* Debian/Ubuntu crée `/var/run/reboot-required` si reboot nécessaire
* `stat` vérifie sa présence
* reboot uniquement si nécessaire


## 6 — Logique complète

Workflow typique :

1. mise à jour système
2. vérification du besoin de reboot
3. reboot conditionnel
4. reprise automatique du playbook


## 7 — Bonnes pratiques

* toujours utiliser `reboot` au lieu de `shell`
* utiliser `stat` pour conditionner
* définir un `test_command`
* prévoir des timeouts adaptés
* éviter les reboot inutiles


## 8 — Anti-patterns

* reboot sans condition
* utiliser `command` ou `shell` pour reboot
* ne pas attendre le retour de la machine
* enchaîner des tâches sans validation post-reboot
* oublier les timeouts


## Conclusion

Le module `reboot` permet de gérer proprement les redémarrages.

Associé à `stat`, il permet :

* des reboots intelligents
* des playbooks robustes
* une automatisation fiable

Il est indispensable dans les scénarios :

* mise à jour système
* déploiement critique
* gestion d’infrastructure automatisée


---

# 20 Ansible - SSH Key & User


## Documentation

https://docs.ansible.com/ansible/latest/collections/ansible/posix/authorized_key_module.html
https://docs.ansible.com/ansible/latest/collections/community/crypto/openssh_keypair_module.html

Commande utile :

```bash
ansible-doc ansible.posix.authorized_key
ansible-doc community.crypto.openssh_keypair
```


## Lab associé

[Voir le lab 20-ansible-ssh-key-et-user](../labs/20-ansible-ssh-key-et-user/)


## 1 — Objectif

L’objectif est de :

* générer une clé SSH
* déployer cette clé sur un utilisateur
* permettre une connexion sans mot de passe


## 2 — Principe

Le workflow classique est :

1. générer une clé SSH (contrôleur)
2. créer un utilisateur cible
3. déployer la clé publique
4. autoriser l’accès SSH


### Point critique

Toujours se poser :

* où est générée la clé ?
* sur quelle machine ?
* pour quel utilisateur ?


## 3 — Module openssh_keypair

### Objectif

Permet de générer une paire de clés SSH.


### Paramètres principaux

#### path

Chemin de la clé :

```yaml
path: /tmp/pp
```


#### type

Type de clé :

* rsa
* ecdsa
* ed25519


#### size

Taille de la clé :

```yaml
size: 4096
```


#### state

* `present`
* `absent`


#### force

Regénère la clé si elle existe :

```yaml
force: true
```


#### regenerate

Gestion avancée :

* `never`
* `fail`
* `partial_idempotence`
* `full_idempotence`
* `always`


#### owner / group / mode

Gestion des permissions :

```yaml
owner: user
mode: "0600"
```


## 4 — Génération de clé SSH

```yaml
- name: Génération de clé SSH
  community.crypto.openssh_keypair:
    path: /tmp/pp
    type: rsa
    size: 4096
    state: present
    force: false
  run_once: true
  delegate_to: localhost
```


### Explication

* `run_once` : exécuté une seule fois
* `delegate_to: localhost` : exécuté sur la machine de contrôle


## 5 — Module authorized_key

### Objectif

Permet d’ajouter une clé publique dans `authorized_keys`.


### Paramètres principaux

#### user

Utilisateur cible :

```yaml
user: devops
```


#### key

Contenu de la clé :

```yaml
key: "{{ lookup('file', '/tmp/pp.pub') }}"
```


#### state

* `present`
* `absent`


#### exclusive

Supprime les autres clés :

```yaml
exclusive: true
```


#### manage_dir

Gère automatiquement `.ssh` :

```yaml
manage_dir: true
```


#### path

Permet de définir un chemin personnalisé.


## 6 — Création d’un utilisateur

```yaml
- name: Création du user devops
  ansible.builtin.user:
    name: devops
    shell: /bin/bash
    groups: sudo
    append: true
    password: "{{ 'password' | password_hash('sha512') }}"
  become: true
```


## 7 — Ajout au sudoers

```yaml
- name: Ajout au sudoers
  ansible.builtin.copy:
    dest: "/etc/sudoers.d/devops"
    content: "devops ALL=(ALL) NOPASSWD: ALL"
  become: true
```


## 8 — Déploiement de la clé SSH

```yaml
- name: Déploiement de la clé SSH
  ansible.posix.authorized_key:
    user: devops
    key: "{{ lookup('file', '/tmp/pp.pub') }}"
    state: present
  become: true
```


## 9 — Mode exclusif

### Objectif

Supprimer toutes les autres clés et ne garder que celles définies.


### Exemple

```yaml
- name: Définir une clé unique
  ansible.posix.authorized_key:
    user: root
    key: "{{ item }}"
    state: present
    exclusive: true
  with_file:
    - public_keys/doe-jane
```


### Attention

* ne pas utiliser `exclusive` avec une boucle classique
* privilégier un fichier contenant toutes les clés


## 10 — Workflow complet

1. génération de la clé sur le contrôleur
2. création de l’utilisateur cible
3. configuration sudo
4. déploiement de la clé publique
5. connexion SSH sans mot de passe


## 11 — Bonnes pratiques

* générer les clés côté contrôleur
* sécuriser les permissions (`0600`)
* utiliser `delegate_to`
* utiliser `run_once`
* éviter les mots de passe SSH
* utiliser `exclusive` avec précaution


## 12 — Anti-patterns

* générer des clés sur les hosts sans contrôle
* stocker des clés privées dans des dépôts
* utiliser des permissions incorrectes
* ne pas contrôler les accès sudo
* écraser les clés sans vérifier


## Conclusion

La gestion des clés SSH est essentielle pour :

* sécuriser les accès
* automatiser les connexions
* faciliter l’utilisation d’Ansible

Le couple `openssh_keypair` + `authorized_key` permet :

* une gestion propre
* une automatisation complète
* une infrastructure sécurisée


---

# 21 Ansible - Delegate, run_once, local


## Documentation

https://docs.ansible.com/ansible/2.3/playbooks_delegation.html

Commande utile :

```bash id="d8k1qm"
ansible-doc -t keyword delegate_to
ansible-doc -t keyword run_once
```


## Lab associé

[Voir le lab 21-ansible-module-delegate-to-et-localhost](../labs/21-ansible-module-delegate-to-et-localhost/)


## 1 — Objectif

Cette partie permet de comprendre comment :

* exécuter une tâche sur une autre machine que l’hôte courant
* exécuter une tâche une seule fois
* exécuter des tâches localement

Ces mécanismes sont utiles pour :

* génération de fichiers centralisés
* appels API depuis le contrôleur
* orchestration primaire / secondaire
* opérations locales avant ou après déploiement


## 2 — delegate_to

### Principe

Le mot-clé `delegate_to` permet de déléguer une tâche à un autre hôte identifié.

La play cible un ensemble d’hôtes, mais la tâche est exécutée sur une autre machine.


### Exemple simple

```yaml id="uxq4xo"
- name: Premier playbook
  hosts: all
  tasks:
    - name: Création de fichier
      ansible.builtin.file:
        state: touch
        path: /tmp/pp.txt
      delegate_to: localhost
```


### Explication

Ici :

* la play cible `all`
* la tâche est exécutée sur `localhost`


### Point d’attention

Si la play cible plusieurs hôtes :

* la tâche sera exécutée une fois par hôte
* même si elle est déléguée à `localhost`

Cela peut produire plusieurs exécutions identiques.


## 3 — Variables et contexte avec delegate_to

### Exemple

```yaml id="3gou09"
- name: Premier playbook
  hosts: all
  tasks:
    - name: Debug sur l’hôte courant
      ansible.builtin.debug:
        var: var1

    - name: Debug délégué à localhost
      ansible.builtin.debug:
        var: var1
      delegate_to: localhost
```


### Explication

Même si la tâche est exécutée sur `localhost`, le contexte des variables reste lié à l’hôte courant de la boucle de play, sauf cas particuliers.

Il faut donc bien distinguer :

* la machine d’exécution de la tâche
* l’hôte logique en cours de traitement

C’est un point important pour éviter les erreurs de compréhension.


## 4 — run_once

### Principe

Le mot-clé `run_once` permet d’exécuter une tâche une seule fois, même si la play cible plusieurs hôtes.


### Exemple

```yaml id="f5c0he"
- name: Création de fichier unique
  ansible.builtin.file:
    state: touch
    path: /tmp/pp.txt
  delegate_to: localhost
  run_once: true
```


### Explication

Cette combinaison est très utile quand on veut :

* générer un fichier une seule fois
* télécharger une ressource une seule fois
* lancer une opération centrale unique


## 5 — Cas d’usage typiques de delegate_to + run_once

Exemples courants :

* génération d’un certificat sur le contrôleur
* téléchargement unique d’un paquet
* création d’un inventaire dynamique
* appel API externe centralisé
* génération d’un fichier partagé avant distribution


## 6 — local_action

### Principe

`local_action` est une syntaxe plus ancienne permettant de forcer une exécution locale.


### Exemple

```yaml id="7b9crv"
tasks:
  - name: Action locale
    local_action: "command touch /tmp/pp2.txt"
```


### Explication

Cette syntaxe est utile pour les anciens playbooks, mais dans les versions modernes on préfère généralement :

* `delegate_to: localhost`
* ou `connection: local`


## 7 — Exécution locale sans SSH

### Principe

On peut exécuter une play directement sur la machine locale, sans SSH.


### Exemple

```yaml id="9m1x8x"
- name: Premier playbook
  hosts: localhost
  connection: local
  tasks:
    - name: Action locale
      ansible.builtin.file:
        state: touch
        path: /tmp/pp3.txt
```


### Explication

Ici :

* la cible est `localhost`
* aucune connexion SSH n’est utilisée
* l’exécution se fait directement localement


## 8 — Différences entre les approches

### delegate_to: localhost

* utile dans une play ciblant des hôtes distants
* délègue seulement certaines tâches


### local_action

* ancienne syntaxe
* pratique à lire dans du code existant


### hosts: localhost + connection: local

* utile pour une play entièrement locale
* pas adapté si seule une tâche doit être locale


## 9 — Cas d’usage réels

### Génération locale d’un fichier avant distribution

* génération sur le contrôleur
* copie sur les hôtes ensuite

### Appel à une API externe

* exécution locale sur le contrôleur
* résultat réutilisé pour les hôtes distants

### Gestion primaire / secondaire

* exécuter certaines tâches uniquement sur un nœud particulier
* utiliser `delegate_to` pour centraliser les opérations critiques


## 10 — Bonnes pratiques

* utiliser `delegate_to` pour les actions centralisées
* ajouter `run_once` si une tâche ne doit s’exécuter qu’une seule fois
* utiliser `connection: local` pour une play entièrement locale
* documenter clairement où s’exécute la tâche
* faire attention au contexte des variables


## 11 — Anti-patterns

* déléguer une tâche sans comprendre qu’elle sera répétée pour chaque host
* oublier `run_once` sur une tâche centrale
* mélanger logique locale et distante sans clarté
* supposer que le contexte des variables change automatiquement avec `delegate_to`


## Conclusion

`delegate_to`, `run_once` et `connection: local` sont des mécanismes essentiels pour structurer des automatisations avancées.

Ils permettent :

* de centraliser certaines actions
* d’éviter les répétitions inutiles
* de mieux organiser les workflows d’orchestration

Leur bonne maîtrise est indispensable pour les playbooks orientés production, particulièrement dans les scénarios de coordination ou d’exécution hybride local / distant.



---

# 22 Ansible - Module COPY


## Documentation

https://docs.ansible.com/ansible/2.5/modules/copy_module.html

Commande utile :

```bash id="3gx6sb"
ansible-doc ansible.builtin.copy
```


## Lab associé

[Voir le lab 22-ansible-module-copy](../labs/22-ansible-module-copy/)


## 1 — Introduction au module copy

### Objectif

Le module `copy` permet de copier :

* des fichiers
* des répertoires
* du contenu généré dynamiquement

Il joue un rôle proche de `scp`, mais avec les avantages d’Ansible :

* idempotence
* gestion des permissions
* validation
* intégration aux playbooks


## 2 — Paramètres principaux

### src

Chemin du fichier source.

```yaml id="6r5p5u"
src: test.txt
```

Point d’attention :

* le chemin dépend du contexte d’exécution
* dans un rôle, Ansible cherche souvent dans `files/`


### dest

Chemin du fichier destination sur la machine cible.

```yaml id="akgiem"
dest: /tmp/pp.txt
```


### owner / group

Définir le propriétaire et le groupe :

```yaml id="qw9ww7"
owner: root
group: root
```


### mode

Définir les permissions :

```yaml id="0cghuh"
mode: "0644"
```


### backup

Créer une sauvegarde datée avant remplacement :

```yaml id="79vjlwm"
backup: true
```


### force

Contrôle le remplacement si le fichier existe déjà :

```yaml id="7pnjlwm"
force: false
```


### content

Permet de copier directement du texte ou une variable sans fichier source.

```yaml id="kx2m52"
content: "Hello world"
```


### remote_src

Contrôle l’origine de la source :

* `false` : copie depuis le contrôleur
* `true` : copie depuis la machine cible


### validate

Permet de valider le fichier avant écriture définitive.

Le fichier temporaire est injecté à la place de `%s`.

```yaml id="im9sf4"
validate: /usr/bin/nginx -t -c %s
```


## 3 — Copie simple

```yaml id="k1j2ul"
tasks:
  - name: Copie simple
    ansible.builtin.copy:
      src: test.txt
      dest: /tmp/pp.txt
```


### Remarque

Il faut faire attention à la localisation de la source :

* fichier courant
* rôle
* répertoire `files/`


## 4 — Contrôle du remplacement

```yaml id="0jlwm4"
tasks:
  - name: Copie sans écrasement forcé
    ansible.builtin.copy:
      src: test.txt
      dest: /tmp/pp.txt
      force: false
```


### Explication

Si le fichier existe déjà, Ansible ne le remplace pas automatiquement si `force: false`.


## 5 — Copie récursive

### Préparation

```bash id="n7m2oh"
mkdir -p tmp/pp/{1,2,3}
```


### Tâche

```yaml id="zc4i3k"
- name: Copie récursive
  ansible.builtin.copy:
    src: tmp/
    dest: /tmp/
```


### Explication

Cette syntaxe permet de copier un répertoire complet vers la cible.


## 6 — Copie depuis la cible avec remote_src

```yaml id="y8p0q0"
- name: Déplacement local sur la cible
  ansible.builtin.copy:
    src: /home/pp
    dest: /tmp/
    remote_src: true
```


### Explication

Ici :

* la source n’est pas sur le contrôleur
* elle est déjà présente sur la machine cible


## 7 — Combinaison avec boucle

```yaml id="2e2nco"
vars:
  mesfichiers:
    - { source: "pp1.txt", destination: "/tmp/{{ ansible_hostname }}_pp1.txt", permission: "0755" }
    - { source: "pp2.txt", destination: "/home/pp/{{ ansible_hostname }}_pp2.txt", permission: "0644" }

tasks:
  - name: Copie de plusieurs fichiers
    ansible.builtin.copy:
      src: "{{ item.source }}"
      dest: "{{ item.destination }}"
      mode: "{{ item.permission }}"
    with_items: "{{ mesfichiers }}"
```


### Intérêt

Permet de :

* copier plusieurs fichiers
* personnaliser les destinations
* adapter les permissions


## 8 — Utilisation de patterns

```yaml id="4e68vz"
- name: Copie avec pattern
  ansible.builtin.copy:
    src: "{{ item }}"
    dest: /tmp/
  with_fileglob:
    - xavk*
```


### Explication

Cette approche permet de parcourir tous les fichiers correspondant à un motif.


## 9 — Copie avec backup

```yaml id="92urhm"
- name: Copie avec sauvegarde
  ansible.builtin.copy:
    src: "{{ item }}"
    dest: /tmp/
    backup: true
  with_fileglob:
    - xavk*
```


### Intérêt

En cas de modification d’un fichier existant :

* Ansible garde une copie précédente
* utile pour rollback ou audit


## 10 — Copie de contenu brut

```yaml id="8n82um"
- name: Copie de contenu généré
  ansible.builtin.copy:
    content: |
      Salut
      la team !!
      on est sur {{ ansible_hostname }}
    dest: /tmp/hello.txt
```


### Cas d’usage

* fichier simple
* message généré
* configuration très légère

Si le contenu devient complexe, il est préférable d’utiliser `template`.


## 11 — Validation avant copie

### Exemple avec nginx

```yaml id="qs3t3k"
- name: Copie du fichier nginx.conf avec validation
  ansible.builtin.copy:
    src: nginx.conf
    dest: /etc/nginx/nginx.conf
    owner: root
    group: root
    mode: "0644"
    validate: /usr/bin/nginx -t -c %s
```


### Exemple avec sudoers

```yaml id="3j9hn7"
- name: Ajout du fichier sudoers devops
  ansible.builtin.copy:
    dest: /etc/sudoers.d/devops
    content: "pp ALL=(ALL) NOPASSWD: ALL"
    owner: root
    group: root
    mode: "0400"
    validate: /usr/sbin/visudo -cf %s
  become: true
```


### Exemple volontairement invalide

```yaml id="cr2vlh"
- name: Test de validation sudoers invalide
  ansible.builtin.copy:
    dest: /etc/sudoers.d/devops
    content: "pp ALL=(ALL) AAAAA: ALL"
    owner: root
    group: root
    mode: "0400"
    validate: /usr/sbin/visudo -cf %s
  become: true
```


### Explication

Dans ce cas :

* la validation échoue
* le fichier n’est pas copié
* on évite de casser une configuration critique


## 12 — Bonnes pratiques

* utiliser le namespace complet `ansible.builtin.copy`
* définir explicitement `owner`, `group` et `mode`
* utiliser `validate` pour les fichiers sensibles
* préférer `template` si du Jinja est nécessaire
* utiliser `backup` sur les fichiers critiques
* bien comprendre le rôle de `remote_src`


## 13 — Anti-patterns

* utiliser `copy` pour des fichiers fortement templatisés
* ne pas valider un fichier système critique
* oublier les permissions
* confondre source locale et source distante
* copier des fichiers sensibles sans contrôle


## Conclusion

Le module `copy` est fondamental dans Ansible.

Il permet :

* de distribuer des fichiers
* de générer du contenu simple
* de gérer les permissions
* de sécuriser les changements avec validation

Sa maîtrise est essentielle pour construire des playbooks fiables et sûrs.


---

# 23 Ansible - Module FETCH


## Documentation

https://docs.ansible.com/ansible/latest/collections/ansible/builtin/fetch_module.html

Commande utile :

```bash id="svt8qj"
ansible-doc ansible.builtin.fetch
```


## Lab associé

[Voir le lab 23-ansible-module-fetch](../labs/23-ansible-module-fetch/)


## 1 — Introduction au module fetch

### Objectif

Le module `fetch` permet de récupérer des fichiers depuis les machines cibles vers la machine de contrôle.

Il joue un rôle proche de `scp`, mais dans le sens inverse du module `copy` :

* `copy` : contrôleur vers cible
* `fetch` : cible vers contrôleur


### Cas d’usage

Le module `fetch` est utile pour :

* récupérer des fichiers de configuration
* collecter des logs
* sauvegarder des fichiers distants
* centraliser des informations système
* préparer des audits


## 2 — Paramètres principaux

### src

Chemin du fichier sur la machine cible :

```yaml id="qcf1hd"
src: /etc/hosts
```


### dest

Chemin de destination sur la machine de contrôle :

```yaml id="n55hkp"
dest: tmp/
```


### flat

Contrôle la structure du fichier récupéré :

* `false` : conserve une arborescence par hôte
* `true` : écrit directement à l’emplacement demandé

```yaml id="3x3fvl"
flat: true
```


### fail_on_missing

Définit si Ansible doit échouer si le fichier source n’existe pas :

```yaml id="1jzepi"
fail_on_missing: true
```

Valeur par défaut : `true`


### validate_checksum

Valide l’intégrité du fichier récupéré :

```yaml id="i2d5if"
validate_checksum: true
```


## 3 — Exemple simple

```yaml id="txzgmn"
- name: Récupération simple
  ansible.builtin.fetch:
    src: /etc/hosts
    dest: tmp/
```


### Explication

Dans ce cas, Ansible crée une structure de destination contenant le nom de l’hôte.

Le fichier ne sera pas copié directement en `tmp/hosts`, mais dans une arborescence liée à l’hôte.


## 4 — Destination précise

```yaml id="u11b4x"
- name: Récupération avec destination précise
  ansible.builtin.fetch:
    src: /etc/hosts
    dest: tmp/hosts_{{ ansible_hostname }}.txt
```


### Point d’attention

Sans `flat: true`, Ansible peut quand même recréer une structure interne selon le contexte.

Il faut donc bien comprendre le comportement attendu avant usage.


## 5 — Utilisation de flat

```yaml id="yqsm3l"
- name: Récupération avec flat
  ansible.builtin.fetch:
    src: /etc/hosts
    dest: tmp/hosts_{{ ansible_hostname }}.txt
    flat: true
```


### Explication

Avec `flat: true` :

* le fichier est écrit exactement à l’emplacement demandé
* il n’y a pas de sous-répertoire supplémentaire


### Attention

Si plusieurs hôtes écrivent dans le même fichier avec `flat: true`, les résultats peuvent s’écraser.

Il est donc recommandé d’utiliser :

* `{{ inventory_hostname }}`
* ou `{{ ansible_hostname }}`

dans le nom du fichier de destination.


## 6 — Exemple pratique : centralisation avec Nginx

Cet exemple montre comment :

1. préparer localement un répertoire de publication
2. récupérer les fichiers distants
3. les exposer via Nginx


### Préparation locale

```yaml id="yrxvh4"
- name: Préparation locale
  hosts: localhost
  connection: local
  become: true
  tasks:
    - name: Installation de nginx
      ansible.builtin.apt:
        name: nginx
        state: present

    - name: Nettoyage du répertoire web
      ansible.builtin.file:
        path: "{{ item }}"
        state: absent
      with_fileglob:
        - /var/www/html/*.html
```


### Collecte des fichiers

```yaml id="zi1n0c"
- name: Récupération des fichiers distants
  hosts: all
  tasks:
    - name: Fetch du fichier hosts
      ansible.builtin.fetch:
        src: /etc/hosts
        dest: /var/www/html/hosts_{{ ansible_hostname }}.txt
        flat: true
```


### Configuration Nginx utile

```nginx id="mhl6vl"
autoindex on;
autoindex_exact_size off;
```


### Explication

Cette approche permet de :

* collecter les fichiers depuis tous les hosts
* les centraliser localement
* les exposer via un serveur web

C’est utile pour :

* debug
* inventaire
* audit
* centralisation légère


## 7 — Différence avec copy

### copy

* source locale
* destination distante

### fetch

* source distante
* destination locale

Leur usage est complémentaire.


## 8 — Bonnes pratiques

* utiliser `flat: true` avec un nom de fichier unique par hôte
* activer la validation par checksum si nécessaire
* anticiper l’échec si le fichier n’existe pas
* organiser clairement les fichiers récupérés
* utiliser `fetch` pour la collecte et l’audit


## 9 — Anti-patterns

* utiliser `flat: true` sans différencier les noms de fichiers
* écraser les résultats de plusieurs hôtes
* supposer que `fetch` fonctionne comme `copy`
* ne pas vérifier si le fichier source existe
* collecter des fichiers sensibles sans contrôle


## Conclusion

Le module `fetch` permet de récupérer proprement des fichiers depuis les machines cibles vers la machine de contrôle.

Il est particulièrement utile pour :

* la collecte d’informations
* la centralisation de fichiers
* le debug
* l’audit

Sa bonne utilisation repose surtout sur une bonne compréhension de :

* la destination
* le comportement de `flat`
* la gestion des noms de fichiers en environnement multi-hôtes


---

# 24 Ansible - Module TEMPLATE


## Documentation

https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html

Commande utile :

```bash id="gx9l2m"
ansible-doc ansible.builtin.template
```


## Lab associé

[Voir le lab 24-ansible-module-template](../labs/24-ansible-module-template/)


## 1 — Introduction au module template

### Objectif

Le module `template` permet de générer un fichier à partir d’un modèle Jinja2.

Il est utilisé pour :

* produire des fichiers de configuration
* injecter des variables
* adapter le contenu à l’hôte ou à l’environnement
* factoriser des fichiers similaires


### Différence avec copy

* `copy` : envoie un fichier tel quel
* `template` : génère le fichier avant de l’envoyer

Le module `template` est donc adapté quand le contenu dépend :

* de variables
* d’un environnement
* d’une liste
* d’une logique Jinja2


## 2 — Paramètres principaux

### src

Chemin du template source :

```yaml id="3l1gik"
src: montemplate.txt.j2
```

Point d’attention :

* en rôle, Ansible cherche souvent dans `templates/`
* hors rôle, le chemin dépend du contexte du playbook


### dest

Chemin du fichier généré sur la machine cible :

```yaml id="uwq7k9"
dest: /tmp/hello.txt
```


### owner / group

Définir le propriétaire et le groupe :

```yaml id="gip5hv"
owner: pp
group: pp
```


### mode

Définir les permissions :

```yaml id="z76jm3"
mode: "0755"
```


### backup

Créer une sauvegarde avant modification :

```yaml id="gk1vt1"
backup: true
```


### validate

Valider le fichier avant remplacement définitif :

```yaml id="alr44k"
validate: /usr/bin/nginx -t -c %s
```


### force

Contrôle l’écrasement du fichier destination :

```yaml id="01886m"
force: true
```


### trim_blocks / lstrip_blocks

Permettent d’ajuster le rendu des blocs Jinja2 :

```jinja2 id="bnwzi9"
#jinja2:lstrip_blocks: True
```

Utiles pour contrôler :

* l’indentation
* les espaces
* les retours à la ligne


### variable_start_string / variable_end_string

Permettent de changer les délimiteurs des variables si nécessaire.


### block_start_string / block_end_string

Permettent de changer les délimiteurs des blocs Jinja2.


## 3 — Exemple simple

### Playbook

```yaml id="rbew09"
- name: Préparation locale
  hosts: all
  vars:
    var1: "pp !!!"
  tasks:
    - name: Génération du fichier
      ansible.builtin.template:
        src: montemplate.txt.j2
        dest: /tmp/hello.txt
```


### Template

```jinja2 id="e89hvb"
Hello {{ var1 }}
```


### Explication

Le fichier final généré sur la cible contiendra :

```text id="kus2un"
Hello pp !!!
```


## 4 — Variables utiles dans un template

Ansible met à disposition plusieurs variables utiles dans les templates :

* `ansible_managed`
* `template_host`
* `template_uid`
* `template_path`
* `template_fullpath`
* `template_run_date`


### Exemple d’en-tête

```jinja2 id="hzzmn8"
#{{ template_run_date }} - "{{ ansible_managed }}" via {{ template_uid }}@{{ template_host }}
```


### Intérêt

Cela permet :

* de documenter le fichier généré
* d’indiquer son origine
* de faciliter l’audit


## 5 — Gestion des permissions

```yaml id="nw58lx"
- name: Génération avec permissions
  ansible.builtin.template:
    src: montemplate.txt.j2
    dest: /tmp/hello.txt
    owner: pp
    group: pp
    mode: "0755"
```


## 6 — Sauvegarde avant modification

```yaml id="jlwmwu"
- name: Génération avec backup
  ansible.builtin.template:
    src: montemplate.txt.j2
    dest: /tmp/hello.txt
    owner: pp
    group: pp
    mode: "0755"
    backup: true
```


### Intérêt

Permet de conserver l’ancienne version du fichier avant remplacement.


## 7 — Génération d’un fichier par itération

### Playbook

```yaml id="48jlwm"
vars:
  var1: "pp !!!"
  var2:
    - { nom: "pp", age: "40" }
    - { nom: "paul", age: "22" }
    - { nom: "pierre", age: "25" }

tasks:
  - name: Génération d'un fichier par personne
    ansible.builtin.template:
      src: montemplate.txt.j2
      dest: "/tmp/hello_{{ item.nom }}.txt"
    with_items: "{{ var2 }}"
```


### Template

```jinja2 id="9niwk3"
#{{ template_run_date }} - "{{ ansible_managed }}" via {{ template_uid }}@{{ template_host }}
Hello {{ var1 }}
je suis {{ item.nom }}
j'ai {{ item.age }}
```


### Explication

Chaque itération produit un fichier distinct :

* `/tmp/hello_pp.txt`
* `/tmp/hello_paul.txt`
* `/tmp/hello_pierre.txt`


## 8 — Itération directement dans le template

### Playbook

```yaml id="j7k8a0"
vars:
  var1: "pp !!!"
  var2:
    - { nom: "pp", age: "40" }
    - { nom: "paul", age: "22" }
    - { nom: "pierre", age: "25" }

tasks:
  - name: Génération d'un fichier unique
    ansible.builtin.template:
      src: montemplate.txt.j2
      dest: /tmp/hello_all.txt
```


### Template

```jinja2 id="ss4uhn"
#{{ template_run_date }} - "{{ ansible_managed }}" via {{ template_uid }}@{{ template_host }}
Hello {{ var1 }}
{% for personne in var2 %}
je suis {{ personne.nom }}
j'ai {{ personne.age }}
{% endfor %}
```


### Explication

Ici, un seul fichier est généré contenant l’ensemble des données.


## 9 — Cas d’usage typiques

Le module `template` est particulièrement adapté pour :

* fichiers Nginx
* fichiers systemd
* fichiers de configuration applicative
* fichiers de monitoring
* scripts générés avec variables


## 10 — Validation avant déploiement

Comme avec `copy`, il est possible de valider un template avant écriture finale.

### Exemple

```yaml id="6vx9n7"
- name: Déploiement du fichier nginx avec validation
  ansible.builtin.template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
    owner: root
    group: root
    mode: "0644"
    validate: /usr/bin/nginx -t -c %s
```


### Intérêt

Permet d’éviter de déployer une configuration invalide.


## 11 — Bonnes pratiques

* utiliser `template` dès qu’un fichier dépend de variables
* garder les templates lisibles
* limiter la logique complexe dans Jinja2
* définir explicitement les permissions
* utiliser `validate` pour les fichiers critiques
* ajouter un en-tête avec `ansible_managed`


## 12 — Anti-patterns

* utiliser `copy` pour un fichier dynamique
* mettre trop de logique métier dans le template
* produire des templates difficilement lisibles
* ne pas valider une configuration critique
* mélanger fortement logique Ansible et logique Jinja2


## Conclusion

Le module `template` est l’un des modules les plus importants d’Ansible.

Il permet de :

* générer des fichiers dynamiques
* factoriser les configurations
* adapter le contenu à chaque hôte ou environnement

Sa maîtrise est essentielle pour produire des déploiements maintenables, lisibles et fiables.


---

# 25 Ansible - Handlers


## Documentation

https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_handlers.html

Commande utile :

```bash id="zb3n88"
ansible-doc -t keyword handlers
```


## Lab associé

[Voir le lab 25-ansible-handlers](../labs/25-ansible-handlers/)


## 1 — Introduction aux handlers

Les handlers sont des tâches spéciales déclenchées uniquement lorsqu’une autre tâche signale un changement.

On peut les voir comme des déclencheurs.

Ils sont particulièrement utiles pour :

* recharger un service après changement de configuration
* redémarrer un processus seulement si nécessaire
* éviter les opérations inutiles


## 2 — Principe de fonctionnement

Une tâche classique peut utiliser `notify` pour appeler un handler.

Le handler :

* n’est exécuté que si la tâche appelante a un état `changed`
* n’est exécuté qu’une seule fois, même si plusieurs tâches le notifient
* est généralement joué en fin de play

Cela permet d’optimiser l’exécution et de respecter l’idempotence.


## 3 — Exemple d’usage avec Nginx

### Contexte

On souhaite :

* installer Nginx
* supprimer les vhosts par défaut
* générer un nouveau vhost
* activer ce vhost
* recharger Nginx uniquement si la configuration a changé


### Playbook

```yaml id="7g71e4"
- name: Premier playbook
  hosts: all
  become: true
  vars:
    nginx_port: 8888

  tasks:
    - name: Installer nginx
      ansible.builtin.apt:
        name:
          - nginx
          - curl
        state: present
        cache_valid_time: 3600
        update_cache: true

    - name: Supprimer les vhosts par défaut
      ansible.builtin.file:
        path: "{{ item }}"
        state: absent
      with_items:
        - /etc/nginx/sites-available/default
        - /etc/nginx/sites-enabled/default

    - name: Installer le vhost
      ansible.builtin.template:
        src: default_vhost.conf.j2
        dest: /etc/nginx/sites-available/default_vhost.conf
        owner: root
        group: root
        mode: "0644"
      notify: reload_nginx

    - name: Activer le vhost
      ansible.builtin.file:
        src: /etc/nginx/sites-available/default_vhost.conf
        dest: /etc/nginx/sites-enabled/default_vhost.conf
        state: link

    - name: Démarrer nginx
      ansible.builtin.systemd:
        name: nginx
        state: started

  handlers:
    - name: reload_nginx
      ansible.builtin.systemd:
        name: nginx
        state: reloaded
```


## 4 — Mot-clé notify

Le mot-clé `notify` permet de relier une tâche à un handler.

### Exemple

```yaml id="tmg07l"
- name: Installer le vhost
  ansible.builtin.template:
    src: default_vhost.conf.j2
    dest: /etc/nginx/sites-available/default_vhost.conf
  notify: reload_nginx
```


### Explication

Le handler `reload_nginx` n’est exécuté que si le fichier de destination a réellement changé.


## 5 — Définition d’un handler

Les handlers sont définis dans un bloc `handlers`.

### Exemple

```yaml id="k8eu37"
handlers:
  - name: reload_nginx
    ansible.builtin.systemd:
      name: nginx
      state: reloaded
```


### Intérêt

Cela permet de :

* centraliser les redémarrages / reloads
* éviter les répétitions
* rendre le playbook plus lisible


## 6 — Moment d’exécution des handlers

Par défaut, les handlers sont exécutés :

* à la fin de la play
* après toutes les tâches normales

Cela signifie qu’un service n’est pas forcément rechargé immédiatement après la tâche qui l’a notifié.


## 7 — Forcer l’exécution avec meta: flush_handlers

### Principe

Il est possible de forcer l’exécution des handlers à un moment précis.

### Exemple

```yaml id="bypx5j"
- name: Flush handlers
  meta: flush_handlers
```


### Explication

Cette instruction force l’exécution immédiate des handlers en attente.

C’est utile quand :

* une suite de tâches dépend du rechargement déjà effectué
* on veut garantir qu’un service est à jour avant de continuer


## 8 — Exemple avancé avec reboot

```yaml id="v1l7i8"
- name: Vérifier si un reboot est nécessaire
  ansible.builtin.stat:
    path: /var/run/reboot.pending
  register: __need_reboot
  changed_when: __need_reboot.stat.exists
  notify: reboot_server
```


### Explication

Ici :

* `stat` vérifie la présence d’un indicateur de reboot
* `changed_when` transforme ce résultat en changement logique
* `notify` déclenche le handler `reboot_server`

Ce type de construction permet d’utiliser les handlers comme mécanisme d’orchestration conditionnelle.


## 9 — Cas d’usage typiques

Les handlers sont particulièrement adaptés pour :

* recharger Nginx après modification de configuration
* redémarrer un service systemd après changement
* relancer une application
* lancer un reboot si nécessaire
* recharger un démon après modification de fichiers critiques


## 10 — Bonnes pratiques

* utiliser les handlers pour les opérations de reload / restart
* ne pas redémarrer un service à chaque tâche
* nommer les handlers de manière explicite
* utiliser `flush_handlers` seulement quand c’est réellement nécessaire
* garder les handlers simples et ciblés


## 11 — Anti-patterns

* redémarrer un service dans chaque tâche au lieu d’utiliser `notify`
* utiliser un handler pour de la logique métier complexe
* abuser de `flush_handlers`
* ne pas comprendre que plusieurs `notify` vers le même handler n’exécutent qu’une seule fois ce handler


## Conclusion

Les handlers sont un mécanisme central d’Ansible pour gérer les actions déclenchées par changement.

Ils permettent :

* des rechargements propres
* une meilleure idempotence
* une meilleure lisibilité
* moins d’actions inutiles

Leur bonne utilisation améliore fortement la qualité des playbooks, en particulier pour la gestion des services et des fichiers de configuration.


---

# 26 Ansible - Les Rôles


## Documentation

https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html

Commande utile :

```bash
ansible-galaxy init mon_role
```


## Lab associé

[Voir le lab 26-ansible-roles](../labs/26-ansible-roles/)


## 1 — Définition d’un rôle

Un rôle est une structure organisée permettant de regrouper :

* des tâches
* des variables
* des fichiers
* des templates
* des handlers

Le tout autour d’un objectif commun.


### Exemple

Un rôle peut représenter :

* un serveur web (nginx)
* une base de données
* un système de monitoring
* une configuration de sécurité


## 2 — Objectif des rôles

Les rôles permettent de :

* structurer les playbooks
* factoriser le code
* réutiliser des composants
* standardiser les déploiements


## 3 — Intérêts des rôles

### Réutilisation

Un rôle peut être utilisé dans plusieurs projets.


### Organisation

Permet de structurer clairement :

* la logique
* les fichiers
* les variables


### Approche modulaire

Principe du lego :

* plus un rôle est petit, plus il est réutilisable
* chaque rôle a une responsabilité claire


### Exemple de découpage

* rôle `mysql` : installation moteur
* rôle `mysql_replication` : réplication
* rôle `mysql_backup` : sauvegarde


## 4 — Organisation de travail

### Bonnes pratiques

* un dépôt par rôle
* un mainteneur identifié
* validation via pull request
* gestion des versions
* documentation associée


### Impact global

Attention aux changements :

* modification de variables
* impact sur les dépendances
* compatibilité avec d’autres rôles


## 5 — Structure d’un rôle

Un rôle suit une arborescence standard.


### Structure typique

```text
mon_role/
├── tasks/
│   └── main.yml
├── handlers/
│   └── main.yml
├── defaults/
│   └── main.yml
├── vars/
│   └── main.yml
├── templates/
├── files/
├── meta/
│   └── main.yml
├── tests/
└── library/
```


## 6 — Description des répertoires

### tasks/

Contient les tâches principales.

Point d’entrée du rôle :

```yaml
tasks/main.yml
```


### defaults/

Variables par défaut du rôle.

* priorité faible
* facilement surchargeables


### vars/

Variables du rôle avec priorité plus élevée.

À utiliser avec prudence.


### handlers/

Handlers spécifiques au rôle.


### templates/

Fichiers Jinja2 utilisés par le rôle.


### files/

Fichiers statiques à copier.


### meta/

Permet de :

* déclarer des dépendances de rôles
* publier sur Ansible Galaxy


### tests/

Contient les tests du rôle.


### library/

Modules personnalisés spécifiques au rôle.


## 7 — Utilisation d’un rôle

### Exemple dans un playbook

```yaml
- name: Déploiement
  hosts: all
  roles:
    - nginx
```


### Avec variables

```yaml
- name: Déploiement nginx
  hosts: all
  roles:
    - role: nginx
      vars:
        nginx_port: 8080
```


## 8 — Création d’un rôle

```bash
ansible-galaxy init mon_role
```


### Résultat

Création automatique de la structure standard.


## 9 — Ansible Galaxy

### Plateforme

https://galaxy.ansible.com/


### Objectif

* partager des rôles
* réutiliser des rôles existants
* standardiser les pratiques


### Installation d’un rôle

```bash
ansible-galaxy install geerlingguy.nginx
```


## 10 — Bonnes pratiques

* garder les rôles simples et ciblés
* documenter chaque rôle
* utiliser `defaults` plutôt que `vars`
* versionner les rôles
* tester les rôles (Molecule, etc.)
* respecter une structure cohérente entre projets


## 11 — Anti-patterns

* créer des rôles trop complexes
* mélanger plusieurs responsabilités dans un rôle
* mettre toute la logique dans `vars`
* ne pas tester les rôles
* ne pas documenter


## Conclusion

Les rôles sont un élément clé d’Ansible pour :

* structurer les projets
* améliorer la maintenabilité
* favoriser la réutilisation

Ils permettent de construire une infrastructure modulaire et évolutive, adaptée aux environnements professionnels.


---

# 27 Ansible - Les Rôles (en pratique)


## Documentation

https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html

Commande utile :

```bash
ansible-galaxy init roles/nom_du_role
```


## Lab associé

[Voir le lab 27-ansible-roles-en-pratique](../labs/27-ansible-roles-en-pratique/)


## 1 — Objectif

Mettre en pratique l’utilisation des rôles dans un projet réel.

On va structurer un projet avec plusieurs rôles :

* génération de clé SSH
* gestion des utilisateurs
* déploiement Nginx


## 2 — Structure du projet

### Arborescence globale

```text
.
├── 00_inventory.yml
├── group_vars
│   └── all.yml
├── host_vars
│   └── node3.yml
├── playbook.yml
└── roles
    ├── nginx
    ├── ssh_keygen
    └── users
```


### Exemple détaillé d’un rôle

```text
roles/nginx/
├── defaults/
├── files/
├── handlers/
├── meta/
├── README.md
├── tasks/
├── templates/
├── tests/
└── vars/
```


## 3 — Description des rôles

### 3.1 — Rôle ssh_keygen

Objectif :

* générer une clé SSH côté contrôleur


### Particularité

* utilisation de `delegate_to: localhost`
* utilisation de `run_once`


### Exemple de tâche

```yaml
- name: Génération de clé SSH
  community.crypto.openssh_keypair:
    path: /tmp/pp
    type: rsa
    size: 4096
    state: present
  delegate_to: localhost
  run_once: true
```


## 3.2 — Rôle users

Objectif :

* créer un utilisateur
* configurer sudo
* déployer une clé SSH


### Exemple de tâches

```yaml
- name: Création utilisateur
  ansible.builtin.user:
    name: devops
    shell: /bin/bash
    groups: sudo
    append: true

- name: Déploiement clé SSH
  ansible.posix.authorized_key:
    user: devops
    key: "{{ lookup('file', '/tmp/pp.pub') }}"
```


## 3.3 — Rôle nginx

Objectif :

* installer nginx
* déployer un vhost
* activer la configuration


### Exemple de tâches

```yaml
- name: Installation nginx
  ansible.builtin.apt:
    name: nginx
    state: present
    update_cache: true

- name: Déploiement vhost
  ansible.builtin.template:
    src: default_vhost.conf.j2
    dest: /etc/nginx/sites-available/default_vhost.conf
  notify: reload_nginx
```


### Handler associé

```yaml
- name: reload_nginx
  ansible.builtin.systemd:
    name: nginx
    state: reloaded
```


## 4 — Création des rôles

Commande :

```bash
ansible-galaxy init roles/ssh_keygen
ansible-galaxy init roles/users
ansible-galaxy init roles/nginx
```


## 5 — Playbook principal

### Exemple

```yaml
- name: Déploiement complet
  hosts: all
  become: true

  roles:
    - ssh_keygen
    - users
    - nginx
```


### Explication

Les rôles sont exécutés dans l’ordre :

1. génération de la clé SSH
2. création des utilisateurs + déploiement des clés
3. installation et configuration de Nginx


## 6 — Logique globale

### Workflow

1. génération de clé côté contrôleur
2. création des utilisateurs sur les cibles
3. injection des clés SSH
4. installation du reverse proxy


### Résultat

* accès SSH sécurisé sans mot de passe
* utilisateurs configurés
* serveur web fonctionnel


## 7 — Organisation recommandée

* un rôle = une responsabilité
* nommage cohérent des rôles
* structure identique entre projets
* séparation claire des variables


## 8 — Bonnes pratiques

* utiliser `defaults` pour les variables configurables
* éviter de mettre de la logique dans `vars`
* documenter chaque rôle
* tester les rôles individuellement
* versionner les rôles
* garder les rôles indépendants


## 9 — Anti-patterns

* créer des rôles trop gros
* coupler fortement les rôles entre eux
* mélanger plusieurs responsabilités
* ne pas documenter les variables
* dépendre de chemins en dur non maîtrisés


## 10 — Cas réel

Ce type d’organisation est utilisé pour :

* déploiement d’infrastructure
* automatisation DevOps
* provisioning de serveurs
* pipelines CI/CD


## Conclusion

Les rôles permettent de passer d’un playbook simple à une architecture structurée.

En pratique, ils permettent :

* une meilleure lisibilité
* une meilleure réutilisation
* une industrialisation des déploiements

C’est une étape clé pour construire des projets Ansible propres et maintenables.


---

# 28 Ansible - Module Systemd


## Documentation

https://docs.ansible.com/ansible/2.5/modules/systemd_module.html

Commande utile :

```bash
ansible-doc ansible.builtin.systemd
```


## Lab associé

[Voir le lab 28-ansible-module-systemd](../labs/28-ansible-module-systemd/)


## 1 — Introduction au module systemd

### Objectif

Le module `systemd` permet de gérer les services sur les systèmes Linux utilisant systemd.

Il remplace les commandes :

* `systemctl start`
* `systemctl stop`
* `systemctl restart`
* `systemctl enable`


### Périmètre

* démarrage / arrêt de services
* activation au boot
* reload de configuration
* gestion des unités systemd


## 2 — Paramètres principaux

### name

Nom du service :

```yaml
name: haproxy
```


### state

État du service :

* `started`
* `stopped`
* `restarted`
* `reloaded`


### enabled

Active le service au démarrage :

```yaml
enabled: true
```


### daemon_reload

Recharge la configuration systemd :

```yaml
daemon_reload: true
```


### daemon_reexec

Relance systemd lui-même.

Usage rare et avancé.


### masked

Empêche l’utilisation du service :

```yaml
masked: false
```


### force

Force la création ou remplacement des liens systemd.


### no_block

Permet de ne pas attendre la fin de l’opération.


### scope

Permet de définir le scope (system ou user).


## 3 — Démarrage d’un service

```yaml
- name: Démarrer haproxy
  ansible.builtin.systemd:
    name: haproxy
    state: started
```


## 4 — Arrêt d’un service

```yaml
- name: Arrêter haproxy
  ansible.builtin.systemd:
    name: haproxy
    state: stopped
```


## 5 — Activation au démarrage

```yaml
- name: Activer haproxy au boot
  ansible.builtin.systemd:
    name: haproxy
    state: started
    enabled: true
```


### Explication

* le service est démarré immédiatement
* il sera aussi lancé au boot


## 6 — Utilisation avec daemon_reload

```yaml
- name: Démarrage avec reload systemd
  ansible.builtin.systemd:
    name: haproxy
    state: started
    enabled: true
    daemon_reload: true
```


### Cas d’usage

* après modification d’un fichier `.service`
* après ajout d’une nouvelle unité systemd


## 7 — Gestion du masking

```yaml
- name: Assurer que le service n’est pas masqué
  ansible.builtin.systemd:
    name: haproxy
    state: started
    enabled: true
    daemon_reload: true
    masked: false
```


### Explication

Un service masqué ne peut pas être démarré.

Cette option permet de lever ce blocage.


## 8 — Reload uniquement

```yaml
- name: Recharger systemd uniquement
  ansible.builtin.systemd:
    daemon_reload: true
```


### Explication

Permet de recharger les unités systemd sans agir sur un service particulier.


## 9 — Cas d’usage typiques

Le module `systemd` est utilisé pour :

* démarrer un service après installation (nginx, haproxy, mysql)
* recharger un service après modification de configuration
* activer un service au boot
* gérer les services dans les rôles
* orchestrer les redémarrages via handlers


## 10 — Intégration avec handlers

### Exemple

```yaml
- name: Déploiement configuration nginx
  ansible.builtin.template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: reload_nginx

handlers:
  - name: reload_nginx
    ansible.builtin.systemd:
      name: nginx
      state: reloaded
```


### Intérêt

* reload uniquement si changement
* évite les interruptions inutiles


## 11 — Bonnes pratiques

* utiliser `systemd` plutôt que `shell`
* utiliser `daemon_reload` après modification des unités
* utiliser les handlers pour reload/restart
* toujours définir explicitement `enabled`
* éviter les restart inutiles


## 12 — Anti-patterns

* utiliser `command` ou `shell` pour gérer les services
* redémarrer un service sans condition
* oublier `daemon_reload` après modification
* masquer un service sans raison
* ne pas utiliser les handlers


## Conclusion

Le module `systemd` est central pour la gestion des services sous Linux.

Il permet :

* une gestion propre et idempotente
* une intégration avec les handlers
* une automatisation fiable des services

Sa maîtrise est indispensable pour tous les déploiements applicatifs et systèmes avec Ansible.


---

# 29 Ansible - Modules UNARCHIVE et GET_URL


## Documentation

UNARCHIVE :
https://docs.ansible.com/ansible/2.5/modules/unarchive_module.html

GET_URL :
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/get_url_module.html

Commandes utiles :

```bash
ansible-doc ansible.builtin.unarchive
ansible-doc ansible.builtin.get_url
```


## Lab associé

[Voir le lab 29-ansible-unarchive-et-get-url](../labs/29-ansible-unarchive-et-get-url/)


## 1 — Introduction

Ces deux modules sont très utilisés ensemble :

* `get_url` : télécharger un fichier
* `unarchive` : extraire une archive

Ils sont essentiels pour :

* installer des binaires
* déployer des applications
* récupérer des artefacts
* automatiser des installations hors gestionnaire de paquets


# PARTIE 1 — MODULE UNARCHIVE


## 2 — Objectif

Le module `unarchive` permet de :

* décompresser une archive
* copier + extraire en une seule étape


### Prérequis

* `tar`
* `unzip`


## 3 — Paramètres principaux

### src

Source de l’archive :

```yaml
src: /tmp/archive.tar.gz
```


### dest

Destination sur la machine cible :

```yaml
dest: /opt/app/
```


### remote_src

Définit l’origine :

* `false` : depuis le contrôleur
* `true` : depuis la cible ou une URL


### creates

Empêche l’exécution si un fichier existe :

```yaml
creates: /opt/app/bin/app
```


### mode / owner / group

Gestion des permissions.


### exclude

Permet d’exclure des fichiers de l’archive.


### list_files

Permet de lister les fichiers contenus dans l’archive.


## 4 — Exemple avec fichier local

```yaml
- name: Extraction depuis le contrôleur
  ansible.builtin.unarchive:
    src: /tmp/node_exporter.tar.gz
    dest: /home/pp/
```


### Explication

* le fichier est copié depuis le contrôleur
* puis extrait sur la cible


## 5 — Exemple avec URL

```yaml
- name: Extraction depuis URL
  ansible.builtin.unarchive:
    src: https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
    dest: /home/pp/
    remote_src: true
```


### Explication

* téléchargement direct depuis la cible
* extraction immédiate


## 6 — Bonnes pratiques UNARCHIVE

* utiliser `creates` pour éviter les extractions multiples
* préférer `remote_src: true` pour les URLs
* contrôler les permissions
* vérifier les dépendances (tar, unzip)


## 7 — Anti-patterns UNARCHIVE

* extraire à chaque run sans contrôle
* ne pas vérifier l’existence des fichiers
* mélanger téléchargement et extraction sans logique
* ignorer les permissions


# PARTIE 2 — MODULE GET_URL


## 8 — Objectif

Le module `get_url` permet de :

* télécharger un fichier depuis une URL
* gérer son intégrité
* contrôler son stockage


## 9 — Paramètres principaux

### url

URL du fichier :

```yaml
url: https://example.com/file.tar.gz
```


### dest

Destination :

```yaml
dest: /opt/file.tar.gz
```


### mode / owner / group

Permissions du fichier téléchargé.


### checksum

Permet de vérifier l’intégrité :

```yaml
checksum: sha512:xxxx
```


### timeout

Durée maximale de téléchargement.


### headers

Permet d’ajouter des headers HTTP.


### force

Remplacer le fichier existant :

```yaml
force: true
```


### validate_certs

Validation TLS :

```yaml
validate_certs: true
```


### use_proxy

Utilisation d’un proxy.


## 10 — Exemple avec checksum

```yaml
- name: Téléchargement sécurisé
  ansible.builtin.get_url:
    url: https://downloads.apache.org/tomcat/tomcat-10/v10.0.0-M8/bin/apache-tomcat-10.0.0-M8.tar.gz
    dest: /opt/tomcat8
    mode: "0755"
    checksum: sha512:5e3dcbc56e14de73c6b866d355db8169680d093fa447e52e9a4082cc7ca363a385ac2a37a1acdc66c1945a21effe440aa06edd8a572ac6096cbe5e22ea356de4
    owner: pp
    group: pp
```


### Explication

* téléchargement du fichier
* vérification via checksum
* sécurisation du contenu


## 11 — Combinaison GET_URL + UNARCHIVE

### Workflow typique

```yaml
- name: Télécharger archive
  ansible.builtin.get_url:
    url: https://example.com/app.tar.gz
    dest: /tmp/app.tar.gz

- name: Extraire archive
  ansible.builtin.unarchive:
    src: /tmp/app.tar.gz
    dest: /opt/app/
```


### Variante optimisée

```yaml
- name: Download + extract
  ansible.builtin.unarchive:
    src: https://example.com/app.tar.gz
    dest: /opt/app/
    remote_src: true
```


## 12 — Cas d’usage typiques

* installation de Prometheus node_exporter
* déploiement de Tomcat
* installation de binaires custom
* déploiement d’applications sans apt/yum


## 13 — Bonnes pratiques

* toujours utiliser un checksum avec `get_url`
* utiliser `creates` avec `unarchive`
* séparer téléchargement et extraction si nécessaire
* gérer les permissions explicitement
* éviter les téléchargements répétés


## 14 — Anti-patterns

* télécharger sans vérifier l’intégrité
* extraire à chaque exécution
* utiliser `shell` pour wget + tar
* ignorer les erreurs réseau
* ne pas gérer les versions


## Conclusion

Les modules `get_url` et `unarchive` sont essentiels pour :

* installer des logiciels
* gérer des artefacts
* automatiser des déploiements hors package manager

Ils permettent une approche :

* propre
* idempotente
* sécurisée

Très utilisés dans les rôles d’installation applicative.


---

# 30 Ansible - Module LINEINFILE


## Documentation

https://docs.ansible.com/ansible/2.5/modules/lineinfile_module.html

Commande utile :

```bash
ansible-doc ansible.builtin.lineinfile
```


## Lab associé

[Voir le lab 30-ansible-module-lineinfile](../labs/30-ansible-module-lineinfile/)


## 1 — Introduction au module lineinfile

### Objectif

Le module `lineinfile` permet de :

* ajouter une ligne dans un fichier
* modifier une ligne existante
* supprimer une ligne
* garantir la présence ou l’absence d’une ligne


### Cas d’usage

* modifier un fichier de configuration
* ajouter une directive
* commenter une ligne
* corriger une configuration existante


## 2 — Paramètres principaux

### path / dest

Chemin du fichier :

```yaml
path: /tmp/test.conf
```


### line

Ligne à ajouter ou modifier :

```yaml
line: "test"
```


### state

* `present` : ligne présente
* `absent` : ligne supprimée


### regexp

Expression régulière pour rechercher la ligne :

```yaml
regexp: "^test$"
```


### create

Créer le fichier s’il n’existe pas :

```yaml
create: true
```


### backrefs

Permet d’utiliser les captures regex :

```yaml
backrefs: true
```


### insertbefore / insertafter

Positionnement de la ligne :

```yaml
insertbefore: "^pattern"
insertafter: "^pattern"
```


### backup

Créer un backup avant modification :

```yaml
backup: true
```


### owner / group / mode

Gestion des permissions.


### validate

Permet de valider avant écriture.


## 3 — Ajout simple d’une ligne

```yaml
- name: Ajout simple
  ansible.builtin.lineinfile:
    path: /tmp/test.conf
    line: "test"
    state: present
    create: true
```


### Remarque

Si la ligne change, une nouvelle ligne peut être ajoutée si aucune correspondance n’est trouvée.


## 4 — Modification d’une ligne

```yaml
- name: Modification d'une ligne
  ansible.builtin.lineinfile:
    path: /tmp/test.conf
    line: "test 2"
    regexp: "^test$"
    state: present
    create: true
```


### Explication

* recherche de la ligne `test`
* remplacement par `test 2`


## 5 — Utilisation des captures (backrefs)

```yaml
- name: Modification avec capture
  ansible.builtin.lineinfile:
    path: /tmp/test.conf
    line: "je suis le nombre : \\1"
    regexp: "^test ([0-2])$"
    backrefs: true
    state: present
    create: true
```


### Explication

* capture du chiffre avec regex
* réutilisation avec `\1`


### Attention

Les captures peuvent produire des effets inattendus sur plusieurs exécutions si mal maîtrisées.


## 6 — Commenter une ligne

```yaml
- name: Commenter une ligne
  ansible.builtin.lineinfile:
    path: /tmp/test.conf
    line: "# \\1"
    regexp: "(^je suis le nombre : [0-2])"
    backrefs: true
    state: present
    create: true
```


## 7 — Insertion avant une ligne

```yaml
- name: Insertion avant
  ansible.builtin.lineinfile:
    path: /tmp/test.conf
    line: "Ma nouvelle ligne"
    insertbefore: "^# je suis le nombre : [0-2]"
    state: present
    create: true
```


### Variante

* `insertafter` pour insertion après


## 8 — Suppression d’une ligne

```yaml
- name: Suppression d'une ligne
  ansible.builtin.lineinfile:
    path: /tmp/test.conf
    regexp: "^Ma nouvelle ligne"
    state: absent
```


### Alternative

On peut aussi utiliser `line` directement.


## 9 — Backup avant modification

```yaml
- name: Suppression avec backup
  ansible.builtin.lineinfile:
    path: /tmp/test.conf
    regexp: "^#"
    state: absent
    backup: true
```


### Intérêt

Permet de :

* conserver l’état précédent
* rollback si nécessaire


## 10 — Cas d’usage typiques

* modifier `/etc/ssh/sshd_config`
* ajouter une entrée dans `/etc/hosts`
* modifier une configuration applicative
* commenter des lignes existantes
* ajuster dynamiquement une configuration


## 11 — Bonnes pratiques

* toujours utiliser `regexp` pour éviter les doublons
* tester les regex avant utilisation
* utiliser `backup` pour les fichiers critiques
* éviter les modifications ambiguës
* privilégier la clarté des règles


## 12 — Anti-patterns

* ajouter une ligne sans `regexp`
* modifier un fichier complexe avec `lineinfile`
* utiliser des regex trop larges
* empiler des modifications incohérentes
* remplacer un usage de `template` par `lineinfile`


## Conclusion

Le module `lineinfile` est très utile pour :

* modifier rapidement un fichier
* faire des ajustements ciblés
* automatiser des corrections simples

Cependant, pour des fichiers complexes, il est préférable d’utiliser `template`.

C’est un module puissant mais à utiliser avec précision.


---

# 31 Ansible - Installation dépôt APT (ex : Docker)


## Documentation

APT KEY :
https://docs.ansible.com/ansible/2.5/modules/apt_key_module.html

APT REPOSITORY :
https://docs.ansible.com/ansible/2.5/modules/apt_repository_module.html

Commande utile :

```bash
ansible-doc ansible.builtin.apt_key
ansible-doc ansible.builtin.apt_repository
```


## Lab associé

[Voir le lab 31-ansible-apt-repository-docker](../labs/31-ansible-apt-repository-docker/)


## 1 — Introduction

L’installation d’un logiciel via dépôt APT nécessite souvent :

1. ajout d’une clé GPG
2. ajout du dépôt
3. mise à jour du cache
4. installation du package

Les modules utilisés :

* `apt_key`
* `apt_repository`
* `apt`


## 2 — Module apt_key

### Objectif

Permet de gérer les clés GPG utilisées pour vérifier les dépôts APT.


### Paramètres principaux

#### data

Contenu direct de la clé :

```yaml
data: "{{ lookup('file', 'apt.asc') }}"
```


#### url

Téléchargement de la clé :

```yaml
url: https://example.com/key.asc
```


#### id

Identifiant de la clé :

```yaml
id: 9FED2BCBDCD29CDF762678CBAED4B06F473041FA
```


#### keyring

Chemin de stockage de la clé :

```yaml
keyring: /etc/apt/trusted.gpg.d/custom.gpg
```


#### state

* `present`
* `absent`


#### validate_certs

Validation TLS.


### Exemple depuis un fichier

```yaml
- name: Ajout clé depuis fichier
  ansible.builtin.apt_key:
    data: "{{ lookup('file', 'apt.asc') }}"
    state: present
```


### Exemple depuis URL

```yaml
- name: Ajout clé depuis URL
  ansible.builtin.apt_key:
    id: 9FED2BCBDCD29CDF762678CBAED4B06F473041FA
    url: https://ftp-master.debian.org/keys/archive-key-6.0.asc
    keyring: /etc/apt/trusted.gpg.d/debian.gpg
```


### Suppression d’une clé

```yaml
- name: Suppression clé
  ansible.builtin.apt_key:
    id: 0x9FED2BCBDCD29CDF762678CBAED4B06F473041FA
    state: absent
```


## 3 — Module apt_repository

### Objectif

Permet de gérer les dépôts APT.


### Paramètres principaux

#### repo

Définition du dépôt :

```yaml
repo: "deb http://example.com/debian stable main"
```


#### filename

Nom du fichier dans `/etc/apt/sources.list.d/` :

```yaml
filename: custom_repo
```


#### state

* `present`
* `absent`


#### update_cache

Met à jour le cache automatiquement :

```yaml
update_cache: true
```


#### mode

Permissions du fichier :

```yaml
mode: "0644"
```


#### validate_certs

Validation TLS.


### Exemple

```yaml
- name: Ajout dépôt
  ansible.builtin.apt_repository:
    repo: "deb http://example.com/debian stable main"
    state: present
    update_cache: true
```


## 4 — Exemple complet : installation Docker

### Étape 1 — Ajout de la clé

```yaml
- name: Ajout clé Docker
  ansible.builtin.apt_key:
    url: https://download.docker.com/linux/debian/gpg
    state: present
```


### Étape 2 — Ajout du dépôt

```yaml
- name: Ajout dépôt Docker
  ansible.builtin.apt_repository:
    repo: "deb https://download.docker.com/linux/debian {{ ansible_distribution_release }} stable"
    state: present
    update_cache: true
```


### Étape 3 — Installation Docker

```yaml
- name: Installation Docker
  ansible.builtin.apt:
    name: docker-ce
    state: present
```


## 5 — Workflow complet

1. ajout de la clé GPG
2. ajout du dépôt
3. mise à jour du cache
4. installation du paquet


## 6 — Cas d’usage typiques

* installation Docker
* installation Kubernetes (kubeadm, kubectl)
* ajout de dépôts internes
* installation de logiciels tiers


## 7 — Bonnes pratiques

* toujours ajouter la clé avant le dépôt
* utiliser `update_cache` après ajout du dépôt
* utiliser `ansible_distribution_release` pour portabilité
* sécuriser avec `validate_certs`
* documenter les sources de dépôts


## 8 — Anti-patterns

* ajouter un dépôt sans clé
* oublier de mettre à jour le cache
* utiliser des dépôts non sécurisés
* hardcoder une version de distribution
* multiplier les dépôts inutiles


## Conclusion

Les modules `apt_key` et `apt_repository` permettent de gérer proprement les dépôts APT.

Ils sont essentiels pour :

* installer des logiciels externes
* automatiser des environnements complets
* maintenir la sécurité des installations

Ils sont très utilisés dans les rôles d’installation applicative comme Docker ou Kubernetes.


---

# 32 Ansible - Précédence des variables


## Documentation

https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html


## Lab associé

[Voir le lab 32-ansible-variable-precedence](../labs/32-ansible-variable-precedence/)


## 1 — Introduction

La précédence des variables (variable precedence) définit quelle valeur est utilisée lorsqu’une même variable est définie à plusieurs endroits.

C’est un concept fondamental pour :

* comprendre le comportement d’Ansible
* éviter les conflits
* structurer correctement un projet


## 2 — Principe général

Lorsqu’une variable est définie plusieurs fois :

* Ansible applique un ordre de priorité
* la valeur la plus prioritaire est retenue


## 3 — Liste complète (ordre croissant)

De la priorité la plus faible à la plus forte :

```text
command line values (ex: -u user)
role defaults
inventory file / script group vars
inventory group_vars/all
playbook group_vars/all
inventory group_vars/*
playbook group_vars/*
inventory host vars
inventory host_vars/*
playbook host_vars/*
host facts / cached set_facts
play vars
play vars_prompt
play vars_files
role vars
block vars
task vars
include_vars
set_fact / registered vars
role params
include params
extra vars (-e)
```


## 4 — Exemple concret

### Définition multiple d’une variable

#### 1 — Role defaults (plus faible)

```yaml
roles/testvars/defaults/main.yml
var1: "default role"
```


#### 2 — group_vars

```yaml
group_vars/all.yml
var1: "group var"
```


#### 3 — host_vars

```yaml
host_vars/node2.yml
var1: "host var node2"
```


#### 4 — variables du playbook

```yaml
vars:
  var1: "playbook var"
```


#### 5 — role vars (très prioritaire)

```yaml
roles/testvars/vars/main.yml
var1: "role var"
```


#### 6 — set_fact (encore plus haut)

```yaml
- name: Override variable
  ansible.builtin.set_fact:
    var1: "set fact var"
```


## 5 — Résultat

Dans un rôle :

```yaml
- name: Debug variable
  ansible.builtin.debug:
    var: var1
```


### Valeur finale

```text
var1: "set fact var"
```


### Explication

`set_fact` écrase toutes les autres définitions précédentes.


## 6 — Ordre simplifié à retenir

```text
defaults
< group_vars
< host_vars
< play vars
< role vars
< set_fact
< extra vars (-e)
```


## 7 — Points importants

### 1 — role vars est très prioritaire

```yaml
roles/testvars/vars/main.yml
var1: "role var"
```

Même si la variable est définie ailleurs :

```yaml
vars:
  var1: "playbook var"
```

La valeur utilisée sera :

```text
role var
```


### 2 — set_fact écrase presque tout

```yaml
- set_fact:
    var1: "new value"
```

* utilisé pendant l’exécution
* très haute priorité


### 3 — extra vars (-e) gagnent toujours

```bash
ansible-playbook playbook.yml -e "var1=cli_value"
```

* priorité maximale
* utile pour override rapide


### 4 — defaults est fait pour être surchargé

```yaml
roles/testvars/defaults/main.yml
```

* priorité faible
* recommandé pour les variables configurables


## 8 — Bonnes pratiques

### À privilégier

* utiliser `defaults/` pour les variables configurables
* documenter les variables
* utiliser `group_vars` et `host_vars` pour l’infra
* limiter l’usage de `set_fact`


### À éviter

* mettre des variables dans `vars/` sans raison
* écraser des variables sans le savoir
* multiplier les niveaux de définition
* utiliser `set_fact` sans contrôle


## 9 — Anti-patterns

* dépendre implicitement de la précédence
* définir une variable dans trop d’endroits
* ne pas savoir d’où vient une valeur
* utiliser `vars/` dans les rôles pour des variables modifiables


## 10 — Méthode pour debug

### Commande utile

```bash
ansible -i inventory all -m debug -a "var=var1"
```


### Astuce

Afficher plusieurs variables :

```yaml
- debug:
    var: hostvars[inventory_hostname]
```


## Conclusion

La précédence des variables est essentielle pour :

* comprendre le comportement d’Ansible
* éviter les erreurs difficiles à diagnostiquer
* structurer correctement les rôles et playbooks

Une bonne maîtrise permet :

* des configurations propres
* des rôles réutilisables
* une meilleure maintenabilité des projets


---

# 33 Ansible - Gather Facts & module Setup


## Documentation

SETUP :
https://docs.ansible.com/ansible/2.3/setup_module.html

GATHER FACTS :
https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html

Commande utile :

```bash
ansible-doc ansible.builtin.setup
```


## Lab associé

[Voir le lab 33-ansible-gather-facts](../labs/33-ansible-gather-facts/)


## 1 — Introduction

Les **facts** sont des informations collectées automatiquement sur les machines cibles.

Ils permettent à Ansible de :

* comprendre l’environnement
* adapter les playbooks dynamiquement
* prendre des décisions conditionnelles


## 2 — Contenu des facts

Les facts couvrent de nombreux domaines :

* système d’exploitation
* interfaces réseau
* disques et partitions
* CPU / mémoire
* utilisateurs
* montages
* variables d’environnement
* type de connexion


## 3 — ansible_facts

Tous les facts sont stockés dans :

```yaml
ansible_facts
```


### Exemple

```yaml
- name: Afficher les facts
  ansible.builtin.debug:
    var: ansible_facts
```


## 4 — Collecte automatique (gather_facts)

Par défaut, Ansible collecte les facts au début de chaque play.

```yaml
- name: Mon playbook
  hosts: all
  gather_facts: true
```


### Résultat

* exécution automatique du module `setup`
* disponibilité des variables `ansible_*`


## 5 — Désactiver la collecte

```yaml
- name: Test sans facts
  hosts: all
  gather_facts: false
  tasks:
    - name: Debug
      ansible.builtin.debug:
        var: ansible_facts
```


### Cas d’usage

* optimisation des performances
* playbooks simples
* environnements contrôlés


## 6 — Module setup

### Objectif

Le module `setup` permet de :

* collecter les facts manuellement
* filtrer les informations
* contrôler le volume de données


## 7 — Utilisation en CLI

### Tous les facts

```bash
ansible -i 00_inventory.yml all -m setup
```


### Avec filtre

```bash
ansible -i 00_inventory.yml all -m setup -a "filter=ansible_user*"
```


## 8 — Utilisation dans un playbook

### Exemple simple

```yaml
- name: Collecte facts
  ansible.builtin.setup:
```


### Avec register

```yaml
- name: Collecte facts
  ansible.builtin.setup:
  register: _hosts_facts

- name: Affichage
  ansible.builtin.debug:
    var: _hosts_facts
```


## 9 — Filtrer les facts

```yaml
- name: Collecte filtrée
  ansible.builtin.setup:
    filter: ansible_user*
  register: _hosts_facts
```


### Intérêt

* réduire la quantité de données
* améliorer les performances
* cibler uniquement les informations utiles


## 10 — Exemples de facts utiles

### Système

```yaml
ansible_distribution
ansible_distribution_version
```


### Réseau

```yaml
ansible_default_ipv4.address
```


### Machine

```yaml
ansible_hostname
ansible_fqdn
```


### CPU / RAM

```yaml
ansible_processor
ansible_memtotal_mb
```


## 11 — Cas d’usage

* conditionner un playbook selon l’OS
* adapter une configuration réseau
* cibler des machines spécifiques
* automatiser des déploiements multi-environnements


## 12 — Bonnes pratiques

* désactiver `gather_facts` si inutile
* utiliser `filter` pour optimiser
* utiliser les facts pour rendre les playbooks dynamiques
* éviter de surcharger inutilement la collecte


## 13 — Anti-patterns

* collecter tous les facts sans besoin
* ne pas utiliser les facts disponibles
* dépendre de facts non fiables
* ignorer l’impact performance sur de gros inventaires


## Conclusion

Les facts sont essentiels pour :

* rendre les playbooks intelligents
* adapter les déploiements
* automatiser de manière dynamique

Le module `setup` permet de :

* contrôler cette collecte
* optimiser les performances
* cibler précisément les informations nécessaires


---

# 34 Ansible - Monitoring : Node Exporter


## Documentation

Node Exporter :
https://github.com/prometheus/node_exporter/releases


## Lab associé

[Voir le lab 34-ansible-node-exporter](../labs/34-ansible-node-exporter/)


## 1 — Objectif

Mettre en place une première brique de monitoring :

* installation de Node Exporter
* exposition des métriques système
* préparation pour Prometheus et Grafana


## 2 — Architecture

### Infrastructure

* 1 nœud monitoring :

  * Prometheus
  * Grafana

* N nœuds monitorés :

  * Node Exporter


### Rôle de Node Exporter

* collecte des métriques système :

  * CPU
  * RAM
  * disque
  * réseau

* exposition via HTTP (port 9100 par défaut)


## 3 — Structure du projet

```text
.
├── inventory.yml
├── playbook.yml
└── roles/
    └── node_exporter/
```


## 4 — Variables du rôle

```yaml
node_exporter_version: "1.0.1"
node_exporter_bin: /usr/local/bin/node_exporter
node_exporter_user: node-exporter
node_exporter_group: "{{ node_exporter_user }}"
node_exporter_dir_conf: /etc/node_exporter
```


## 5 — Workflow du rôle

### Étapes

1. vérifier si installé
2. créer utilisateur système
3. créer répertoire (optionnel)
4. télécharger et extraire
5. déplacer le binaire
6. nettoyer
7. créer service systemd
8. démarrer le service


## 6 — Vérification de l’existant

```yaml
- name: Check if node exporter exists
  ansible.builtin.stat:
    path: "{{ node_exporter_bin }}"
  register: __check_node_exporter_present
```


## 7 — Création de l’utilisateur

```yaml
- name: Create node exporter user
  ansible.builtin.user:
    name: "{{ node_exporter_user }}"
    append: true
    shell: /usr/sbin/nologin
    system: true
    create_home: false
    home: /
```


## 8 — Création du répertoire

```yaml
- name: Create config directory
  ansible.builtin.file:
    path: "{{ node_exporter_dir_conf }}"
    state: directory
    owner: "{{ node_exporter_user }}"
    group: "{{ node_exporter_group }}"
```


## 9 — Téléchargement et extraction

```yaml
- name: Download and extract node exporter
  ansible.builtin.unarchive:
    src: "https://github.com/prometheus/node_exporter/releases/download/v{{ node_exporter_version }}/node_exporter-{{ node_exporter_version }}.linux-amd64.tar.gz"
    dest: /tmp/
    remote_src: true
  when: __check_node_exporter_present.stat.exists == false
```


## 10 — Déplacement du binaire

```yaml
- name: Move binary
  ansible.builtin.copy:
    src: "/tmp/node_exporter-{{ node_exporter_version }}.linux-amd64/node_exporter"
    dest: "{{ node_exporter_bin }}"
    owner: "{{ node_exporter_user }}"
    group: "{{ node_exporter_group }}"
    mode: "0755"
    remote_src: true
  when: __check_node_exporter_present.stat.exists == false
```


## 11 — Nettoyage

```yaml
- name: Clean temporary files
  ansible.builtin.file:
    path: "/tmp/node_exporter-{{ node_exporter_version }}.linux-amd64/"
    state: absent
```


## 12 — Template systemd

### Fichier : `node_exporter.service.j2`

```ini
[Unit]
Description=Node Exporter
After=network-online.target

[Service]
User={{ node_exporter_user }}
Group={{ node_exporter_user }}
Type=simple
ExecStart={{ node_exporter_bin }}

[Install]
WantedBy=multi-user.target
```


## 13 — Installation du service

```yaml
- name: Install systemd service
  ansible.builtin.template:
    src: node_exporter.service.j2
    dest: /etc/systemd/system/node_exporter.service
    owner: root
    group: root
    mode: "0755"
  notify: reload_daemon_and_restart_node_exporter
```


## 14 — Flush des handlers

```yaml
- name: Flush handlers
  meta: flush_handlers
```


## 15 — Démarrage du service

```yaml
- name: Ensure service is started
  ansible.builtin.systemd:
    name: node_exporter
    state: started
    enabled: true
```


## 16 — Handler

```yaml
- name: reload_daemon_and_restart_node_exporter
  ansible.builtin.systemd:
    name: node_exporter
    state: restarted
    daemon_reload: true
    enabled: true
```


## 17 — Vérification

### Accès HTTP

```text
http://<IP>:9100/metrics
```


### Résultat attendu

* endpoint accessible
* métriques Prometheus exposées


## 18 — Bonnes pratiques

* vérifier l’existence avant installation
* utiliser un user dédié non connecté
* utiliser `remote_src: true` pour les downloads
* utiliser des handlers pour les reload
* nettoyer les fichiers temporaires


## 19 — Anti-patterns

* installer sans vérification préalable
* lancer en root sans raison
* ne pas gérer systemd proprement
* oublier `daemon_reload`
* ne pas rendre le service persistent


## Conclusion

Node Exporter est la première étape d’une stack de monitoring.

Ce rôle permet :

* une installation propre
* une approche idempotente
* une intégration avec systemd

Il sert de base pour :

* Prometheus (scraping)
* Grafana (visualisation)

C’est un cas concret complet combinant :

* rôles
* templates
* handlers
* modules système
* logique conditionnelle


---

# 35 Ansible - Monitoring : Node Exporter - Gestion de version


## Documentation

Node Exporter :
https://github.com/prometheus/node_exporter/releases

Module shell :
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/shell_module.html

Module systemd :
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/systemd_module.html


## Lab associé

[Voir le lab 35-ansible-node-exporter-gestion-de-version](../labs/35-ansible-gestion-de-version/)


## 1 — Objectif

L’objectif est de gérer la mise à jour de Node Exporter.

Le principe est de :

* vérifier si le binaire existe
* identifier la version actuellement installée
* comparer avec la version attendue
* télécharger et réinstaller uniquement si nécessaire
* redémarrer le service en cas de changement


## 2 — Problématique

Pour mettre à jour Node Exporter, il faut pouvoir savoir quelle version est déjà présente.

Plusieurs approches existent :

* lire la version via le binaire
* interroger l’endpoint HTTP avec `curl`
* récupérer l’information dans la configuration systemd

Dans ce cas, l’approche retenue consiste à stocker la version dans le fichier de service systemd, puis à la relire.


## 3 — Principe retenu

La version attendue est injectée dans le service systemd.

### Exemple de template systemd

```ini id="lpc6pi"
[Unit]
Description=Node Exporter Version {{ node_exporter_version }}
After=network-online.target

[Service]
User={{ node_exporter_user }}
Group={{ node_exporter_user }}
Type=simple
ExecStart={{ node_exporter_bin }}

[Install]
WantedBy=multi-user.target
```


## 4 — Variables principales

```yaml id="v24q2w"
node_exporter_version: "1.0.1"
node_exporter_bin: /usr/local/bin/node_exporter
node_exporter_user: node-exporter
node_exporter_group: "{{ node_exporter_user }}"
node_exporter_dir_conf: /etc/node_exporter
```


## 5 — Vérification de présence

```yaml id="jlwmcp"
- name: Check if node exporter exists
  ansible.builtin.stat:
    path: "{{ node_exporter_bin }}"
  register: __check_node_exporter_present
```


## 6 — Récupération de la version installée

### Exemple avec shell

```yaml id="x7kkcy"
- name: Get node exporter version from systemd service
  ansible.builtin.shell: "cat /etc/systemd/system/node_exporter.service | grep Version | sed s/'.*Version '//g"
  when: __check_node_exporter_present.stat.exists == true
  changed_when: false
  register: __get_node_exporter_version
```


### Explication

Cette tâche :

* lit le fichier de service
* récupère la ligne contenant `Version`
* extrait uniquement la version
* ne marque pas la tâche comme modifiée


## 7 — Condition de mise à jour

Le téléchargement et le nettoyage doivent être conditionnés à deux cas :

* Node Exporter n’est pas installé
* la version installée est différente de la version attendue


### Condition

```yaml id="snl6j4"
when: __check_node_exporter_present.stat.exists == false or __get_node_exporter_version.stdout != node_exporter_version
```


## 8 — Téléchargement conditionnel

```yaml id="3r2j7r"
- name: Download and extract node exporter
  ansible.builtin.unarchive:
    src: "https://github.com/prometheus/node_exporter/releases/download/v{{ node_exporter_version }}/node_exporter-{{ node_exporter_version }}.linux-amd64.tar.gz"
    dest: /tmp/
    remote_src: true
  when: __check_node_exporter_present.stat.exists == false or __get_node_exporter_version.stdout != node_exporter_version
```


## 9 — Déplacement du binaire

```yaml id="2mgg1m"
- name: Move binary
  ansible.builtin.copy:
    src: "/tmp/node_exporter-{{ node_exporter_version }}.linux-amd64/node_exporter"
    dest: "{{ node_exporter_bin }}"
    owner: "{{ node_exporter_user }}"
    group: "{{ node_exporter_group }}"
    mode: "0755"
    remote_src: true
  when: __check_node_exporter_present.stat.exists == false or __get_node_exporter_version.stdout != node_exporter_version
```


## 10 — Nettoyage conditionnel

```yaml id="feua4u"
- name: Clean temporary files
  ansible.builtin.file:
    path: "/tmp/node_exporter-{{ node_exporter_version }}.linux-amd64/"
    state: absent
  when: __check_node_exporter_present.stat.exists == false or __get_node_exporter_version.stdout != node_exporter_version
```


## 11 — Mise à jour du service systemd

Le template systemd doit être redéployé pour refléter la nouvelle version.

```yaml id="pjlwm3"
- name: Install systemd service
  ansible.builtin.template:
    src: node_exporter.service.j2
    dest: /etc/systemd/system/node_exporter.service
    owner: root
    group: root
    mode: "0755"
  notify: reload_daemon_and_restart_node_exporter
```


## 12 — Handler associé

```yaml id="i9ov5r"
- name: reload_daemon_and_restart_node_exporter
  ansible.builtin.systemd:
    name: node_exporter
    state: restarted
    daemon_reload: true
    enabled: true
```


## 13 — Logique globale

Workflow :

1. vérifier si le binaire existe
2. lire la version installée
3. comparer avec la version attendue
4. télécharger uniquement si nécessaire
5. remplacer le binaire
6. mettre à jour systemd
7. redémarrer le service


## 14 — Limites de l’approche

Cette méthode repose sur une convention :

* la version doit être présente dans le fichier de service

Si ce fichier est modifié manuellement ou absent, la détection devient moins fiable.


## 15 — Alternatives possibles

### Lecture du binaire

Exemple :

```bash id="94rbq3"
node_exporter --version
```

Avantages :

* plus proche de l’état réel du binaire

Inconvénients :

* nécessite d’exécuter le binaire


### Interrogation HTTP

Exemple :

```bash id="jonhmd"
curl http://localhost:9100/metrics
```

Avantages :

* vérifie aussi que le service répond

Inconvénients :

* nécessite que le service soit lancé


## 16 — Bonnes pratiques

* éviter les téléchargements inutiles
* centraliser la version dans une variable
* conditionner les tâches de mise à jour
* redémarrer uniquement si nécessaire
* garder une logique de version simple et explicite


## 17 — Anti-patterns

* télécharger à chaque exécution
* ne pas comparer les versions
* faire confiance uniquement à l’existence du binaire
* redémarrer systématiquement le service
* disperser la version dans plusieurs fichiers


## Conclusion

La gestion de version de Node Exporter permet de passer d’une simple installation à une vraie logique de maintenance.

Cette approche permet :

* une mise à jour conditionnelle
* une meilleure idempotence
* un meilleur contrôle des changements

C’est une étape importante pour industrialiser un rôle Ansible de déploiement applicatif ou système.


---

# 36 Ansible - Monitoring : Prometheus


## Documentation

Prometheus :
https://prometheus.io/docs/prometheus/latest/

Module apt :
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html

Module template :
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html

Module systemd :
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/systemd_module.html

Module uri :
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/uri_module.html


## Lab associé

[Voir le lab 36-ansible-installation-prometheus](../labs/36-ansible-installation-prometheus/)


## 1 — Objectif

Cette partie constitue la deuxième étape de la mise en pratique autour du monitoring.

La séquence globale est :

1. installation de Node Exporter
2. installation de Prometheus
3. installation de Grafana

L’objectif ici est d’installer Prometheus sur le nœud de monitoring afin de :

* collecter les métriques
* interroger les exporters
* centraliser les données
* préparer la visualisation dans Grafana


## 2 — Architecture cible

L’environnement de travail repose sur :

* 1 nœud de monitoring :

  * Prometheus
  * Grafana

* plusieurs nœuds supervisés :

  * Node Exporter

Prometheus joue ici le rôle de collecteur central.


## 3 — Structure du projet

```text
.
├── inventory.yml
├── playbook.yml
└── roles/
    ├── node_exporter/
    └── prometheus/
```


## 4 — Variables du rôle

Les variables permettent de piloter la configuration du service et du fichier `prometheus.yml`.

```yaml
prometheus_dir_configuration: "/etc/prometheus"
prometheus_retention_time: "365d"
prometheus_scrape_interval: "30s"
prometheus_node_exporter: true
prometheus_node_exporter_group: "all"
prometheus_env: "production"

prometheus_var_config:
  global:
    scrape_interval: "{{ prometheus_scrape_interval }}"
    evaluation_interval: 5s
    external_labels:
      env: "{{ prometheus_env }}"
  scrape_configs:
    - job_name: prometheus
      scrape_interval: 5m
      static_configs:
        - targets: ["{{ inventory_hostname }}:9090"]
```


## 5 — Logique du rôle

Le rôle Prometheus suit une séquence simple :

1. installation du paquet
2. génération des arguments de lancement
3. génération du fichier de configuration
4. démarrage du service
5. exécution des handlers

Cette approche permet de garder un rôle lisible et facilement maintenable.


## 6 — Installation de Prometheus

```yaml
- name: Update and install Prometheus
  ansible.builtin.apt:
    name: prometheus
    state: latest
    update_cache: true
    cache_valid_time: 3600
```

### Explication

Cette tâche :

* met à jour le cache APT
* installe Prometheus
* garantit la présence de la dernière version disponible dans le dépôt

En production, il peut être préférable de figer une version plutôt que d’utiliser systématiquement `latest`.


## 7 — Arguments passés à Prometheus

Prometheus utilise généralement un fichier d’environnement ou une configuration de service pour ses options de démarrage.

### Déploiement du fichier d’arguments

```yaml
- name: Prometheus args
  ansible.builtin.template:
    src: prometheus.j2
    dest: /etc/default/prometheus
    mode: "0644"
    owner: root
    group: root
  notify: restart_prometheus
```

### Explication

Cette tâche permet de générer les arguments du service à partir d’un template Jinja2.

Le handler `restart_prometheus` est notifié car un changement sur les arguments de lancement nécessite généralement un redémarrage du service.


## 8 — Fichier de configuration Prometheus

Le fichier principal de configuration est `prometheus.yml`.

### Déploiement du fichier

```yaml
- name: Prometheus configuration file
  ansible.builtin.template:
    src: prometheus.yml.j2
    dest: "{{ prometheus_dir_configuration }}/prometheus.yml"
    mode: "0755"
    owner: prometheus
    group: prometheus
  notify: reload_prometheus
```

### Explication

Cette tâche génère la configuration à partir des variables du rôle.

Le handler déclenché ici est `reload_prometheus`, car une modification de la configuration peut être rechargée sans redémarrage complet du service.


## 9 — Démarrage du service

```yaml
- name: Start Prometheus
  ansible.builtin.systemd:
    name: prometheus
    state: started
    enabled: true
```

### Explication

Cette tâche garantit que :

* le service est démarré
* le service est activé au boot


## 10 — Flush des handlers

```yaml
- name: Flush handlers
  meta: flush_handlers
```

### Explication

Par défaut, les handlers sont exécutés en fin de play.

`flush_handlers` permet ici de forcer leur exécution immédiatement, afin de s’assurer que Prometheus a bien pris en compte la configuration avant la suite du workflow.


## 11 — Handlers

### Redémarrage du service

```yaml
- name: restart_prometheus
  ansible.builtin.systemd:
    name: prometheus
    state: restarted
    enabled: true
    daemon_reload: true
```

### Rechargement de la configuration

```yaml
- name: reload_prometheus
  ansible.builtin.uri:
    url: http://localhost:9090/-/reload
    method: POST
    status_code: 200
```

### Explication

Deux logiques sont séparées :

* `restart_prometheus` : utilisé si les arguments de lancement changent
* `reload_prometheus` : utilisé si seule la configuration Prometheus change

Cette distinction est importante car elle évite des redémarrages inutiles.


## 12 — Exemple de template de configuration

Le contenu réel de `prometheus.yml.j2` peut s’appuyer sur la variable `prometheus_var_config`.

Exemple de logique attendue :

```jinja2
global:
  scrape_interval: {{ prometheus_var_config.global.scrape_interval }}
  evaluation_interval: {{ prometheus_var_config.global.evaluation_interval }}
  external_labels:
    env: "{{ prometheus_var_config.global.external_labels.env }}"

scrape_configs:
  - job_name: prometheus
    scrape_interval: 5m
    static_configs:
      - targets:
          - "{{ inventory_hostname }}:9090"
```


## 13 — Intégration avec Node Exporter

Une fois Node Exporter installé sur les nœuds supervisés, Prometheus peut les scrapper.

L’idée est de construire dynamiquement les cibles selon un groupe d’inventory, par exemple :

```yaml
prometheus_node_exporter_group: "all"
```

Cela permet de faire évoluer la configuration en fonction de l’inventory plutôt qu’en dur.

Dans une version plus avancée du rôle, on peut générer automatiquement les `targets` à partir des groupes Ansible.


## 14 — Vérification

Après déploiement, Prometheus doit être accessible sur :

```text
http://<ip_du_serveur_monitoring>:9090
```

Points à vérifier :

* le service tourne
* l’interface web est accessible
* la configuration est chargée
* les cibles apparaissent dans l’onglet Targets


## 15 — Bonnes pratiques

* séparer arguments système et configuration applicative
* utiliser des handlers distincts pour reload et restart
* utiliser des templates pour éviter la configuration en dur
* centraliser les variables du rôle
* versionner les fichiers de configuration
* utiliser l’inventory pour générer les cibles de scraping


## 16 — Anti-patterns

* mettre toutes les cibles Prometheus en dur sans lien avec l’inventory
* redémarrer Prometheus à chaque changement mineur
* mélanger configuration système et configuration applicative
* utiliser `latest` partout sans politique de version
* ne pas valider que le service répond après changement


## Conclusion

Cette étape permet d’ajouter la brique centrale de collecte dans la stack de monitoring.

Le rôle Prometheus permet :

* une installation propre
* une configuration pilotée par variables
* une intégration naturelle avec Node Exporter
* une gestion propre des changements via handlers

C’est la base nécessaire avant la troisième étape : l’installation et la configuration de Grafana.


---

# 37 Ansible - Module HTTP / Requêtes


## Documentation

https://docs.ansible.com/ansible/2.3/uri_module.html

Commande utile :

```bash
ansible-doc ansible.builtin.uri
```


## Lab associé

[Voir le lab 37-ansible-module-http-requetes](../labs/37-ansible-module-http-requetes/)


## 1 — Introduction au module uri

### Objectif

Le module `uri` permet d’envoyer des requêtes HTTP ou HTTPS depuis Ansible.

Il permet notamment de :

* tester un endpoint
* appeler une API
* vérifier un code de retour
* envoyer des données
* récupérer une réponse
* valider un contenu retourné

C’est le module de référence pour toutes les interactions HTTP dans un playbook.


## 2 — Cas d’usage

Le module `uri` est utile pour :

* tester la disponibilité d’un site
* interagir avec une API REST
* déclencher un reload applicatif
* vérifier un endpoint de supervision
* envoyer des données JSON
* automatiser des appels authentifiés


## 3 — Paramètres principaux

### url

URL cible :

```yaml
url: https://example.org
```


### method

Méthode HTTP :

* `GET`
* `POST`
* `PUT`
* `DELETE`
* `PATCH`
* `HEAD`
* `TRACE`

Exemple :

```yaml
method: GET
```


### status_code

Code ou liste de codes considérés comme valides :

```yaml
status_code: 200
```

ou

```yaml
status_code:
  - 200
  - 201
  - 301
```


### return_content

Permet de récupérer le contenu de la réponse :

```yaml
return_content: true
```


### body

Contenu envoyé dans la requête.


### body_format

Format du corps de requête :

* `json`
* `raw`

Exemple :

```yaml
body_format: json
```


### headers

Ajout de headers HTTP :

```yaml
headers:
  Content-Type: application/json
```


### user / password

Authentification basic auth :

```yaml
user: "toto"
password: "test"
```


### force_basic_auth

Force l’envoi du basic auth dès la première requête.


### validate_certs

Validation stricte du certificat TLS :

```yaml
validate_certs: false
```


### timeout

Durée maximale de la requête :

```yaml
timeout: 10
```


### follow_redirects

Permet de suivre les redirections.


## 4 — Requête simple

```yaml
- name: Test HTTP simple
  hosts: all
  tasks:
    - name: Requête GET
      ansible.builtin.uri:
        url: http://pp.blog
        method: GET
        validate_certs: false
```


## 5 — Vérification du code de retour

```yaml
- name: Vérification du status
  hosts: all
  tasks:
    - name: Requête GET avec status attendu
      ansible.builtin.uri:
        url: http://pp.blog
        method: GET
        validate_certs: false
        status_code: 200
```


### Explication

La tâche échoue si le code HTTP retourné n’est pas `200`.


## 6 — Liste de codes de retour autorisés

```yaml
- name: Vérification de plusieurs codes
  hosts: all
  tasks:
    - name: Requête POST avec plusieurs codes autorisés
      ansible.builtin.uri:
        url: https://httpbin.org/status/500
        method: POST
        status_code:
          - 200
          - 201
          - 301
        validate_certs: false
```


### Explication

Ici, seuls les codes listés seront considérés comme valides.


## 7 — Récupération du contenu

```yaml
- name: Récupération du contenu
  hosts: all
  tasks:
    - name: Requête GET avec contenu
      ansible.builtin.uri:
        url: http://httpbin.org/get
        return_content: true
        method: GET
      register: __content

    - name: Affichage du contenu
      ansible.builtin.debug:
        var: __content.content
```


### Explication

Le contenu de la réponse est stocké dans :

```yaml
__content.content
```


## 8 — Utilisation du format JSON

```yaml
- name: Requête JSON
  hosts: all
  tasks:
    - name: Appel HTTP avec parsing JSON
      ansible.builtin.uri:
        url: https://httpbin.org/get
        method: GET
        return_content: true
        validate_certs: false
        body_format: json
      register: __body

    - name: Affichage d'une clé JSON
      ansible.builtin.debug:
        var: __body.json.url
```


### Explication

Quand la réponse est interprétée comme JSON, on peut accéder directement aux clés via :

```yaml
__body.json.<clé>
```


## 9 — Validation du contenu

```yaml
- name: Validation du contenu
  hosts: all
  tasks:
    - name: Vérification de la réponse
      ansible.builtin.uri:
        url: http://pp.blog
        return_content: true
        method: GET
        validate_certs: false
      register: __content
      failed_when: "'pp' not in __content.content"
```


### Explication

Cette tâche :

* récupère le contenu
* échoue si la chaîne `pp` n’est pas présente

C’est utile pour :

* vérifier une bannière
* tester une page de santé
* valider une réponse métier simple


## 10 — Authentification basic auth

```yaml
- name: Requête avec basic auth
  hosts: all
  tasks:
    - name: Appel protégé
      ansible.builtin.uri:
        url: https://httpbin.org/basic-auth/toto/test
        user: "toto"
        password: "test"
        method: GET
        validate_certs: false
```


## 11 — Envoi de données JSON

Exemple d’appel `POST` avec body JSON :

```yaml
- name: Envoi JSON
  hosts: all
  tasks:
    - name: Requête POST JSON
      ansible.builtin.uri:
        url: https://httpbin.org/post
        method: POST
        body_format: json
        body:
          app: monitoring
          env: production
        return_content: true
      register: __result

    - name: Affichage du retour JSON
      ansible.builtin.debug:
        var: __result.json
```


## 12 — Headers personnalisés

```yaml
- name: Requête avec headers
  hosts: all
  tasks:
    - name: Appel API avec header
      ansible.builtin.uri:
        url: https://httpbin.org/headers
        method: GET
        headers:
          X-App-Name: ansible
          X-Env: prod
        return_content: true
      register: __headers_result
```


## 13 — Cas d’usage typiques

Le module `uri` est souvent utilisé pour :

* tester un endpoint web
* appeler une API de supervision
* déclencher un reload HTTP
* récupérer un token
* vérifier une page applicative
* faire des tests post-déploiement


## 14 — Bonnes pratiques

* toujours définir `status_code` quand c’est pertinent
* utiliser `return_content` seulement si nécessaire
* stocker les résultats dans `register`
* valider le contenu avec `failed_when` si besoin
* utiliser `validate_certs: true` en production sauf contrainte spécifique
* éviter de mettre des identifiants en dur


## 15 — Anti-patterns

* utiliser `shell` avec `curl` à la place de `uri`
* désactiver TLS sans raison
* ne pas vérifier le code de retour
* supposer qu’une réponse 200 est toujours suffisante
* exposer des credentials directement dans le code


## Conclusion

Le module `uri` est l’outil standard d’Ansible pour les interactions HTTP et HTTPS.

Il permet :

* des vérifications simples
* des appels API avancés
* des validations de services
* une intégration propre dans les playbooks

Sa maîtrise est essentielle pour les usages modernes d’Ansible, notamment autour des APIs, de la supervision et des tests applicatifs.


---

# 38 Ansible - Modules COMMAND & SHELL


## Documentation

SHELL :
https://docs.ansible.com/ansible/2.5/modules/shell_module.html

COMMAND :
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/command_module.html

Commande utile :

```bash
ansible-doc ansible.builtin.command
ansible-doc ansible.builtin.shell
```


## Lab associé

[Voir le lab 38-ansible-command-shell](../labs/38-ansible-command-shell/)


## 1 — Introduction

Les modules `command` et `shell` permettent d’exécuter des commandes sur les machines cibles.

Ils sont souvent utilisés pour :

* exécuter des commandes système
* interagir avec des outils CLI
* réaliser des actions non couvertes par des modules Ansible


## 2 — Différence entre COMMAND et SHELL

### command

* exécute une commande directement
* plus sécurisé
* ne passe pas par un shell
* ne supporte pas :

  * pipes (`|`)
  * redirections (`>`)
  * variables shell


### shell

* passe par un shell (`/bin/sh`)
* supporte :

  * pipes
  * redirections
  * variables d’environnement
  * scripts multi-lignes


### Règle importante

Toujours privilégier `command` quand possible.

Utiliser `shell` uniquement si nécessaire.


# PARTIE 1 — MODULE COMMAND


## 3 — Paramètres principaux

### cmd

Commande à exécuter :

```yaml
cmd: ls
```


### argv

Commande sous forme de liste :

```yaml
argv:
  - ls
  - -larth
```


### chdir

Changer de répertoire avant exécution :

```yaml
chdir: /etc/
```


### creates

N’exécute pas la commande si le fichier existe :

```yaml
creates: /tmp/file
```


### removes

Exécute la commande uniquement si le fichier existe :

```yaml
removes: /tmp/file
```


### stdin

Entrée standard.


### warn

Activer/désactiver les warnings.


## 4 — Exemple simple

```yaml
- name: Commande simple
  ansible.builtin.command:
    cmd: ls
  register: __output
```


## 5 — Changement de répertoire

```yaml
- name: Commande avec chdir
  ansible.builtin.command:
    cmd: ls
    chdir: /etc/
  register: __output
```


## 6 — Utilisation avec argv

```yaml
- name: Commande avec argv
  ansible.builtin.command:
    argv:
      - ls
      - -larth
  register: __output
```


## 7 — Utilisation avec creates

```yaml
- name: Création fichier
  ansible.builtin.file:
    path: /tmp/pp
    state: touch

- name: Commande conditionnelle
  ansible.builtin.command:
    cmd: ls -lath /tmp
    creates: /tmp/pp
  register: __output
```


### Explication

Si `/tmp/pp` existe, la commande ne sera pas exécutée.


## 8 — Utilisation avec removes

```yaml
- name: Commande si fichier existe
  ansible.builtin.command:
    cmd: ls -lath /tmp
    removes: /tmp/pp
```


### Explication

La commande s’exécute uniquement si le fichier existe.


# PARTIE 2 — MODULE SHELL


## 9 — Paramètres principaux

### chdir

Répertoire d’exécution.


### creates / removes

Même logique que `command`.


### executable

Choix du shell :

```yaml
executable: /bin/bash
```


### stdin

Entrée standard.


### warn

Afficher ou non les warnings.


## 10 — Exemple avec pipe

```yaml
- name: Commande avec pipe
  ansible.builtin.shell: cat /etc/hosts | grep 127
  register: __output

- name: Debug
  ansible.builtin.debug:
    var: __output
```


## 11 — Exemple multi-lignes

```yaml
- name: Bloc de commandes
  ansible.builtin.shell: |
    cat /etc/hosts
    ls /etc/
  register: __output

- name: Debug
  ansible.builtin.debug:
    var: __output
```


## 12 — Variables d’environnement

```yaml
- name: Commande avec variable d'environnement
  ansible.builtin.shell: echo "Hello $MAVAR"
  environment:
    MAVAR: "pp"
  register: __output
```


## 13 — Cas d’usage typiques

* exécuter une commande système
* interagir avec un outil CLI
* parser une sortie
* lancer un script
* faire un test rapide


## 14 — Bonnes pratiques

* privilégier `command` à `shell`
* utiliser `creates` et `removes` pour l’idempotence
* éviter les commandes complexes
* utiliser `register` pour analyser les résultats
* préférer un module Ansible dédié si disponible


## 15 — Anti-patterns

* utiliser `shell` pour tout
* ne pas contrôler l’idempotence
* utiliser des pipes inutiles
* écrire des scripts complexes dans `shell`
* ignorer les modules natifs Ansible


## 16 — Comparaison rapide

| Critère          | command | shell                   |
| ---------------- | ------- | ----------------------- |
| Sécurité         | élevée  | plus faible             |
| Support pipes    | non     | oui                     |
| Redirections     | non     | oui                     |
| Variables shell  | non     | oui                     |
| Usage recommandé | oui     | seulement si nécessaire |


## Conclusion

Les modules `command` et `shell` permettent d’exécuter des commandes sur les machines cibles.

* `command` doit être utilisé par défaut
* `shell` est réservé aux cas nécessitant des fonctionnalités avancées

Une bonne utilisation de ces modules permet :

* de garder des playbooks propres
* d’éviter les comportements imprévisibles
* de maintenir une bonne idempotence


---

# 39 Ansible - Variables d’environnement et prompt


## Documentation

https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_environment.html


## Lab associé

[Voir le lab 39-ansible-env-et-prompt](../labs/39-ansible-env-et-prompt/)


## 1 — Introduction

Ansible permet :

* de définir des variables d’environnement
* d’interagir avec l’utilisateur via des prompts

Ces mécanismes sont utiles pour :

* adapter dynamiquement un playbook
* injecter des valeurs runtime
* gérer différents environnements (dev, stage, prod)


## 2 — Variables d’environnement

### Objectif

Les variables d’environnement permettent de :

* passer des valeurs aux commandes exécutées
* influencer le comportement des outils CLI
* standardiser certaines configurations


## 3 — Définition dans un playbook

```yaml
- name: Exemple variables d’environnement
  hosts: all
  environment:
    PATHLIB: "/var/lib/"

  tasks:
    - name: Echo variable
      ansible.builtin.shell: echo $PATHLIB
      register: __output

    - name: Affichage
      ansible.builtin.debug:
        var: __output
```


### Explication

* la variable est définie au niveau du play
* elle est disponible dans toutes les tâches


## 4 — Définition au niveau d’une tâche

```yaml
- name: Variable environnement par tâche
  hosts: all
  tasks:
    - name: Echo variable
      ansible.builtin.shell: echo $PATHLIB
      environment:
        PATHLIB: "/tmp/"
      register: __output
```


### Explication

* portée limitée à la tâche
* écrase les variables du play si conflit


## 5 — vars_prompt

### Objectif

`vars_prompt` permet de demander une valeur à l’utilisateur au moment de l’exécution.


## 6 — Exemple simple

```yaml
- name: Prompt utilisateur
  hosts: all

  vars_prompt:
    - name: nom

  tasks:
    - name: Echo nom
      ansible.builtin.shell: "echo Salut {{ nom }}"
      register: __output

    - name: Affichage
      ansible.builtin.debug:
        var: __output
```


### Explication

* Ansible demande une valeur pour `nom`
* la valeur est ensuite utilisable dans le playbook


## 7 — Prompt avec message et valeur par défaut

```yaml
- name: Prompt avec défaut
  hosts: all

  vars_prompt:
    - name: env
      prompt: "Quel est votre environnement ? prod/stage/dev"
      default: dev

  environment:
    ENV: "{{ env }}"

  tasks:
    - name: Echo environnement
      ansible.builtin.shell: "echo Salut $ENV"
      register: __output

    - name: Affichage
      ansible.builtin.debug:
        var: __output
```


### Explication

* un message est affiché
* une valeur par défaut est proposée
* la valeur est injectée dans une variable d’environnement


## 8 — Variables d’environnement côté machine Ansible

On peut récupérer une variable d’environnement locale (machine contrôleur) avec `lookup`.

```yaml
- name: Lecture variable environnement locale
  hosts: all
  tasks:
    - name: Echo ENV local
      ansible.builtin.shell: "echo {{ lookup('env', 'ENV') | default('stage', true) }}"
      register: __output

    - name: Affichage
      ansible.builtin.debug:
        var: __output
```


### Explication

* `lookup('env', 'ENV')` récupère la variable côté contrôleur
* `default('stage', true)` définit une valeur par défaut si absente


## 9 — Cas d’usage typiques

* choisir un environnement (dev / prod)
* injecter des variables dynamiques
* passer des credentials temporaires
* adapter un comportement runtime
* interagir avec l’utilisateur


## 10 — Bonnes pratiques

* utiliser `vars_prompt` pour les valeurs sensibles ou dynamiques
* définir des valeurs par défaut
* limiter l’usage des variables d’environnement aux besoins réels
* documenter les variables attendues
* éviter les dépendances implicites


## 11 — Anti-patterns

* utiliser des variables d’environnement sans les documenter
* dépendre d’un prompt dans des pipelines automatisés
* exposer des informations sensibles en clair
* multiplier les sources de variables
* ne pas gérer les valeurs par défaut


## Conclusion

Les variables d’environnement et les prompts permettent :

* une meilleure flexibilité
* une adaptation dynamique des playbooks
* une interaction utilisateur simple

Bien utilisés, ils permettent de rendre les déploiements plus souples tout en gardant une bonne maîtrise de la configuration.


---

# 40 Ansible - Module SYNCHRONIZE


## Documentation

https://docs.ansible.com/ansible/2.3/synchronize_module.html


## Lab associé

[Voir le lab 40-ansible-synchronize](../labs/40-ansible-synchronize/)


## 1 — Introduction

Le module `synchronize` est un wrapper autour de **rsync**.

Il permet de :

* synchroniser des fichiers ou répertoires
* optimiser les transferts
* gérer les mises à jour différentielles
* limiter les volumes de données transférés


## 2 — Pourquoi utiliser synchronize

Comparé au module `copy` :

| Critère      | copy       | synchronize |
| ------------ | ---------- | ----------- |
| Performance  | faible     | élevée      |
| Gros volumes | non adapté | adapté      |
| Delta (diff) | non        | oui         |
| Robustesse   | moyenne    | élevée      |


### Intérêt principal

* rsync envoie uniquement les différences
* gestion des coupures réseau
* meilleure performance sur gros volumes


## 3 — Prérequis

* rsync doit être installé :

  * sur la machine Ansible
  * sur les machines cibles

```yaml
- name: Install rsync
  ansible.builtin.apt:
    name: rsync
    state: present
  become: yes
```


## 4 — Paramètres principaux

### src / dest

```yaml
src: fichier ou répertoire source
dest: destination
```


### mode

* `push` (défaut) : machine Ansible → cible
* `pull` : cible → machine Ansible


### archive

Active plusieurs options rsync :

* permissions
* timestamps
* ownership

```yaml
archive: yes
```


### recursive

Parcours des sous-répertoires :

```yaml
recursive: yes
```


### delete

Supprime les fichiers en trop côté destination :

```yaml
delete: yes
```


### compress

Compression pendant le transfert :

```yaml
compress: yes
```


### checksum

Comparaison via checksum plutôt que timestamp :

```yaml
checksum: yes
```


### owner / group / perms

Préservation des attributs :

```yaml
owner: yes
group: yes
perms: yes
```


### rsync_opts

Options supplémentaires :

```yaml
rsync_opts:
  - "--exclude=.git"
```


### partial

Conserve les fichiers partiellement transférés :

```yaml
partial: yes
```


### times

Préserve les dates :

```yaml
times: yes
```


## 5 — Exemple simple

```yaml
- name: Synchronisation simple
  hosts: all
  tasks:
    - name: Sync fichier
      ansible.builtin.synchronize:
        src: pp.txt
        dest: /tmp/pp.txt
```


## 6 — Synchronisation de répertoire

```yaml
- name: Synchronisation répertoire
  hosts: all
  tasks:
    - name: Création dossier cible
      ansible.builtin.file:
        path: /tmp/files
        state: directory

    - name: Sync répertoire
      ansible.builtin.synchronize:
        src: files/
        dest: /tmp/files
```


### Explication

* le `/` final est important
* copie le contenu du dossier et non le dossier lui-même


## 7 — Synchronisation entre deux machines distantes

```yaml
- name: Sync entre deux machines
  hosts: all
  tasks:
    - name: Installation rsync
      ansible.builtin.apt:
        name: rsync
        state: present
      become: yes

    - name: Création dossier cible
      ansible.builtin.file:
        path: /tmp/files
        state: directory

    - name: Synchronisation distante
      ansible.builtin.synchronize:
        src: /tmp/files/
        dest: /tmp/files
      delegate_to: 172.17.0.2
```


### Explication

* `delegate_to` permet d’exécuter la synchronisation depuis un autre host
* utile pour des transferts machine → machine sans passer par le contrôleur


## 8 — Mode pull

```yaml
- name: Récupération depuis cible
  hosts: all
  tasks:
    - name: Pull depuis remote
      ansible.builtin.synchronize:
        mode: pull
        src: /etc/hosts
        dest: ./hosts_backup/
```


## 9 — Exemple avancé

```yaml
- name: Synchronisation avancée
  hosts: all
  tasks:
    - name: Sync avec options
      ansible.builtin.synchronize:
        src: /data/
        dest: /backup/data/
        archive: yes
        delete: yes
        compress: yes
        rsync_opts:
          - "--exclude=*.log"
          - "--exclude=.cache"
```


## 10 — Cas d’usage typiques

* sauvegarde de données
* déploiement applicatif
* synchronisation de fichiers volumineux
* mirroring de répertoires
* copie entre serveurs


## 11 — Bonnes pratiques

* toujours utiliser `archive: yes` pour des copies complètes
* utiliser `delete` avec précaution
* vérifier le sens (`push` vs `pull`)
* tester avec des petits volumes avant production
* exclure les fichiers inutiles


## 12 — Anti-patterns

* utiliser `copy` pour de gros volumes
* oublier d’installer rsync
* utiliser `delete` sans validation
* synchroniser sans comprendre le sens du flux
* ignorer les permissions et ownership


## Conclusion

Le module `synchronize` est indispensable pour :

* les transferts volumineux
* les synchronisations fréquentes
* les environnements distribués

Il combine la puissance de rsync avec la simplicité d’Ansible, ce qui en fait un outil clé pour les infrastructures modernes.


---

# 41 Ansible - Inventory dynamique


## Documentation

[https://docs.ansible.com/ansible/latest/plugins/inventory.html](https://docs.ansible.com/ansible/latest/plugins/inventory.html)
[https://docs.ansible.com/ansible/latest/dev_guide/developing_inventory.html](https://docs.ansible.com/ansible/latest/dev_guide/developing_inventory.html)
[https://github.com/ansible-collections/community.general/tree/main/scripts/inventory](https://github.com/ansible-collections/community.general/tree/main/scripts/inventory)


## Lab associé

[Voir le lab 41-ansible-inventory-dynamic](../labs/41-ansible-inventory-dynamic/)


## 1 — Introduction

Un inventory dynamique permet de générer automatiquement la liste des hosts au lieu de les définir statiquement.

Contrairement à un inventory classique :

* statique → écrit à la main
* dynamique → généré à la volée


## 2 — Objectif

Permet de :

* découvrir automatiquement des machines
* s’intégrer avec des APIs (cloud, CMDB…)
* éviter la maintenance manuelle
* adapter l’infrastructure en temps réel


## 3 — Types d’inventory dynamique

### 1. Scripts (legacy)

* script bash / python
* retourne du JSON
* exécuté par Ansible


### 2. Plugins (moderne)

* YAML + plugin
* plus propre et maintenable
* recommandé aujourd’hui


## 4 — Configuration ansible.cfg

```ini
[inventory]
enable_plugins = host_list, script, auto, yaml, ini, toml
```


## 5 — Exemple avec plugin (nmap)

### Fichier nmap.yml

```yaml
plugin: nmap
strict: false
address: 192.168.1.0/24
```


### Commandes

```bash
ansible-inventory -i nmap.yml --list
ansible -i nmap.yml all -m ping
```


### Explication

* scan réseau automatique
* génération des hosts
* inventory dynamique basé sur découverte


## 6 — Script dynamique (inventory.sh)

Un script dynamique doit :

* accepter des arguments (`--list`, `--host`)
* retourner du JSON valide


### Exemple simplifié

```bash
#!/bin/bash

ip="
192.168.100.12
192.168.100.13
"

if [ "$1" = "--list" ]; then
  echo "{"
  echo '  "grp1": {'
  echo '    "hosts": ['

  first=1
  for i in $ip; do
    if [ $first -eq 1 ]; then
      first=0
    else
      echo ','
    fi
    printf '      "%s"' "$i"
  done

  echo ''
  echo '    ],'
  echo '    "vars": {'
  echo '      "mavariable": "1"'
  echo '    }'
  echo '  },'
  echo '  "_meta": {'
  echo '    "hostvars": {'

  first=1
  for i in $ip; do
    if [ $first -eq 1 ]; then
      first=0
    else
      echo ','
    fi

    if [ "$i" = "192.168.100.12" ]; then
      var1="pp1"
    elif [ "$i" = "192.168.100.13" ]; then
      var1="pp2"
    else
      var1="default"
    fi

    printf '      "%s": {\n' "$i"
    printf '        "var1": "%s"\n' "$var1"
    printf '      }'
  done

  echo ''
  echo '    }'
  echo '  }'
  echo '}'

elif [ "$1" = "--host" ]; then
  echo "{}"
else
  echo "{}"
fi
```


## 7 — Structure attendue

Un inventory dynamique doit retourner :

```json
{
  "group": {
    "hosts": [],
    "vars": {}
  },
  "_meta": {
    "hostvars": {}
  }
}
```


## 8 — Utilisation

```bash
chmod +x inventory.sh

ansible-inventory -i inventory.sh --list
ansible -i inventory.sh all -m ping
```


## 9 — Concepts importants

### _meta.hostvars

* permet d’éviter un appel `--host` par machine
* améliore fortement les performances


### --list vs --host

* `--list` : retourne tout l’inventory
* `--host <hostname>` : retourne les variables d’un host

Aujourd’hui, `_meta` remplace généralement `--host`


## 10 — Cas d’usage typiques

* cloud (AWS, Azure, GCP)
* Kubernetes
* CMDB
* discovery réseau
* environnements dynamiques


## 11 — Bonnes pratiques

* privilégier les plugins aux scripts
* toujours retourner un JSON valide
* utiliser `_meta` pour les performances
* versionner les scripts
* tester avec `ansible-inventory`


## 12 — Anti-patterns

* écrire des scripts complexes non maintenables
* ne pas gérer les erreurs JSON
* faire un appel externe par host
* ne pas documenter la logique
* mélanger logique métier et inventory


## Conclusion

L’inventory dynamique est essentiel pour :

* les infrastructures modernes
* les environnements cloud
* les architectures évolutives

Il permet de rendre Ansible :

* plus flexible
* plus automatisé
* plus scalable

C’est une brique clé dès que l’infrastructure n’est plus statique.


---

# 42 Ansible - Module ASSEMBLE


## Documentation

https://docs.ansible.com/ansible/latest/collections/ansible/builtin/assemble_module.html


## Lab associé

[Voir le lab 42-ansible-assemble](../labs/42-ansible-assemble/)


## 1 — Introduction

Le module `assemble` permet de concaténer plusieurs fichiers en un seul.

Il est particulièrement utile pour :

* générer des fichiers de configuration
* assembler des fragments
* modulariser des configurations


## 2 — Objectif

Plutôt que de gérer un gros fichier unique, on découpe :

* plusieurs petits fichiers (fragments)
* regroupés ensuite automatiquement

Cela permet :

* une meilleure lisibilité
* une maintenance plus simple
* une organisation modulaire


## 3 — Fonctionnement

Le module :

1. lit tous les fichiers d’un répertoire
2. les concatène dans un ordre donné
3. génère un fichier final


## 4 — Paramètres principaux

### src

Répertoire contenant les fichiers source :

```yaml
src: /tmp/sources
```


### dest

Fichier final généré :

```yaml
dest: /tmp/myconf.cfg
```


### remote_src

* `yes` : les fichiers sont déjà sur la machine cible
* `no` : les fichiers sont sur la machine Ansible


### delimiter

Ajoute un séparateur entre chaque fichier :

```yaml
delimiter: '### START FRAGMENT ###'
```


### regexp

Filtrer les fichiers :

```yaml
regexp: ".*\\.conf"
```


### backup

Créer un backup du fichier final :

```yaml
backup: yes
```


### validate

Valider le fichier avant écriture :

```yaml
validate: /usr/sbin/nginx -t -c %s
```


## 5 — Exemple avec fichiers sur la cible (remote)

```yaml
- name: Création répertoire source
  ansible.builtin.file:
    path: /tmp/sources
    state: directory

- name: Copie des fragments
  ansible.builtin.copy:
    src: "files/{{ item }}"
    dest: /tmp/sources/
  with_items:
    - t1
    - t2
    - t3

- name: Assemble fichier
  ansible.builtin.assemble:
    src: /tmp/sources
    dest: /tmp/myconf.cfg
```


### Explication

* les fichiers sont copiés sur la cible
* `assemble` concatène les fichiers présents sur la cible


## 6 — Exemple avec delimiter

```yaml
- name: Assemble avec séparateur
  ansible.builtin.assemble:
    src: /tmp/sources
    dest: /tmp/myconf.cfg
    delimiter: '### START FRAGMENT ###'
```


### Explication

Chaque fichier sera séparé par une ligne spécifique, utile pour :

* debug
* lisibilité
* audit


## 7 — Exemple sans remote_src

```yaml
- name: Assemble depuis machine Ansible
  ansible.builtin.assemble:
    src: files/
    dest: /tmp/myconf.cfg
    remote_src: no
```


### Explication

* les fichiers sont lus côté machine Ansible
* puis envoyés sur la cible


## 8 — Cas d’usage typiques

* configuration nginx (vhosts fragmentés)
* configuration ssh
* fichiers applicatifs modulaires
* assemblage de fragments dynamiques
* gestion de conf multi-sources


## 9 — Bonnes pratiques

* nommer les fichiers avec un ordre (ex : 01_, 02_, 03_)
* utiliser `delimiter` pour debug
* utiliser `validate` pour éviter les erreurs
* éviter les fichiers trop volumineux
* organiser les fragments logiquement


## 10 — Anti-patterns

* concaténer des fichiers non structurés
* ne pas contrôler l’ordre des fichiers
* oublier la validation
* mélanger plusieurs types de contenu
* utiliser assemble pour des cas simples


## 11 — Différence avec TEMPLATE

| Module   | Usage                               |
| -------- | ----------------------------------- |
| template | fichier unique dynamique            |
| assemble | concaténation de plusieurs fichiers |


## Conclusion

Le module `assemble` permet de :

* modulariser la configuration
* simplifier la maintenance
* structurer les fichiers complexes

C’est une approche très utilisée dans les environnements DevOps pour gérer des configurations évolutives.


---

# 43 Ansible - Module SET_FACT


## Documentation

https://docs.ansible.com/ansible/latest/collections/ansible/builtin/set_fact_module.html


## Lab associé

[Voir le lab 43-ansible-set-fact](../labs/43-ansible-set-fact/)


## 1 — Introduction

Le module `set_fact` permet de définir des variables dynamiques pendant l’exécution d’un playbook.

Ces variables :

* sont calculées à runtime
* peuvent dépendre d’autres variables
* peuvent être utilisées dans les tâches suivantes


## 2 — Objectif

Permet de :

* construire des variables dynamiques
* stocker des résultats intermédiaires
* enrichir les facts
* manipuler des données


## 3 — Paramètres principaux

### key: value

Définition d’une variable :

```yaml
mavariable: "valeur"
```


### cacheable

Permet de stocker la variable dans le cache de facts :

```yaml
cacheable: yes
```


## 4 — Exemple simple

```yaml
- name: Set fact simple
  hosts: all
  tasks:
    - name: Définir une variable
      ansible.builtin.set_fact:
        mavariable: "Hello tout le monde !!"

    - name: Debug
      ansible.builtin.debug:
        var: mavariable
```


### Explication

* la variable est créée dynamiquement
* elle est disponible dans toutes les tâches suivantes


## 5 — Exemple avec calcul

```yaml
- name: Set fact dynamique
  hosts: all
  vars:
    var1: "hello"
    var2: "je suis"

  tasks:
    - name: Récupération user
      ansible.builtin.command: "echo $USER"
      register: __user

    - name: Construction variable
      ansible.builtin.set_fact:
        mavariable: "{{ var1 }} {{ var2 }} {{ __user.stdout }} sur {{ ansible_hostname }}"

    - name: Debug
      ansible.builtin.debug:
        var: mavariable
```


### Explication

* on combine plusieurs sources :

  * variables
  * résultat d’une commande
  * facts système
* résultat dynamique construit à l’exécution


## 6 — Accès aux facts existants

Exemple avec les facts système :

```yaml
- name: Affichage date
  hosts: all
  tasks:
    - name: Debug date
      ansible.builtin.debug:
        var: ansible_date_time
```


### Explication

Les facts sont stockés dans :

```yaml
ansible_facts
```


## 7 — Cache des facts

Configuration dans `ansible.cfg` :

```ini
# cache facts
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp/facts_cache
fact_caching_timeout = 7200
```


### Explication

* permet de réutiliser les facts entre plusieurs runs
* améliore les performances
* évite de recalculer certaines données


## 8 — Utilisation de cacheable

```yaml
- name: Set fact cacheable
  ansible.builtin.set_fact:
    mavariable: "persistante"
  cacheable: yes
```


### Explication

* la variable est stockée dans le cache
* elle peut être réutilisée dans d’autres playbooks


## 9 — Contourner le cache

```yaml
- name: Date sans cache
  hosts: all
  tasks:
    - name: Récupération date
      ansible.builtin.shell: "date +%Y-%m-%d"
      register: shell_date

    - name: Set fact
      ansible.builtin.set_fact:
        date: "{{ shell_date.stdout }}"
```


### Explication

* permet d’éviter les valeurs obsolètes
* utile pour les données dynamiques


## 10 — Cas d’usage typiques

* construire des variables dynamiques
* stocker un résultat intermédiaire
* transformer des données
* préparer des templates
* gérer des conditions complexes


## 11 — Bonnes pratiques

* nommer clairement les variables
* éviter les collisions de noms
* utiliser `set_fact` pour des valeurs calculées uniquement
* privilégier `vars` pour les valeurs statiques
* documenter les variables importantes


## 12 — Anti-patterns

* utiliser `set_fact` pour tout
* écraser des variables existantes sans le savoir
* stocker trop de données dans les facts
* ne pas gérer le cache
* créer des dépendances implicites


## 13 — Priorité des variables

Les variables définies avec `set_fact` ont une priorité élevée.

Elles écrasent :

* variables d’inventaire
* group_vars
* host_vars
* variables de playbook

Mais restent inférieures aux `extra vars (-e)`.


## Conclusion

Le module `set_fact` est essentiel pour :

* manipuler des données dynamiques
* enrichir les playbooks
* construire des logiques avancées

Bien utilisé, il permet de rendre les automatisations plus intelligentes et plus flexibles.


---

# 44 Ansible - Monitoring : Grafana


## Documentation

Grafana :
https://grafana.com/docs/

Module apt :
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html

Module apt_key :
https://docs.ansible.com/ansible/2.5/modules/apt_key_module.html

Module apt_repository :
https://docs.ansible.com/ansible/2.5/modules/apt_repository_module.html

Module systemd :
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/systemd_module.html

Module uri :
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/uri_module.html


## Lab associé

[Voir le lab 44-ansible-grafana](../labs/44-ansible-grafana/)


## 1 — Introduction

Cette partie correspond à la troisième étape du monitoring :

1. Node Exporter
2. Prometheus
3. Grafana

Grafana permet de :

* visualiser les métriques
* créer des dashboards
* exploiter les données de Prometheus


## 2 — Objectif

Mettre en place Grafana sur le serveur de monitoring afin de :

* se connecter à Prometheus
* visualiser les données
* construire des dashboards


## 3 — Architecture

* 1 serveur monitoring :

  * Prometheus
  * Grafana

* N serveurs :

  * Node Exporter

Grafana interroge Prometheus qui lui-même collecte les métriques.


## 4 — Installation des prérequis

```yaml
- name: Install GPG tools
  ansible.builtin.apt:
    name: gnupg,software-properties-common
    state: present
    update_cache: yes
    cache_valid_time: 3600
```


### Explication

* nécessaire pour gérer les clés GPG
* indispensable pour ajouter des dépôts externes


## 5 — Ajout de la clé GPG

```yaml
- name: Add Grafana GPG key
  ansible.builtin.apt_key:
    url: "https://packages.grafana.com/gpg.key"
    validate_certs: no
```


### Explication

* permet de valider les paquets Grafana
* étape obligatoire avant ajout du dépôt


## 6 — Ajout du repository

```yaml
- name: Add Grafana repository
  ansible.builtin.apt_repository:
    repo: "deb https://packages.grafana.com/oss/deb stable main"
    state: present
    validate_certs: no
```


### Explication

* ajoute le dépôt officiel Grafana
* permet d’installer le package via APT


## 7 — Installation de Grafana

```yaml
- name: Install Grafana
  ansible.builtin.apt:
    name: grafana
    state: latest
    update_cache: yes
    cache_valid_time: 3600
```


### Explication

* installe Grafana
* récupère la dernière version disponible


## 8 — Démarrage du service

```yaml
- name: Start Grafana service
  ansible.builtin.systemd:
    name: grafana-server
    state: started
    enabled: yes
```


### Explication

* démarre Grafana
* active le service au boot


## 9 — Attente du service

```yaml
- name: Wait for Grafana to be up
  ansible.builtin.uri:
    url: "http://127.0.0.1:3000"
    status_code: 200
  register: __result
  until: __result.status == 200
  retries: 120
  delay: 1
```


### Explication

* attend que Grafana soit disponible
* évite d’enchaîner des tâches trop tôt
* retry toutes les secondes pendant 120 secondes


## 10 — Changement du mot de passe admin

```yaml
- name: Change Grafana admin password
  ansible.builtin.shell: "grafana-cli admin reset-admin-password {{ grafana_admin_password }}"
  register: __command_admin
  changed_when: __command_admin.rc != 0
```


### Explication

* modifie le mot de passe admin par défaut
* utilise `grafana-cli`
* évite les changements inutiles avec `changed_when`


## 11 — Variables recommandées

```yaml
grafana_admin_password: "StrongPassword123"
```


## 12 — Accès à Grafana

Grafana est accessible sur :

```text
http://<ip_du_serveur>:3000
```

Identifiants par défaut :

* user : admin
* password : admin (modifié via Ansible)


## 13 — Intégration avec Prometheus

Dans Grafana :

1. ajouter une datasource
2. type : Prometheus
3. URL :

   ```text
   http://localhost:9090
   ```


## 14 — Cas d’usage

* dashboards monitoring
* visualisation CPU / RAM / disque
* métriques applicatives
* alerting
* observabilité


## 15 — Bonnes pratiques

* changer le mot de passe admin
* utiliser HTTPS en production
* sauvegarder les dashboards
* utiliser des variables d’environnement
* versionner les dashboards (json)


## 16 — Anti-patterns

* laisser les credentials par défaut
* ne pas sécuriser l’accès
* ne pas attendre le service avant configuration
* tout configurer manuellement
* ne pas versionner les dashboards


## Conclusion

Grafana complète la stack de monitoring :

* Node Exporter → collecte
* Prometheus → stockage
* Grafana → visualisation

Cette dernière étape permet :

* de rendre les données exploitables
* d’avoir une vision claire de l’infrastructure
* de finaliser une stack de monitoring complète et professionnelle


---

