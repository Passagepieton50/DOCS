 #!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Adresse IP du serveur distant
read -p "Veuillez entrer l'utilisateur SSH: " SSH_USER
read -p "Veuillez entrer l'adresse IP ou le nom du serveur où vous souhaitez installer RSYSLOG: " RSYSLOG_SERVER_IP

# Fonction pour installer les packages nécessaires
install_packages() {
    echo "#################################################################"
    echo " INSTALLATION DES PAQUETS RSYSLOG LOGANALYZER PHP ET MARIADB <3"
    echo "#################################################################"


    ssh $SSH_USER@$RSYSLOG_SERVER_IP "dpkg -l | grep -q apache2 && echo 'Apache est déjà installé.' || sudo apt-get install -y apache2"
    ssh $SSH_USER@$RSYSLOG_SERVER_IP "dpkg -l | grep -q mariadb-server && echo 'MariaDB est déjà installé.' || sudo apt-get install -y mariadb-server"
    ssh $SSH_USER@$RSYSLOG_SERVER_IP "sudo apt-get update && sudo apt-get install php8.2 php8.2-mysql php8.2-gd rsyslog-mysql -y"
    ssh $SSH_USER@$RSYSLOG_SERVER_IP" sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32 sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 871920D1991BC93C gpg --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32 gpg --export --armor 3B4FE6ACC0B21F32 | sudo apt-key add
"



}

# Fonction pour installer rsyslog et loganalyzer sur le serveur
install_rsyslog_loganalyzer() {
    echo "#################################################################"
    echo "           INSTALLATION DE RSYSLOG ET LOGANALYZER <3"
    echo "#################################################################"

    ssh $SSH_USER@$RSYSLOG_SERVER_IP " sudo mkdir -p /srv/"
    ssh $SSH_USER@$RSYSLOG_SERVER_IP " sudo chmod 777 -R /srv/"
    ssh $SSH_USER@$RSYSLOG_SERVER_IP " sudo wget -O /srv/loganalyzer-4.1.8.tar.gz http://download.adiscon.com/loganalyzer/loganalyzer-4.1.8.tar.gz"
    ssh $SSH_USER@$RSYSLOG_SERVER_IP " sudo cd /srv/ && tar -zxvf loganalyzer-4.1.8.tar.gz"
    ssh $SSH_USER@$RSYSLOG_SERVER_IP " sudo mkdir -p /var/www/html/loganalyzer"
    ssh $SSH_USER@$RSYSLOG_SERVER_IP " sudo chmod 777 -R /var/www/html/loganalyzer"
    ssh $SSH_USER@$RSYSLOG_SERVER_IP " sudo sudo rsync -av /srv/loganalyzer-4.1.8/src/ /var/www/html/loganalyzer"
    ssh $SSH_USER@$RSYSLOG_SERVER_IP " sudo chown -R www-data:www-data /var/www/html/loganalyzer"
}


# Fonction pour configurer la base de données pour rsyslog sur le serveur
configure_rsyslog_database() {
    echo "#################################################################"
    echo "      CONFIGURATION DE LA BASE DE DONNÉES POUR RSYSLOG <3"
    echo "#################################################################"

    # Demander l'adresse IP du serveur MySQL
    read -p "Veuillez entrer l'adresse IP du serveur MySQL: " MYSQL_IP

    # Demander le nom de la base de données à créer
    read -p "Veuillez entrer le nom de la base de données à créer pour rsyslog: " DB_NAME

    # Demander le nom d'utilisateur et le mot de passe
    read -p "Veuillez entrer le nom d'utilisateur pour se connecter à la base de données: " DB_$SSH_USER
    read -sp "Veuillez entrer le mot de passe de l'utilisateur pour se connecter à la base de données: " DB_PASSWORD
    echo

    # Se connecter au serveur MySQL et créer la base de données et la table SystemEvents
    # Se connecter au serveur MySQL et créer la base de données et la table SystemEvents
    ssh $SSH_USER@$RSYSLOG_SERVER_IP "mysql -h $MYSQL_IP -u $DB_$SSH_USER -p'$DB_PASSWORD' -e \"CREATE DATABASE IF NOT EXISTS $DB_NAME; \
        USE $DB_NAME; \
        CREATE TABLE SystemEvents (
            ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
            DeviceReportedTime TIMESTAMP NOT NULL,
            Facility SMALLINT NOT NULL,
            Priority SMALLINT NOT NULL,
            FromHost VARCHAR(60) NOT NULL,
            Message TEXT,
            InfoUnitID INT,
            SysLogTag VARCHAR(60),
            TimeGenerated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            ReceivedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        );\""


    # Demander le nom d'utilisateur pour rsyslog et attribuer les droits nécessaires
    read -p "Veuillez entrer le nom d'utilisateur pour rsyslog: " RSYSLOG_$SSH_USER
    read -p "Veuillez entrer le mot de passe pour l'utilisateur rsyslog: " RSYSLOG_PASSWORD

    # Attribuer les droits nécessaires à l'utilisateur rsyslog
    ssh $SSH_USER@$RSYSLOG_SERVER_IP "mysql -h $MYSQL_IP -u $DB_$SSH_USER -p$DB_PASSWORD -e \"GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$RSYSLOG_$SSH_USER'@'%' IDENTIFIED BY '$RSYSLOG_PASSWORD'; \
        FLUSH PRIVILEGES;\""

    echo "Base de données rsyslog configurée avec succès!"
}

