![Ansible](../assets/images/ansible.png)

# 44 Ansible - Monitoring : Grafana


## Documentation

Grafana :
https://grafana.com/docs/

Module apt :
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html

Module apt_key :
https://docs.ansible.com/ansible/2.5/modules/apt_key_module.html

Module apt_repository :
https://docs.ansible.com/ansible/2.5/modules/apt_repository_module.html

Module systemd :
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/systemd_module.html

Module uri :
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/uri_module.html


## Lab associé

[Voir le lab 44-ansible-grafana](../labs/44-ansible-grafana/)


## 1 — Introduction

Cette partie correspond à la troisième étape du monitoring :

1. Node Exporter
2. Prometheus
3. Grafana

Grafana permet de :

* visualiser les métriques
* créer des dashboards
* exploiter les données de Prometheus


## 2 — Objectif

Mettre en place Grafana sur le serveur de monitoring afin de :

* se connecter à Prometheus
* visualiser les données
* construire des dashboards


## 3 — Architecture

* 1 serveur monitoring :

  * Prometheus
  * Grafana

* N serveurs :

  * Node Exporter

Grafana interroge Prometheus qui lui-même collecte les métriques.


## 4 — Installation des prérequis

```yaml
- name: Install GPG tools
  ansible.builtin.apt:
    name: gnupg,software-properties-common
    state: present
    update_cache: yes
    cache_valid_time: 3600
```


### Explication

* nécessaire pour gérer les clés GPG
* indispensable pour ajouter des dépôts externes


## 5 — Ajout de la clé GPG

```yaml
- name: Add Grafana GPG key
  ansible.builtin.apt_key:
    url: "https://packages.grafana.com/gpg.key"
    validate_certs: no
```


### Explication

* permet de valider les paquets Grafana
* étape obligatoire avant ajout du dépôt


## 6 — Ajout du repository

```yaml
- name: Add Grafana repository
  ansible.builtin.apt_repository:
    repo: "deb https://packages.grafana.com/oss/deb stable main"
    state: present
    validate_certs: no
```


### Explication

* ajoute le dépôt officiel Grafana
* permet d’installer le package via APT


## 7 — Installation de Grafana

```yaml
- name: Install Grafana
  ansible.builtin.apt:
    name: grafana
    state: latest
    update_cache: yes
    cache_valid_time: 3600
```


### Explication

* installe Grafana
* récupère la dernière version disponible


## 8 — Démarrage du service

```yaml
- name: Start Grafana service
  ansible.builtin.systemd:
    name: grafana-server
    state: started
    enabled: yes
```


### Explication

* démarre Grafana
* active le service au boot


## 9 — Attente du service

```yaml
- name: Wait for Grafana to be up
  ansible.builtin.uri:
    url: "http://127.0.0.1:3000"
    status_code: 200
  register: __result
  until: __result.status == 200
  retries: 120
  delay: 1
```


### Explication

* attend que Grafana soit disponible
* évite d’enchaîner des tâches trop tôt
* retry toutes les secondes pendant 120 secondes


## 10 — Changement du mot de passe admin

```yaml
- name: Change Grafana admin password
  ansible.builtin.shell: "grafana-cli admin reset-admin-password {{ grafana_admin_password }}"
  register: __command_admin
  changed_when: __command_admin.rc != 0
```


### Explication

* modifie le mot de passe admin par défaut
* utilise `grafana-cli`
* évite les changements inutiles avec `changed_when`


## 11 — Variables recommandées

```yaml
grafana_admin_password: "StrongPassword123"
```


## 12 — Accès à Grafana

Grafana est accessible sur :

```text
http://<ip_du_serveur>:3000
```

Identifiants par défaut :

* user : admin
* password : admin (modifié via Ansible)


## 13 — Intégration avec Prometheus

Dans Grafana :

1. ajouter une datasource
2. type : Prometheus
3. URL :

   ```text
   http://localhost:9090
   ```


## 14 — Cas d’usage

* dashboards monitoring
* visualisation CPU / RAM / disque
* métriques applicatives
* alerting
* observabilité


## 15 — Bonnes pratiques

* changer le mot de passe admin
* utiliser HTTPS en production
* sauvegarder les dashboards
* utiliser des variables d’environnement
* versionner les dashboards (json)


## 16 — Anti-patterns

* laisser les credentials par défaut
* ne pas sécuriser l’accès
* ne pas attendre le service avant configuration
* tout configurer manuellement
* ne pas versionner les dashboards


## Conclusion

Grafana complète la stack de monitoring :

* Node Exporter → collecte
* Prometheus → stockage
* Grafana → visualisation

Cette dernière étape permet :

* de rendre les données exploitables
* d’avoir une vision claire de l’infrastructure
* de finaliser une stack de monitoring complète et professionnelle
