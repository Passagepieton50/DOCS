![Ansible](../assets/images/ansible.png)

# 24 Ansible - Module TEMPLATE


## Documentation

https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html

Commande utile :

```bash id="gx9l2m"
ansible-doc ansible.builtin.template
```


## Lab associé

[Voir le lab 24-ansible-module-template](../labs/24-ansible-module-template/)


## 1 — Introduction au module template

### Objectif

Le module `template` permet de générer un fichier à partir d’un modèle Jinja2.

Il est utilisé pour :

* produire des fichiers de configuration
* injecter des variables
* adapter le contenu à l’hôte ou à l’environnement
* factoriser des fichiers similaires


### Différence avec copy

* `copy` : envoie un fichier tel quel
* `template` : génère le fichier avant de l’envoyer

Le module `template` est donc adapté quand le contenu dépend :

* de variables
* d’un environnement
* d’une liste
* d’une logique Jinja2


## 2 — Paramètres principaux

### src

Chemin du template source :

```yaml id="3l1gik"
src: montemplate.txt.j2
```

Point d’attention :

* en rôle, Ansible cherche souvent dans `templates/`
* hors rôle, le chemin dépend du contexte du playbook


### dest

Chemin du fichier généré sur la machine cible :

```yaml id="uwq7k9"
dest: /tmp/hello.txt
```


### owner / group

Définir le propriétaire et le groupe :

```yaml id="gip5hv"
owner: pp
group: pp
```


### mode

Définir les permissions :

```yaml id="z76jm3"
mode: "0755"
```


### backup

Créer une sauvegarde avant modification :

```yaml id="gk1vt1"
backup: true
```


### validate

Valider le fichier avant remplacement définitif :

```yaml id="alr44k"
validate: /usr/bin/nginx -t -c %s
```


### force

Contrôle l’écrasement du fichier destination :

```yaml id="01886m"
force: true
```


### trim_blocks / lstrip_blocks

Permettent d’ajuster le rendu des blocs Jinja2 :

```jinja2 id="bnwzi9"
#jinja2:lstrip_blocks: True
```

Utiles pour contrôler :

* l’indentation
* les espaces
* les retours à la ligne


### variable_start_string / variable_end_string

Permettent de changer les délimiteurs des variables si nécessaire.


### block_start_string / block_end_string

Permettent de changer les délimiteurs des blocs Jinja2.


## 3 — Exemple simple

### Playbook

```yaml id="rbew09"
- name: Préparation locale
  hosts: all
  vars:
    var1: "pp !!!"
  tasks:
    - name: Génération du fichier
      ansible.builtin.template:
        src: montemplate.txt.j2
        dest: /tmp/hello.txt
```


### Template

```jinja2 id="e89hvb"
Hello {{ var1 }}
```


### Explication

Le fichier final généré sur la cible contiendra :

```text id="kus2un"
Hello pp !!!
```


## 4 — Variables utiles dans un template

Ansible met à disposition plusieurs variables utiles dans les templates :

* `ansible_managed`
* `template_host`
* `template_uid`
* `template_path`
* `template_fullpath`
* `template_run_date`


### Exemple d’en-tête

```jinja2 id="hzzmn8"
#{{ template_run_date }} - "{{ ansible_managed }}" via {{ template_uid }}@{{ template_host }}
```


### Intérêt

Cela permet :

* de documenter le fichier généré
* d’indiquer son origine
* de faciliter l’audit


## 5 — Gestion des permissions

```yaml id="nw58lx"
- name: Génération avec permissions
  ansible.builtin.template:
    src: montemplate.txt.j2
    dest: /tmp/hello.txt
    owner: pp
    group: pp
    mode: "0755"
```


## 6 — Sauvegarde avant modification

```yaml id="jlwmwu"
- name: Génération avec backup
  ansible.builtin.template:
    src: montemplate.txt.j2
    dest: /tmp/hello.txt
    owner: pp
    group: pp
    mode: "0755"
    backup: true
```


### Intérêt

Permet de conserver l’ancienne version du fichier avant remplacement.


## 7 — Génération d’un fichier par itération

### Playbook

```yaml id="48jlwm"
vars:
  var1: "pp !!!"
  var2:
    - { nom: "pp", age: "40" }
    - { nom: "paul", age: "22" }
    - { nom: "pierre", age: "25" }

tasks:
  - name: Génération d'un fichier par personne
    ansible.builtin.template:
      src: montemplate.txt.j2
      dest: "/tmp/hello_{{ item.nom }}.txt"
    with_items: "{{ var2 }}"
```


### Template

```jinja2 id="9niwk3"
#{{ template_run_date }} - "{{ ansible_managed }}" via {{ template_uid }}@{{ template_host }}
Hello {{ var1 }}
je suis {{ item.nom }}
j'ai {{ item.age }}
```


### Explication

Chaque itération produit un fichier distinct :

* `/tmp/hello_pp.txt`
* `/tmp/hello_paul.txt`
* `/tmp/hello_pierre.txt`


## 8 — Itération directement dans le template

### Playbook

```yaml id="j7k8a0"
vars:
  var1: "pp !!!"
  var2:
    - { nom: "pp", age: "40" }
    - { nom: "paul", age: "22" }
    - { nom: "pierre", age: "25" }

tasks:
  - name: Génération d'un fichier unique
    ansible.builtin.template:
      src: montemplate.txt.j2
      dest: /tmp/hello_all.txt
```


### Template

```jinja2 id="ss4uhn"
#{{ template_run_date }} - "{{ ansible_managed }}" via {{ template_uid }}@{{ template_host }}
Hello {{ var1 }}
{% for personne in var2 %}
je suis {{ personne.nom }}
j'ai {{ personne.age }}
{% endfor %}
```


### Explication

Ici, un seul fichier est généré contenant l’ensemble des données.


## 9 — Cas d’usage typiques

Le module `template` est particulièrement adapté pour :

* fichiers Nginx
* fichiers systemd
* fichiers de configuration applicative
* fichiers de monitoring
* scripts générés avec variables


## 10 — Validation avant déploiement

Comme avec `copy`, il est possible de valider un template avant écriture finale.

### Exemple

```yaml id="6vx9n7"
- name: Déploiement du fichier nginx avec validation
  ansible.builtin.template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
    owner: root
    group: root
    mode: "0644"
    validate: /usr/bin/nginx -t -c %s
```


### Intérêt

Permet d’éviter de déployer une configuration invalide.


## 11 — Bonnes pratiques

* utiliser `template` dès qu’un fichier dépend de variables
* garder les templates lisibles
* limiter la logique complexe dans Jinja2
* définir explicitement les permissions
* utiliser `validate` pour les fichiers critiques
* ajouter un en-tête avec `ansible_managed`


## 12 — Anti-patterns

* utiliser `copy` pour un fichier dynamique
* mettre trop de logique métier dans le template
* produire des templates difficilement lisibles
* ne pas valider une configuration critique
* mélanger fortement logique Ansible et logique Jinja2


## Conclusion

Le module `template` est l’un des modules les plus importants d’Ansible.

Il permet de :

* générer des fichiers dynamiques
* factoriser les configurations
* adapter le contenu à chaque hôte ou environnement

Sa maîtrise est essentielle pour produire des déploiements maintenables, lisibles et fiables.
