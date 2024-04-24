#!/bin/bash

# Liste des adresses IP des hôtes
hosts=("172.20.10.18")

# Nom d'utilisateur SSH
ssh_user="user"
#Install zabbix agent2 on all computer
for host in "${hosts[@]}"; do
    echo "Install zabbix on $host"
    ssh "$ssh_user@$host" "sudo wget https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/zabbix-release_6.4-1+debian12_all.deb && sudo dpkg -i zabbix-release_6.4-1+debian12_all.deb && sudo apt update && sudo apt upgrade -y && sudo apt install zabbix-agent2 zabbix-agent2-plugin-* && sudo sed -i 's/ServerActive=127.0.0.1/ServerActive=172.20.4.60/g' /etc/zabbix/zabbix_agent2.conf && sudo sed -i 's/Server=127.0.0.1/Server=172.20.4.60/g' /etc/zabbix/zabbix_agent2.conf && sudo sed -i 's/# HostMetadataItem=/HostMetadataItem = system.uname/g' /etc/zabbix/zabbix_agent2.conf  && sudo sed -i 's/Hostname=Zabbix server/#Hostname=Zabbix server/g' /etc/zabbix/zabbix_agent2.conf && sudo sed -i 's/# HostnameItem=system.hostname/HostnameItem=system.hostname/g' /etc/zabbix/zabbix_agent2.conf  && sudo systemctl restart zabbix-agent2 && sudo systemctl enable zabbix-agent2"

done
