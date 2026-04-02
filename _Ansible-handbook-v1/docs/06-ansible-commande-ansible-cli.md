![Ansible](../assets/images/ansible.png)

# 06 Ansible - Commande ansible CLI



## 1. Introduction aux commandes Ansible

### Qu’est-ce que la commande ansible

La commande `ansible` permet d’exécuter des actions ponctuelles sur un ou plusieurs hôtes, sans utiliser de playbook.

On parle de **commandes ad-hoc**.

Usage typique :

* test de connectivité
* exécution rapide d’une commande
* debug
* opérations simples



### Syntaxe générale

```bash
ansible <pattern> -m <module> -a "<arguments>"
```

* `<pattern>` : groupe ou hôte cible
* `-m` : module utilisé
* `-a` : arguments du module



## 2. Commandes de base

### Test de connectivité

```bash
ansible all -m ping
```

Permet de vérifier :

* accès SSH
* fonctionnement d’Ansible
* disponibilité des hôtes



### Exécution d’une commande

```bash
ansible all -m command -a "uptime"
```



### Utilisation du module shell

```bash
ansible all -m shell -a "echo hello"
```

Différence :

* `command` : sécurisé, sans shell
* `shell` : permet pipes, redirections



### Gestion des paquets

```bash
ansible all -m ansible.builtin.apt -a "name=nginx state=present" --become
```



### Gestion des fichiers

```bash
ansible all -m copy -a "src=./file.txt dest=/tmp/file.txt"
```



## 3. Ciblage des hôtes

### Utilisation des groupes

```bash
ansible webservers -m ping
```



### Ciblage spécifique

```bash
ansible node1 -m ping
```



### Combinaison de groupes

```bash
ansible "webservers:dbservers" -m ping
```



### Exclusion

```bash
ansible "all:!node1" -m ping
```



## 4. Gestion des privilèges

### Exécution avec sudo

```bash
ansible all -m apt -a "name=nginx state=present" --become
```



### Demande de mot de passe

```bash
ansible all -m ping --ask-become-pass
```



## 5. Gestion des variables

### Variables inline

```bash
ansible all -m shell -a "echo {{ var }}" -e "var=hello"
```



### Variables depuis fichier

```bash
ansible all -m shell -a "echo {{ var }}" -e "@vars.yml"
```



## 6. Options utiles

### Mode verbose

```bash
ansible all -m ping -vvv
```

Permet :

* debug avancé
* analyse des connexions SSH



### Limiter le nombre d’hôtes

```bash
ansible all -m ping --limit node1
```



### Spécifier un inventory

```bash
ansible all -m ping -i inventory.yml
```



### Exécution parallèle

```bash
ansible all -m ping -f 20
```

* `-f` : nombre de forks



## 7. Bonnes pratiques

* utiliser les commandes ad-hoc pour :

  * debug
  * tests rapides
* ne pas remplacer les playbooks
* privilégier les modules natifs
* éviter `shell` si possible
* tester avant exécution en production



## 8. Anti-patterns

* automatiser via commandes ad-hoc répétées
* utiliser `shell` pour tout
* exécuter sans contrôle sur `all`
* ne pas utiliser `--limit`



## 9. Cas d’usage réels

### Vérifier tous les serveurs

```bash
ansible all -m ping
```



### Redémarrer un service

```bash
ansible webservers -m systemd -a "name=nginx state=restarted" --become
```



### Vérifier l’espace disque

```bash
ansible all -m command -a "df -h"
```



### Copier un fichier

```bash
ansible all -m copy -a "src=./config.conf dest=/etc/config.conf" --become
```



## Conclusion

La commande `ansible` est un outil puissant pour :

* le debug
* les actions rapides
* les opérations ponctuelles

Cependant, elle doit rester complémentaire aux playbooks, qui restent la méthode principale pour des automatisations structurées et maintenables.
