$dir = Split-Path $MyInvocation.MyCommand.Path
Write-Host "Script directory is $dir"
Set-Location $dir

Write-Output "PROGRESS: Setting folder icon"
. "./Set-FolderIcon.ps1"
New-Item -Path "E:\Source" -Name "desktop.ini" -ItemType "file"
Set-FolderIcon -Icon "${dir}\matrix_code.ico" -Path "E:\Source"

Write-Output "PROGRESS: Turn on WSL and VM Platform - needs restart"
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

Unregister-ScheduledTask -TaskName SetupVM -Confirm:$false

Write-Output "PROGRESS: Creating scheduled task to continue setup"
$argument = "-ExecutionPolicy Unrestricted -NoExit -Command & ${dir}/Initialize-VirtualMachine3.ps1}'"
$action = New-ScheduledTaskAction -Execute "powershell" -Argument $argument
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel Highest
$task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal
Register-ScheduledTask SetupVM -InputObject $task

Write-Output "PROGRESS: About to restart to complete setup"
Start-Sleep -Seconds 5
Restart-Computer