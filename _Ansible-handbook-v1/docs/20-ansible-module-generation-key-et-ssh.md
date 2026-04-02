![Ansible](../assets/images/ansible.png)

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
