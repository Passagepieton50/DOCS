# Installation et configuration de Guacamole Apache afin de s'authentifier sur les vms

![alt text](image-1.png)

Prérequis :
- Proxmox
- Héberger sur debian
- Guacd
- MySQL
- MariaDB
- Tomcat


## Mise en place d'une VM et sur ProxMox

### Création de la machine virtuelle dans ProxMox

importez l'iso debian dans votre pool de stockage, ensuite creez votre machine virtuelle avec l'iso précédemment ajouter, choisissez le stockage, la ram, le cpu, pour le réseau cela dépend de votre configuration.

### Configuration de debian

Une fois la machine virtuelle démarré faites l'installation de debian, choisissez votre langue, votre pays, votre clavier, votre nom de machine, votre nom d'utilisateur et votre mot de passe. Pour les packages choisissez juste SSH server, standard system utilities et apache2.
Une fois l'installation terminé, connectez vous à la vm avec votre utilisateur et votre mot de passe.


### Mettre en place les configurations réseaux sur les machines virtuelles


```bash
sudo nano /etc/network/interfaces
```
Puis renseigner la configuration réseau comme ceci, attention à bien mettre une IP différente sur chaque vms :

### Mise en place du serveur Guacamole Apache.

Ensuite installer les paquets qui permettront le bon fonctionnement de Guacamole Apache. 

```bash
sudo apt-get update
sudo apt-get install build-essential libcairo2-dev libjpeg62-turbo-dev libpng-dev libtool-bin uuid-dev libossp-uuid-dev libavcodec-dev libavformat-dev libavutil-dev libswscale-dev freerdp2-dev libpango1.0-dev libssh2-1-dev libtelnet-dev libvncserver-dev libwebsockets-dev libpulse-dev libssl-dev libvorbis-dev libwebp-dev
```

Installation du serveur Guacamole Apache dans le répertoire que vous voulez.

```bash
wget https://downloads.apache.org/guacamole/1.5.2/source/guacamole-server-1.5.2.tar.gz
```
Il faudra ensuite décompresser le fichier avec la commande :

```bash
tar -xzf guacamole-server-1.5.2.tar.gz
```

Pour l'installation du serveur guacamole on a besoin de faire une compilation et donc on va d'abord vérifier les dépendances avec la commande : 

```bash
sudo ./configure --with-init-dir=/etc/init.d
```
Ce qui ressemble à ça : 

![alt text](image-2.png)

Et ensuite on va venir initialiser la compilation : 

```bash
sudo make 
sudo make install
```
Ensuite il faut mettre à jour les liens guacamole-server et les librairies avec la commande : 

```bash
sudo ldconfig
```

Puis on va lancer le service guacd (guacamole) avec les commandes 

```bash
sudo systemctl daemon-reload
sudo systemctl start guacd
sudo systemctl enable guacd
```

On peut venir maintenant vérifier que le service est lancer avec la commande :

```bash
sudo systemctl status guacd
```

![alt text](image-3.png)

Puis on va créer l'arborescence de guacamole apache en créant les fichiers/répertoire qui permettent le bon fonctionnement de Guacamole Apache.

```bash
sudo mkdir -p /etc/guacamole/{extensions,lib}
```

### Installer Guacamole Client (Web App)

Pour la Web App de Guacamole il faut utiliser Tomcat, prenez la version que vous voulez. Pour ma part j'ai pris la version Tomcat9.

Donc on va venir installer les différents paquets de tomcat : 

```bash
sudo apt-get install tomcat9 tomcat9-admin tomcat9-common tomcat9-user
```

Ensuite on va venir installer la Web App de guacamole.

```bash
wget https://downloads.apache.org/guacamole/1.5.2/binary/guacamole-1.5.2.war
```
Et ensuite on déplace le fichier dans la librairie de Web App de tomcat9 avec cette commande : 

```bash
sudo mv guacamole-1.5.2.war /var/lib/tomcat9/webapps/guacamole.war
```

On vient ensuite relancer les services guacd et tomcat9 avec la commande :

```bash
sudo systemctl restart tomcat9 guacd
```

### Installation de la base de donnée de guacamole

Dans notre infra on a décider d'externaliser toutes les bdd dans un serveur de bdd redondé. Donc la bdd de guacamole sera externalisé. 

### Serveur de base de données

Sur le serveur de base de données on va venir créer une base de donnée "guacamole" et un user "guacamole" ayant des droits sur la base de donnée guacamole.


```bash
Pour ce connecter à la bdd faite "mysql" 
```

```bash
CREATE DATABASE guacamole;
CREATE USER 'guacamole'@'IP' IDENTIFIED BY '####';
GRANT SELECT,INSERT,UPDATE,DELETE ON guacamole.* TO 'guacamole'@'IP';
FLUSH PRIVILEGES;
EXIT;
```

### VM Guacamole 

Installer le paquet mariadb-client avec la commande :

```bash
apt install mariadb-client
```

Puis on va venir créer le fichier "guacamole.properties"

```bash
sudo nano /etc/guacamole/guacamole.properties
```

Et on va venir alimenter la configuration de guacamole selon nos besoins. 

Pour la bdd il faut renseigner : 

```bash
mysql-hostname: IP BDD
mysql-port: PORT SQL
mysql-database: NOM DE LA BDD
mysql-username: USER BDD
mysql-password: PASSWORD DU USER
```

Ensuite on va venir editer la configuration de guacd pour le rendre disponible. 

```bash
sudo nano /etc/guacamole/guacd.conf
[server] 
bind_host = 0.0.0.0
bind_port = 4822
```

Ensuite pour initialiser les nouvelles configurations apportés on va venir redémarrer les services tomcat9 guacd et mariadb. 


```bash
sudo systemctl restart tomcat9 guacd mariadb
```

Vous pouvez maintenant vous rendre sur l'interface WEB à partir de l'URL : 

```bash
http://<Adresse IP>:8080/guacamole/
```
Vous arriverez sur cette page : 

![alt text](image-4.png)

Vous pouvez vous connecter avec les mots de passes par defaut "guacadmin guacadmin".

Ensuite vous pouvez configurer vos connexions, groupes ect ect via l'interface web de guacamole.

![alt text](image-5.png)

### Liaison de votre guacamole à un AD 

Dans notre infrastructure nous disposons d'un Windows Server, avec un gestionnaire d'utilisateur et un domaine. L'idée est de pouvoir ce connecter à notre guacamole avec nos comptes AD.

Pour faire ceci 