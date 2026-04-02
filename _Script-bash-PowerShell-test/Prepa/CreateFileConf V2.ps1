# Fonction pour afficher un message avec une couleur spécifiée
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(437)

function Write-Message {
    param (
        [string]$message,
        [string]$color
    )

    # Définir des couleurs prédéfinies
    $colors = @{
        'Red'    = 'DarkRed'
        'Yellow' = 'Yellow'
        'Green'  = 'DarkGreen'
    }

    Write-Host $message -ForegroundColor $colors[$color]

    # Ajouter le message au fichier de journal
    $logMessage = "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) - $message"
    Add-Content -Path "C:\Users\admin\script_log.txt" -Value $logMessage
}

# Fonction pour lire une réponse de l'utilisateur avec une couleur spécifiée et une validation optionnelle
function Read-Host-Colored {
    param (
        [string]$prompt,
        [string]$promptColor,
        [string]$validationRegex = $null
    )

    $colors = @{
        'Red'    = 'DarkRed'
        'Yellow' = 'Yellow'
        'Green'  = 'DarkGreen'
    }

    do {
        Write-Host $prompt -ForegroundColor $colors[$promptColor]
        $response = Read-Host
    } while ($validationRegex -and -not ($response -match $validationRegex))

    # Ajouter la question et la réponse au fichier de journal
    $logMessage = "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) - User response: $prompt - $response"
    Add-Content -Path "C:\Users\admin\script_log.txt" -Value $logMessage

    $response
}

# Validation pour une adresse IP
$ipValidationRegex = '^([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])$'

# Validation pour un masque de sous-réseau (0 à 32)
$subnetValidationRegex = '^(0|([1-2]?[0-9]?|3[0-2]))$'

# Afficher un message d'introduction en rouge
Write-Message "'''''' DEBUT DE LA CONFIGURATION DU POSTE ''''''" -color 'Red'

# Demander le nom du poste en jaune
$nomPoste = Read-Host-Colored -prompt "Entrez le nom du poste" -promptColor Yellow
# Demander le nom de l'utilisateur à créer en jaune
$nomUtilisateur = Read-Host-Colored -prompt "Entrez le nom de l'utilisateur" -promptColor Yellow
# Demander le groupe de l'utilisateur en jaune
$groupeUtilisateur = Read-Host-Colored -prompt "Entrez le nom du groupe de l'utilisateur" -promptColor Yellow

# Afficher un message pour indiquer le début de la configuration RDP en rouge
Write-Message "Debut de la configuration RDP" -color 'Red'

# Demander des informations spécifiques pour la configuration RDP en jaune
$serveurRDP = Read-Host-Colored -prompt "Quel est le nom du serveur ou l'adresse IP du bureau à distance?" -promptColor Yellow
$utilisateurRDP = Read-Host-Colored -prompt "Quel est le nom d'utilisateur pour la connexion au bureau à distance?" -promptColor Yellow
$domaineRDP = Read-Host-Colored -prompt "Quel est le domaine de l'utilisateur?" -promptColor Yellow

# Ajouter une question pour le type (OpenPro, OpenEntreprise, Rubis)
$type = Read-Host-Colored -prompt "Quel est le type de serveur ? (OpenPro/OpenEntreprise/Rubis)" -promptColor Yellow

# Afficher un message pour indiquer la fin de la configuration RDP en rouge
Write-Message "Fin de la configuration RDP" -color 'Red'

# Demander si le poste est en DHCP en jaune
$dhcp = Read-Host-Colored -prompt "Le poste est-il en DHCP ? (Oui/Non)" -promptColor Yellow

# Initialiser une variable pour stocker toutes les informations de configuration
$configAll = @{}

