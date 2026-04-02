![Ansible](../assets/images/ansible.png) ![Terraform](../assets/images/terraform.png) 

# 13 Ansible - Idempotence Ansible vs Terraform


## Documentation

https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html

Commande utile :

```bash
ansible-doc ansible.builtin.file
```


## Lab associé

[Voir le lab 13-ansible-idempotence](../labs/13-ansible-idempotence/)


## 1 — Notions fondamentales

### Idempotence

L’idempotence est un principe clé d’Ansible.

Une tâche idempotente garantit que :

* l’état final est toujours le même
* plusieurs exécutions ne changent pas le résultat
* aucune action inutile n’est effectuée


### Stateful vs Stateless

Deux concepts importants :

* **stateful** : système avec mémoire de l’état
* **stateless** : système sans mémoire


### Positionnement

* Terraform : idempotent + stateful
* Ansible : idempotent + stateless


## 2 — Différence Ansible vs Terraform

### Terraform

* maintient un fichier `.tfstate`
* connaît l’état de l’infrastructure
* compare état réel vs état attendu

Exemple :

* création d’une VM → ajout dans le state
* suppression du code → Terraform supprime la VM


### Ansible

* ne conserve aucun état
* agit uniquement sur l’état actuel du système

Exemple :

* création d’une VM → Ansible l’exécute
* suppression du code → Ansible ne fait rien


### Résumé

* Terraform : gestion complète du cycle de vie
* Ansible : configuration et orchestration


## 3 — Idempotence avec le module file

### Exemple idempotent

```yaml
- name: touch idempotent
  ansible.builtin.file:
    path: /tmp/pp.txt
    state: touch
    mode: "0755"
    modification_time: preserve
    access_time: preserve
```


### Comportement

* le fichier est créé s’il n’existe pas
* aucune modification si déjà présent
* exécution répétable sans effet


## 4 — Exemple non idempotent

```yaml
- name: touch non idempotent
  ansible.builtin.file:
    path: /tmp/pp/1/2/3
    state: touch
    mode: "0755"
    modification_time: now
    access_time: now
```


### Comportement

* modification à chaque exécution
* timestamp toujours mis à jour
* perte d’idempotence


## 5 — Comprendre l’idempotence

### Idempotence stricte

* état final identique
* aucune modification inutile


### Cas problématiques

Certaines options cassent l’idempotence :

* `modification_time: now`
* `command`
* `shell`
* scripts externes


## 6 — Limites du modèle stateless

### Problème

Ansible ne sait pas :

* ce qu’il a créé auparavant
* ce qui doit être supprimé
* l’état global de l’infrastructure


### Exemple concret

Création d’une VM :

* Terraform : stocke dans `.tfstate`
* Ansible : exécute sans mémoire

Suppression du code :

* Terraform : supprime la VM
* Ansible : ne fait rien


### Conséquence

Avec Ansible :

* il faut gérer explicitement les états
* utiliser des inventaires dynamiques
* structurer correctement les playbooks


## 7 — Bonnes pratiques

* privilégier les modules idempotents
* éviter `shell` et `command`
* utiliser `--check` pour valider
* comprendre l’impact des paramètres
* tester plusieurs exécutions


## 8 — Anti-patterns

* utiliser des actions non idempotentes sans contrôle
* dépendre d’un état implicite
* mélanger provisioning et configuration
* supposer qu’Ansible “se souvient”


## Conclusion

L’idempotence est au cœur d’Ansible.

Cependant :

* Ansible est stateless
* Terraform est stateful

Comprendre cette différence permet :

* d’éviter des erreurs de conception
* de choisir le bon outil
* de construire des automatisations robustes

En pratique :

* Terraform provisionne
* Ansible configure

