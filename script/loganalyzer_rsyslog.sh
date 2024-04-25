
#Script permettant d'installer loganalyzer et d'afficher les logs de rsyslog

install_rsyslog_loganalyzer() {
    echo "#################################################################"
    echo "           INSTALLATION DE RSYSLOG ET LOGANALYZER <3"
    echo "#################################################################"

read -p "Veuillez entrer l'utilisateur SSH: " SSH_USER
read -p "Veuillez entrer l'adresse IP ou le nom du serveur où vous souhaitez installer RSYSLOG: " RSYSLOG_SERVER_IP


    ssh $SSH_USER@$RSYSLOG_SERVER_IP "sudo mkdir -p /srv/ &&
                                      sudo chmod 777 -R /srv/ &&
                                      sudo wget -O /srv/loganalyzer-4.1.13.tar.gz http://download.adiscon.com/loganalyzer/loganalyzer-4.1.13.tar.gz &&
                                      sudo tar -zxvf /srv/loganalyzer-4.1.13.tar.gz -C /srv/ &&
                                      sudo mkdir -p /var/www/html/loganalyzer &&
                                      sudo chmod 777 -R /var/www/html/loganalyzer &&
                                      sudo rsync -av /srv/loganalyzer-4.1.13/src/ /var/www/html/loganalyzer &&
                                      sudo chown -R www-data:www-data /var/www/html/loganalyzer"
}
install_rsyslog_loganalyzer
