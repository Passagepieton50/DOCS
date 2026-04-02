![Ansible](../assets/images/ansible.png)

# 10 Ansible - Inventory commande



## 1. Introduction à ansible-inventory

La commande `ansible-inventory` permet d’inspecter et de comprendre comment Ansible interprète un inventory.

Elle permet de :

* visualiser les groupes
* voir les hosts
* afficher les variables
* vérifier la structure réelle

C’est un outil essentiel pour :

* debug
* validation
* compréhension d’un inventory complexe



## 2. Afficher tout l’inventaire en JSON

### Principe

L’option `--list` affiche l’inventory complet :

* groupes
* hosts
* variables

Le format par défaut est JSON.



### Arborescence

```bash
.
└── 00_inventory.yml
```



### Configuration

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
ansible-inventory -i 00_inventory.yml --list
```



### Résultat

```json
{
  "_meta": {
    "hostvars": {
      "node2": { "var1": "webserver" },
      "node3": { "var1": "webserver" },
      "node4": { "var1": "dbserver" },
      "node5": { "var1": "node5" }
    }
  }
}
```



## 3. Afficher l’inventaire en YAML

### Principe

L’option `--yaml` affiche le même contenu dans un format plus lisible.



### Commande

```bash
ansible-inventory -i 00_inventory.yml --yaml
```



### Résultat

```yaml
all:
  children:
    common:
      children:
        webserver:
          hosts:
            node2:
              var1: webserver
            node3:
              var1: webserver
        dbserver:
          hosts:
            node4:
              var1: dbserver
            node5:
              var1: node5
```



### Intérêt

* plus lisible que JSON
* adapté à l’analyse humaine



## 4. Affichage compact avec --export

### Principe

L’option `--export` simplifie la sortie :

* moins de détails internes
* structure plus propre



### Commande

```bash
ansible-inventory -i 00_inventory.yml --list --export
```



### Résultat

```json
{
  "webserver": {
    "hosts": ["node2", "node3"],
    "vars": { "var1": "webserver" }
  }
}
```



### Intérêt

* export
* audit rapide
* compréhension simplifiée



## 5. Afficher l’arbre des groupes

### Principe

L’option `--graph` affiche la hiérarchie :

* groupes
* sous-groupes
* hosts



### Commande

```bash
ansible-inventory -i 00_inventory.yml --graph
```



### Résultat

```text
@all:
  |--@common:
  |  |--@webserver:
  |  |  |--node2
  |  |  |--node3
  |  |--@dbserver:
  |  |  |--node4
  |  |  |--node5
```



### Intérêt

* visualiser la structure
* comprendre les relations



## 6. Afficher l’arbre avec les variables

### Principe

Ajout de `--vars` :

* affiche les variables associées



### Commande

```bash
ansible-inventory -i 00_inventory.yml --graph --vars
```



### Résultat

```text
@webserver:
  |--{var1 = webserver}
  |--node2
  |--node3
```



### Intérêt

* comprendre la propagation des variables
* debug des conflits



## 7. Exporter l’inventaire vers un fichier

### Principe

L’option `--output` permet d’écrire dans un fichier.



### Commande

```bash
ansible-inventory -i 00_inventory.yml --list --output inventory_export.json
```



### Résultat

Fichier créé :

```text
inventory_export.json
```



### Intérêt

* sauvegarde
* audit
* intégration dans d’autres outils



## 8. Formats alternatifs (exemple TOML)

### Principe

Ansible peut exporter dans d’autres formats.



### Commandes

```bash
pip3 install toml
ansible-inventory -i 00_inventory.yml --toml
```



### Résultat

```toml
[webserver]
hosts = ["node2", "node3"]
```



### Intérêt

* interopérabilité
* intégration avec d’autres outils



## 9. Visualisation avancée avec grapher

Dépôt : https://github.com/willthames/ansible-inventory-grapher

### Principe

Utiliser un outil externe pour générer un vrai diagramme.



### Commandes

```bash
pip3 install ansible-inventory-grapher
sudo apt install graphviz

ansible-inventory-grapher -i inventory.yml all | dot -Tpng | display png:-
```



### Résultat

* génération d’un schéma graphique
* représentation complète de l’inventory



### Intérêt

* documentation
* présentation
* compréhension globale



## 10. Commandes essentielles

```bash
ansible-inventory -i inventory.yml --list
ansible-inventory -i inventory.yml --yaml
ansible-inventory -i inventory.yml --graph
ansible-inventory -i inventory.yml --graph --vars
ansible-inventory -i inventory.yml --list --export
```



## 11. Bonnes pratiques

* toujours vérifier un inventory avec `--list`
* utiliser `--graph` pour comprendre la structure
* utiliser `--vars` pour debug les variables
* exporter pour audit
* valider avant exécution en production



## 12. Anti-patterns

* ne pas vérifier son inventory
* ignorer les conflits de variables
* travailler sans visualisation
* utiliser un inventory complexe sans validation



## Conclusion

La commande `ansible-inventory` est indispensable pour :

* comprendre l’état réel de l’inventory
* diagnostiquer les problèmes
* valider les configurations

Elle doit être utilisée systématiquement lors du développement et du debug.
