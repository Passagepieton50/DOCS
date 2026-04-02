![Ansible](../assets/images/ansible.png)

# 14 Ansible - Plateforme dev Docker


## Documentation

https://docs.podman.io/
https://docs.ansible.com/


## Lab associé

[Voir le lab 14-ansible-plateforme-dev-docker](../labs/14-ansible-plateforme-dev-docker/)


## 1 — Objectif de la plateforme

L’objectif de cette plateforme est de fournir un environnement de test Ansible :

* reproductible
* isolé
* automatisé
* proche d’un environnement réel

Elle permet de :

* créer des machines (conteneurs)
* tester des playbooks
* simuler une infrastructure


## 2 — Principe de fonctionnement

La plateforme repose sur :

* Podman (alternative à Docker)
* des conteneurs Debian avec SSH
* un script de provisioning


### Fonctionnement global

1. création de conteneurs
2. configuration SSH
3. ajout d’un utilisateur
4. déploiement des clés SSH
5. génération d’un inventory Ansible


## 3 — Script de déploiement

Le script fourni permet de gérer toute la plateforme :




### Commandes disponibles

```bash
-c <n>   # créer n conteneurs
-i       # afficher les informations (IP + nom)
-s       # démarrer les conteneurs
-t       # arrêter les conteneurs
-d       # supprimer les conteneurs
-a       # générer un inventory Ansible
```


## 4 — Création des conteneurs

### Commande

```bash
./new_deploy.sh -c 3
```


### Comportement

Le script :

* crée des conteneurs Debian
* active systemd
* démarre SSH
* crée un utilisateur
* configure sudo sans mot de passe
* injecte la clé SSH


### Exemple interne

```bash
sudo podman run -d --systemd=true ...
```


## 5 — Configuration des accès SSH

Le script configure automatiquement :

* `~/.ssh/authorized_keys`
* permissions sécurisées
* accès sans mot de passe


### Avantage

Permet à Ansible de fonctionner immédiatement :

```bash
ansible all -m ping
```


## 6 — Gestion des utilisateurs

Chaque conteneur :

* crée un utilisateur identique à l’utilisateur local
* ajoute cet utilisateur dans sudoers


### Configuration sudo

```bash
NOPASSWD: ALL
```


### Avantage

* compatible avec `become`
* pas besoin de mot de passe


## 7 — Génération automatique de l’inventory

### Commande

```bash
./new_deploy.sh -a
```


### Résultat

Création du dossier :

```bash
ansible_dir/
├── 00_inventory.yml
├── group_vars/
└── host_vars/
```


### Exemple d’inventory généré

```yaml
all:
  vars:
    ansible_python_interpreter: /usr/bin/python3
  hosts:
    10.0.0.2:
    10.0.0.3:
```


### Avantage

* pas besoin de créer l’inventory à la main
* prêt à être utilisé immédiatement


## 8 — Gestion du cycle de vie

### Démarrage

```bash
./new_deploy.sh -s
```


### Arrêt

```bash
./new_deploy.sh -t
```


### Suppression

```bash
./new_deploy.sh -d
```


### Inspection

```bash
./new_deploy.sh -i
```

Affiche :

* nom du conteneur
* adresse IP


## 9 — Utilisation avec Ansible

### Test de connectivité

```bash
ansible -i ansible_dir/00_inventory.yml all -m ping
```


### Exécution d’un playbook

```bash
ansible-playbook -i ansible_dir/00_inventory.yml playbook.yml
```


## 10 — Avantages de cette approche

* environnement jetable
* reproductible
* rapide à créer
* idéal pour tests et formation
* compatible CI/CD


## 11 — Limites

* pas un environnement de production
* réseau simplifié
* persistance limitée
* dépendance à Podman/Docker


## 12 — Bonnes pratiques

* recréer les environnements régulièrement
* ne pas tester directement en production
* versionner les scripts
* automatiser la création d’inventory
* utiliser des clés SSH


## 13 — Anti-patterns

* utiliser des environnements manuels
* ne pas automatiser la création
* tester directement en production
* mélanger environnement de test et production


## Conclusion

Cette plateforme permet de :

* simuler une infrastructure
* tester des playbooks
* valider des configurations

Elle constitue une base essentielle pour :

* l’apprentissage
* le développement
* la validation avant production

Elle s’intègre parfaitement dans une démarche DevOps orientée automatisation et reproductibilité.
