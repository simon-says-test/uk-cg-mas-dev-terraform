$dir = Split-Path $MyInvocation.MyCommand.Path
Write-Host "Script directory is $dir"

Write-Output "PROGRESS: Setting folder icon"
#. "./Set-FolderIcon.ps1"
#New-Item -Path $source -Name "desktop.ini" -ItemType "file"
#Set-FolderIcon -Icon "${source}\vm-setup\${Env:SCRIPT_DIR}\matrix_code.ico" -Path $source

Unregister-ScheduledTask -TaskName SetupVM -Confirm:$false