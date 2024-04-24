#!/bin/bash

# Liste des adresses IP des machines virtuelles
hosts=(172.20.3.2)

# Fonction pour exécuter des commandes sur les machines virtuelles via SSH
function run_remote_command {
    sshpass -p 'user' ssh -o StrictHostKeyChecking=no user@$1 "$2"
}

# Installer les packages nécessaires sur les machines virtuelles
for host in "${hosts[@]}"
do
    run_remote_command $host "sudo apt update && sudo apt install -y sssd adcli realm krb5-user sssd-tools sssd libnss-sss libpam-sss adcli"
    
    # Configurer les fichiers sur les machines virtuelles
    run_remote_command $host "sudo bash -c 'cat << EOF > /etc/sssd/sssd.conf
[sssd]
domains = paovh.local
config_file_version = 2
services = nss, pac, pam, ssh

[domain/paovh.local]
default_shell = /bin/bash
krb5_store_password_if_offline = False
cache_credentials = False
krb5_realm = PAOVH.LOCAL
realmd_tags = manages-system joined-with-adcli
id_provider = ad
auth_provider = ad
access_provider = ad
chpass_provider = ad
fallback_homedir = /home/%d/%u
ad_domain = paovh.local
use_fully_qualified_names = True
ldap_id_mapping = True
ldap_user_extra_attrs = altSecurityIdentities:altSecurityIdentities
ldap_user_ssh_public_key = altSecurityIdentities
ldap_use_tokengroups = True
ad_gpo_access_control = disabled
EOF
'"
    # Définir les droits sur sssd.conf
    run_remote_command $host "sudo chmod 600 /etc/sssd/sssd.conf"
    
    run_remote_command $host "sudo bash -c 'cat << EOF > /etc/krb5.conf
[libdefaults]
    default_realm = PAOVH.LOCAL
    dns_lookup_realm = false
    dns_lookup_kdc = false
    renew_lifetime = 1d
    rdns = false

[realms]
    PAOVH.LOCAL = {
        admin_server = AD1.VM.DSI.paovh.local
        kdc = AD1.VM.DSI.paovh.local
    }

[domain_realm]
    .paovh.local = PAOVH.LOCAL

[logging]
    default = SYSLOG
EOF
'"
    # Définir les droits sur krb5.conf
    run_remote_command $host "sudo chmod 644 /etc/krb5.conf"

    # Ajouter les lignes spécifiées à la fin de /etc/ssh/sshd_config
    run_remote_command $host "sudo sed -i '\$aAuthorizedKeysCommand /usr/bin/sss_ssh_authorizedkeys' /etc/ssh/sshd_config"
    run_remote_command $host "sudo sed -i '\$aAuthorizedKeysCommandUser root' /etc/ssh/sshd_config"
    run_remote_command $host "sudo sed -i '\$aHostkeyAlgorithms +ssh-rsa,ssh-dss' /etc/ssh/sshd_config"
    run_remote_command $host "sudo sed -i '\$aPubkeyAcceptedAlgorithms +ssh-rsa' /etc/ssh/sshd_config"

    # Ajouter la ligne spécifiée à la fin de /etc/pam.d/common-session
    run_remote_command $host "sudo sed -i '\$asession required        pam_mkhomedir.so skel=\/etc\/skel\/ umask=0022' /etc/pam.d/common-session"
done
