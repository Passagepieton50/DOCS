![Ansible](../assets/images/ansible.png)
# 07 Ansible - Module CLI



## 1. Introduction aux modules Ansible

### Qu’est-ce qu’un module

Un module est une unité d’exécution dans Ansible.

Chaque module réalise une action spécifique :

* installer un paquet
* gérer un fichier
* démarrer un service
* interagir avec une API

Ansible envoie le module sur la machine distante, l’exécute, puis récupère le résultat.



### Fonctionnement des modules

Lors de l’exécution :

1. Ansible se connecte à la machine
2. envoie le module (temporaire)
3. exécute le module
4. supprime le module
5. récupère le résultat JSON

Ce fonctionnement explique :

* l’absence d’agent
* le besoin de Python sur la cible
* le comportement idempotent



## 2. Utilisation des modules en CLI

### Syntaxe générale

```bash
ansible <pattern> -m <module> -a "<arguments>"
```

Exemple :

```bash id="x8k3pn"
ansible all -m ansible.builtin.ping
```



### Passage d’arguments

```bash id="u3y7lb"
ansible all -m ansible.builtin.apt -a "name=nginx state=present" --become
```



### Format clé=valeur

Arguments classiques :

```bash id="n7q2fw"
name=nginx state=present
```



### Format JSON (plus avancé)

```bash id="v9d5zk"
ansible all -m copy -a '{"src": "file.txt", "dest": "/tmp/file.txt"}'
```



## 3. Types de modules

### Modules système

* `apt`
* `yum`
* `package`



### Modules fichiers

* `copy`
* `template`
* `file`



### Modules services

* `systemd`
* `service`



### Modules réseau / API

* `uri`
* modules cloud (AWS, Azure)



### Modules utilitaires

* `command`
* `shell`
* `debug`



## 4. Modules built-in et collections

### Modules natifs

Ansible fournit des modules intégrés :

```bash id="d4g9qk"
ansible-doc -l
```



### Utilisation recommandée

Toujours utiliser le namespace complet :

```bash id="w2k6je"
ansible.builtin.apt
```

Avantages :

* explicite
* évite les conflits
* compatible avec les collections



### Documentation des modules

```bash id="t7z1rm"
ansible-doc ansible.builtin.apt
```

Permet de voir :

* paramètres
* exemples
* comportement



## 5. Résultat des modules

### Structure de sortie

Les modules retournent un JSON contenant :

* `changed`
* `failed`
* `stdout`
* `stderr`

Exemple :

```json id="j2m8xp"
{
  "changed": false,
  "stdout": "",
  "stderr": ""
}
```



### Interprétation

* `changed: true` → modification effectuée
* `changed: false` → rien à faire
* `failed: true` → erreur



## 6. Bon usage des modules

### Privilégier les modules natifs

```bash
ansible all -m apt -a "name=nginx state=present"
```



### Éviter shell et command

```bash
ansible all -m shell -a "apt install -y nginx"
```

À éviter sauf cas spécifique.



### Utiliser des modules idempotents

Les modules sont conçus pour :

* éviter les actions inutiles
* garantir la cohérence



## 7. Debug avec les modules

### Module debug

```bash id="z6p1xt"
ansible all -m debug -a "msg='hello world'"
```



### Affichage de variables

```bash id="u9k3rb"
ansible all -m debug -a "var=ansible_hostname"
```



### Mode verbose

```bash id="k8x1pm"
ansible all -m ping -vvv
```



## 8. Bonnes pratiques

* utiliser les modules officiels
* utiliser les namespaces complets
* lire la documentation (`ansible-doc`)
* éviter les commandes shell
* comprendre les retours (`changed`, `failed`)
* tester en CLI avant playbook



## 9. Anti-patterns

* utiliser `shell` pour tout
* ignorer les modules existants
* ne pas vérifier les retours
* ne pas documenter les usages
* copier/coller sans comprendre



## Conclusion

Les modules sont le cœur d’Ansible.

Une bonne maîtrise permet :

* des playbooks propres
* une automatisation fiable
* une meilleure maintenabilité

Comprendre leur fonctionnement est essentiel pour passer d’un usage basique à une utilisation professionnelle d’Ansible.
