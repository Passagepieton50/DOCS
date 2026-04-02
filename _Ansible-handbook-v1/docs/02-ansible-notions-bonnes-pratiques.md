![Ansible](../assets/images/ansible.png)

# 02 Ansible - Notions & Bonnes pratiques



## 1. Principes fondamentaux d’Ansible

### Idempotence et gestion de l’état

L’idempotence est un principe central d’Ansible.

Une tâche idempotente garantit que :

* l’état final est atteint sans effets de bord
* plusieurs exécutions successives produisent le même résultat

Exemple :

```yaml
- name: Installer nginx
  ansible.builtin.apt:
    name: nginx
    state: present
```

Si nginx est déjà installé, aucune modification n’est effectuée.

Implications :

* sécurité en production
* automatisation fiable
* possibilité de relancer sans risque



### Approche déclarative vs impérative

Ansible privilégie une approche déclarative :

* on décrit l’état cible
* pas les étapes détaillées

Déclaratif :

```yaml
- name: Installer nginx
  ansible.builtin.apt:
    name: nginx
    state: present
```

Impératif (à éviter) :

```yaml
- name: Installer nginx
  ansible.builtin.command: apt install -y nginx
```

Bonne pratique :

* privilégier les modules natifs
* éviter `shell` et `command` sauf cas spécifique



### Simplicité et lisibilité du code

Un playbook doit être :

* lisible
* explicite
* compréhensible rapidement

Bonnes pratiques :

* noms de tâches explicites
* indentation claire
* structure cohérente
* éviter la complexité inutile

Exemple :

```yaml
- name: Créer un utilisateur applicatif
  ansible.builtin.user:
    name: appuser
    state: present
```



## 2. Organisation d’un projet Ansible

### Structure recommandée

Un projet Ansible doit être structuré pour être maintenable.

Exemple :

```bash
project/
├── inventory/
├── group_vars/
├── host_vars/
├── roles/
├── playbooks/
└── ansible.cfg
```

Objectifs :

* séparation des responsabilités
* réutilisabilité
* lisibilité



### Utilisation des rôles

Les rôles permettent de structurer le code.

Un rôle contient :

* tasks
* handlers
* templates
* variables
* fichiers

Avantages :

* modularité
* réutilisation
* standardisation



### Séparation des environnements

Il est recommandé de séparer les environnements :

* dev
* staging
* production

Exemple :

```bash
inventory/
├── dev/
├── staging/
└── prod/
```

Cela permet :

* d’éviter les erreurs de déploiement
* de tester avant production
* d’isoler les configurations



## 3. Gestion des variables

### Hiérarchie des variables

Ansible possède un système de priorité des variables.

Exemples de sources :

* defaults (rôles)
* group_vars
* host_vars
* variables de playbook
* extra vars (`-e`)

Bonne pratique :

* centraliser les variables
* éviter les redéfinitions inutiles



### Bon usage des variables

Bonnes pratiques :

* noms explicites
* cohérence de nommage
* éviter les valeurs en dur

Exemple :

```yaml
nginx_port: 80
```



### Sécurité des variables

Les données sensibles doivent être protégées.

Utiliser :

* **ansible-vault**

Exemple :

```bash
ansible-vault encrypt secrets.yml
```



## 4. Bonnes pratiques d’écriture

### Nommage des tâches

Chaque tâche doit avoir un nom clair :

```yaml
- name: Installer les paquets système requis
```

Cela permet :

* debugging plus simple
* logs lisibles



### Découpage des playbooks

Éviter les playbooks monolithiques.

Préférer :

* rôles
* includes
* organisation modulaire



### Utilisation des handlers

Les handlers permettent d’exécuter des actions uniquement si nécessaire.

Exemple :

```yaml
- name: Redémarrer nginx
  ansible.builtin.service:
    name: nginx
    state: restarted
```

Déclenché uniquement si une tâche change un état.



## 5. Performance et optimisation

### Limiter les tâches inutiles

Utiliser :

* `when`
* `changed_when`
* `failed_when`



### Désactiver gather_facts si inutile

```yaml
gather_facts: false
```

Permet d’accélérer l’exécution.



### Exécution parallèle

Ansible exécute les tâches en parallèle.

Paramètre :

```ini
forks = 10
```

Bonne pratique :

* ajuster selon l’infrastructure



## 6. Tests et validation

### Vérification syntaxique

```bash
ansible-playbook playbook.yml --syntax-check
```



### Mode dry-run

```bash
ansible-playbook playbook.yml --check
```

Permet de simuler l’exécution.



### Linting

Utiliser :

```bash
ansible-lint
```

Permet de détecter :

* mauvaises pratiques
* erreurs potentielles



## 7. Anti-patterns à éviter

* utilisation excessive de `shell` et `command`
* playbooks trop longs
* variables en dur
* absence de rôles
* duplication de code
* absence de tests
* mélange des environnements



## Conclusion

Les bonnes pratiques Ansible permettent :

* une meilleure maintenabilité
* une réduction des erreurs
* une automatisation fiable
* une meilleure lisibilité du code

Un projet bien structuré est essentiel pour une utilisation en production et une intégration dans un environnement DevOps.
