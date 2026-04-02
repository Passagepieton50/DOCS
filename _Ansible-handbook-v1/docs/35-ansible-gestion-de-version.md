![Ansible](../assets/images/ansible.png)

# 35 Ansible - Monitoring : Node Exporter - Gestion de version


## Documentation

Node Exporter :
https://github.com/prometheus/node_exporter/releases

Module shell :
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/shell_module.html

Module systemd :
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/systemd_module.html


## Lab associé

[Voir le lab 35-ansible-node-exporter-gestion-de-version](../labs/35-ansible-gestion-de-version/)


## 1 — Objectif

L’objectif est de gérer la mise à jour de Node Exporter.

Le principe est de :

* vérifier si le binaire existe
* identifier la version actuellement installée
* comparer avec la version attendue
* télécharger et réinstaller uniquement si nécessaire
* redémarrer le service en cas de changement


## 2 — Problématique

Pour mettre à jour Node Exporter, il faut pouvoir savoir quelle version est déjà présente.

Plusieurs approches existent :

* lire la version via le binaire
* interroger l’endpoint HTTP avec `curl`
* récupérer l’information dans la configuration systemd

Dans ce cas, l’approche retenue consiste à stocker la version dans le fichier de service systemd, puis à la relire.


## 3 — Principe retenu

La version attendue est injectée dans le service systemd.

### Exemple de template systemd

```ini id="lpc6pi"
[Unit]
Description=Node Exporter Version {{ node_exporter_version }}
After=network-online.target

[Service]
User={{ node_exporter_user }}
Group={{ node_exporter_user }}
Type=simple
ExecStart={{ node_exporter_bin }}

[Install]
WantedBy=multi-user.target
```


## 4 — Variables principales

```yaml id="v24q2w"
node_exporter_version: "1.0.1"
node_exporter_bin: /usr/local/bin/node_exporter
node_exporter_user: node-exporter
node_exporter_group: "{{ node_exporter_user }}"
node_exporter_dir_conf: /etc/node_exporter
```


## 5 — Vérification de présence

```yaml id="jlwmcp"
- name: Check if node exporter exists
  ansible.builtin.stat:
    path: "{{ node_exporter_bin }}"
  register: __check_node_exporter_present
```


## 6 — Récupération de la version installée

### Exemple avec shell

```yaml id="x7kkcy"
- name: Get node exporter version from systemd service
  ansible.builtin.shell: "cat /etc/systemd/system/node_exporter.service | grep Version | sed s/'.*Version '//g"
  when: __check_node_exporter_present.stat.exists == true
  changed_when: false
  register: __get_node_exporter_version
```


### Explication

Cette tâche :

* lit le fichier de service
* récupère la ligne contenant `Version`
* extrait uniquement la version
* ne marque pas la tâche comme modifiée


## 7 — Condition de mise à jour

Le téléchargement et le nettoyage doivent être conditionnés à deux cas :

* Node Exporter n’est pas installé
* la version installée est différente de la version attendue


### Condition

```yaml id="snl6j4"
when: __check_node_exporter_present.stat.exists == false or __get_node_exporter_version.stdout != node_exporter_version
```


## 8 — Téléchargement conditionnel

```yaml id="3r2j7r"
- name: Download and extract node exporter
  ansible.builtin.unarchive:
    src: "https://github.com/prometheus/node_exporter/releases/download/v{{ node_exporter_version }}/node_exporter-{{ node_exporter_version }}.linux-amd64.tar.gz"
    dest: /tmp/
    remote_src: true
  when: __check_node_exporter_present.stat.exists == false or __get_node_exporter_version.stdout != node_exporter_version
```


## 9 — Déplacement du binaire

```yaml id="2mgg1m"
- name: Move binary
  ansible.builtin.copy:
    src: "/tmp/node_exporter-{{ node_exporter_version }}.linux-amd64/node_exporter"
    dest: "{{ node_exporter_bin }}"
    owner: "{{ node_exporter_user }}"
    group: "{{ node_exporter_group }}"
    mode: "0755"
    remote_src: true
  when: __check_node_exporter_present.stat.exists == false or __get_node_exporter_version.stdout != node_exporter_version
```


## 10 — Nettoyage conditionnel

```yaml id="feua4u"
- name: Clean temporary files
  ansible.builtin.file:
    path: "/tmp/node_exporter-{{ node_exporter_version }}.linux-amd64/"
    state: absent
  when: __check_node_exporter_present.stat.exists == false or __get_node_exporter_version.stdout != node_exporter_version
```


## 11 — Mise à jour du service systemd

Le template systemd doit être redéployé pour refléter la nouvelle version.

```yaml id="pjlwm3"
- name: Install systemd service
  ansible.builtin.template:
    src: node_exporter.service.j2
    dest: /etc/systemd/system/node_exporter.service
    owner: root
    group: root
    mode: "0755"
  notify: reload_daemon_and_restart_node_exporter
```


## 12 — Handler associé

```yaml id="i9ov5r"
- name: reload_daemon_and_restart_node_exporter
  ansible.builtin.systemd:
    name: node_exporter
    state: restarted
    daemon_reload: true
    enabled: true
```


## 13 — Logique globale

Workflow :

1. vérifier si le binaire existe
2. lire la version installée
3. comparer avec la version attendue
4. télécharger uniquement si nécessaire
5. remplacer le binaire
6. mettre à jour systemd
7. redémarrer le service


## 14 — Limites de l’approche

Cette méthode repose sur une convention :

* la version doit être présente dans le fichier de service

Si ce fichier est modifié manuellement ou absent, la détection devient moins fiable.


## 15 — Alternatives possibles

### Lecture du binaire

Exemple :

```bash id="94rbq3"
node_exporter --version
```

Avantages :

* plus proche de l’état réel du binaire

Inconvénients :

* nécessite d’exécuter le binaire


### Interrogation HTTP

Exemple :

```bash id="jonhmd"
curl http://localhost:9100/metrics
```

Avantages :

* vérifie aussi que le service répond

Inconvénients :

* nécessite que le service soit lancé


## 16 — Bonnes pratiques

* éviter les téléchargements inutiles
* centraliser la version dans une variable
* conditionner les tâches de mise à jour
* redémarrer uniquement si nécessaire
* garder une logique de version simple et explicite


## 17 — Anti-patterns

* télécharger à chaque exécution
* ne pas comparer les versions
* faire confiance uniquement à l’existence du binaire
* redémarrer systématiquement le service
* disperser la version dans plusieurs fichiers


## Conclusion

La gestion de version de Node Exporter permet de passer d’une simple installation à une vraie logique de maintenance.

Cette approche permet :

* une mise à jour conditionnelle
* une meilleure idempotence
* un meilleur contrôle des changements

C’est une étape importante pour industrialiser un rôle Ansible de déploiement applicatif ou système.
