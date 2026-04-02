![Ansible](../assets/images/ansible.png)

# 21 Ansible - Delegate, run_once, local


## Documentation

https://docs.ansible.com/ansible/2.3/playbooks_delegation.html

Commande utile :

```bash id="d8k1qm"
ansible-doc -t keyword delegate_to
ansible-doc -t keyword run_once
```


## Lab associé

[Voir le lab 21-ansible-module-delegate-to-et-localhost](../labs/21-ansible-module-delegate-to-et-localhost/)


## 1 — Objectif

Cette partie permet de comprendre comment :

* exécuter une tâche sur une autre machine que l’hôte courant
* exécuter une tâche une seule fois
* exécuter des tâches localement

Ces mécanismes sont utiles pour :

* génération de fichiers centralisés
* appels API depuis le contrôleur
* orchestration primaire / secondaire
* opérations locales avant ou après déploiement


## 2 — delegate_to

### Principe

Le mot-clé `delegate_to` permet de déléguer une tâche à un autre hôte identifié.

La play cible un ensemble d’hôtes, mais la tâche est exécutée sur une autre machine.


### Exemple simple

```yaml id="uxq4xo"
- name: Premier playbook
  hosts: all
  tasks:
    - name: Création de fichier
      ansible.builtin.file:
        state: touch
        path: /tmp/pp.txt
      delegate_to: localhost
```


### Explication

Ici :

* la play cible `all`
* la tâche est exécutée sur `localhost`


### Point d’attention

Si la play cible plusieurs hôtes :

* la tâche sera exécutée une fois par hôte
* même si elle est déléguée à `localhost`

Cela peut produire plusieurs exécutions identiques.


## 3 — Variables et contexte avec delegate_to

### Exemple

```yaml id="3gou09"
- name: Premier playbook
  hosts: all
  tasks:
    - name: Debug sur l’hôte courant
      ansible.builtin.debug:
        var: var1

    - name: Debug délégué à localhost
      ansible.builtin.debug:
        var: var1
      delegate_to: localhost
```


### Explication

Même si la tâche est exécutée sur `localhost`, le contexte des variables reste lié à l’hôte courant de la boucle de play, sauf cas particuliers.

Il faut donc bien distinguer :

* la machine d’exécution de la tâche
* l’hôte logique en cours de traitement

C’est un point important pour éviter les erreurs de compréhension.


## 4 — run_once

### Principe

Le mot-clé `run_once` permet d’exécuter une tâche une seule fois, même si la play cible plusieurs hôtes.


### Exemple

```yaml id="f5c0he"
- name: Création de fichier unique
  ansible.builtin.file:
    state: touch
    path: /tmp/pp.txt
  delegate_to: localhost
  run_once: true
```


### Explication

Cette combinaison est très utile quand on veut :

* générer un fichier une seule fois
* télécharger une ressource une seule fois
* lancer une opération centrale unique


## 5 — Cas d’usage typiques de delegate_to + run_once

Exemples courants :

* génération d’un certificat sur le contrôleur
* téléchargement unique d’un paquet
* création d’un inventaire dynamique
* appel API externe centralisé
* génération d’un fichier partagé avant distribution


## 6 — local_action

### Principe

`local_action` est une syntaxe plus ancienne permettant de forcer une exécution locale.


### Exemple

```yaml id="7b9crv"
tasks:
  - name: Action locale
    local_action: "command touch /tmp/pp2.txt"
```


### Explication

Cette syntaxe est utile pour les anciens playbooks, mais dans les versions modernes on préfère généralement :

* `delegate_to: localhost`
* ou `connection: local`


## 7 — Exécution locale sans SSH

### Principe

On peut exécuter une play directement sur la machine locale, sans SSH.


### Exemple

```yaml id="9m1x8x"
- name: Premier playbook
  hosts: localhost
  connection: local
  tasks:
    - name: Action locale
      ansible.builtin.file:
        state: touch
        path: /tmp/pp3.txt
```


### Explication

Ici :

* la cible est `localhost`
* aucune connexion SSH n’est utilisée
* l’exécution se fait directement localement


## 8 — Différences entre les approches

### delegate_to: localhost

* utile dans une play ciblant des hôtes distants
* délègue seulement certaines tâches


### local_action

* ancienne syntaxe
* pratique à lire dans du code existant


### hosts: localhost + connection: local

* utile pour une play entièrement locale
* pas adapté si seule une tâche doit être locale


## 9 — Cas d’usage réels

### Génération locale d’un fichier avant distribution

* génération sur le contrôleur
* copie sur les hôtes ensuite

### Appel à une API externe

* exécution locale sur le contrôleur
* résultat réutilisé pour les hôtes distants

### Gestion primaire / secondaire

* exécuter certaines tâches uniquement sur un nœud particulier
* utiliser `delegate_to` pour centraliser les opérations critiques


## 10 — Bonnes pratiques

* utiliser `delegate_to` pour les actions centralisées
* ajouter `run_once` si une tâche ne doit s’exécuter qu’une seule fois
* utiliser `connection: local` pour une play entièrement locale
* documenter clairement où s’exécute la tâche
* faire attention au contexte des variables


## 11 — Anti-patterns

* déléguer une tâche sans comprendre qu’elle sera répétée pour chaque host
* oublier `run_once` sur une tâche centrale
* mélanger logique locale et distante sans clarté
* supposer que le contexte des variables change automatiquement avec `delegate_to`


## Conclusion

`delegate_to`, `run_once` et `connection: local` sont des mécanismes essentiels pour structurer des automatisations avancées.

Ils permettent :

* de centraliser certaines actions
* d’éviter les répétitions inutiles
* de mieux organiser les workflows d’orchestration

Leur bonne maîtrise est indispensable pour les playbooks orientés production, particulièrement dans les scénarios de coordination ou d’exécution hybride local / distant.

