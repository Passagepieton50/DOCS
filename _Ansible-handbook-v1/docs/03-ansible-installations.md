![Ansible](../assets/images/ansible.png)

# 03 Ansible - Installations

Documentation : 

https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

https://releases.ansible.com/ansible/

https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#ansible-python-interpreter


## 1. Installation et environnement technique d’Ansible

### Prérequis

Avant d’installer Ansible, plusieurs éléments sont nécessaires :

* Python (version 3.9 ou supérieure recommandée)
* accès SSH aux machines cibles
* système Linux ou macOS pour le control node (Windows possible via WSL)

Sur les machines cibles :

* Python doit être présent (souvent installé par défaut sur Linux)



### Installation d’Ansible

Méthode recommandée (2026) : installation via `pip` avec environnement virtuel.

Création d’un environnement :

```bash id="f7c2x1"
python3 -m venv venv
source venv/bin/activate
```

Installation :

```bash id="p9a4kl"
pip install ansible-core
```

Vérification :

```bash id="u3m8zp"
ansible --version
```



### Alternative via gestionnaire de paquets

Installation possible via APT :

```bash id="d4n8ws"
sudo apt update
sudo apt install ansible
```

Limites :

* version souvent en retard
* moins flexible que `pip`



### Bonnes pratiques d’installation

* utiliser un environnement virtuel Python
* versionner les dépendances (`requirements.txt`)
* éviter les installations globales
* standardiser la version d’Ansible dans l’équipe



## 2. Configuration de l’environnement Ansible

### Fichier de configuration `ansible.cfg`

Ansible utilise un fichier de configuration pour définir son comportement.

Ordre de priorité :

1. variable d’environnement `ANSIBLE_CONFIG`
2. fichier local `./ansible.cfg`
3. `~/.ansible.cfg`
4. `/etc/ansible/ansible.cfg`

Exemple minimal :

```ini id="s7n2fk"
[defaults]
inventory = ./inventory
remote_user = ubuntu
host_key_checking = False
retry_files_enabled = False
```



### Configuration SSH

Ansible utilise SSH pour communiquer avec les machines.

Bonne pratique :

* utiliser des clés SSH
* éviter les mots de passe

Génération de clé :

```bash id="v6k9qz"
ssh-keygen -t ed25519
```

Copie de la clé :

```bash id="c2j7lx"
ssh-copy-id user@host
```



### Test de connectivité

Commande simple :

```bash id="k1r9xm"
ansible all -m ping
```

Permet de vérifier :

* connectivité réseau
* accès SSH
* fonctionnement d’Ansible



## 3. Gestion des modules et collections

### Modules Ansible

Les modules sont les unités d’exécution.

Exemples :

* gestion de paquets (`apt`, `yum`)
* fichiers (`copy`, `template`)
* services (`systemd`)

Bonne pratique :

* utiliser les modules officiels
* éviter les commandes shell



### Collections

Les collections regroupent :

* modules
* plugins
* rôles

Installation :

```bash id="y9l2qp"
ansible-galaxy collection install community.general
```

Bonne pratique :

* déclarer les collections dans un fichier `requirements.yml`

Exemple :

```yaml id="o2x6ct"
collections:
  - name: community.general
```

Installation :

```bash id="l8f3rm"
ansible-galaxy collection install -r requirements.yml
```



### ansible-core vs ansible

* **ansible-core** : moteur minimal
* **ansible** : package complet avec collections incluses

Bonne pratique :

* utiliser `ansible-core`
* gérer les dépendances explicitement



## 4. Mise en place d’un environnement de travail

### Structure initiale

Exemple minimal :

```bash id="t4w8ds"
project/
├── inventory/
├── playbook.yml
├── ansible.cfg
└── requirements.yml
```



### Exemple d’inventory

```yaml id="b7n3qe"
all:
  hosts:
    node1:
      ansible_host: 192.168.1.10
```



### Exemple de playbook

```yaml id="z1k8hf"
- name: Test Ansible
  hosts: all
  tasks:
    - name: Ping
      ansible.builtin.ping:
```

Exécution :

```bash id="r5p2mv"
ansible-playbook playbook.yml
```



## 5. Intégration avec l’infrastructure

### Environnements cloud

Ansible peut s’intégrer avec :

* AWS
* Azure
* GCP

Via :

* modules dédiés
* inventaires dynamiques



### Intégration CI/CD

Ansible peut être exécuté dans :

* GitLab CI
* GitHub Actions
* Jenkins

Utilisations :

* déploiement automatisé
* configuration post-provisioning
* orchestration



### Environnement de développement

Pour tester localement :

* utiliser Docker
* utiliser des machines virtuelles
* utiliser Vagrant

Objectif :

* reproduire un environnement proche de la production



## 6. Bonnes pratiques d’installation et d’environnement

* isoler l’environnement (virtualenv)
* versionner les dépendances
* standardiser la configuration (`ansible.cfg`)
* utiliser des clés SSH
* tester la connectivité avant exécution
* séparer les environnements



## 7. Erreurs fréquentes

* installation globale non maîtrisée
* versions différentes entre équipes
* absence de configuration `ansible.cfg`
* mauvaise gestion des clés SSH
* dépendances non versionnées



## Conclusion

Une installation maîtrisée d’Ansible est essentielle pour :

* garantir la reproductibilité
* éviter les erreurs d’environnement
* faciliter la collaboration
* assurer une exécution fiable

Un environnement propre et standardisé est une base indispensable avant d’aller plus loin dans l’automatisation.
