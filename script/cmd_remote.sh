
#!/bin/bash

# Liste des adresses IP des hôtes
hosts=("172.20.2.26" "172.20.2.25" "172.20.10.30" "172.20.10.31" "172.20.10.15" "172.20.10.16" "172.20.10.17" "172.20.3.2" "172.20.4.60" "172.20.3.82")

# Nom d'utilisateur SSH
ssh_user="user"

# Itérer sur chaque adresse IP et redémarrer rsyslog
for host in "${hosts[@]}"; do
    echo "$host"
    ssh "$ssh_user@$host" "sudo apt install ufw"
done
