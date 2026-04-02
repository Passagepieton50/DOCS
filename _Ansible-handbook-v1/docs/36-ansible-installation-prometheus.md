![Ansible](../assets/images/ansible.png)

# 36 Ansible - Monitoring : Prometheus


## Documentation

Prometheus :
https://prometheus.io/docs/prometheus/latest/

Module apt :
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html

Module template :
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html

Module systemd :
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/systemd_module.html

Module uri :
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/uri_module.html


## Lab associé

[Voir le lab 36-ansible-installation-prometheus](../labs/36-ansible-installation-prometheus/)


## 1 — Objectif

Cette partie constitue la deuxième étape de la mise en pratique autour du monitoring.

La séquence globale est :

1. installation de Node Exporter
2. installation de Prometheus
3. installation de Grafana

L’objectif ici est d’installer Prometheus sur le nœud de monitoring afin de :

* collecter les métriques
* interroger les exporters
* centraliser les données
* préparer la visualisation dans Grafana


## 2 — Architecture cible

L’environnement de travail repose sur :

* 1 nœud de monitoring :

  * Prometheus
  * Grafana

* plusieurs nœuds supervisés :

  * Node Exporter

Prometheus joue ici le rôle de collecteur central.


## 3 — Structure du projet

```text
.
├── inventory.yml
├── playbook.yml
└── roles/
    ├── node_exporter/
    └── prometheus/
```


## 4 — Variables du rôle

Les variables permettent de piloter la configuration du service et du fichier `prometheus.yml`.

```yaml
prometheus_dir_configuration: "/etc/prometheus"
prometheus_retention_time: "365d"
prometheus_scrape_interval: "30s"
prometheus_node_exporter: true
prometheus_node_exporter_group: "all"
prometheus_env: "production"

prometheus_var_config:
  global:
    scrape_interval: "{{ prometheus_scrape_interval }}"
    evaluation_interval: 5s
    external_labels:
      env: "{{ prometheus_env }}"
  scrape_configs:
    - job_name: prometheus
      scrape_interval: 5m
      static_configs:
        - targets: ["{{ inventory_hostname }}:9090"]
```


## 5 — Logique du rôle

Le rôle Prometheus suit une séquence simple :

1. installation du paquet
2. génération des arguments de lancement
3. génération du fichier de configuration
4. démarrage du service
5. exécution des handlers

Cette approche permet de garder un rôle lisible et facilement maintenable.


## 6 — Installation de Prometheus

```yaml
- name: Update and install Prometheus
  ansible.builtin.apt:
    name: prometheus
    state: latest
    update_cache: true
    cache_valid_time: 3600
```

### Explication

Cette tâche :

* met à jour le cache APT
* installe Prometheus
* garantit la présence de la dernière version disponible dans le dépôt

En production, il peut être préférable de figer une version plutôt que d’utiliser systématiquement `latest`.


## 7 — Arguments passés à Prometheus

Prometheus utilise généralement un fichier d’environnement ou une configuration de service pour ses options de démarrage.

### Déploiement du fichier d’arguments

```yaml
- name: Prometheus args
  ansible.builtin.template:
    src: prometheus.j2
    dest: /etc/default/prometheus
    mode: "0644"
    owner: root
    group: root
  notify: restart_prometheus
```

### Explication

Cette tâche permet de générer les arguments du service à partir d’un template Jinja2.

Le handler `restart_prometheus` est notifié car un changement sur les arguments de lancement nécessite généralement un redémarrage du service.


## 8 — Fichier de configuration Prometheus

Le fichier principal de configuration est `prometheus.yml`.

### Déploiement du fichier

```yaml
- name: Prometheus configuration file
  ansible.builtin.template:
    src: prometheus.yml.j2
    dest: "{{ prometheus_dir_configuration }}/prometheus.yml"
    mode: "0755"
    owner: prometheus
    group: prometheus
  notify: reload_prometheus
```

### Explication

Cette tâche génère la configuration à partir des variables du rôle.

Le handler déclenché ici est `reload_prometheus`, car une modification de la configuration peut être rechargée sans redémarrage complet du service.


## 9 — Démarrage du service

```yaml
- name: Start Prometheus
  ansible.builtin.systemd:
    name: prometheus
    state: started
    enabled: true
```

### Explication

Cette tâche garantit que :

* le service est démarré
* le service est activé au boot


## 10 — Flush des handlers

```yaml
- name: Flush handlers
  meta: flush_handlers
```

### Explication

Par défaut, les handlers sont exécutés en fin de play.

`flush_handlers` permet ici de forcer leur exécution immédiatement, afin de s’assurer que Prometheus a bien pris en compte la configuration avant la suite du workflow.


## 11 — Handlers

### Redémarrage du service

```yaml
- name: restart_prometheus
  ansible.builtin.systemd:
    name: prometheus
    state: restarted
    enabled: true
    daemon_reload: true
```

### Rechargement de la configuration

```yaml
- name: reload_prometheus
  ansible.builtin.uri:
    url: http://localhost:9090/-/reload
    method: POST
    status_code: 200
```

### Explication

Deux logiques sont séparées :

* `restart_prometheus` : utilisé si les arguments de lancement changent
* `reload_prometheus` : utilisé si seule la configuration Prometheus change

Cette distinction est importante car elle évite des redémarrages inutiles.


## 12 — Exemple de template de configuration

Le contenu réel de `prometheus.yml.j2` peut s’appuyer sur la variable `prometheus_var_config`.

Exemple de logique attendue :

```jinja2
global:
  scrape_interval: {{ prometheus_var_config.global.scrape_interval }}
  evaluation_interval: {{ prometheus_var_config.global.evaluation_interval }}
  external_labels:
    env: "{{ prometheus_var_config.global.external_labels.env }}"

scrape_configs:
  - job_name: prometheus
    scrape_interval: 5m
    static_configs:
      - targets:
          - "{{ inventory_hostname }}:9090"
```


## 13 — Intégration avec Node Exporter

Une fois Node Exporter installé sur les nœuds supervisés, Prometheus peut les scrapper.

L’idée est de construire dynamiquement les cibles selon un groupe d’inventory, par exemple :

```yaml
prometheus_node_exporter_group: "all"
```

Cela permet de faire évoluer la configuration en fonction de l’inventory plutôt qu’en dur.

Dans une version plus avancée du rôle, on peut générer automatiquement les `targets` à partir des groupes Ansible.


## 14 — Vérification

Après déploiement, Prometheus doit être accessible sur :

```text
http://<ip_du_serveur_monitoring>:9090
```

Points à vérifier :

* le service tourne
* l’interface web est accessible
* la configuration est chargée
* les cibles apparaissent dans l’onglet Targets


## 15 — Bonnes pratiques

* séparer arguments système et configuration applicative
* utiliser des handlers distincts pour reload et restart
* utiliser des templates pour éviter la configuration en dur
* centraliser les variables du rôle
* versionner les fichiers de configuration
* utiliser l’inventory pour générer les cibles de scraping


## 16 — Anti-patterns

* mettre toutes les cibles Prometheus en dur sans lien avec l’inventory
* redémarrer Prometheus à chaque changement mineur
* mélanger configuration système et configuration applicative
* utiliser `latest` partout sans politique de version
* ne pas valider que le service répond après changement


## Conclusion

Cette étape permet d’ajouter la brique centrale de collecte dans la stack de monitoring.

Le rôle Prometheus permet :

* une installation propre
* une configuration pilotée par variables
* une intégration naturelle avec Node Exporter
* une gestion propre des changements via handlers

C’est la base nécessaire avant la troisième étape : l’installation et la configuration de Grafana.
