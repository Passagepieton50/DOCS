![Ansible](../assets/images/ansible.png)

# 22 Ansible - Module COPY


## Documentation

https://docs.ansible.com/ansible/2.5/modules/copy_module.html

Commande utile :

```bash id="3gx6sb"
ansible-doc ansible.builtin.copy
```


## Lab associé

[Voir le lab 22-ansible-module-copy](../labs/22-ansible-module-copy/)


## 1 — Introduction au module copy

### Objectif

Le module `copy` permet de copier :

* des fichiers
* des répertoires
* du contenu généré dynamiquement

Il joue un rôle proche de `scp`, mais avec les avantages d’Ansible :

* idempotence
* gestion des permissions
* validation
* intégration aux playbooks


## 2 — Paramètres principaux

### src

Chemin du fichier source.

```yaml id="6r5p5u"
src: test.txt
```

Point d’attention :

* le chemin dépend du contexte d’exécution
* dans un rôle, Ansible cherche souvent dans `files/`


### dest

Chemin du fichier destination sur la machine cible.

```yaml id="akgiem"
dest: /tmp/pp.txt
```


### owner / group

Définir le propriétaire et le groupe :

```yaml id="qw9ww7"
owner: root
group: root
```


### mode

Définir les permissions :

```yaml id="0cghuh"
mode: "0644"
```


### backup

Créer une sauvegarde datée avant remplacement :

```yaml id="79vjlwm"
backup: true
```


### force

Contrôle le remplacement si le fichier existe déjà :

```yaml id="7pnjlwm"
force: false
```


### content

Permet de copier directement du texte ou une variable sans fichier source.

```yaml id="kx2m52"
content: "Hello world"
```


### remote_src

Contrôle l’origine de la source :

* `false` : copie depuis le contrôleur
* `true` : copie depuis la machine cible


### validate

Permet de valider le fichier avant écriture définitive.

Le fichier temporaire est injecté à la place de `%s`.

```yaml id="im9sf4"
validate: /usr/bin/nginx -t -c %s
```


## 3 — Copie simple

```yaml id="k1j2ul"
tasks:
  - name: Copie simple
    ansible.builtin.copy:
      src: test.txt
      dest: /tmp/pp.txt
```


### Remarque

Il faut faire attention à la localisation de la source :

* fichier courant
* rôle
* répertoire `files/`


## 4 — Contrôle du remplacement

```yaml id="0jlwm4"
tasks:
  - name: Copie sans écrasement forcé
    ansible.builtin.copy:
      src: test.txt
      dest: /tmp/pp.txt
      force: false
```


### Explication

Si le fichier existe déjà, Ansible ne le remplace pas automatiquement si `force: false`.


## 5 — Copie récursive

### Préparation

```bash id="n7m2oh"
mkdir -p tmp/pp/{1,2,3}
```


### Tâche

```yaml id="zc4i3k"
- name: Copie récursive
  ansible.builtin.copy:
    src: tmp/
    dest: /tmp/
```


### Explication

Cette syntaxe permet de copier un répertoire complet vers la cible.


## 6 — Copie depuis la cible avec remote_src

```yaml id="y8p0q0"
- name: Déplacement local sur la cible
  ansible.builtin.copy:
    src: /home/pp
    dest: /tmp/
    remote_src: true
```


### Explication

Ici :

* la source n’est pas sur le contrôleur
* elle est déjà présente sur la machine cible


## 7 — Combinaison avec boucle

```yaml id="2e2nco"
vars:
  mesfichiers:
    - { source: "pp1.txt", destination: "/tmp/{{ ansible_hostname }}_pp1.txt", permission: "0755" }
    - { source: "pp2.txt", destination: "/home/pp/{{ ansible_hostname }}_pp2.txt", permission: "0644" }

tasks:
  - name: Copie de plusieurs fichiers
    ansible.builtin.copy:
      src: "{{ item.source }}"
      dest: "{{ item.destination }}"
      mode: "{{ item.permission }}"
    with_items: "{{ mesfichiers }}"
```


### Intérêt

Permet de :

* copier plusieurs fichiers
* personnaliser les destinations
* adapter les permissions


## 8 — Utilisation de patterns

```yaml id="4e68vz"
- name: Copie avec pattern
  ansible.builtin.copy:
    src: "{{ item }}"
    dest: /tmp/
  with_fileglob:
    - xavk*
```


### Explication

Cette approche permet de parcourir tous les fichiers correspondant à un motif.


## 9 — Copie avec backup

```yaml id="92urhm"
- name: Copie avec sauvegarde
  ansible.builtin.copy:
    src: "{{ item }}"
    dest: /tmp/
    backup: true
  with_fileglob:
    - xavk*
```


### Intérêt

En cas de modification d’un fichier existant :

* Ansible garde une copie précédente
* utile pour rollback ou audit


## 10 — Copie de contenu brut

```yaml id="8n82um"
- name: Copie de contenu généré
  ansible.builtin.copy:
    content: |
      Salut
      la team !!
      on est sur {{ ansible_hostname }}
    dest: /tmp/hello.txt
```


### Cas d’usage

* fichier simple
* message généré
* configuration très légère

Si le contenu devient complexe, il est préférable d’utiliser `template`.


## 11 — Validation avant copie

### Exemple avec nginx

```yaml id="qs3t3k"
- name: Copie du fichier nginx.conf avec validation
  ansible.builtin.copy:
    src: nginx.conf
    dest: /etc/nginx/nginx.conf
    owner: root
    group: root
    mode: "0644"
    validate: /usr/bin/nginx -t -c %s
```


### Exemple avec sudoers

```yaml id="3j9hn7"
- name: Ajout du fichier sudoers devops
  ansible.builtin.copy:
    dest: /etc/sudoers.d/devops
    content: "pp ALL=(ALL) NOPASSWD: ALL"
    owner: root
    group: root
    mode: "0400"
    validate: /usr/sbin/visudo -cf %s
  become: true
```


### Exemple volontairement invalide

```yaml id="cr2vlh"
- name: Test de validation sudoers invalide
  ansible.builtin.copy:
    dest: /etc/sudoers.d/devops
    content: "pp ALL=(ALL) AAAAA: ALL"
    owner: root
    group: root
    mode: "0400"
    validate: /usr/sbin/visudo -cf %s
  become: true
```


### Explication

Dans ce cas :

* la validation échoue
* le fichier n’est pas copié
* on évite de casser une configuration critique


## 12 — Bonnes pratiques

* utiliser le namespace complet `ansible.builtin.copy`
* définir explicitement `owner`, `group` et `mode`
* utiliser `validate` pour les fichiers sensibles
* préférer `template` si du Jinja est nécessaire
* utiliser `backup` sur les fichiers critiques
* bien comprendre le rôle de `remote_src`


## 13 — Anti-patterns

* utiliser `copy` pour des fichiers fortement templatisés
* ne pas valider un fichier système critique
* oublier les permissions
* confondre source locale et source distante
* copier des fichiers sensibles sans contrôle


## Conclusion

Le module `copy` est fondamental dans Ansible.

Il permet :

* de distribuer des fichiers
* de générer du contenu simple
* de gérer les permissions
* de sécuriser les changements avec validation

Sa maîtrise est essentielle pour construire des playbooks fiables et sûrs.
