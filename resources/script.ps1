$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$source = "E:\Source"
Write-Host "My directory is $dir"
. "./Set-FolderIcon.ps1"
New-Item -Path "E:\" -Name "Source" -ItemType "directory"
New-Item -Path $source -Name "desktop.ini" -ItemType "file"
Set-FolderIcon -Icon "${dir}\matrix_code.ico" -Path $source

# Add Source to quick access:
$qa = New-Object -ComObject shell.application
$qa.NameSpace($source).Self.InvokeVerb("pintohome")

# Remove Videos from quick access:
($qa.Namespace("shell:::{679F85CB-0220-4080-B29B-5540CC05AAB6}").Items() | Where-Object { $_.Path -EQ "C:${env:HOMEPATH}\Videos" }).InvokeVerb("unpinfromhome")
Write-Output "Success!"
exit 0