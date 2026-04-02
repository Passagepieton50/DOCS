powershell -File C:\Users\admin\CreateFileConf.ps1
$SchTskTrigger = New-ScheduledTaskTrigger -AtLogOn
$SchTskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "C:\users\admin\update.ps1"
$SchTskPrincipal = New-ScheduledTaskPrincipal -UserId "admin" -LogonType ServiceAccount -RunLevel Highest
Register-ScheduledTask -TaskName ConfigNext -Action $SchTskAction -Trigger $SchTskTrigger -Principal $SchTskPrincipal
Restart-Computer -force

