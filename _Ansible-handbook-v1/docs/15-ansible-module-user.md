![Ansible](../assets/images/ansible.png)

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
