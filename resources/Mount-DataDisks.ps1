# If updates to this script aren't been reflected when it runs, update the resource names (in storage.tf) to force recreation

$disks = Get-Disk | Where-Object partitionstyle -eq 'raw' | Sort-Object number

$letters = 70..89 | ForEach-Object { [char]$_ }
$count = 0

foreach ($disk in $disks) {
    $driveLetter = $letters[$count].ToString()
    $count++
    $disk | 
        Initialize-Disk -PartitionStyle MBR -PassThru |
        New-Partition -UseMaximumSize -DriveLetter $driveLetter |
        Format-Volume -FileSystem NTFS -NewFileSystemLabel "Data${count}" -Confirm:$false
    Write-Host "Disk mounted as ${driveLetter}:"
}
