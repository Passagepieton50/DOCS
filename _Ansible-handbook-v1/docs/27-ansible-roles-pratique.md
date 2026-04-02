![Ansible](../assets/images/ansible.png)

# 27 Ansible - Les Rôles (en pratique)


## Documentation

https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html

Commande utile :

```bash
ansible-galaxy init roles/nom_du_role
```


## Lab associé

[Voir le lab 27-ansible-roles-en-pratique](../labs/27-ansible-roles-en-pratique/)


## 1 — Objectif

Mettre en pratique l’utilisation des rôles dans un projet réel.

On va structurer un projet avec plusieurs rôles :

* génération de clé SSH
* gestion des utilisateurs
* déploiement Nginx


## 2 — Structure du projet

### Arborescence globale

```text
.
├── 00_inventory.yml
├── group_vars
│   └── all.yml
├── host_vars
│   └── node3.yml
├── playbook.yml
└── roles
    ├── nginx
    ├── ssh_keygen
    └── users
```


### Exemple détaillé d’un rôle

```text
roles/nginx/
├── defaults/
├── files/
├── handlers/
├── meta/
├── README.md
├── tasks/
├── templates/
├── tests/
└── vars/
```


## 3 — Description des rôles

### 3.1 — Rôle ssh_keygen

Objectif :

* générer une clé SSH côté contrôleur


### Particularité

* utilisation de `delegate_to: localhost`
* utilisation de `run_once`


### Exemple de tâche

```yaml
- name: Génération de clé SSH
  community.crypto.openssh_keypair:
    path: /tmp/pp
    type: rsa
    size: 4096
    state: present
  delegate_to: localhost
  run_once: true
```


## 3.2 — Rôle users

Objectif :

* créer un utilisateur
* configurer sudo
* déployer une clé SSH


### Exemple de tâches

```yaml
- name: Création utilisateur
  ansible.builtin.user:
    name: devops
    shell: /bin/bash
    groups: sudo
    append: true

- name: Déploiement clé SSH
  ansible.posix.authorized_key:
    user: devops
    key: "{{ lookup('file', '/tmp/pp.pub') }}"
```


## 3.3 — Rôle nginx

Objectif :

* installer nginx
* déployer un vhost
* activer la configuration


### Exemple de tâches

```yaml
- name: Installation nginx
  ansible.builtin.apt:
    name: nginx
    state: present
    update_cache: true

- name: Déploiement vhost
  ansible.builtin.template:
    src: default_vhost.conf.j2
    dest: /etc/nginx/sites-available/default_vhost.conf
  notify: reload_nginx
```


### Handler associé

```yaml
- name: reload_nginx
  ansible.builtin.systemd:
    name: nginx
    state: reloaded
```


## 4 — Création des rôles

Commande :

```bash
ansible-galaxy init roles/ssh_keygen
ansible-galaxy init roles/users
ansible-galaxy init roles/nginx
```


## 5 — Playbook principal

### Exemple

```yaml
- name: Déploiement complet
  hosts: all
  become: true

  roles:
    - ssh_keygen
    - users
    - nginx
```


### Explication

Les rôles sont exécutés dans l’ordre :

1. génération de la clé SSH
2. création des utilisateurs + déploiement des clés
3. installation et configuration de Nginx


## 6 — Logique globale

### Workflow

1. génération de clé côté contrôleur
2. création des utilisateurs sur les cibles
3. injection des clés SSH
4. installation du reverse proxy


### Résultat

* accès SSH sécurisé sans mot de passe
* utilisateurs configurés
* serveur web fonctionnel


## 7 — Organisation recommandée

* un rôle = une responsabilité
* nommage cohérent des rôles
* structure identique entre projets
* séparation claire des variables


## 8 — Bonnes pratiques

* utiliser `defaults` pour les variables configurables
* éviter de mettre de la logique dans `vars`
* documenter chaque rôle
* tester les rôles individuellement
* versionner les rôles
* garder les rôles indépendants


## 9 — Anti-patterns

* créer des rôles trop gros
* coupler fortement les rôles entre eux
* mélanger plusieurs responsabilités
* ne pas documenter les variables
* dépendre de chemins en dur non maîtrisés


## 10 — Cas réel

Ce type d’organisation est utilisé pour :

* déploiement d’infrastructure
* automatisation DevOps
* provisioning de serveurs
* pipelines CI/CD


## Conclusion

Les rôles permettent de passer d’un playbook simple à une architecture structurée.

En pratique, ils permettent :

* une meilleure lisibilité
* une meilleure réutilisation
* une industrialisation des déploiements

C’est une étape clé pour construire des projets Ansible propres et maintenables.