# Fonction pour configurer rsyslog sur le serveur
configure_rsyslog_server() {
    echo "#################################################################"
    echo "           CONFIGURATION DE RSYSLOG SUR LE SERVEUR <3"
    echo "#################################################################"

    # Décommenter les modules dans /etc/rsyslog.conf
    ssh $SSH_USER@$RSYSLOG_SERVER_IP "sudo sed -i 's/#module(load=\"imudp\")/module(load=\"imudp\")/' /etc/rsyslog.conf"
    ssh $SSH_USER@$RSYSLOG_SERVER_IP "sudo sed -i 's/#input(type=\"imudp\" port=\"514\")/input(type=\"imudp\" port=\"514\")/' /etc/rsyslog.conf"
    ssh $SSH_USER@$RSYSLOG_SERVER_IP "sudo sed -i 's/#module(load=\"imtcp\")/module(load=\"imtcp\")/' /etc/rsyslog.conf"
    ssh $SSH_USER@$RSYSLOG_SERVER_IP "sudo sed -i 's/#input(type=\"imtcp\" port=\"514\")/input(type=\"imtcp\" port=\"514\")/' /etc/rsyslog.conf"

    # Ajouter la configuration dans /etc/rsyslog.d/mysql.conf
    echo -e "module (load=\"ommysql\")\n*.* action(type=\"ommysql\" server=\"$MYSQL_IP\" db=\"$DB_NAME\" uid=\"$DB_$SSH_USER\" pwd=\"$DB_PASSWORD\")" | \
        ssh $SSH_USER@$RSYSLOG_SERVER_IP "sudo tee -a /etc/rsyslog.d/mysql.conf"
        ssh $SSH_USER@$RSYSLOG_SERVER_IP "sudo sed -i '4s/^/#/' /etc/rsyslog.d/mysql.conf"
        ssh $SSH_USER@$RSYSLOG_SERVER_IP "sudo sed -i '5s/^/#/' /etc/rsyslog.d/mysql.conf"



    # Redémarrer le service rsyslog
    ssh $SSH_USER@$RSYSLOG_SERVER_IP "sudo systemctl restart rsyslog.service"

    echo "RSYSLOG configuré avec succès!"
}
# Fonction pour installer rsyslog sur les hôtes distants
install_rsyslog_remote() {
    echo "#################################################################"
    echo "       INSTALLATION DE RSYSLOG SUR LES HÔTES DISTANTS <3"
    echo "#################################################################"

    # Initialiser la variable d'hôte
    HOST_COUNT=1

    # Boucle pour demander les adresses IP des hôtes distants
    while true; do
        read -p "ICI ERREUR JSP PQ MAIS MET UNE IP: " HOST_IP
        if [ "$HOST_IP" == "end" ]; then
            break
        else
            HOST_COUNT=$((HOST_COUNT+1))
        fi
    done

    # Définir l'adresse IP du serveur rsyslog
    read -p "Veuillez entrer l'adresse IP du serveur rsyslog: " RSYSLOG_SERVER_IP


    for ((i=1; i<$HOST_COUNT; i++)); do
        read -p "Quelle est l'adresse IP de l'hôte $i pour rsyslog? " HOST_IP
        if [ "$HOST_IP" == "end" ]; then
            break
        fi

        # Affiche l'adresse IP de l'hôte pour des fins de débogage
        echo "Adresse IP de l'hôte : $HOST_IP"

        # Se connecter à l'hôte distant et exécuter les commandes
        ssh $SSH_USER@$HOST_IP "
            sudo apt-get update && sudo apt-get install rsyslog -y &&
            sudo sed -i 's/#module(load=\"imudp\")/module(load=\"imudp\")/' /etc/rsyslog.conf &&
            sudo sed -i 's/#input(type=\"imudp\" port=\"514\")/input(type=\"imudp\" port=\"514\")/' /etc/rsyslog.conf &&
            sudo sed -i 's/#module(load=\"imtcp\")/module(load=\"imtcp\")/' /etc/rsyslog.conf &&
            sudo sed -i 's/#input(type=\"imtcp\" port=\"514\")/input(type=\"imtcp\" port=\"514\")/' /etc/rsyslog.conf &&
            echo '*.* @@$RSYSLOG_SERVER_IP:514' | sudo tee -a /etc/rsyslog.conf
        "
    done




    echo "RSYSLOG installé sur les hôtes distants avec succès!"
}

# Fonction pour configurer Loganalyzer
configure_loganalyzer() {
    echo "#################################################################"
    echo "             CONFIGURATION DE LOGANALYZER <3"
    echo "#################################################################"

    # Afficher les instructions pour configurer Loganalyzer sur http://IPSERVERRSYSLOG/LOGANALYZER
    echo "Pour configurer Loganalyzer, accédez à http://$RSYSLOG_SERVER_IP/loganalyzer"
}

# Exécuter les fonctions
install_packages
install_rsyslog_loganalyzer
configure_rsyslog_database
configure_rsyslog_server
install_rsyslog_remote
configure_loganalyzer

echo "Installation et configuration terminées avec succès!"
