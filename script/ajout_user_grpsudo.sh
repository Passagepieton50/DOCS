#!/bin/bash

# Liste des adresses IP
ips=(
    "172.20.10.15"
    "172.20.10.16"
    "172.20.10.17"
    "172.20.10.18"
    "172.20.10.30"
    "172.20.10.31"
    "172.20.10.32"
    "172.20.2.25"
    "172.20.2.26"
    "172.20.3.2"
    "172.20.3.82"
    "172.20.4.60"
)

# Nom d'utilisateur et mot de passe
username="user"

# Boucle sur toutes les adresses IP
for ip in "${ips[@]}"; do
    # Se connecter à l'adresse IP avec l'utilisateur "user" et exécuter les commandes nécessaires
    ssh -o StrictHostKeyChecking=no $username@$ip << EOF
        # Ajouter les utilisateurs au groupe sudo
        sudo usermod -aG sudo admt1-tsbe@paovh.local
        sudo usermod -aG sudo admt1-rngt@paovh.local
        sudo usermod -aG sudo admt1-ccct@paovh.local
        sudo usermod -aG sudo admt1-arrt@paovh.local
        sudo usermod -aG sudo admt1-mope@paovh.local
        sudo usermod -aG sudo admt1-petr@paovh.local
	sudo usermod -aG sudo admt1-hord@paovh.local
        # Ajouter les règles NOPASSWD dans le fichier sudoers
        echo "%sudo ALL=(ALL:ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
EOF
done
