![Ansible](../assets/images/ansible.png)

# 33 Ansible - Gather Facts & module Setup


## Documentation

SETUP :
https://docs.ansible.com/ansible/2.3/setup_module.html

GATHER FACTS :
https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html

Commande utile :

```bash
ansible-doc ansible.builtin.setup
```


## Lab associé

[Voir le lab 33-ansible-gather-facts](../labs/33-ansible-gather-facts/)


## 1 — Introduction

Les **facts** sont des informations collectées automatiquement sur les machines cibles.

Ils permettent à Ansible de :

* comprendre l’environnement
* adapter les playbooks dynamiquement
* prendre des décisions conditionnelles


## 2 — Contenu des facts

Les facts couvrent de nombreux domaines :

* système d’exploitation
* interfaces réseau
* disques et partitions
* CPU / mémoire
* utilisateurs
* montages
* variables d’environnement
* type de connexion


## 3 — ansible_facts

Tous les facts sont stockés dans :

```yaml
ansible_facts
```


### Exemple

```yaml
- name: Afficher les facts
  ansible.builtin.debug:
    var: ansible_facts
```


## 4 — Collecte automatique (gather_facts)

Par défaut, Ansible collecte les facts au début de chaque play.

```yaml
- name: Mon playbook
  hosts: all
  gather_facts: true
```


### Résultat

* exécution automatique du module `setup`
* disponibilité des variables `ansible_*`


## 5 — Désactiver la collecte

```yaml
- name: Test sans facts
  hosts: all
  gather_facts: false
  tasks:
    - name: Debug
      ansible.builtin.debug:
        var: ansible_facts
```


### Cas d’usage

* optimisation des performances
* playbooks simples
* environnements contrôlés


## 6 — Module setup

### Objectif

Le module `setup` permet de :

* collecter les facts manuellement
* filtrer les informations
* contrôler le volume de données


## 7 — Utilisation en CLI

### Tous les facts

```bash
ansible -i 00_inventory.yml all -m setup
```


### Avec filtre

```bash
ansible -i 00_inventory.yml all -m setup -a "filter=ansible_user*"
```


## 8 — Utilisation dans un playbook

### Exemple simple

```yaml
- name: Collecte facts
  ansible.builtin.setup:
```


### Avec register

```yaml
- name: Collecte facts
  ansible.builtin.setup:
  register: _hosts_facts

- name: Affichage
  ansible.builtin.debug:
    var: _hosts_facts
```


## 9 — Filtrer les facts

```yaml
- name: Collecte filtrée
  ansible.builtin.setup:
    filter: ansible_user*
  register: _hosts_facts
```


### Intérêt

* réduire la quantité de données
* améliorer les performances
* cibler uniquement les informations utiles


## 10 — Exemples de facts utiles

### Système

```yaml
ansible_distribution
ansible_distribution_version
```


### Réseau

```yaml
ansible_default_ipv4.address
```


### Machine

```yaml
ansible_hostname
ansible_fqdn
```


### CPU / RAM

```yaml
ansible_processor
ansible_memtotal_mb
```


## 11 — Cas d’usage

* conditionner un playbook selon l’OS
* adapter une configuration réseau
* cibler des machines spécifiques
* automatiser des déploiements multi-environnements


## 12 — Bonnes pratiques

* désactiver `gather_facts` si inutile
* utiliser `filter` pour optimiser
* utiliser les facts pour rendre les playbooks dynamiques
* éviter de surcharger inutilement la collecte


## 13 — Anti-patterns

* collecter tous les facts sans besoin
* ne pas utiliser les facts disponibles
* dépendre de facts non fiables
* ignorer l’impact performance sur de gros inventaires


## Conclusion

Les facts sont essentiels pour :

* rendre les playbooks intelligents
* adapter les déploiements
* automatiser de manière dynamique

Le module `setup` permet de :

* contrôler cette collecte
* optimiser les performances
* cibler précisément les informations nécessaires
