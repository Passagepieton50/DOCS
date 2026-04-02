# Ansible Handbook

Documentation structurée autour de 44 chapitres couvrant les fondamentaux, les modules, les bonnes pratiques et plusieurs cas concrets autour d’Ansible.



## Sommaire

### Fondamentaux

* [01 Ansible - Introductions](docs/01-ansible-introductions.md)
* [02 Ansible - Notions & Bonnes pratiques](docs/02-ansible-notions-bonnes-pratiques.md)
* [03 Ansible - Installations](docs/03-ansible-installations.md)
* [04 Ansible - SSH](docs/04-ansible-ssh.md)
* [05 Ansible - Fichier cfg, configuration et tuning](docs/05-ansible-fichier-cfg-configuration-et-tuning.md)
* [06 Ansible - Commande ansible CLI](docs/06-ansible-commande-ansible-cli.md)
* [07 Ansible - Module CLI](docs/07-ansible-module-cli.md)



### Inventory et variables

* [08 Ansible - Inventory](docs/08-ansible-inventory.md)
* [09 Ansible - Inventory variables](docs/09-ansible-inventory-variables.md)
* [10 Ansible - Inventory commande](docs/10-ansible-inventory-commande.md)



### Playbooks et concepts avancés

* [11 Ansible - Playbook introductions](docs/11-ansible-playbook-introductions.md)
* [12 Ansible - Playbook et module](docs/12-ansible-playbook-et-module.md)
* [13 Ansible - Idempotence Ansible vs Terraform](docs/13-ansible-idempotence-ansible-vs-terraform.md)
* [14 Ansible - Plateforme dev Docker](docs/14-ansible-plateforme-dev-docker.md)



### Modules fondamentaux

* [15 Ansible - Module user](docs/15-ansible-module-user.md)
* [16 Ansible - Stat et register](docs/16-ansible-stat-et-register.md)
* [17 Ansible - With item et boucle](docs/17-ansible-with-item-et-boucle.md)
* [18 Ansible - Module apt](docs/18-ansible-module-apt.md)
* [19 Ansible - Module reboot](docs/19-ansible-module-reboot.md)
* [20 Ansible - Module génération key et SSH](docs/20-ansible-module-generation-key-et-ssh.md)
* [21 Ansible - Module delegate_to et localhost](docs/21-ansible-module-delegate-to-et-localhost.md)
* [22 Ansible - Module copy](docs/22-ansible-module-copy.md)
* [23 Ansible - Module fetch](docs/23-ansible-module-fetch.md)
* [24 Ansible - Module template](docs/24-ansible-module-template.md)
* [25 Ansible - Handlers](docs/25-ansible-handlers.md)



### Rôles et structuration

* [26 Ansible - Rôles théorie](docs/26-ansible-roles-theorie.md)
* [27 Ansible - Rôles pratique](docs/27-ansible-roles-pratique.md)



### Modules avancés

* [28 Ansible - Module systemd](docs/28-ansible-module-systemd.md)
* [29 Ansible - Module unarchive](docs/29-ansible-module-unarchive.md)
* [30 Ansible - Module lineinfile](docs/30-ansible-module-lineinfile.md)
* [31 Ansible - Module apt repo](docs/31-ansible-module-apt-repo.md)



### Variables et fonctionnement interne

* [32 Ansible - Variables hiérarchie](docs/32-ansible-variables-hierarchie.md)
* [33 Ansible - Gather fact](docs/33-ansible-gather-fact.md)



### Cas pratiques

* [34 Ansible - Installation de node exporter](docs/34-ansible-installation-de-node-exporter.md)
* [35 Ansible - Gestion de version](docs/35-ansible-gestion-de-version.md)
* [36 Ansible - Installation Prometheus](docs/36-ansible-installation-prometheus.md)



### Modules et usages avancés

* [37 Ansible - Module HTTP requêtes](docs/37-ansible-module-http-requetes.md)
* [38 Ansible - Module command et shell](docs/38-ansible-module-command-et-shell.md)
* [39 Ansible - Variables et prompt](docs/39-ansible-variables-et-prompt.md)
* [40 Ansible - Module synchronize](docs/40-ansible-module-synchronize.md)
* [41 Ansible - Inventory dynamique](docs/41-ansible-inventory-dynamique.md)
* [42 Ansible - Module assemble](docs/42-ansible-module-assemble.md)
* [43 Ansible - Module set_fact et cache](docs/43-ansible-module-set-fact-et-cache.md)



### Stack monitoring

* [44 Ansible - Grafana](docs/44-ansible-grafana.md)



## Structure du dépôt

* `docs/` : documentation principale
* `labs/` : code et laboratoires associés
* `assets/` : ressources statiques (images, fichiers)



## Objectifs

Ce dépôt vise à fournir :

* une documentation complète et progressive d’Ansible
* une approche orientée production et bonnes pratiques DevOps
* des exemples concrets réutilisables
* une base pédagogique pour formation ou auto-apprentissage



## Utilisation

Chaque chapitre contient :

* une explication détaillée
* des exemples contextualisés
* un lien vers un laboratoire (`labs/`) lorsque du code est associé



## Licence

MIT
