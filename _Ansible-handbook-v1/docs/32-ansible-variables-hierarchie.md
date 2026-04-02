![Ansible](../assets/images/ansible.png)

# 32 Ansible - Précédence des variables


## Documentation

https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html


## Lab associé

[Voir le lab 32-ansible-variable-precedence](../labs/32-ansible-variable-precedence/)


## 1 — Introduction

La précédence des variables (variable precedence) définit quelle valeur est utilisée lorsqu’une même variable est définie à plusieurs endroits.

C’est un concept fondamental pour :

* comprendre le comportement d’Ansible
* éviter les conflits
* structurer correctement un projet


## 2 — Principe général

Lorsqu’une variable est définie plusieurs fois :

* Ansible applique un ordre de priorité
* la valeur la plus prioritaire est retenue


## 3 — Liste complète (ordre croissant)

De la priorité la plus faible à la plus forte :

```text
command line values (ex: -u user)
role defaults
inventory file / script group vars
inventory group_vars/all
playbook group_vars/all
inventory group_vars/*
playbook group_vars/*
inventory host vars
inventory host_vars/*
playbook host_vars/*
host facts / cached set_facts
play vars
play vars_prompt
play vars_files
role vars
block vars
task vars
include_vars
set_fact / registered vars
role params
include params
extra vars (-e)
```


## 4 — Exemple concret

### Définition multiple d’une variable

#### 1 — Role defaults (plus faible)

```yaml
roles/testvars/defaults/main.yml
var1: "default role"
```


#### 2 — group_vars

```yaml
group_vars/all.yml
var1: "group var"
```


#### 3 — host_vars

```yaml
host_vars/node2.yml
var1: "host var node2"
```


#### 4 — variables du playbook

```yaml
vars:
  var1: "playbook var"
```


#### 5 — role vars (très prioritaire)

```yaml
roles/testvars/vars/main.yml
var1: "role var"
```


#### 6 — set_fact (encore plus haut)

```yaml
- name: Override variable
  ansible.builtin.set_fact:
    var1: "set fact var"
```


## 5 — Résultat

Dans un rôle :

```yaml
- name: Debug variable
  ansible.builtin.debug:
    var: var1
```


### Valeur finale

```text
var1: "set fact var"
```


### Explication

`set_fact` écrase toutes les autres définitions précédentes.


## 6 — Ordre simplifié à retenir

```text
defaults
< group_vars
< host_vars
< play vars
< role vars
< set_fact
< extra vars (-e)
```


## 7 — Points importants

### 1 — role vars est très prioritaire

```yaml
roles/testvars/vars/main.yml
var1: "role var"
```

Même si la variable est définie ailleurs :

```yaml
vars:
  var1: "playbook var"
```

La valeur utilisée sera :

```text
role var
```


### 2 — set_fact écrase presque tout

```yaml
- set_fact:
    var1: "new value"
```

* utilisé pendant l’exécution
* très haute priorité


### 3 — extra vars (-e) gagnent toujours

```bash
ansible-playbook playbook.yml -e "var1=cli_value"
```

* priorité maximale
* utile pour override rapide


### 4 — defaults est fait pour être surchargé

```yaml
roles/testvars/defaults/main.yml
```

* priorité faible
* recommandé pour les variables configurables


## 8 — Bonnes pratiques

### À privilégier

* utiliser `defaults/` pour les variables configurables
* documenter les variables
* utiliser `group_vars` et `host_vars` pour l’infra
* limiter l’usage de `set_fact`


### À éviter

* mettre des variables dans `vars/` sans raison
* écraser des variables sans le savoir
* multiplier les niveaux de définition
* utiliser `set_fact` sans contrôle


## 9 — Anti-patterns

* dépendre implicitement de la précédence
* définir une variable dans trop d’endroits
* ne pas savoir d’où vient une valeur
* utiliser `vars/` dans les rôles pour des variables modifiables


## 10 — Méthode pour debug

### Commande utile

```bash
ansible -i inventory all -m debug -a "var=var1"
```


### Astuce

Afficher plusieurs variables :

```yaml
- debug:
    var: hostvars[inventory_hostname]
```


## Conclusion

La précédence des variables est essentielle pour :

* comprendre le comportement d’Ansible
* éviter les erreurs difficiles à diagnostiquer
* structurer correctement les rôles et playbooks

Une bonne maîtrise permet :

* des configurations propres
* des rôles réutilisables
* une meilleure maintenabilité des projets