if ($dhcp -eq "Non") {
    # Demander la configuration réseau en jaune
    Write-Message "Debut de la configuration réseau" -color 'Red'
    $configAll += @{
        "Nom du poste"           = $nomPoste
        "Nom de l'utilisateur"   = $nomUtilisateur
        "Groupe de l'utilisateur"= $groupeUtilisateur
        "Serveur RDP"            = $serveurRDP
        "Utilisateur RDP"        = $utilisateurRDP
        "Domaine RDP"            = $domaineRDP
        "DHCP"                   = $dhcp
        "Adresse IP"             = Read-Host-Colored -prompt "Entrez l'adresse IP" -promptColor Yellow -validationRegex $ipValidationRegex
        "Masque de sous-réseau"  = Read-Host-Colored -prompt "Entrez le masque de sous-réseau (0 à 32)" -promptColor Yellow -validationRegex $subnetValidationRegex
        "Passerelle"             = $null
        "Serveur DNS Primaire"   = $null
        "Serveur DNS Secondaire" = $null
    }

    # Demander la passerelle (gateway) avec vérification
    do {
        $configAll["Passerelle"] = Read-Host-Colored -prompt "Entrez l'adresse de la passerelle (gateway)" -promptColor Yellow -validationRegex $ipValidationRegex
        if ($configAll["Passerelle"] -eq $configAll["Adresse IP"]) {
            Write-Host "L'adresse de la passerelle ne peut pas être la même que l'adresse IP. Veuillez réessayer." -ForegroundColor Yellow
            # Ajouter un message d'erreur au fichier de journal
            $logMessage = "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) - Erreur : L'adresse de la passerelle ne peut pas être la même que l'adresse IP."
            Add-Content -Path "C:\Users\admin\script_log.txt" -Value $logMessage
        }
    } while ($configAll["Passerelle"] -eq $configAll["Adresse IP"])

    # Demander les serveurs DNS avec vérification
    $configAll["Serveur DNS Primaire"]   = Read-Host-Colored -prompt "Entrez l'adresse du serveur DNS primaire" -promptColor Yellow -validationRegex $ipValidationRegex
    $configAll["Serveur DNS Secondaire"] = Read-Host-Colored -prompt "Entrez l'adresse du serveur DNS secondaire" -promptColor Yellow -validationRegex $ipValidationRegex

    Write-Message "Fin de la configuration réseau" -color 'Red'
} else {
    # Si DHCP est sélectionné, ajouter une indication DHCP au tableau
    $configAll += @{
        "Nom du poste"           = $nomPoste
        "Nom de l'utilisateur"   = $nomUtilisateur
        "Groupe de l'utilisateur"= $groupeUtilisateur
        "Serveur RDP"            = $serveurRDP
        "Utilisateur RDP"        = $utilisateurRDP
        "Domaine RDP"            = $domaineRDP
        "DHCP"                   = $dhcp
        "Adresse IP"             = "DHCP"
        "Passerelle"             = $null
        "Serveur DNS Primaire"   = $null
        "Serveur DNS Secondaire" = $null
    }
}

# Afficher un message de confirmation en rouge
Write-Message "Fichier de configuration créé avec succès : C:\Users\admin\config.txt" -color 'Red'

# Afficher un message de clôture en rouge
Write-Message "'''''' FIN DE LA CONFIGURATION DU POSTE ''''''" -color 'Red'

# Créer un fichier de configuration avec toutes les informations récupérées
$configFileContent = $configAll.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }
$configFileContent | Set-Content -Path "C:\Users\admin\config.txt" -Force -Encoding UTF8

# Créer un fichier trié avec le format spécifié
$sortedConfigFileContent = $configAll.GetEnumerator() | Sort-Object Name | ForEach-Object { "$($_.Key)=$($_.Value)" }
$sortedConfigFileContent | Set-Content -Path "C:\Users\admin\config_sorted.txt" -Force -Encoding UTF8

# Ajouter un message au fichier de journal
$logMessage = "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) - Fichier trié créé avec succès : C:\Users\admin\config_sorted.txt"
Add-Content -Path "C:\Users\admin\script_log.txt" -Value $logMessage

# Ajouter une condition pour le type de serveur
if ($type -eq "Rubis") {
    # Appeler le script Rubis ici lorsque le script sera disponible
    $logMessage = "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) - Appel du script Rubis."
    Add-Content -Path "C:\Users\admin\script_log.txt" -Value $logMessage
} else {
    # Créer un fichier RDP avec les informations de configuration RDP
    $rdpFileName = if ($type -eq "OpenPro") { "OpenPro.rdp" } else { "OpenEntreprise.rdp" }
    
    $rdpFileContent = @"
full address:s:$serveurRDP
username:s:$utilisateurR
domain:s:$domaineRDP
screen mode id:i:2
use multimon:i:0
desktopwidth:i:1920
desktopheight:i:1080
session bpp:i:32
winposstr:s:0,1,0,0,1920,1050
compression:i:1
keyboardhook:i:2
audiocapturemode:i:0
videoplaybackmode:i:1
connection type:i:7
networkautodetect:i:1
bandwidthautodetect:i:1
enableworkspacereconnect:i:0
disable wallpaper:i:0
allow font smoothing:i:0
allow desktop composition:i:0
disable full window drag:i:1
disable menu anims:i:1
disable themes:i:0
bitmapcachepersistenable:i:1
audiomode:i:0
redirectprinters:i:1
redirectcomports:i:0
redirectsmartcards:i:1
redirectclipboard:i:1
redirectposdevices:i:0
redirectdirectx:i:1
autoreconnection enabled:i:1
authentication level:i:2
prompt for credentials:i:0
negotiate security layer:i:1
remoteapplicationmode:i:0
alternate shell:s:
shell working directory:s:
gatewayhostname:s:
gatewayusagemethod:i:4
gatewaycredentialssource:i:4
gatewayprofileusagemethod:i:0
promptcredentialonce:i:1
use redirection server name:i:1
drivestoredirect:s:
"@

    # Écrire le contenu du fichier RDP dans le fichier correspondant
    $rdpFileContent | Set-Content -Path "C:\Users\admin\Desktop\$rdpFileName" -Force -Encoding UTF8
    
    # Ajouter un message au fichier de journal
    $logMessage = "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) - Fichier RDP créé avec succès : C:\Users\admin\Desktop\$rdpFileName"
    Add-Content -Path "C:\Users\admin\script_log.txt" -Value $logMessage
}
