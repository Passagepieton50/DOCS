![Ansible](../assets/images/ansible.png)

# 39 Ansible - Variables d’environnement et prompt


## Documentation

https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_environment.html


## Lab associé

[Voir le lab 39-ansible-env-et-prompt](../labs/39-ansible-env-et-prompt/)


## 1 — Introduction

Ansible permet :

* de définir des variables d’environnement
* d’interagir avec l’utilisateur via des prompts

Ces mécanismes sont utiles pour :

* adapter dynamiquement un playbook
* injecter des valeurs runtime
* gérer différents environnements (dev, stage, prod)


## 2 — Variables d’environnement

### Objectif

Les variables d’environnement permettent de :

* passer des valeurs aux commandes exécutées
* influencer le comportement des outils CLI
* standardiser certaines configurations


## 3 — Définition dans un playbook

```yaml
- name: Exemple variables d’environnement
  hosts: all
  environment:
    PATHLIB: "/var/lib/"

  tasks:
    - name: Echo variable
      ansible.builtin.shell: echo $PATHLIB
      register: __output

    - name: Affichage
      ansible.builtin.debug:
        var: __output
```


### Explication

* la variable est définie au niveau du play
* elle est disponible dans toutes les tâches


## 4 — Définition au niveau d’une tâche

```yaml
- name: Variable environnement par tâche
  hosts: all
  tasks:
    - name: Echo variable
      ansible.builtin.shell: echo $PATHLIB
      environment:
        PATHLIB: "/tmp/"
      register: __output
```


### Explication

* portée limitée à la tâche
* écrase les variables du play si conflit


## 5 — vars_prompt

### Objectif

`vars_prompt` permet de demander une valeur à l’utilisateur au moment de l’exécution.


## 6 — Exemple simple

```yaml
- name: Prompt utilisateur
  hosts: all

  vars_prompt:
    - name: nom

  tasks:
    - name: Echo nom
      ansible.builtin.shell: "echo Salut {{ nom }}"
      register: __output

    - name: Affichage
      ansible.builtin.debug:
        var: __output
```


### Explication

* Ansible demande une valeur pour `nom`
* la valeur est ensuite utilisable dans le playbook


## 7 — Prompt avec message et valeur par défaut

```yaml
- name: Prompt avec défaut
  hosts: all

  vars_prompt:
    - name: env
      prompt: "Quel est votre environnement ? prod/stage/dev"
      default: dev

  environment:
    ENV: "{{ env }}"

  tasks:
    - name: Echo environnement
      ansible.builtin.shell: "echo Salut $ENV"
      register: __output

    - name: Affichage
      ansible.builtin.debug:
        var: __output
```


### Explication

* un message est affiché
* une valeur par défaut est proposée
* la valeur est injectée dans une variable d’environnement


## 8 — Variables d’environnement côté machine Ansible

On peut récupérer une variable d’environnement locale (machine contrôleur) avec `lookup`.

```yaml
- name: Lecture variable environnement locale
  hosts: all
  tasks:
    - name: Echo ENV local
      ansible.builtin.shell: "echo {{ lookup('env', 'ENV') | default('stage', true) }}"
      register: __output

    - name: Affichage
      ansible.builtin.debug:
        var: __output
```


### Explication

* `lookup('env', 'ENV')` récupère la variable côté contrôleur
* `default('stage', true)` définit une valeur par défaut si absente


## 9 — Cas d’usage typiques

* choisir un environnement (dev / prod)
* injecter des variables dynamiques
* passer des credentials temporaires
* adapter un comportement runtime
* interagir avec l’utilisateur


## 10 — Bonnes pratiques

* utiliser `vars_prompt` pour les valeurs sensibles ou dynamiques
* définir des valeurs par défaut
* limiter l’usage des variables d’environnement aux besoins réels
* documenter les variables attendues
* éviter les dépendances implicites


## 11 — Anti-patterns

* utiliser des variables d’environnement sans les documenter
* dépendre d’un prompt dans des pipelines automatisés
* exposer des informations sensibles en clair
* multiplier les sources de variables
* ne pas gérer les valeurs par défaut


## Conclusion

Les variables d’environnement et les prompts permettent :

* une meilleure flexibilité
* une adaptation dynamique des playbooks
* une interaction utilisateur simple

Bien utilisés, ils permettent de rendre les déploiements plus souples tout en gardant une bonne maîtrise de la configuration.
