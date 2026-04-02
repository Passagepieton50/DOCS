![Ansible](../assets/images/ansible.png)

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
