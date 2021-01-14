$dir = Split-Path $MyInvocation.MyCommand.Path
Write-Host "Script directory is $dir"
Set-Location $dir

Unregister-ScheduledTask -TaskName SetupVM -Confirm:$false

Write-Output "PROGRESS: Downloading and installing kernel update"
Invoke-WebRequest -UseBasicParsing -Uri https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -OutFile $Env:userprofile\Downloads\kernel.msi
Start-Process $Env:userprofile\Downloads\kernel.msi -ArgumentList /quiet

Write-Output "PROGRESS: Setting default WSL version"
wsl --set-default-version 2

Write-Output "PROGRESS: Downloading and installing Ubuntu 20.04 LTS"
Invoke-WebRequest -Uri https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64-wsl.rootfs.tar.gz -OutFile $Env:userprofile\Downloads\ubuntu-20.04-focal-wsl.tar.gz -UseBasicParsing

# Slightly dodgy way of getting drive letter as sometimes is E, sometimes F
$drive = Get-PSDrive -PSProvider FileSystem | Select-Object -Last 1 | Select-Object -ExpandProperty "Name"

Write-Output "PROGRESS: Importing into WSL"
mkdir "${drive}:\UbuntuFocal"
wsl.exe --import UbuntuFocal "${drive}:\UbuntuFocal" $Env:userprofile\Downloads\ubuntu-20.04-focal-wsl.tar.gz

Write-Output "PROGRESS: Setting up WSL user"
bash -c "adduser wsl"
bash -c "usermod -aG sudo wsl"

# Standard way to set default user doesn't work when importing so let's hack the registry 
Function WSL-SetDefaultUser ($distro, $user) { 
    Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName | 
    Where-Object -Property DistributionName -eq $distro | 
    Set-ItemProperty -Name DefaultUid -Value ((wsl -d $distro -u $user -e id -u) | 
    Out-String); };
WSL-SetDefaultUser UbuntuFocal wsl

Write-Output "PROGRESS: Mapping WSL to Windows drive"
. New-PSDrive -Persist -Name "U" -PSProvider "FileSystem" -Root "\\wsl$\UbuntuFocal"

Write-Output "PROGRESS: Installing other useful things"
choco install vscode -y
choco install docker-desktop -y
choco install microsoft-windows-terminal -y

Write-Output "PROGRESS: Allowing user to select to install optional things"
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Data Entry Form'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Use Ctrl and click to select what you want to install:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.Listbox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,20)

$listBox.SelectionMode = 'MultiExtended'

$hash = @{
  "PG Admin 4" = "choco install pgadmin4 -y"
  "Chrome"     = "choco install googlechrome -y"
  "Firefox"    = "choco install firefox -y"
  "Azure CLI"  = "Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; Remove-Item .\AzureCLI.msi"
 }

$hash.Keys | ForEach-Object { [void] $listBox.Items.Add($_) }


$listBox.Height = 70
$form.Controls.Add($listBox)
$form.Topmost = $true

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $x = $listBox.SelectedItems
    $x | ForEach-Object { 
        Invoke-Expression "Write-Output 'PROGRESS: Installing {$_}'" 
        Invoke-Expression $hash[$_] 
    }
}

Write-Output "PROGRESS: Setup complete"
