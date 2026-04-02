![Ansible](../assets/images/ansible.png)

# 43 Ansible - Module SET_FACT


## Documentation

https://docs.ansible.com/ansible/latest/collections/ansible/builtin/set_fact_module.html


## Lab associé

[Voir le lab 43-ansible-set-fact](../labs/43-ansible-set-fact/)


## 1 — Introduction

Le module `set_fact` permet de définir des variables dynamiques pendant l’exécution d’un playbook.

Ces variables :

* sont calculées à runtime
* peuvent dépendre d’autres variables
* peuvent être utilisées dans les tâches suivantes


## 2 — Objectif

Permet de :

* construire des variables dynamiques
* stocker des résultats intermédiaires
* enrichir les facts
* manipuler des données


## 3 — Paramètres principaux

### key: value

Définition d’une variable :

```yaml
mavariable: "valeur"
```


### cacheable

Permet de stocker la variable dans le cache de facts :

```yaml
cacheable: yes
```


## 4 — Exemple simple

```yaml
- name: Set fact simple
  hosts: all
  tasks:
    - name: Définir une variable
      ansible.builtin.set_fact:
        mavariable: "Hello tout le monde !!"

    - name: Debug
      ansible.builtin.debug:
        var: mavariable
```


### Explication

* la variable est créée dynamiquement
* elle est disponible dans toutes les tâches suivantes


## 5 — Exemple avec calcul

```yaml
- name: Set fact dynamique
  hosts: all
  vars:
    var1: "hello"
    var2: "je suis"

  tasks:
    - name: Récupération user
      ansible.builtin.command: "echo $USER"
      register: __user

    - name: Construction variable
      ansible.builtin.set_fact:
        mavariable: "{{ var1 }} {{ var2 }} {{ __user.stdout }} sur {{ ansible_hostname }}"

    - name: Debug
      ansible.builtin.debug:
        var: mavariable
```


### Explication

* on combine plusieurs sources :

  * variables
  * résultat d’une commande
  * facts système
* résultat dynamique construit à l’exécution


## 6 — Accès aux facts existants

Exemple avec les facts système :

```yaml
- name: Affichage date
  hosts: all
  tasks:
    - name: Debug date
      ansible.builtin.debug:
        var: ansible_date_time
```


### Explication

Les facts sont stockés dans :

```yaml
ansible_facts
```


## 7 — Cache des facts

Configuration dans `ansible.cfg` :

```ini
# cache facts
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp/facts_cache
fact_caching_timeout = 7200
```


### Explication

* permet de réutiliser les facts entre plusieurs runs
* améliore les performances
* évite de recalculer certaines données


## 8 — Utilisation de cacheable

```yaml
- name: Set fact cacheable
  ansible.builtin.set_fact:
    mavariable: "persistante"
  cacheable: yes
```


### Explication

* la variable est stockée dans le cache
* elle peut être réutilisée dans d’autres playbooks


## 9 — Contourner le cache

```yaml
- name: Date sans cache
  hosts: all
  tasks:
    - name: Récupération date
      ansible.builtin.shell: "date +%Y-%m-%d"
      register: shell_date

    - name: Set fact
      ansible.builtin.set_fact:
        date: "{{ shell_date.stdout }}"
```


### Explication

* permet d’éviter les valeurs obsolètes
* utile pour les données dynamiques


## 10 — Cas d’usage typiques

* construire des variables dynamiques
* stocker un résultat intermédiaire
* transformer des données
* préparer des templates
* gérer des conditions complexes


## 11 — Bonnes pratiques

* nommer clairement les variables
* éviter les collisions de noms
* utiliser `set_fact` pour des valeurs calculées uniquement
* privilégier `vars` pour les valeurs statiques
* documenter les variables importantes


## 12 — Anti-patterns

* utiliser `set_fact` pour tout
* écraser des variables existantes sans le savoir
* stocker trop de données dans les facts
* ne pas gérer le cache
* créer des dépendances implicites


## 13 — Priorité des variables

Les variables définies avec `set_fact` ont une priorité élevée.

Elles écrasent :

* variables d’inventaire
* group_vars
* host_vars
* variables de playbook

Mais restent inférieures aux `extra vars (-e)`.


## Conclusion

Le module `set_fact` est essentiel pour :

* manipuler des données dynamiques
* enrichir les playbooks
* construire des logiques avancées

Bien utilisé, il permet de rendre les automatisations plus intelligentes et plus flexibles.
