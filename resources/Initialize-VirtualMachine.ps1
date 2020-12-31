# If updates to this script aren't been reflected when it runs, force resource recreation using:
# terraform taint azurerm_storage_blob.initialize_vm

$dir = Split-Path $MyInvocation.MyCommand.Path
Write-Host "Current directory is $dir"

Write-Output "Changing language and keyboard layout" 
Set-WinUserLanguageList -LanguageList en-GB -Force

Write-Output "Mount data disks"
. "./Mount-DataDisks.ps1"

Write-Output  "Install Chocolatey package manager"
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

Write-Output "PROGRESS: Install git"
& choco install git -y --no-progress

Write-Output "PROGRESS: Creating Source directory"
New-Item -Path "E:\" -Name "Source" -ItemType "directory"
$repo = "E:/Source/vm-setup"

Write-Output "PROGRESS: Creating scheduled task to clone repo, get remaining scripts and continue setup upon login"
$argument = "-Command &{git clone $Env:REPO_URL $repo; ./${repo}/${Env:SCRIPT_DIR}Initialize-VirtualMachine2.ps1}'"
$action = New-ScheduledTaskAction -Execute "powershell" -Argument $argument
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel Highest
$task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal
Register-ScheduledTask SetupVM -InputObject $task

Write-Output "This is what success looks like!"
exit 0