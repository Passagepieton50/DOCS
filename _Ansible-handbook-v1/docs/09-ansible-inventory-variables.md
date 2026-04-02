![Ansible](../assets/images/ansible.png)

# 09 Ansible - Inventory variables

Documentation : 

https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html

## 1. Introduction aux variables d’inventaire

Les variables d’inventaire permettent de définir des valeurs associées :

* à un groupe
* à un hôte
* à l’ensemble de l’infrastructure

Elles permettent :

* d’éviter les valeurs en dur
* d’adapter les configurations selon les environnements
* de factoriser les déploiements



## 2. Principe de précédence des variables

### Notion de priorité

Dans Ansible, plusieurs variables peuvent définir la même clé.

La valeur finale dépend d’un système de priorité appelé **précedence**.



### Test avec extra vars

Les variables passées avec `-e` ont la priorité la plus élevée.

#### Commande

```bash
ansible -i "node2," all -b -e "var1=pp" -m debug -a "msg={{ var1 }}"
```



#### Résultat

```json
node2 | SUCCESS => {
    "msg": "pp"
}
```



### Conclusion

Une variable définie avec `-e` écrase toutes les autres :

* inventory
* group_vars
* host_vars



## 3. Variables dans le fichier d’inventaire

### Principe

Les variables peuvent être définies directement dans le fichier d’inventory.



### Exemple

```yaml
all:
  children:
    common:
      children:
        webserver:
          hosts:
            node2:
            node3:
          vars:
            var1: "webserver"

        dbserver:
          hosts:
            node4:
            node5:
              var1: "node5"
          vars:
            var1: "dbserver"

    monitoring:
      children:
        webserver:
        dbserver:
```



### Commande

```bash
ansible -i inventory.yml all -m debug -a "msg={{ var1 }}"
```



### Résultat

```json
node2 => webserver
node3 => webserver
node4 => dbserver
node5 => node5
```



### Règle

* une variable définie au niveau groupe s’applique à tous les hosts
* une variable définie au niveau host écrase celle du groupe



## 4. Variables avec group_vars

### Principe

Les variables peuvent être externalisées dans un répertoire `group_vars/`.

Chaque fichier correspond à un groupe.



### Arborescence

```bash
.
├── inventory.yml
└── group_vars/
    ├── webserver.yml
    └── dbserver.yml
```



### Configuration

```yaml
# group_vars/webserver.yml
var1: "gp_webserver"
```

```yaml
# group_vars/dbserver.yml
var1: "gp_dbserver"
```



### Résultat

```json
node2 => gp_webserver
node3 => gp_webserver
node4 => gp_dbserver
node5 => gp_dbserver
```



### Avantages

* meilleure organisation
* séparation des responsabilités
* facilité de maintenance



## 5. Variables avec host_vars

### Principe

Les variables définies dans `host_vars/` sont spécifiques à une machine.

Elles ont une priorité plus élevée que celles définies dans `group_vars`.



### Arborescence

```bash
.
├── inventory.yml
├── group_vars/
│   ├── webserver.yml
│   └── dbserver.yml
└── host_vars/
    ├── node2.yml
    └── node5.yml
```



### Configuration

```yaml
# host_vars/node2.yml
var1: "host_node2"
```

```yaml
# host_vars/node5.yml
var1: "host_node5"
```



### Résultat

```json
node2 => host_node2
node3 => gp_webserver
node4 => gp_dbserver
node5 => host_node5
```



### Règle

* host_vars > group_vars



## 6. Variables globales avec group_vars/all

### Principe

Un host qui n’appartient qu’au groupe `all` récupère les variables définies dans :

```bash
group_vars/all.yml
```



### Exemple

```yaml
# group_vars/all.yml
var1: "gp_all"
```



### Cas d’usage

Host sans groupe spécifique :

```yaml
monitoring:
  hosts:
    node6:
```



### Résultat

```json
node6 => gp_all
```



## 7. Résumé de la précédence

Ordre de priorité (du plus faible au plus fort) :

```text
group_vars/all
↓
group_vars/groupe
↓
host_vars/host
↓
extra vars (-e)
```



## 8. Bonnes pratiques

* centraliser les variables dans `group_vars`
* utiliser `host_vars` uniquement pour des cas spécifiques
* éviter les variables en dur dans les playbooks
* nommer clairement les variables
* documenter les variables importantes



## 9. Anti-patterns

* définir les variables partout (confusion)
* dupliquer les variables
* utiliser excessivement `-e` en production
* mélanger logique et configuration
* ne pas comprendre la précédence



## Conclusion

La gestion des variables est un élément clé dans Ansible.

Une bonne maîtrise permet :

* des playbooks plus propres
* une meilleure maintenabilité
* une configuration flexible et évolutive

La compréhension de la précédence est indispensable pour éviter des comportements inattendus.
