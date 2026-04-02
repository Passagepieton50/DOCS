![Ansible](../assets/images/ansible.png)

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
