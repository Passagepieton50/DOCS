![Ansible](../assets/images/ansible.png)

# 40 Ansible - Module SYNCHRONIZE


## Documentation

https://docs.ansible.com/ansible/2.3/synchronize_module.html


## Lab associé

[Voir le lab 40-ansible-synchronize](../labs/40-ansible-synchronize/)


## 1 — Introduction

Le module `synchronize` est un wrapper autour de **rsync**.

Il permet de :

* synchroniser des fichiers ou répertoires
* optimiser les transferts
* gérer les mises à jour différentielles
* limiter les volumes de données transférés


## 2 — Pourquoi utiliser synchronize

Comparé au module `copy` :

| Critère      | copy       | synchronize |
| ------------ | ---------- | ----------- |
| Performance  | faible     | élevée      |
| Gros volumes | non adapté | adapté      |
| Delta (diff) | non        | oui         |
| Robustesse   | moyenne    | élevée      |


### Intérêt principal

* rsync envoie uniquement les différences
* gestion des coupures réseau
* meilleure performance sur gros volumes


## 3 — Prérequis

* rsync doit être installé :

  * sur la machine Ansible
  * sur les machines cibles

```yaml
- name: Install rsync
  ansible.builtin.apt:
    name: rsync
    state: present
  become: yes
```


## 4 — Paramètres principaux

### src / dest

```yaml
src: fichier ou répertoire source
dest: destination
```


### mode

* `push` (défaut) : machine Ansible → cible
* `pull` : cible → machine Ansible


### archive

Active plusieurs options rsync :

* permissions
* timestamps
* ownership

```yaml
archive: yes
```


### recursive

Parcours des sous-répertoires :

```yaml
recursive: yes
```


### delete

Supprime les fichiers en trop côté destination :

```yaml
delete: yes
```


### compress

Compression pendant le transfert :

```yaml
compress: yes
```


### checksum

Comparaison via checksum plutôt que timestamp :

```yaml
checksum: yes
```


### owner / group / perms

Préservation des attributs :

```yaml
owner: yes
group: yes
perms: yes
```


### rsync_opts

Options supplémentaires :

```yaml
rsync_opts:
  - "--exclude=.git"
```


### partial

Conserve les fichiers partiellement transférés :

```yaml
partial: yes
```


### times

Préserve les dates :

```yaml
times: yes
```


## 5 — Exemple simple

```yaml
- name: Synchronisation simple
  hosts: all
  tasks:
    - name: Sync fichier
      ansible.builtin.synchronize:
        src: pp.txt
        dest: /tmp/pp.txt
```


## 6 — Synchronisation de répertoire

```yaml
- name: Synchronisation répertoire
  hosts: all
  tasks:
    - name: Création dossier cible
      ansible.builtin.file:
        path: /tmp/files
        state: directory

    - name: Sync répertoire
      ansible.builtin.synchronize:
        src: files/
        dest: /tmp/files
```


### Explication

* le `/` final est important
* copie le contenu du dossier et non le dossier lui-même


## 7 — Synchronisation entre deux machines distantes

```yaml
- name: Sync entre deux machines
  hosts: all
  tasks:
    - name: Installation rsync
      ansible.builtin.apt:
        name: rsync
        state: present
      become: yes

    - name: Création dossier cible
      ansible.builtin.file:
        path: /tmp/files
        state: directory

    - name: Synchronisation distante
      ansible.builtin.synchronize:
        src: /tmp/files/
        dest: /tmp/files
      delegate_to: 172.17.0.2
```


### Explication

* `delegate_to` permet d’exécuter la synchronisation depuis un autre host
* utile pour des transferts machine → machine sans passer par le contrôleur


## 8 — Mode pull

```yaml
- name: Récupération depuis cible
  hosts: all
  tasks:
    - name: Pull depuis remote
      ansible.builtin.synchronize:
        mode: pull
        src: /etc/hosts
        dest: ./hosts_backup/
```


## 9 — Exemple avancé

```yaml
- name: Synchronisation avancée
  hosts: all
  tasks:
    - name: Sync avec options
      ansible.builtin.synchronize:
        src: /data/
        dest: /backup/data/
        archive: yes
        delete: yes
        compress: yes
        rsync_opts:
          - "--exclude=*.log"
          - "--exclude=.cache"
```


## 10 — Cas d’usage typiques

* sauvegarde de données
* déploiement applicatif
* synchronisation de fichiers volumineux
* mirroring de répertoires
* copie entre serveurs


## 11 — Bonnes pratiques

* toujours utiliser `archive: yes` pour des copies complètes
* utiliser `delete` avec précaution
* vérifier le sens (`push` vs `pull`)
* tester avec des petits volumes avant production
* exclure les fichiers inutiles


## 12 — Anti-patterns

* utiliser `copy` pour de gros volumes
* oublier d’installer rsync
* utiliser `delete` sans validation
* synchroniser sans comprendre le sens du flux
* ignorer les permissions et ownership


## Conclusion

Le module `synchronize` est indispensable pour :

* les transferts volumineux
* les synchronisations fréquentes
* les environnements distribués

Il combine la puissance de rsync avec la simplicité d’Ansible, ce qui en fait un outil clé pour les infrastructures modernes.
