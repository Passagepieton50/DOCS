![Ansible](../assets/images/ansible.png)

# 37 Ansible - Module HTTP / Requêtes


## Documentation

https://docs.ansible.com/ansible/2.3/uri_module.html

Commande utile :

```bash
ansible-doc ansible.builtin.uri
```


## Lab associé

[Voir le lab 37-ansible-module-http-requetes](../labs/37-ansible-module-http-requetes/)


## 1 — Introduction au module uri

### Objectif

Le module `uri` permet d’envoyer des requêtes HTTP ou HTTPS depuis Ansible.

Il permet notamment de :

* tester un endpoint
* appeler une API
* vérifier un code de retour
* envoyer des données
* récupérer une réponse
* valider un contenu retourné

C’est le module de référence pour toutes les interactions HTTP dans un playbook.


## 2 — Cas d’usage

Le module `uri` est utile pour :

* tester la disponibilité d’un site
* interagir avec une API REST
* déclencher un reload applicatif
* vérifier un endpoint de supervision
* envoyer des données JSON
* automatiser des appels authentifiés


## 3 — Paramètres principaux

### url

URL cible :

```yaml
url: https://example.org
```


### method

Méthode HTTP :

* `GET`
* `POST`
* `PUT`
* `DELETE`
* `PATCH`
* `HEAD`
* `TRACE`

Exemple :

```yaml
method: GET
```


### status_code

Code ou liste de codes considérés comme valides :

```yaml
status_code: 200
```

ou

```yaml
status_code:
  - 200
  - 201
  - 301
```


### return_content

Permet de récupérer le contenu de la réponse :

```yaml
return_content: true
```


### body

Contenu envoyé dans la requête.


### body_format

Format du corps de requête :

* `json`
* `raw`

Exemple :

```yaml
body_format: json
```


### headers

Ajout de headers HTTP :

```yaml
headers:
  Content-Type: application/json
```


### user / password

Authentification basic auth :

```yaml
user: "toto"
password: "test"
```


### force_basic_auth

Force l’envoi du basic auth dès la première requête.


### validate_certs

Validation stricte du certificat TLS :

```yaml
validate_certs: false
```


### timeout

Durée maximale de la requête :

```yaml
timeout: 10
```


### follow_redirects

Permet de suivre les redirections.


## 4 — Requête simple

```yaml
- name: Test HTTP simple
  hosts: all
  tasks:
    - name: Requête GET
      ansible.builtin.uri:
        url: http://pp.blog
        method: GET
        validate_certs: false
```


## 5 — Vérification du code de retour

```yaml
- name: Vérification du status
  hosts: all
  tasks:
    - name: Requête GET avec status attendu
      ansible.builtin.uri:
        url: http://pp.blog
        method: GET
        validate_certs: false
        status_code: 200
```


### Explication

La tâche échoue si le code HTTP retourné n’est pas `200`.


## 6 — Liste de codes de retour autorisés

```yaml
- name: Vérification de plusieurs codes
  hosts: all
  tasks:
    - name: Requête POST avec plusieurs codes autorisés
      ansible.builtin.uri:
        url: https://httpbin.org/status/500
        method: POST
        status_code:
          - 200
          - 201
          - 301
        validate_certs: false
```


### Explication

Ici, seuls les codes listés seront considérés comme valides.


## 7 — Récupération du contenu

```yaml
- name: Récupération du contenu
  hosts: all
  tasks:
    - name: Requête GET avec contenu
      ansible.builtin.uri:
        url: http://httpbin.org/get
        return_content: true
        method: GET
      register: __content

    - name: Affichage du contenu
      ansible.builtin.debug:
        var: __content.content
```


### Explication

Le contenu de la réponse est stocké dans :

```yaml
__content.content
```


## 8 — Utilisation du format JSON

```yaml
- name: Requête JSON
  hosts: all
  tasks:
    - name: Appel HTTP avec parsing JSON
      ansible.builtin.uri:
        url: https://httpbin.org/get
        method: GET
        return_content: true
        validate_certs: false
        body_format: json
      register: __body

    - name: Affichage d'une clé JSON
      ansible.builtin.debug:
        var: __body.json.url
```


### Explication

Quand la réponse est interprétée comme JSON, on peut accéder directement aux clés via :

```yaml
__body.json.<clé>
```


## 9 — Validation du contenu

```yaml
- name: Validation du contenu
  hosts: all
  tasks:
    - name: Vérification de la réponse
      ansible.builtin.uri:
        url: http://pp.blog
        return_content: true
        method: GET
        validate_certs: false
      register: __content
      failed_when: "'pp' not in __content.content"
```


### Explication

Cette tâche :

* récupère le contenu
* échoue si la chaîne `pp` n’est pas présente

C’est utile pour :

* vérifier une bannière
* tester une page de santé
* valider une réponse métier simple


## 10 — Authentification basic auth

```yaml
- name: Requête avec basic auth
  hosts: all
  tasks:
    - name: Appel protégé
      ansible.builtin.uri:
        url: https://httpbin.org/basic-auth/toto/test
        user: "toto"
        password: "test"
        method: GET
        validate_certs: false
```


## 11 — Envoi de données JSON

Exemple d’appel `POST` avec body JSON :

```yaml
- name: Envoi JSON
  hosts: all
  tasks:
    - name: Requête POST JSON
      ansible.builtin.uri:
        url: https://httpbin.org/post
        method: POST
        body_format: json
        body:
          app: monitoring
          env: production
        return_content: true
      register: __result

    - name: Affichage du retour JSON
      ansible.builtin.debug:
        var: __result.json
```


## 12 — Headers personnalisés

```yaml
- name: Requête avec headers
  hosts: all
  tasks:
    - name: Appel API avec header
      ansible.builtin.uri:
        url: https://httpbin.org/headers
        method: GET
        headers:
          X-App-Name: ansible
          X-Env: prod
        return_content: true
      register: __headers_result
```


## 13 — Cas d’usage typiques

Le module `uri` est souvent utilisé pour :

* tester un endpoint web
* appeler une API de supervision
* déclencher un reload HTTP
* récupérer un token
* vérifier une page applicative
* faire des tests post-déploiement


## 14 — Bonnes pratiques

* toujours définir `status_code` quand c’est pertinent
* utiliser `return_content` seulement si nécessaire
* stocker les résultats dans `register`
* valider le contenu avec `failed_when` si besoin
* utiliser `validate_certs: true` en production sauf contrainte spécifique
* éviter de mettre des identifiants en dur


## 15 — Anti-patterns

* utiliser `shell` avec `curl` à la place de `uri`
* désactiver TLS sans raison
* ne pas vérifier le code de retour
* supposer qu’une réponse 200 est toujours suffisante
* exposer des credentials directement dans le code


## Conclusion

Le module `uri` est l’outil standard d’Ansible pour les interactions HTTP et HTTPS.

Il permet :

* des vérifications simples
* des appels API avancés
* des validations de services
* une intégration propre dans les playbooks

Sa maîtrise est essentielle pour les usages modernes d’Ansible, notamment autour des APIs, de la supervision et des tests applicatifs.
