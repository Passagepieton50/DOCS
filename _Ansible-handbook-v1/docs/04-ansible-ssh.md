![Ansible](../assets/images/ansible.png)

# 04 Ansible - SSH



## 1. Fonctionnement SSH dans Ansible

### Utilisation de SSH par Ansible

Ansible utilise SSH comme mécanisme principal pour communiquer avec les machines distantes.

Lors de l’exécution :

* connexion SSH au serveur cible
* transfert temporaire du module
* exécution de la tâche
* récupération du résultat

Aucune installation d’agent n’est nécessaire sur les machines distantes.



### Avantages du modèle SSH

* pas d’agent à maintenir
* sécurité basée sur SSH
* intégration native avec les systèmes Linux
* facilité de mise en place



### Prérequis côté cible

Les machines doivent :

* être accessibles en SSH
* disposer de Python (sauf cas spécifiques)
* avoir un utilisateur avec les droits nécessaires



## 2. Authentification SSH

### Authentification par clé (recommandée)

Ansible fonctionne idéalement avec des clés SSH.

Génération :

```bash
ssh-keygen -t ed25519
```

Copie vers la machine cible :

```bash
ssh-copy-id user@host
```



### Configuration dans l’inventory

```yaml
all:
  hosts:
    node1:
      ansible_host: 192.168.1.10
      ansible_user: ubuntu
      ansible_ssh_private_key_file: ~/.ssh/id_ed25519
```



### Authentification par mot de passe (non recommandée)

Possible via :

```bash
ansible all -m ping --ask-pass
```

Limites :

* moins sécurisé
* difficile à automatiser
* non adapté CI/CD



## 3. Gestion des accès et élévation de privilèges

### Utilisation de become (sudo)

Ansible permet d’exécuter des commandes avec élévation de privilèges.

Exemple :

```yaml
- name: Installer nginx
  hosts: all
  become: true
  tasks:
    - name: Installer nginx
      ansible.builtin.apt:
        name: nginx
        state: present
```



### Configuration de become

Dans l’inventory :

```yaml
ansible_become: true
ansible_become_method: sudo
ansible_become_user: root
```



### Gestion du mot de passe sudo

```bash
ansible-playbook playbook.yml --ask-become-pass
```

Bonne pratique :

* privilégier sudo sans mot de passe pour automatisation



## 4. Configuration SSH avancée

### Fichier ~/.ssh/config

Permet de simplifier les connexions.

Exemple :

```sshconfig
Host node1
    HostName 192.168.1.10
    User ubuntu
    IdentityFile ~/.ssh/id_ed25519
```

Ensuite dans l’inventory :

```yaml
node1:
```



### Désactivation du host key checking

Dans `ansible.cfg` :

```ini
[defaults]
host_key_checking = False
```

Permet d’éviter les prompts interactifs.



### Paramètres SSH personnalisés

```ini
[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s
```

Optimisation :

* réutilisation des connexions
* meilleure performance



## 5. Bastion et ProxyJump

### Accès via bastion

Dans certains environnements, l’accès aux serveurs passe par un bastion.

Configuration :

```sshconfig
Host bastion
    HostName bastion.example.com
    User ubuntu

Host node1
    HostName 10.0.0.10
    User ubuntu
    ProxyJump bastion
```



### Intégration avec Ansible

Ansible utilise automatiquement cette configuration SSH.

Alternative dans inventory :

```yaml
ansible_ssh_common_args: '-o ProxyJump=bastion'
```



## 6. Optimisation des connexions SSH

### Connexions persistantes

Ansible peut réutiliser les connexions SSH.

```ini
[ssh_connection]
pipelining = True
```

Avantages :

* réduction du temps d’exécution
* moins de connexions ouvertes



### Désactivation de sudo requiretty

Sur certaines distributions :

```bash
sudo visudo
```

Ajouter ou modifier :

```bash
Defaults:ansible !requiretty
```



## 7. Debug et troubleshooting SSH

### Test de connexion

```bash
ansible all -m ping
```



### Mode verbose

```bash
ansible all -m ping -vvv
```

Permet de voir :

* les connexions SSH
* les erreurs
* les commandes exécutées



### Erreurs fréquentes

* permission denied (clé SSH incorrecte)
* mauvais utilisateur
* problème de sudo
* host key non validée
* port SSH incorrect



## 8. Bonnes pratiques

* utiliser des clés SSH
* éviter les mots de passe
* centraliser la config SSH
* utiliser ProxyJump pour les bastions
* activer pipelining
* tester la connectivité avant exécution



## 9. Anti-patterns

* utilisation de mot de passe en production
* duplication des configs SSH dans l’inventory
* absence de gestion des accès
* désactivation globale de la sécurité sans contrôle



## Conclusion

SSH est le pilier du fonctionnement d’Ansible.

Une configuration correcte permet :

* une automatisation fiable
* une sécurité maîtrisée
* de meilleures performances

Une mauvaise configuration SSH est l’une des principales causes d’échec dans les déploiements Ansible.
