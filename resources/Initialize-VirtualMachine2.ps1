$dir = Split-Path $MyInvocation.MyCommand.Path
Write-Host "Script directory is $dir"
Set-Location $dir

# Slightly dodgy way of getting drive letter as sometimes is E, sometimes F
$drive = Get-PSDrive -PSProvider FileSystem | Select-Object -Last 1 | Select-Object -ExpandProperty "Name"
Write-Output "PROGRESS: Creating Source directory"
New-Item -Path "${drive}:\" -Name "Source" -ItemType "directory"

Write-Output "PROGRESS: Setting folder icon"
Copy-Item "${dir}\matrix_code.ico" "${Env:userprofile}\Pictures\matrix_code.ico"
. "./Set-FolderIcon.ps1"
New-Item -Path "${drive}:\Source" -Name "desktop.ini" -ItemType "file"
Set-FolderIcon -Icon "${Env:userprofile}\Pictures\matrix_code.ico" -Path "${drive}:\Source"

Write-Output "PROGRESS: Turning on WSL and VM Platform - needs restart"
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

Unregister-ScheduledTask -TaskName SetupVM -Confirm:$false

Write-Output "PROGRESS: Creating scheduled task to continue setup"
$argument = "-ExecutionPolicy Unrestricted -NoExit -Command & {${dir}\Initialize-VirtualMachine3.ps1}"
$action = New-ScheduledTaskAction -Execute "powershell" -Argument $argument
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel Highest
$task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal
Register-ScheduledTask SetupVM -InputObject $task

Write-Output "PROGRESS: Expiring password"
$user = "WinNT:\\" + [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$usr=[ADSI] $user 
$usr.passwordExpired = 1  
$usr.setinfo()

Write-Output "PROGRESS: About to restart to complete setup"
Write-Host 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
Start-Sleep -Seconds 3
Restart-Computer -Force