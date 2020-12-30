# If updates to this script aren't been reflected when it runs, force resource recreation using:
# terraform taint azurerm_storage_blob.initialize_vm

$dir = Split-Path $MyInvocation.MyCommand.Path
Write-Host "Current directory is $dir"

# Change language and keyboard layout
Set-WinUserLanguageList -LanguageList en-GB -Force

# Mount data disks
. "./Mount-DataDisks.ps1"

# Install Chocolatey package manager
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Since we can't restart terminal as such, the amendment to the path variable is not respected - hardcode path to exe
$choco = "C:\ProgramData\chocolatey\bin\choco.exe"
& $choco
& $choco install git -y --no-progress
Write-Output "Installed git?"
git --version

# Clone script repo to get remaining scripts and other resources
New-Item -Path "E:\" -Name "Source" -ItemType "directory"
$source = "E:\Source"
Set-Location $source
git clone $Env:REPO_URL "vm-setup"
Set-Location "vm-setup"
Set-Location $Env:SCRIPT_DIR

. "./Set-FolderIcon.ps1"
New-Item -Path $source -Name "desktop.ini" -ItemType "file"
Set-FolderIcon -Icon "${dir}\matrix_code.ico" -Path $source

# Add Source to quick access:
$qa = New-Object -ComObject shell.application
$qa.NameSpace($source).Self.InvokeVerb("pintohome")

# Remove Videos from quick access:
($qa.Namespace("shell:::{679F85CB-0220-4080-B29B-5540CC05AAB6}").Items() | Where-Object { $_.Path -EQ "C:${env:HOMEPATH}\Videos" }).InvokeVerb("unpinfromhome")
Write-Output "Success!"
exit 0