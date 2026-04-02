![Ansible](../assets/images/ansible.png)

# 05 Ansible - Fichier cfg, configuration et tuning

Documentation : 

https://docs.ansible.com/ansible/2.3/intro_configuration.html

https://www.blog-libre.org/2019/05/11/loption-controlmaster-de-ssh_config/

https://mitogen.networkgenomics.com/ansible_detailed.html

## 1. Introduction au fichier ansible.cfg

### Rôle du fichier de configuration

Le fichier `ansible.cfg` permet de définir le comportement global d’Ansible :

* gestion des connexions
* paramètres SSH
* performance
* chemins par défaut
* options d’exécution

Il permet de standardiser l’environnement d’exécution dans un projet.



### Ordre de priorité des configurations

Ansible charge la configuration selon cet ordre :

1. variable d’environnement `ANSIBLE_CONFIG`
2. fichier local `./ansible.cfg`
3. fichier utilisateur `~/.ansible.cfg`
4. fichier global `/etc/ansible/ansible.cfg`

Bonne pratique :

* utiliser un `ansible.cfg` au niveau du projet



## 2. Configuration minimale recommandée

Exemple de configuration de base :

```ini id="r2k9vx"
[defaults]
inventory = ./inventory
remote_user = ubuntu
host_key_checking = False
retry_files_enabled = False
stdout_callback = yaml

[ssh_connection]
pipelining = True
```



### Explication des paramètres

* `inventory` : chemin vers l’inventory
* `remote_user` : utilisateur SSH par défaut
* `host_key_checking` : désactive la validation interactive SSH
* `retry_files_enabled` : désactive les fichiers `.retry`
* `stdout_callback` : améliore la lisibilité des sorties
* `pipelining` : optimise les connexions SSH



## 3. Paramètres importants

### Gestion des connexions

```ini id="d3h7qp"
[defaults]
timeout = 30
forks = 10
```

* `timeout` : délai de connexion SSH
* `forks` : nombre de connexions parallèles

Bonne pratique :

* adapter `forks` selon l’infrastructure



### Optimisation SSH

```ini id="w9m2ts"
[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s
pipelining = True
```

Avantages :

* connexions persistantes
* réduction du temps d’exécution



### Gestion des logs

```ini id="g5k1xz"
[defaults]
log_path = ./ansible.log
```

Permet :

* traçabilité
* audit des exécutions



### Gestion des privilèges

```ini id="p4z8qn"
[privilege_escalation]
become = True
become_method = sudo
become_user = root
```



## 4. Configuration avancée

### Désactivation de gather_facts par défaut

```ini id="y6f2kr"
[defaults]
gathering = explicit
```

Permet :

* gain de performance
* contrôle des faits collectés



### Gestion des callbacks

```ini id="t3j9vd"
[defaults]
stdout_callback = yaml
bin_ansible_callbacks = True
```

Permet :

* sortie plus lisible
* debug facilité



### Gestion des erreurs

```ini id="q8c4lw"
[defaults]
retry_files_enabled = False
```

Évite la génération de fichiers inutiles.



## 5. Performance et tuning

### Ajustement des forks

```ini id="v1p7nb"
forks = 20
```

Impact :

* plus de parallélisme
* plus de charge CPU



### Activation du pipelining

```ini id="s9m3xe"
pipelining = True
```

Réduit :

* nombre de connexions SSH
* latence



### Désactivation du host key checking

```ini id="k7x2fa"
host_key_checking = False
```

Attention :

* améliore l’automatisation
* réduit la sécurité



## 6. Bonnes pratiques

* versionner le fichier `ansible.cfg`
* utiliser une configuration projet
* activer pipelining
* ajuster les forks
* centraliser les paramètres
* documenter les choix



## 7. Anti-patterns

* utiliser la configuration globale système
* ne pas maîtriser les forks
* désactiver la sécurité sans justification
* ne pas versionner la configuration
* dupliquer les paramètres dans plusieurs fichiers



## 8. Exemple de configuration production

```ini id="b8k2vn"
[defaults]
inventory = ./inventory
remote_user = ubuntu
timeout = 30
forks = 20
host_key_checking = False
retry_files_enabled = False
stdout_callback = yaml
log_path = ./ansible.log
gathering = explicit

[ssh_connection]
pipelining = True
ssh_args = -o ControlMaster=auto -o ControlPersist=60s

[privilege_escalation]
become = True
become_method = sudo
become_user = root
```



## Conclusion

Le fichier `ansible.cfg` est un élément central de l’écosystème Ansible.

Une bonne configuration permet :

* d’améliorer les performances
* de standardiser les exécutions
* de sécuriser les opérations
* de faciliter le debugging

Un mauvais paramétrage peut entraîner :

* des lenteurs
* des erreurs difficiles à diagnostiquer
* des comportements incohérents

La maîtrise de ce fichier est essentielle pour une utilisation avancée d’Ansible.
