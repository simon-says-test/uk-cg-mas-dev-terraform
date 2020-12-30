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

# Since we can't restart terminal as such, the amendment to the path variable is not respected - hardcode path to exe
$choco = "C:\ProgramData\chocolatey\bin\choco.exe"

Write-Output "PROGRESS: Test choco"
& choco

Write-Output "PROGRESS: Install git"
& $choco install git -y --no-progress

Write-Output "PROGRESS: Creating Source directory"
New-Item -Path "E:\" -Name "Source" -ItemType "directory"
$source = "E:\Source"
Set-Location $source

Write-Output "PROGRESS: Cloning repo get remaining scripts and other resources"
git clone $Env:REPO_URL "vm-setup"
Set-Location "vm-setup"
Set-Location $Env:SCRIPT_DIR

Write-Output "PROGRESS: Setting folder icon"
. "./Set-FolderIcon.ps1"
New-Item -Path $source -Name "desktop.ini" -ItemType "file"
Set-FolderIcon -Icon "${source}\vm-setup\${Env:SCRIPT_DIR}\matrix_code.ico" -Path $source

Write-Output "This is what success looks like!"
exit 0