![Ansible](../assets/images/ansible.png)

# 25 Ansible - Handlers


## Documentation

https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_handlers.html

Commande utile :

```bash id="zb3n88"
ansible-doc -t keyword handlers
```


## Lab associé

[Voir le lab 25-ansible-handlers](../labs/25-ansible-handlers/)


## 1 — Introduction aux handlers

Les handlers sont des tâches spéciales déclenchées uniquement lorsqu’une autre tâche signale un changement.

On peut les voir comme des déclencheurs.

Ils sont particulièrement utiles pour :

* recharger un service après changement de configuration
* redémarrer un processus seulement si nécessaire
* éviter les opérations inutiles


## 2 — Principe de fonctionnement

Une tâche classique peut utiliser `notify` pour appeler un handler.

Le handler :

* n’est exécuté que si la tâche appelante a un état `changed`
* n’est exécuté qu’une seule fois, même si plusieurs tâches le notifient
* est généralement joué en fin de play

Cela permet d’optimiser l’exécution et de respecter l’idempotence.


## 3 — Exemple d’usage avec Nginx

### Contexte

On souhaite :

* installer Nginx
* supprimer les vhosts par défaut
* générer un nouveau vhost
* activer ce vhost
* recharger Nginx uniquement si la configuration a changé


### Playbook

```yaml id="7g71e4"
- name: Premier playbook
  hosts: all
  become: true
  vars:
    nginx_port: 8888

  tasks:
    - name: Installer nginx
      ansible.builtin.apt:
        name:
          - nginx
          - curl
        state: present
        cache_valid_time: 3600
        update_cache: true

    - name: Supprimer les vhosts par défaut
      ansible.builtin.file:
        path: "{{ item }}"
        state: absent
      with_items:
        - /etc/nginx/sites-available/default
        - /etc/nginx/sites-enabled/default

    - name: Installer le vhost
      ansible.builtin.template:
        src: default_vhost.conf.j2
        dest: /etc/nginx/sites-available/default_vhost.conf
        owner: root
        group: root
        mode: "0644"
      notify: reload_nginx

    - name: Activer le vhost
      ansible.builtin.file:
        src: /etc/nginx/sites-available/default_vhost.conf
        dest: /etc/nginx/sites-enabled/default_vhost.conf
        state: link

    - name: Démarrer nginx
      ansible.builtin.systemd:
        name: nginx
        state: started

  handlers:
    - name: reload_nginx
      ansible.builtin.systemd:
        name: nginx
        state: reloaded
```


## 4 — Mot-clé notify

Le mot-clé `notify` permet de relier une tâche à un handler.

### Exemple

```yaml id="tmg07l"
- name: Installer le vhost
  ansible.builtin.template:
    src: default_vhost.conf.j2
    dest: /etc/nginx/sites-available/default_vhost.conf
  notify: reload_nginx
```


### Explication

Le handler `reload_nginx` n’est exécuté que si le fichier de destination a réellement changé.


## 5 — Définition d’un handler

Les handlers sont définis dans un bloc `handlers`.

### Exemple

```yaml id="k8eu37"
handlers:
  - name: reload_nginx
    ansible.builtin.systemd:
      name: nginx
      state: reloaded
```


### Intérêt

Cela permet de :

* centraliser les redémarrages / reloads
* éviter les répétitions
* rendre le playbook plus lisible


## 6 — Moment d’exécution des handlers

Par défaut, les handlers sont exécutés :

* à la fin de la play
* après toutes les tâches normales

Cela signifie qu’un service n’est pas forcément rechargé immédiatement après la tâche qui l’a notifié.


## 7 — Forcer l’exécution avec meta: flush_handlers

### Principe

Il est possible de forcer l’exécution des handlers à un moment précis.

### Exemple

```yaml id="bypx5j"
- name: Flush handlers
  meta: flush_handlers
```


### Explication

Cette instruction force l’exécution immédiate des handlers en attente.

C’est utile quand :

* une suite de tâches dépend du rechargement déjà effectué
* on veut garantir qu’un service est à jour avant de continuer


## 8 — Exemple avancé avec reboot

```yaml id="v1l7i8"
- name: Vérifier si un reboot est nécessaire
  ansible.builtin.stat:
    path: /var/run/reboot.pending
  register: __need_reboot
  changed_when: __need_reboot.stat.exists
  notify: reboot_server
```


### Explication

Ici :

* `stat` vérifie la présence d’un indicateur de reboot
* `changed_when` transforme ce résultat en changement logique
* `notify` déclenche le handler `reboot_server`

Ce type de construction permet d’utiliser les handlers comme mécanisme d’orchestration conditionnelle.


## 9 — Cas d’usage typiques

Les handlers sont particulièrement adaptés pour :

* recharger Nginx après modification de configuration
* redémarrer un service systemd après changement
* relancer une application
* lancer un reboot si nécessaire
* recharger un démon après modification de fichiers critiques


## 10 — Bonnes pratiques

* utiliser les handlers pour les opérations de reload / restart
* ne pas redémarrer un service à chaque tâche
* nommer les handlers de manière explicite
* utiliser `flush_handlers` seulement quand c’est réellement nécessaire
* garder les handlers simples et ciblés


## 11 — Anti-patterns

* redémarrer un service dans chaque tâche au lieu d’utiliser `notify`
* utiliser un handler pour de la logique métier complexe
* abuser de `flush_handlers`
* ne pas comprendre que plusieurs `notify` vers le même handler n’exécutent qu’une seule fois ce handler


## Conclusion

Les handlers sont un mécanisme central d’Ansible pour gérer les actions déclenchées par changement.

Ils permettent :

* des rechargements propres
* une meilleure idempotence
* une meilleure lisibilité
* moins d’actions inutiles

Leur bonne utilisation améliore fortement la qualité des playbooks, en particulier pour la gestion des services et des fichiers de configuration.
