![Ansible](../assets/images/ansible.png)

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
