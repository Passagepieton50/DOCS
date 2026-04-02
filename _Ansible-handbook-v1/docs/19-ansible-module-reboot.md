![Ansible](../assets/images/ansible.png)

# 19 Ansible - Check & Reboot


## Documentation

https://docs.ansible.com/ansible/latest/collections/ansible/builtin/reboot_module.html

Commande utile :

```bash
ansible-doc ansible.builtin.reboot
```


## Lab associé

[Voir le lab 19-ansible-check-et-reboot](../labs/19-ansible-check-et-reboot/)


## 1 — Introduction au module reboot

### Objectif

Le module `reboot` permet de :

* redémarrer une machine
* attendre son retour en ligne
* vérifier que le système est opérationnel

Il est essentiel pour :

* mises à jour système
* changements critiques (kernel, config)
* automatisations nécessitant un reboot contrôlé


## 2 — Principe de fonctionnement

Contrairement à un simple `shutdown -r`, le module :

* déclenche le reboot
* attend la coupure de connexion
* attend le retour SSH
* exécute une commande de test

Cela garantit que :

* la machine est bien redémarrée
* elle est prête à recevoir des tâches suivantes


## 3 — Paramètres principaux

### msg

Message affiché avant reboot :

```yaml
msg: "Reboot via ansible"
```


### connect_timeout

Timeout de connexion SSH :

```yaml
connect_timeout: 5
```


### reboot_timeout

Temps maximum pour le reboot :

```yaml
reboot_timeout: 300
```


### pre_reboot_delay

Délai avant reboot :

```yaml
pre_reboot_delay: 0
```


### post_reboot_delay

Délai après reboot :

```yaml
post_reboot_delay: 30
```


### test_command

Commande utilisée pour valider le reboot :

```yaml
test_command: uptime
```


### boot_time_command

Permet de vérifier que le reboot est effectif via un identifiant système.


## 4 — Exemple simple avec condition

### Playbook

```yaml
- name: Mon premier playbook
  hosts: all
  remote_user: vagrant
  become: true
  tasks:

    - name: Création fichier
      ansible.builtin.file:
        path: /tmp/pp.txt
        state: touch

    - name: Vérification du fichier
      ansible.builtin.stat:
        path: /tmp/pp.txt
      register: __file_exist

    - name: Reboot conditionnel
      ansible.builtin.reboot:
        msg: "Reboot via ansible"
        connect_timeout: 5
        reboot_timeout: 300
        pre_reboot_delay: 0
        post_reboot_delay: 30
        test_command: uptime
      when: __file_exist.stat.exists

    - name: Création second fichier
      ansible.builtin.file:
        path: /tmp/pp2.txt
        state: touch
```


### Explication

1. création d’un fichier
2. vérification avec `stat`
3. reboot seulement si le fichier existe
4. reprise normale du playbook après reboot


## 5 — Cas réel : reboot après mise à jour

### Mise à jour système

```yaml
- name: Mise à jour du cache
  ansible.builtin.apt:
    update_cache: true
    force_apt_get: true
    cache_valid_time: 3600

- name: Upgrade système
  ansible.builtin.apt:
    upgrade: dist
    force_apt_get: true
```


### Vérification reboot requis

```yaml
- name: Vérification reboot requis
  ansible.builtin.stat:
    path: /var/run/reboot-required
  register: reboot_required_file
```


### Reboot conditionnel

```yaml
- name: Reboot si nécessaire
  ansible.builtin.reboot:
    msg: "Reboot via ansible"
    connect_timeout: 5
    reboot_timeout: 300
    pre_reboot_delay: 0
    post_reboot_delay: 30
    test_command: uptime
  when: reboot_required_file.stat.exists
```


### Explication

* Debian/Ubuntu crée `/var/run/reboot-required` si reboot nécessaire
* `stat` vérifie sa présence
* reboot uniquement si nécessaire


## 6 — Logique complète

Workflow typique :

1. mise à jour système
2. vérification du besoin de reboot
3. reboot conditionnel
4. reprise automatique du playbook


## 7 — Bonnes pratiques

* toujours utiliser `reboot` au lieu de `shell`
* utiliser `stat` pour conditionner
* définir un `test_command`
* prévoir des timeouts adaptés
* éviter les reboot inutiles


## 8 — Anti-patterns

* reboot sans condition
* utiliser `command` ou `shell` pour reboot
* ne pas attendre le retour de la machine
* enchaîner des tâches sans validation post-reboot
* oublier les timeouts


## Conclusion

Le module `reboot` permet de gérer proprement les redémarrages.

Associé à `stat`, il permet :

* des reboots intelligents
* des playbooks robustes
* une automatisation fiable

Il est indispensable dans les scénarios :

* mise à jour système
* déploiement critique
* gestion d’infrastructure automatisée
