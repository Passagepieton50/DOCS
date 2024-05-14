# Charger les donnees à partir du fichier de configuration
$configData = Get-Content -Path "C:\Users\admin\config.txt" | ForEach-Object {
    $line = $_.Trim()
    if (-not [string]::IsNullOrEmpty($line) -and $line -notlike "#*") {
        $name, $value = $line -split "=", 2
        $name = $name.Trim()
        $value = $value.Trim()
        [PSCustomObject]@{
            Name = $name
            Value = $value
        }
    }
}

# Creer un tableau associatif pour stocker les valeurs
$configuration = @{}
$interfaceAlias = "Ethernet"

# Parcourir les donnees et les stocker dans le tableau associatif
foreach ($entry in $configData) {
    $name = $entry.Name
    $value = $entry.Value

    # Utilisez le nom comme cle pour stocker la valeur
    $configuration[$name] = $value
}

# Maintenant, vous pouvez acceder aux valeurs en utilisant les noms correspondants
$nomDuPoste = $configuration["Nom du poste"]
$nomUtilisateur = $configuration["Nom de l'utilisateur"]
#$motDePasse = $configuration["Mot de passe de l'utilisateur"]
$groupeUtilisateur = $configuration["Groupe de l'utilisateur"]
$adresseIP = $configuration["Adresse IP"]
$masqueSousReseau = $configuration["Masque de sous-reseau"]
$passerelle = $configuration["Passerelle"]
$serveurDNS = $configuration["Serveur DNS Primaire"]
$serveurDNS2 = $configuration["Serveur DNS Secondaire"]
$nomDuDomaine = $configuration["Nom du domaine"]
$serveurRDP = $configuration["Serveur RDP"]

# Creez un nouvel utilisateur
New-LocalUser -Name $nomUtilisateur -NoPassword
Add-LocalGroupMember -Group 'Administrateurs' -Member $nomUtilisateur -Verbose
# Assurez-vous de specifier l'alias "Ethernet" correct
if ($adresseIP -eq "DHCP") {
    Set-NetIPInterface -interfaceAlias $interfaceAlias -Dhcp Enabled
} else {
    # Desactiver le DHCP
    Set-NetIPInterface -InterfaceAlias $interfaceAlias -Dhcp Disabled

    # Configurer l'adresse IP
    New-NetIPAddress -InterfaceAlias $interfaceAlias -IPAddress $adresseIP -PrefixLength $masqueSousReseau -DefaultGateway $passerelle

    # Definir les serveurs DNS
    Set-DnsClientServerAddress -InterfaceAlias $interfaceAlias -ServerAddresses $serveurDNS, $serveurDNS2
}

# Modifier le nom de l'ordinateur avec les informations d'identification
Rename-Computer -NewName $nomDuPoste -Force

# Désactive les mises en veille de l'ordinateur
powercfg -change -monitor-timeout-ac 0
powercfg -change -disk-timeout-ac 0
powercfg -change -standby-timeout-ac 0
powercfg -change -hibernate-timeout-ac 0

Get-WmiObject -Namespace root\wmi -Class MSPower_DeviceEnable | where {$_.InstanceName -match "PCI"} | Set-WmiInstance -Arguments @{Enable = "False"}


Write-Host "Configuration terminee avec succes."

#Restart-Computer -Force