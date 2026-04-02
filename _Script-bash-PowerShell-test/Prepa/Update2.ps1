# Définir la politique d'exécution pour permettre l'exécution de scripts (attention à la sécurité)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force

#Install-PackageProvider -Name Nuget -MinimumVersion 2.8.5.201 -force

# Supprimer la tâche planifiée ConfigNext2 si elle existe
Unregister-ScheduledTask -TaskName "ConfigNext2" -Confirm:$false -ErrorAction SilentlyContinue

# Créer une nouvelle tâche planifiée ConfigNext2 pour exécuter le script en cas de besoin
$SchTskTrigger = New-ScheduledTaskTrigger -AtLogOn
$SchTskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "C:\users\admin\Update3.ps1"
$SchTskPrincipal = New-ScheduledTaskPrincipal -UserId "admin" -LogonType ServiceAccount -RunLevel Highest
Register-ScheduledTask -TaskName "ConfigNext3" -Action $SchTskAction -Trigger $SchTskTrigger -Principal $SchTskPrincipal

# Installer le module PSWindowsUpdate s'il n'est pas déjà installé
if (-not (Get-Module -Name PSWindowsUpdate -ListAvailable)) {
    Install-Module -Name PSWindowsUpdate -Force
}

# Importer le module PSWindowsUpdate qui fournit des cmdlets pour gérer les mises à jour Windows
Import-Module PSWindowsUpdate -Force

# Vérifier s'il y a des mises à jour Windows disponibles
$updates = Get-WindowsUpdate

# Vérifier si des mises à jour sont disponibles
if ($updates.Count -gt 0) {
    Write-Host "Mises à jour disponibles :"
    $updates | ForEach-Object {
        Write-Host " - $($_.Title)"
    }

    # Installer les mises à jour disponibles
    Install-WindowsUpdate -AcceptAll -ForceInstall

    # Afficher un message de réussite une fois que les mises à jour sont installées
    Write-Host "Mises à jour installées avec succès."
} else {
    # Supprimer la tâche planifiée ConfigNext2

    # Redémarrer l'ordinateur
    Restart-Computer -Force


    Write-Host "Aucune mise à jour Windows disponible. La tâche planifiée a été supprimée (ConfigNext2) et l'ordinateur a été redémarré."
}

Restart-Computer -force