![Ansible](../assets/images/ansible.png)

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
