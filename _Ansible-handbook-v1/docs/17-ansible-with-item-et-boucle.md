![Ansible](../assets/images/ansible.png)

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
