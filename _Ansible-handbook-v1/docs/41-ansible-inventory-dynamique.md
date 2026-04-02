![Ansible](../assets/images/ansible.png)

# 41 Ansible - Inventory dynamique


## Documentation

[https://docs.ansible.com/ansible/latest/plugins/inventory.html](https://docs.ansible.com/ansible/latest/plugins/inventory.html)
[https://docs.ansible.com/ansible/latest/dev_guide/developing_inventory.html](https://docs.ansible.com/ansible/latest/dev_guide/developing_inventory.html)
[https://github.com/ansible-collections/community.general/tree/main/scripts/inventory](https://github.com/ansible-collections/community.general/tree/main/scripts/inventory)


## Lab associé

[Voir le lab 41-ansible-inventory-dynamic](../labs/41-ansible-inventory-dynamic/)


## 1 — Introduction

Un inventory dynamique permet de générer automatiquement la liste des hosts au lieu de les définir statiquement.

Contrairement à un inventory classique :

* statique → écrit à la main
* dynamique → généré à la volée


## 2 — Objectif

Permet de :

* découvrir automatiquement des machines
* s’intégrer avec des APIs (cloud, CMDB…)
* éviter la maintenance manuelle
* adapter l’infrastructure en temps réel


## 3 — Types d’inventory dynamique

### 1. Scripts (legacy)

* script bash / python
* retourne du JSON
* exécuté par Ansible


### 2. Plugins (moderne)

* YAML + plugin
* plus propre et maintenable
* recommandé aujourd’hui


## 4 — Configuration ansible.cfg

```ini
[inventory]
enable_plugins = host_list, script, auto, yaml, ini, toml
```


## 5 — Exemple avec plugin (nmap)

### Fichier nmap.yml

```yaml
plugin: nmap
strict: false
address: 192.168.1.0/24
```


### Commandes

```bash
ansible-inventory -i nmap.yml --list
ansible -i nmap.yml all -m ping
```


### Explication

* scan réseau automatique
* génération des hosts
* inventory dynamique basé sur découverte


## 6 — Script dynamique (inventory.sh)

Un script dynamique doit :

* accepter des arguments (`--list`, `--host`)
* retourner du JSON valide


### Exemple simplifié

```bash
#!/bin/bash

ip="
192.168.100.12
192.168.100.13
"

if [ "$1" = "--list" ]; then
  echo "{"
  echo '  "grp1": {'
  echo '    "hosts": ['

  first=1
  for i in $ip; do
    if [ $first -eq 1 ]; then
      first=0
    else
      echo ','
    fi
    printf '      "%s"' "$i"
  done

  echo ''
  echo '    ],'
  echo '    "vars": {'
  echo '      "mavariable": "1"'
  echo '    }'
  echo '  },'
  echo '  "_meta": {'
  echo '    "hostvars": {'

  first=1
  for i in $ip; do
    if [ $first -eq 1 ]; then
      first=0
    else
      echo ','
    fi

    if [ "$i" = "192.168.100.12" ]; then
      var1="pp1"
    elif [ "$i" = "192.168.100.13" ]; then
      var1="pp2"
    else
      var1="default"
    fi

    printf '      "%s": {\n' "$i"
    printf '        "var1": "%s"\n' "$var1"
    printf '      }'
  done

  echo ''
  echo '    }'
  echo '  }'
  echo '}'

elif [ "$1" = "--host" ]; then
  echo "{}"
else
  echo "{}"
fi
```


## 7 — Structure attendue

Un inventory dynamique doit retourner :

```json
{
  "group": {
    "hosts": [],
    "vars": {}
  },
  "_meta": {
    "hostvars": {}
  }
}
```


## 8 — Utilisation

```bash
chmod +x inventory.sh

ansible-inventory -i inventory.sh --list
ansible -i inventory.sh all -m ping
```


## 9 — Concepts importants

### _meta.hostvars

* permet d’éviter un appel `--host` par machine
* améliore fortement les performances


### --list vs --host

* `--list` : retourne tout l’inventory
* `--host <hostname>` : retourne les variables d’un host

Aujourd’hui, `_meta` remplace généralement `--host`


## 10 — Cas d’usage typiques

* cloud (AWS, Azure, GCP)
* Kubernetes
* CMDB
* discovery réseau
* environnements dynamiques


## 11 — Bonnes pratiques

* privilégier les plugins aux scripts
* toujours retourner un JSON valide
* utiliser `_meta` pour les performances
* versionner les scripts
* tester avec `ansible-inventory`


## 12 — Anti-patterns

* écrire des scripts complexes non maintenables
* ne pas gérer les erreurs JSON
* faire un appel externe par host
* ne pas documenter la logique
* mélanger logique métier et inventory


## Conclusion

L’inventory dynamique est essentiel pour :

* les infrastructures modernes
* les environnements cloud
* les architectures évolutives

Il permet de rendre Ansible :

* plus flexible
* plus automatisé
* plus scalable

C’est une brique clé dès que l’infrastructure n’est plus statique.
