![Ansible](../assets/images/ansible.png)

# 28 Ansible - Module Systemd


## Documentation

https://docs.ansible.com/ansible/2.5/modules/systemd_module.html

Commande utile :

```bash
ansible-doc ansible.builtin.systemd
```


## Lab associé

[Voir le lab 28-ansible-module-systemd](../labs/28-ansible-module-systemd/)


## 1 — Introduction au module systemd

### Objectif

Le module `systemd` permet de gérer les services sur les systèmes Linux utilisant systemd.

Il remplace les commandes :

* `systemctl start`
* `systemctl stop`
* `systemctl restart`
* `systemctl enable`


### Périmètre

* démarrage / arrêt de services
* activation au boot
* reload de configuration
* gestion des unités systemd


## 2 — Paramètres principaux

### name

Nom du service :

```yaml
name: haproxy
```


### state

État du service :

* `started`
* `stopped`
* `restarted`
* `reloaded`


### enabled

Active le service au démarrage :

```yaml
enabled: true
```


### daemon_reload

Recharge la configuration systemd :

```yaml
daemon_reload: true
```


### daemon_reexec

Relance systemd lui-même.

Usage rare et avancé.


### masked

Empêche l’utilisation du service :

```yaml
masked: false
```


### force

Force la création ou remplacement des liens systemd.


### no_block

Permet de ne pas attendre la fin de l’opération.


### scope

Permet de définir le scope (system ou user).


## 3 — Démarrage d’un service

```yaml
- name: Démarrer haproxy
  ansible.builtin.systemd:
    name: haproxy
    state: started
```


## 4 — Arrêt d’un service

```yaml
- name: Arrêter haproxy
  ansible.builtin.systemd:
    name: haproxy
    state: stopped
```


## 5 — Activation au démarrage

```yaml
- name: Activer haproxy au boot
  ansible.builtin.systemd:
    name: haproxy
    state: started
    enabled: true
```


### Explication

* le service est démarré immédiatement
* il sera aussi lancé au boot


## 6 — Utilisation avec daemon_reload

```yaml
- name: Démarrage avec reload systemd
  ansible.builtin.systemd:
    name: haproxy
    state: started
    enabled: true
    daemon_reload: true
```


### Cas d’usage

* après modification d’un fichier `.service`
* après ajout d’une nouvelle unité systemd


## 7 — Gestion du masking

```yaml
- name: Assurer que le service n’est pas masqué
  ansible.builtin.systemd:
    name: haproxy
    state: started
    enabled: true
    daemon_reload: true
    masked: false
```


### Explication

Un service masqué ne peut pas être démarré.

Cette option permet de lever ce blocage.


## 8 — Reload uniquement

```yaml
- name: Recharger systemd uniquement
  ansible.builtin.systemd:
    daemon_reload: true
```


### Explication

Permet de recharger les unités systemd sans agir sur un service particulier.


## 9 — Cas d’usage typiques

Le module `systemd` est utilisé pour :

* démarrer un service après installation (nginx, haproxy, mysql)
* recharger un service après modification de configuration
* activer un service au boot
* gérer les services dans les rôles
* orchestrer les redémarrages via handlers


## 10 — Intégration avec handlers

### Exemple

```yaml
- name: Déploiement configuration nginx
  ansible.builtin.template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: reload_nginx

handlers:
  - name: reload_nginx
    ansible.builtin.systemd:
      name: nginx
      state: reloaded
```


### Intérêt

* reload uniquement si changement
* évite les interruptions inutiles


## 11 — Bonnes pratiques

* utiliser `systemd` plutôt que `shell`
* utiliser `daemon_reload` après modification des unités
* utiliser les handlers pour reload/restart
* toujours définir explicitement `enabled`
* éviter les restart inutiles


## 12 — Anti-patterns

* utiliser `command` ou `shell` pour gérer les services
* redémarrer un service sans condition
* oublier `daemon_reload` après modification
* masquer un service sans raison
* ne pas utiliser les handlers


## Conclusion

Le module `systemd` est central pour la gestion des services sous Linux.

Il permet :

* une gestion propre et idempotente
* une intégration avec les handlers
* une automatisation fiable des services

Sa maîtrise est indispensable pour tous les déploiements applicatifs et systèmes avec Ansible.
