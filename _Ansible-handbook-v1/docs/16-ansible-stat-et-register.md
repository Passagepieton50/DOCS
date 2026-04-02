![Ansible](../assets/images/ansible.png)

# 16 Ansible - Register - Stat


## Documentation

https://docs.ansible.com/ansible/latest/collections/ansible/builtin/stat_module.html

Commande utile :

```bash
ansible-doc ansible.builtin.stat
```


## Lab associé

[Voir le lab 16-ansible-stat-et-register](../labs/16-ansible-stat-et-register/)


## 1 — Introduction au module stat

### Objectif

Le module `stat` permet d’inspecter un fichier ou un répertoire sur une machine cible.

Il permet notamment de vérifier :

* l’existence
* le type
* les permissions
* le propriétaire
* la checksum
* le type MIME

C’est un module très utile pour :

* faire des vérifications avant action
* conditionner l’exécution d’une tâche
* construire une logique de contrôle dans un playbook


## 2 — Paramètres principaux

### path

Chemin du fichier ou du répertoire à inspecter :

```yaml
path: /tmp/pp.txt
```


### follow

Permet de suivre les liens symboliques :

```yaml
follow: true
```


### get_checksum

Permet de récupérer la checksum du fichier :

```yaml
get_checksum: true
```


### checksum_algorithm

Permet de choisir l’algorithme de hash :

```yaml
checksum_algorithm: sha256
```


### get_mime

Permet de récupérer le type MIME :

```yaml
get_mime: true
```


## 3 — Création d’un fichier

Avant d’utiliser `stat`, on peut créer un fichier de test.

```yaml
- name: Création d'un fichier
  ansible.builtin.file:
    path: /tmp/pp.txt
    state: touch
    owner: pp
```


## 4 — Utilisation simple de stat

```yaml
- name: Vérification avec stat
  ansible.builtin.stat:
    path: /tmp/pp.txt
```

Cette tâche récupère les informations sur le fichier, mais ne les stocke pas encore dans une variable réutilisable.


## 5 — Utilisation de register

### Principe

Le mot-clé `register` permet de stocker le résultat d’une tâche dans une variable.

```yaml
- name: Vérification avec stat
  ansible.builtin.stat:
    path: /tmp/pp.txt
  register: __fichier_pp
```


### Affichage du contenu

```yaml
- name: Affichage du retour complet
  ansible.builtin.debug:
    var: __fichier_pp
```


### Intérêt

`register` permet de :

* récupérer les données retournées par un module
* les afficher pour debug
* les réutiliser dans des conditions


## 6 — Accès à une clé précise

Le module `stat` retourne une structure contenant plusieurs informations.

Pour vérifier si le fichier existe :

```yaml
- name: Vérification de l'existence
  ansible.builtin.debug:
    var: __fichier_pp.stat.exists
```

Autres clés fréquemment utiles :

* `__fichier_pp.stat.exists`
* `__fichier_pp.stat.isdir`
* `__fichier_pp.stat.islnk`
* `__fichier_pp.stat.pw_name`
* `__fichier_pp.stat.mode`


## 7 — Utilisation conditionnelle avec when

Le résultat de `stat` peut être utilisé dans une condition.

```yaml
- name: Création du répertoire pp
  ansible.builtin.file:
    path: /tmp/pp
    state: directory
  when: __fichier_pp.stat.exists
```

Ici, le répertoire n’est créé que si le fichier `/tmp/pp.txt` existe.


## 8 — Exemple complet

```yaml
tasks:
  - name: Création d'un fichier
    ansible.builtin.file:
      path: /tmp/pp.txt
      state: touch
      owner: root
    when: pp_file is defined

  - name: Vérification avec stat
    ansible.builtin.stat:
      path: /tmp/pp.txt
    register: __fichier_pp

  - name: Affichage de l'existence du fichier
    ansible.builtin.debug:
      var: __fichier_pp.stat.exists

  - name: Création du répertoire pp
    ansible.builtin.file:
      path: /tmp/pp
      state: directory
    when: __fichier_pp.stat.exists and pp_file is defined
```


## 9 — Logique de fonctionnement

Dans cet exemple :

1. un fichier est créé seulement si `pp_file` est défini
2. `stat` vérifie ensuite si ce fichier existe
3. `debug` affiche le résultat
4. un répertoire est créé uniquement si :

   * le fichier existe
   * et `pp_file` est défini

Ce schéma est très courant dans les playbooks réels.


## 10 — Cas d’usage fréquents

Le couple `stat` + `register` est très utile pour :

* vérifier si un fichier de configuration existe
* contrôler la présence d’un binaire
* éviter un téléchargement inutile
* lancer une action seulement si une ressource est présente
* vérifier l’état d’un lien symbolique
* contrôler les permissions avant correction


## 11 — Bonnes pratiques

* utiliser `register` avec un nom explicite
* debugger d’abord le retour complet si besoin
* utiliser ensuite une clé précise
* éviter les conditions trop complexes sans debug préalable
* utiliser `stat` avant les opérations sensibles


## 12 — Anti-patterns

* tester l’existence d’un fichier avec `shell` ou `command`
* utiliser une variable `register` mal nommée
* écrire des `when` complexes sans avoir inspecté le retour
* supposer qu’un fichier existe sans vérification


## Conclusion

Le module `stat` permet d’inspecter l’état réel du système.

Associé à `register`, il devient un outil central pour :

* contrôler l’exécution
* fiabiliser les playbooks
* introduire une logique conditionnelle propre

La maîtrise de `stat` et `register` est essentielle pour écrire des automatisations Ansible robustes et maintenables.
