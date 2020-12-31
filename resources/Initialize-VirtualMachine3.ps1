$dir = Split-Path $MyInvocation.MyCommand.Path
Write-Host "Script directory is $dir"
Set-Location $dir

Write-Output "PROGRESS: Downloading and installing kernel update"
Invoke-WebRequest -UseBasicParsing -Uri https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -OutFile $Env:userprofile\Downloads\kernel.msi
Start-Process $Env:userprofile\Downloads\kernel.msi -ArgumentList /quiet

Write-Output "PROGRESS: Setting default WSL version"
wsl --set-default-version 2

Write-Output "PROGRESS: Downloading and installing Ubuntu 20.04 LTS"
Invoke-WebRequest -Uri https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64-wsl.rootfs.tar.gz -OutFile $Env:userprofile\Downloads\ubuntu-20.04-focal-wsl.tar.gz -UseBasicParsing

Write-Output "PROGRESS: Importing into WSL"
mkdir c:\UbuntuFocal
wsl.exe --import UbuntuFocal C:\UbuntuFocal $Env:userprofile\Downloads\ubuntu-20.04-focal-wsl.tar.gz

Write-Output "PROGRESS: Installing other useful things"
choco install vscode -y --no-progress
choco install docker-desktop -y --no-progress
choco install microsoft-windows-terminal -y --no-progress
choco install pgadmin4 -y --no-progress

Write-Output "PROGRESS: Install Azure CLI"

Unregister-ScheduledTask -TaskName SetupVM -Confirm:$false
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; Remove-Item .\AzureCLI.msi

Write-Output "PROGRESS: About to restart to complete setup"
Start-Sleep -Seconds 5
Restart-Computer -Force