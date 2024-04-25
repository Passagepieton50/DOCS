#!/bin/bash

# Script permettant de créer des bdd à la demande des utilisateurs destinés à être heberger sur notre infrastructure.

# Variables interactives
read -p "Nom d'utilisateur de la DB : " DB_USER
read -p "Nom de la DB : " DB_NAME
DB_PASSWORD=$(pwgen -cnsBv 8 1)

# Vérifier si la base de données existe
DB_EXISTS=$(mysql -h 172.20.10.32 -P 3306 -u script -p -e "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='$DB_NAME';" | grep -o $DB_NAME)

if [ "$DB_EXISTS" ]; then
    echo "Erreur : La DB '$DB_NAME' est existante, veuillez la supprimer ou changer le nom de la bdd."
    exit 1
fi

# Vérifier si l'utilisateur existe
USER_EXISTS=$(mysql -h 172.20.10.32 -P 3306 -u script -p -e "SELECT USER FROM mysql.user WHERE USER='$DB_USER';" | grep -o $DB_USER)

if [ "$USER_EXISTS" ]; then
    echo "Erreur : L'utilisateur '$DB_USER' est existant, veuillez le supprimer ou changer le nom de l'utilisateur."
    exit 1
fi

# Commandes SQL permettant de créer la bdd
SQL_CREATE_DB="CREATE DATABASE IF NOT EXISTS $DB_NAME;"
SQL_CREATE_USER="CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
SQL_GRANT_PRIVILEGES="GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
SQL_FLUSH="FLUSH PRIVILEGES;"

# Exécution des commandes SQL
mysql -h 172.20.10.32 -P 3306 -u script -p -e "$SQL_CREATE_DB;$SQL_CREATE_USER;$SQL_GRANT_PRIVILEGES;$SQL_FLUSH"

echo "DB : $DB_NAME"
echo "Utilisateur : $DB_USER"
echo "Mot de passe de l'utilisateur : $DB_PASSWORD"
