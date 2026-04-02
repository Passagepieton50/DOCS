Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Installation de Google Chrome
choco install googlechrome -y

# Installation de Mozilla Firefox
choco install firefox -y

# Installation d'Adobe Reader (Acrobat Reader)
choco install adobereader -y

# Installation de 7-Zip
choco install 7zip -y

# Installation de NPP
choco install notepadplusplus -y

#Installation de forticlientvpn
choco install forticlientvpn -y

#Installation de TV
choco install teamviewer -y
# Vous pouvez également ajouter d'autres logiciels ou personnaliser davantage votre installation ici

Write-Host "Les installations sont terminées."

# Supprimer la tâche planifiée ConfigNext2 si elle existe
Unregister-ScheduledTask -TaskName "ConfigNext4" -Confirm:$false -ErrorAction SilentlyContinue

# Créer une nouvelle tâche planifiée ConfigNext2 pour exécuter le script en cas de besoin
$SchTskTrigger = New-ScheduledTaskTrigger -AtLogOn
$SchTskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "C:\users\admin\ConfPoste.ps1"
$SchTskPrincipal = New-ScheduledTaskPrincipal -UserId "admin" -LogonType ServiceAccount -RunLevel Highest
Register-ScheduledTask -TaskName "ConfigNext5" -Action $SchTskAction -Trigger $SchTskTrigger -Principal $SchTskPrincipal

Restart-Computer -Force 
