![Ansible](../assets/images/ansible.png)

# 26 Ansible - Les Rôles


## Documentation

https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html

Commande utile :

```bash
ansible-galaxy init mon_role
```


## Lab associé

[Voir le lab 26-ansible-roles](../labs/26-ansible-roles/)


## 1 — Définition d’un rôle

Un rôle est une structure organisée permettant de regrouper :

* des tâches
* des variables
* des fichiers
* des templates
* des handlers

Le tout autour d’un objectif commun.


### Exemple

Un rôle peut représenter :

* un serveur web (nginx)
* une base de données
* un système de monitoring
* une configuration de sécurité


## 2 — Objectif des rôles

Les rôles permettent de :

* structurer les playbooks
* factoriser le code
* réutiliser des composants
* standardiser les déploiements


## 3 — Intérêts des rôles

### Réutilisation

Un rôle peut être utilisé dans plusieurs projets.


### Organisation

Permet de structurer clairement :

* la logique
* les fichiers
* les variables


### Approche modulaire

Principe du lego :

* plus un rôle est petit, plus il est réutilisable
* chaque rôle a une responsabilité claire


### Exemple de découpage

* rôle `mysql` : installation moteur
* rôle `mysql_replication` : réplication
* rôle `mysql_backup` : sauvegarde


## 4 — Organisation de travail

### Bonnes pratiques

* un dépôt par rôle
* un mainteneur identifié
* validation via pull request
* gestion des versions
* documentation associée


### Impact global

Attention aux changements :

* modification de variables
* impact sur les dépendances
* compatibilité avec d’autres rôles


## 5 — Structure d’un rôle

Un rôle suit une arborescence standard.


### Structure typique

```text
mon_role/
├── tasks/
│   └── main.yml
├── handlers/
│   └── main.yml
├── defaults/
│   └── main.yml
├── vars/
│   └── main.yml
├── templates/
├── files/
├── meta/
│   └── main.yml
├── tests/
└── library/
```


## 6 — Description des répertoires

### tasks/

Contient les tâches principales.

Point d’entrée du rôle :

```yaml
tasks/main.yml
```


### defaults/

Variables par défaut du rôle.

* priorité faible
* facilement surchargeables


### vars/

Variables du rôle avec priorité plus élevée.

À utiliser avec prudence.


### handlers/

Handlers spécifiques au rôle.


### templates/

Fichiers Jinja2 utilisés par le rôle.


### files/

Fichiers statiques à copier.


### meta/

Permet de :

* déclarer des dépendances de rôles
* publier sur Ansible Galaxy


### tests/

Contient les tests du rôle.


### library/

Modules personnalisés spécifiques au rôle.


## 7 — Utilisation d’un rôle

### Exemple dans un playbook

```yaml
- name: Déploiement
  hosts: all
  roles:
    - nginx
```


### Avec variables

```yaml
- name: Déploiement nginx
  hosts: all
  roles:
    - role: nginx
      vars:
        nginx_port: 8080
```


## 8 — Création d’un rôle

```bash
ansible-galaxy init mon_role
```


### Résultat

Création automatique de la structure standard.


## 9 — Ansible Galaxy

### Plateforme

https://galaxy.ansible.com/


### Objectif

* partager des rôles
* réutiliser des rôles existants
* standardiser les pratiques


### Installation d’un rôle

```bash
ansible-galaxy install geerlingguy.nginx
```


## 10 — Bonnes pratiques

* garder les rôles simples et ciblés
* documenter chaque rôle
* utiliser `defaults` plutôt que `vars`
* versionner les rôles
* tester les rôles (Molecule, etc.)
* respecter une structure cohérente entre projets


## 11 — Anti-patterns

* créer des rôles trop complexes
* mélanger plusieurs responsabilités dans un rôle
* mettre toute la logique dans `vars`
* ne pas tester les rôles
* ne pas documenter


## Conclusion

Les rôles sont un élément clé d’Ansible pour :

* structurer les projets
* améliorer la maintenabilité
* favoriser la réutilisation

Ils permettent de construire une infrastructure modulaire et évolutive, adaptée aux environnements professionnels.
