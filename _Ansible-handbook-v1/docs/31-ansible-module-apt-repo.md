![Ansible](../assets/images/ansible.png)

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
