![Ansible](../assets/images/ansible.png)

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
