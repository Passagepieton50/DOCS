![Ansible](../assets/images/ansible.png)

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
