![Ansible](../assets/images/ansible.png)
# 08 Ansible - Inventory



## 1. Définition et rôle de l’inventory

L’inventory est l’élément central d’Ansible.

Il correspond à :

* la liste des machines
* leur organisation
* les variables associées

Il décrit l’infrastructure :

* serveurs
* rôles des serveurs
* organisation logique



### Concepts fondamentaux

Un inventory contient deux types d’objets :

* **hosts** : machines
* **groupes** : ensembles de machines



### Formats disponibles

Ansible supporte plusieurs formats :

* INI : format historique, simple mais limité
* YAML : format recommandé (lisible et structuré)
* JSON : utilisé pour les inventaires dynamiques



### Composants d’un inventory

Un inventory peut inclure :

* un fichier d’inventaire
* un répertoire `group_vars`
* un répertoire `host_vars`



## 2. Structure logique d’un inventory

### Groupe racine

Le groupe racine est toujours :

```yaml
all
```

Tous les hôtes appartiennent implicitement à ce groupe.



### Hiérarchie des groupes

Un inventory peut être structuré en :

* groupes parents
* groupes enfants
* sous-groupes



### Exemple logique

Structure souhaitée :

* parent1

  * enfant1 → srv1, srv2
  * enfant2 → srv3

    * enfant3 → srv5
  * parent1 contient aussi srv4



## 3. Format INI

Exemple :

```ini
[parent1]
srv4

[enfant1]
srv1
srv2

[enfant2]
srv3

[enfant3]
srv5

[parent1:children]
enfant1
enfant2

[enfant2:children]
enfant3
```



### Limites du format INI

* peu structuré
* difficile à maintenir
* erreurs fréquentes



## 4. Format YAML (recommandé)

### Exemple équivalent

```yaml
all:
  children:
    parent1:
      hosts:
        srv4:
      children:
        enfant1:
          hosts:
            srv1:
            srv2:
        enfant2:
          hosts:
            srv3:
          children:
            enfant3:
              hosts:
                srv5:
```



### Avantages du YAML

* structure claire
* lisibilité
* extensibilité
* compatible avec variables complexes



## 5. Appartenance multiple à des groupes

Un host peut appartenir à plusieurs groupes.

Exemple :

```yaml
all:
  children:
    parent1:
      hosts:
        srv4:
    parent2:
      hosts:
        srv4:
        srv6:
        srv7:
        srv8:
        srv9:
```

Ici :

* `srv4` appartient à **parent1 et parent2**



## 6. Utilisation des patterns

Les patterns permettent de générer plusieurs hosts rapidement.

### Exemple

```yaml
all:
  children:
    parent1:
      children:
        enfant1:
          hosts:
            srv[1:2]:
        enfant2:
          hosts:
            srv3:
          children:
            enfant3:
              hosts:
                srv5:
    parent2:
      hosts:
        srv[6:9]:
```



### Avantages

* réduction de duplication
* génération rapide
* utile en environnement homogène



## 7. Organisation réelle (approche DevOps)

### Exemple d’architecture

```yaml
all:
  children:
    common:
      children:
        webserver:
          hosts:
            srv[1:4]:
        dbserver:
          hosts:
            srv[5:6]:
        app:
          hosts:
            srv[7:10]:
        appdock:
          hosts:
            srv[11:15]

    monitoring:
      children:
        common:
```



### Lecture de cette structure

* `common` : couche partagée
* `webserver` : serveurs web (nginx)
* `dbserver` : bases de données
* `app` : applications
* `appdock` : applications dockerisées
* `monitoring` : couche transverse



### Logique DevOps

Cette organisation permet :

* séparation par rôle
* factorisation des configurations
* déploiement ciblé

Exemples :

```bash
ansible webserver -m ping
ansible dbserver -m ping
```



## 8. Bonnes pratiques

* utiliser YAML
* structurer les groupes logiquement
* éviter les inventaires plats
* séparer les rôles (web, db, app)
* utiliser des patterns intelligemment
* éviter la duplication



## 9. Anti-patterns

* tout mettre dans `all`
* ne pas utiliser de groupes
* dupliquer les hosts
* mélanger les environnements
* utiliser uniquement des IP sans abstraction



## Conclusion

L’inventory est la base de tout projet Ansible.

Une bonne conception permet :

* une automatisation claire
* une meilleure maintenabilité
* une évolutivité du projet

Un inventory mal structuré devient rapidement difficile à maintenir et à faire évoluer.
