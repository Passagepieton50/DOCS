# Demander le nom du poste
$nomPoste = Read-Host "Entrez le nom du poste"

# Demander le nom de l'utilisateur à creer
$nomUtilisateur = Read-Host "Entrez le nom de l'utilisateur"

# Demander le groupe de l'utilisateur
$groupeUtilisateur = Read-Host "Entrez le nom du groupe de l'utilisateur"

# Demander si le poste est en DHCP
$dhcp = Read-Host "Le poste est-il en DHCP ? (Oui/Non)"
$dhcp = $dhcp.ToUpper()

if ($dhcp -eq "NON") {
    # Demander la configuration reseau
    $adresseIP = Read-Host "Entrez l'adresse IP"
    $masque = Read-Host "Entrez le masque de sous-reseau"
    $passerelle = Read-Host "Entrez l'adresse de la passerelle (gateway)"
    $dnsPrimaire = Read-Host "Entrez l'adresse du serveur DNS primaire"
    $dnsSecondaire = Read-Host "Entrez l'adresse du serveur DNS secondaire"

    # Creer un objet de configuration avec les donnees saisies
    $config = @{
        "Nom du poste" = $nomPoste
        "Nom de l'utilisateur" = $nomUtilisateur
        "Groupe de l'utilisateur" = $groupeUtilisateur
        "Adresse IP" = $adresseIP
        "Masque de sous-reseau" = $masque
        "Passerelle" = $passerelle
        "Serveur DNS Primaire" = $dnsPrimaire
        "Serveur DNS Secondaire" = $dnsSecondaire
    }

    # Convertir les paires "Nom Paramètre" et "Valeur" en une seule chaîne avec le format correct
    $configString = $config.GetEnumerator() | ForEach-Object {
        $_.Key + "=" + $_.Value
    }

    # Creer un fichier de configuration en texte (config.txt) dans le repertoire de l'utilisateur "admin"
    $configString | Out-File -FilePath "C:\Users\admin\config.txt" -Force

    # Afficher un message de confirmation
    Write-Host "Fichier de configuration cree avec succes : C:\Users\admin\config.txt"
} else {
    # Si DHCP est selectionne, creer un fichier de configuration avec l'indication DHCP
    $config = @{
        "Nom du poste" = $nomPoste
        "Nom de l'utilisateur" = $nomUtilisateur
        "Groupe de l'utilisateur" = $groupeUtilisateur
        "Adresse IP" = "DHCP"
    }

    $configString = $config.GetEnumerator() | ForEach-Object {
        $_.Key + "=" + $_.Value
    }

    $configString | Out-File -FilePath "C:\Users\admin\config.txt" -Force


}


$typeinstall = Read-Host "Quel type type d'installation OpenPro, Rubis ou OpenEntreprise ?"

$config = @{
    "Type d'installation" = $typeinstall
}
$configString = $config.GetEnumerator() | ForEach-Object {
    $_.Key + "=" + $_.Value
}

$configString | Out-File -FilePath "C:\Users\admin\typeinstall.txt" -Force
    
Write-Host "Les fichiers de configurations ont ete creer"