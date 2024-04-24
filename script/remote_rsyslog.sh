# Lire le nom d'utilisateur SSH
read -p "Veuillez entrer le nom d'utilisateur SSH : " SSH_USER

# Fonction pour installer rsyslog sur les hôtes distants
install_rsyslog_remote() {
    echo "#################################################################"
    echo "       INSTALLATION DE RSYSLOG SUR LES HÔTES DISTANTS <3"
    echo "#################################################################"

    # Initialiser la variable d'hôte
    HOST_COUNT=1
    HOST_IPS=()

    # Boucle pour demander les adresses IP des hôtes distants
    while true; do
        read -p "Veuillez entrer l'adresse IP de l'hôte $HOST_COUNT pour rsyslog (entrez 'end' pour terminer) : " HOST_IP
        if [ "$HOST_IP" == "end" ]; then
            break
        else
            HOST_IPS+=("$HOST_IP")
            HOST_COUNT=$((HOST_COUNT+1))
        fi
    done

    # Définir l'adresse IP du serveur rsyslog
    read -p "Veuillez entrer l'adresse IP du serveur rsyslog: " RSYSLOG_SERVER_IP

    # Boucle pour exécuter les commandes sur chaque hôte
    for HOST_IP in "${HOST_IPS[@]}"; do
        # Affiche l'adresse IP de l'hôte pour des fins de débogage
        echo "Adresse IP de l'hôte : $HOST_IP"

        # Exécuter les commandes sur l'hôte actuel
        ssh "$SSH_USER@$HOST_IP" "sudo apt-get update &&
                                    sudo apt-get install rsyslog -y &&
                                    sudo sed -i 's/#module(load=\\\"imudp\\\")/module(load=\\\"imudp\\\")/' /etc/rsyslog.conf &&
                                    sudo sed -i 's/#input(type=\\\"imudp\\\" port=\\\"514\\\")/input(type=\\\"imudp\\\" port=\\\"514\\\")/' /etc/rsyslog.conf &&
                                    sudo sed -i 's/#module(load=\\\"imtcp\\\")/module(load=\\\"imtcp\\\")/' /etc/rsyslog.conf &&
                                    sudo sed -i 's/#input(type=\\\"imtcp\\\" port=\\\"514\\\")/input(type=\\\"imtcp\\\" port=\\\"514\\\")/' /etc/rsyslog.conf &&
                                    echo '*.* @@$RSYSLOG_SERVER_IP:514' | sudo tee -a /etc/rsyslog.conf"
    done

    echo "RSYSLOG installé sur les hôtes distants avec succès!"
}

# Appeler la fonction
install_rsyslog_remote
