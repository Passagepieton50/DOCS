
#!/bin/bash

# Liste des adresses IP des hôtes
hosts=("172.20.2.21" "172.20.2.22" "172.20.2.23" "172.20.2.24" "172.20.10.30" "172.20.10.31" "172.20.10.15" "172.20.10.16" "172.20.10.17")

# Nom d'utilisateur SSH
ssh_user="user"

# Itérer sur chaque adresse IP et redémarrer rsyslog
for host in "${hosts[@]}"; do
    echo "Redémarrage de rsyslog sur $host"
    ssh "$ssh_user@$host" "ip a"
done
