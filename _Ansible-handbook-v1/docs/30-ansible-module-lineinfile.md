![Ansible](../assets/images/ansible.png)

# 30 Ansible - Module LINEINFILE


## Documentation

https://docs.ansible.com/ansible/2.5/modules/lineinfile_module.html

Commande utile :

```bash
ansible-doc ansible.builtin.lineinfile
```


## Lab associé

[Voir le lab 30-ansible-module-lineinfile](../labs/30-ansible-module-lineinfile/)


## 1 — Introduction au module lineinfile

### Objectif

Le module `lineinfile` permet de :

* ajouter une ligne dans un fichier
* modifier une ligne existante
* supprimer une ligne
* garantir la présence ou l’absence d’une ligne


### Cas d’usage

* modifier un fichier de configuration
* ajouter une directive
* commenter une ligne
* corriger une configuration existante


## 2 — Paramètres principaux

### path / dest

Chemin du fichier :

```yaml
path: /tmp/test.conf
```


### line

Ligne à ajouter ou modifier :

```yaml
line: "test"
```


### state

* `present` : ligne présente
* `absent` : ligne supprimée


### regexp

Expression régulière pour rechercher la ligne :

```yaml
regexp: "^test$"
```


### create

Créer le fichier s’il n’existe pas :

```yaml
create: true
```


### backrefs

Permet d’utiliser les captures regex :

```yaml
backrefs: true
```


### insertbefore / insertafter

Positionnement de la ligne :

```yaml
insertbefore: "^pattern"
insertafter: "^pattern"
```


### backup

Créer un backup avant modification :

```yaml
backup: true
```


### owner / group / mode

Gestion des permissions.


### validate

Permet de valider avant écriture.


## 3 — Ajout simple d’une ligne

```yaml
- name: Ajout simple
  ansible.builtin.lineinfile:
    path: /tmp/test.conf
    line: "test"
    state: present
    create: true
```


### Remarque

Si la ligne change, une nouvelle ligne peut être ajoutée si aucune correspondance n’est trouvée.


## 4 — Modification d’une ligne

```yaml
- name: Modification d'une ligne
  ansible.builtin.lineinfile:
    path: /tmp/test.conf
    line: "test 2"
    regexp: "^test$"
    state: present
    create: true
```


### Explication

* recherche de la ligne `test`
* remplacement par `test 2`


## 5 — Utilisation des captures (backrefs)

```yaml
- name: Modification avec capture
  ansible.builtin.lineinfile:
    path: /tmp/test.conf
    line: "je suis le nombre : \\1"
    regexp: "^test ([0-2])$"
    backrefs: true
    state: present
    create: true
```


### Explication

* capture du chiffre avec regex
* réutilisation avec `\1`


### Attention

Les captures peuvent produire des effets inattendus sur plusieurs exécutions si mal maîtrisées.


## 6 — Commenter une ligne

```yaml
- name: Commenter une ligne
  ansible.builtin.lineinfile:
    path: /tmp/test.conf
    line: "# \\1"
    regexp: "(^je suis le nombre : [0-2])"
    backrefs: true
    state: present
    create: true
```


## 7 — Insertion avant une ligne

```yaml
- name: Insertion avant
  ansible.builtin.lineinfile:
    path: /tmp/test.conf
    line: "Ma nouvelle ligne"
    insertbefore: "^# je suis le nombre : [0-2]"
    state: present
    create: true
```


### Variante

* `insertafter` pour insertion après


## 8 — Suppression d’une ligne

```yaml
- name: Suppression d'une ligne
  ansible.builtin.lineinfile:
    path: /tmp/test.conf
    regexp: "^Ma nouvelle ligne"
    state: absent
```


### Alternative

On peut aussi utiliser `line` directement.


## 9 — Backup avant modification

```yaml
- name: Suppression avec backup
  ansible.builtin.lineinfile:
    path: /tmp/test.conf
    regexp: "^#"
    state: absent
    backup: true
```


### Intérêt

Permet de :

* conserver l’état précédent
* rollback si nécessaire


## 10 — Cas d’usage typiques

* modifier `/etc/ssh/sshd_config`
* ajouter une entrée dans `/etc/hosts`
* modifier une configuration applicative
* commenter des lignes existantes
* ajuster dynamiquement une configuration


## 11 — Bonnes pratiques

* toujours utiliser `regexp` pour éviter les doublons
* tester les regex avant utilisation
* utiliser `backup` pour les fichiers critiques
* éviter les modifications ambiguës
* privilégier la clarté des règles


## 12 — Anti-patterns

* ajouter une ligne sans `regexp`
* modifier un fichier complexe avec `lineinfile`
* utiliser des regex trop larges
* empiler des modifications incohérentes
* remplacer un usage de `template` par `lineinfile`


## Conclusion

Le module `lineinfile` est très utile pour :

* modifier rapidement un fichier
* faire des ajustements ciblés
* automatiser des corrections simples

Cependant, pour des fichiers complexes, il est préférable d’utiliser `template`.

C’est un module puissant mais à utiliser avec précision.
