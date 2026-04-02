![Ansible](../assets/images/ansible.png)

# 29 Ansible - Modules UNARCHIVE et GET_URL


## Documentation

UNARCHIVE :
https://docs.ansible.com/ansible/2.5/modules/unarchive_module.html

GET_URL :
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/get_url_module.html

Commandes utiles :

```bash
ansible-doc ansible.builtin.unarchive
ansible-doc ansible.builtin.get_url
```


## Lab associé

[Voir le lab 29-ansible-unarchive-et-get-url](../labs/29-ansible-unarchive-et-get-url/)


## 1 — Introduction

Ces deux modules sont très utilisés ensemble :

* `get_url` : télécharger un fichier
* `unarchive` : extraire une archive

Ils sont essentiels pour :

* installer des binaires
* déployer des applications
* récupérer des artefacts
* automatiser des installations hors gestionnaire de paquets


# PARTIE 1 — MODULE UNARCHIVE


## 2 — Objectif

Le module `unarchive` permet de :

* décompresser une archive
* copier + extraire en une seule étape


### Prérequis

* `tar`
* `unzip`


## 3 — Paramètres principaux

### src

Source de l’archive :

```yaml
src: /tmp/archive.tar.gz
```


### dest

Destination sur la machine cible :

```yaml
dest: /opt/app/
```


### remote_src

Définit l’origine :

* `false` : depuis le contrôleur
* `true` : depuis la cible ou une URL


### creates

Empêche l’exécution si un fichier existe :

```yaml
creates: /opt/app/bin/app
```


### mode / owner / group

Gestion des permissions.


### exclude

Permet d’exclure des fichiers de l’archive.


### list_files

Permet de lister les fichiers contenus dans l’archive.


## 4 — Exemple avec fichier local

```yaml
- name: Extraction depuis le contrôleur
  ansible.builtin.unarchive:
    src: /tmp/node_exporter.tar.gz
    dest: /home/pp/
```


### Explication

* le fichier est copié depuis le contrôleur
* puis extrait sur la cible


## 5 — Exemple avec URL

```yaml
- name: Extraction depuis URL
  ansible.builtin.unarchive:
    src: https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
    dest: /home/pp/
    remote_src: true
```


### Explication

* téléchargement direct depuis la cible
* extraction immédiate


## 6 — Bonnes pratiques UNARCHIVE

* utiliser `creates` pour éviter les extractions multiples
* préférer `remote_src: true` pour les URLs
* contrôler les permissions
* vérifier les dépendances (tar, unzip)


## 7 — Anti-patterns UNARCHIVE

* extraire à chaque run sans contrôle
* ne pas vérifier l’existence des fichiers
* mélanger téléchargement et extraction sans logique
* ignorer les permissions


# PARTIE 2 — MODULE GET_URL


## 8 — Objectif

Le module `get_url` permet de :

* télécharger un fichier depuis une URL
* gérer son intégrité
* contrôler son stockage


## 9 — Paramètres principaux

### url

URL du fichier :

```yaml
url: https://example.com/file.tar.gz
```


### dest

Destination :

```yaml
dest: /opt/file.tar.gz
```


### mode / owner / group

Permissions du fichier téléchargé.


### checksum

Permet de vérifier l’intégrité :

```yaml
checksum: sha512:xxxx
```


### timeout

Durée maximale de téléchargement.


### headers

Permet d’ajouter des headers HTTP.


### force

Remplacer le fichier existant :

```yaml
force: true
```


### validate_certs

Validation TLS :

```yaml
validate_certs: true
```


### use_proxy

Utilisation d’un proxy.


## 10 — Exemple avec checksum

```yaml
- name: Téléchargement sécurisé
  ansible.builtin.get_url:
    url: https://downloads.apache.org/tomcat/tomcat-10/v10.0.0-M8/bin/apache-tomcat-10.0.0-M8.tar.gz
    dest: /opt/tomcat8
    mode: "0755"
    checksum: sha512:5e3dcbc56e14de73c6b866d355db8169680d093fa447e52e9a4082cc7ca363a385ac2a37a1acdc66c1945a21effe440aa06edd8a572ac6096cbe5e22ea356de4
    owner: pp
    group: pp
```


### Explication

* téléchargement du fichier
* vérification via checksum
* sécurisation du contenu


## 11 — Combinaison GET_URL + UNARCHIVE

### Workflow typique

```yaml
- name: Télécharger archive
  ansible.builtin.get_url:
    url: https://example.com/app.tar.gz
    dest: /tmp/app.tar.gz

- name: Extraire archive
  ansible.builtin.unarchive:
    src: /tmp/app.tar.gz
    dest: /opt/app/
```


### Variante optimisée

```yaml
- name: Download + extract
  ansible.builtin.unarchive:
    src: https://example.com/app.tar.gz
    dest: /opt/app/
    remote_src: true
```


## 12 — Cas d’usage typiques

* installation de Prometheus node_exporter
* déploiement de Tomcat
* installation de binaires custom
* déploiement d’applications sans apt/yum


## 13 — Bonnes pratiques

* toujours utiliser un checksum avec `get_url`
* utiliser `creates` avec `unarchive`
* séparer téléchargement et extraction si nécessaire
* gérer les permissions explicitement
* éviter les téléchargements répétés


## 14 — Anti-patterns

* télécharger sans vérifier l’intégrité
* extraire à chaque exécution
* utiliser `shell` pour wget + tar
* ignorer les erreurs réseau
* ne pas gérer les versions


## Conclusion

Les modules `get_url` et `unarchive` sont essentiels pour :

* installer des logiciels
* gérer des artefacts
* automatiser des déploiements hors package manager

Ils permettent une approche :

* propre
* idempotente
* sécurisée

Très utilisés dans les rôles d’installation applicative.
