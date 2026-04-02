![Ansible](../assets/images/ansible.png)

# 34 Ansible - Monitoring : Node Exporter


## Documentation

Node Exporter :
https://github.com/prometheus/node_exporter/releases


## Lab associé

[Voir le lab 34-ansible-node-exporter](../labs/34-ansible-node-exporter/)


## 1 — Objectif

Mettre en place une première brique de monitoring :

* installation de Node Exporter
* exposition des métriques système
* préparation pour Prometheus et Grafana


## 2 — Architecture

### Infrastructure

* 1 nœud monitoring :

  * Prometheus
  * Grafana

* N nœuds monitorés :

  * Node Exporter


### Rôle de Node Exporter

* collecte des métriques système :

  * CPU
  * RAM
  * disque
  * réseau

* exposition via HTTP (port 9100 par défaut)


## 3 — Structure du projet

```text
.
├── inventory.yml
├── playbook.yml
└── roles/
    └── node_exporter/
```


## 4 — Variables du rôle

```yaml
node_exporter_version: "1.0.1"
node_exporter_bin: /usr/local/bin/node_exporter
node_exporter_user: node-exporter
node_exporter_group: "{{ node_exporter_user }}"
node_exporter_dir_conf: /etc/node_exporter
```


## 5 — Workflow du rôle

### Étapes

1. vérifier si installé
2. créer utilisateur système
3. créer répertoire (optionnel)
4. télécharger et extraire
5. déplacer le binaire
6. nettoyer
7. créer service systemd
8. démarrer le service


## 6 — Vérification de l’existant

```yaml
- name: Check if node exporter exists
  ansible.builtin.stat:
    path: "{{ node_exporter_bin }}"
  register: __check_node_exporter_present
```


## 7 — Création de l’utilisateur

```yaml
- name: Create node exporter user
  ansible.builtin.user:
    name: "{{ node_exporter_user }}"
    append: true
    shell: /usr/sbin/nologin
    system: true
    create_home: false
    home: /
```


## 8 — Création du répertoire

```yaml
- name: Create config directory
  ansible.builtin.file:
    path: "{{ node_exporter_dir_conf }}"
    state: directory
    owner: "{{ node_exporter_user }}"
    group: "{{ node_exporter_group }}"
```


## 9 — Téléchargement et extraction

```yaml
- name: Download and extract node exporter
  ansible.builtin.unarchive:
    src: "https://github.com/prometheus/node_exporter/releases/download/v{{ node_exporter_version }}/node_exporter-{{ node_exporter_version }}.linux-amd64.tar.gz"
    dest: /tmp/
    remote_src: true
  when: __check_node_exporter_present.stat.exists == false
```


## 10 — Déplacement du binaire

```yaml
- name: Move binary
  ansible.builtin.copy:
    src: "/tmp/node_exporter-{{ node_exporter_version }}.linux-amd64/node_exporter"
    dest: "{{ node_exporter_bin }}"
    owner: "{{ node_exporter_user }}"
    group: "{{ node_exporter_group }}"
    mode: "0755"
    remote_src: true
  when: __check_node_exporter_present.stat.exists == false
```


## 11 — Nettoyage

```yaml
- name: Clean temporary files
  ansible.builtin.file:
    path: "/tmp/node_exporter-{{ node_exporter_version }}.linux-amd64/"
    state: absent
```


## 12 — Template systemd

### Fichier : `node_exporter.service.j2`

```ini
[Unit]
Description=Node Exporter
After=network-online.target

[Service]
User={{ node_exporter_user }}
Group={{ node_exporter_user }}
Type=simple
ExecStart={{ node_exporter_bin }}

[Install]
WantedBy=multi-user.target
```


## 13 — Installation du service

```yaml
- name: Install systemd service
  ansible.builtin.template:
    src: node_exporter.service.j2
    dest: /etc/systemd/system/node_exporter.service
    owner: root
    group: root
    mode: "0755"
  notify: reload_daemon_and_restart_node_exporter
```


## 14 — Flush des handlers

```yaml
- name: Flush handlers
  meta: flush_handlers
```


## 15 — Démarrage du service

```yaml
- name: Ensure service is started
  ansible.builtin.systemd:
    name: node_exporter
    state: started
    enabled: true
```


## 16 — Handler

```yaml
- name: reload_daemon_and_restart_node_exporter
  ansible.builtin.systemd:
    name: node_exporter
    state: restarted
    daemon_reload: true
    enabled: true
```


## 17 — Vérification

### Accès HTTP

```text
http://<IP>:9100/metrics
```


### Résultat attendu

* endpoint accessible
* métriques Prometheus exposées


## 18 — Bonnes pratiques

* vérifier l’existence avant installation
* utiliser un user dédié non connecté
* utiliser `remote_src: true` pour les downloads
* utiliser des handlers pour les reload
* nettoyer les fichiers temporaires


## 19 — Anti-patterns

* installer sans vérification préalable
* lancer en root sans raison
* ne pas gérer systemd proprement
* oublier `daemon_reload`
* ne pas rendre le service persistent


## Conclusion

Node Exporter est la première étape d’une stack de monitoring.

Ce rôle permet :

* une installation propre
* une approche idempotente
* une intégration avec systemd

Il sert de base pour :

* Prometheus (scraping)
* Grafana (visualisation)

C’est un cas concret complet combinant :

* rôles
* templates
* handlers
* modules système
* logique conditionnelle
