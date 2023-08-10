function Get-SystemHardware {
"_______________HARDWARE_______________"
    Get-WmiObject Win32_ComputerSystem | Select-Object description
}

function Get-OperatingSystem {
"____________OperatingSystem____________"
    $operatingSystem = Get-WmiObject Win32_OperatingSystem | Select-Object Caption, Version
    $operatingSystem | Format-list
}

function Get-Processor {
"_______________Processor_______________"
    Get-CIMInstance cim_processor | Select-Object Name, MaxClockSpeed, NumberOfCores, L2CacheSize, L3CacheSize | Format-list
}

function Get-RAM {
"__________________RAM__________________"
    $totalcapacity = 0
    get-wmiobject win32_physicalmemory |
    foreach {new-object -TypeName psobject -Property @{
    Manufacturer = $_.manufacturer
    Description = $_.Description
    "Speed" = $_.speed
    "Size" = $_.capacity/1mb
    Bank = $_.banklabel
    Slot = $_.devicelocator
    }
    $totalcapacity += $_.capacity/1mb
    } |
    format-table -AutoSize Manufacturer,Description, "Size", "Speed", Bank, Slot
    "Total RAM: ${totalcapacity}MB "
}

function Get-DiskDrive {
"_________________DISKDRIVES_________________"
    $diskDrives = Get-CIMInstance CIM_diskdrive

    foreach ($disk in $diskDrives) {
        $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
        foreach ($partition in $partitions) {
            $logicalDisks = $partition | Get-CimAssociatedInstance -ResultClassName CIM_LogicalDisk
            foreach ($logicalDisk in $logicalDisks) {
                New-object -typename psobject -property @{
                    Manufacturer = $disk.Manufacturer
                    Location = $partition.DeviceID
                    Drive = $logicalDisk.DeviceID
                    Size_GB = ($logicalDisk.Size / 1GB)
                    FreeSpace_GB = ($logicalDisk.FreeSpace / 1GB)
                    PercentFree = (($logicalDisk.FreeSpace / $logicalDisk.Size) * 100)
                }
            }
        }
    }
}

function Get-NetworkAdapter {
"_______________NetworkAdapter_______________"
    $networkadapters = get-ciminstance win32_networkadapterconfiguration | Where-Object ipenabled
    $networkadapters | Select-Object Description,index,ipaddress,ipsubnet,dnsdomain,DNSServerSearchOrder |  format-table -AutoSize -Wrap
}

function Get-GPU {
"_________________VIDEOCARD_________________"
    $GPU = Get-WmiObject Win32_VideoController | Select-Object AdapterCompatibility, Description, CurrentHorizontalResolution, CurrentVerticalResolution
    $GPU | ForEach-Object {
        if ($_.AdapterCompatibility -eq $null) {
            $_.AdapterCompatibility = "N/a"
        }
        if ($_.Description -eq $null) {
            $_.Description = "N/a"
        }
        if ($_.CurrentHorizontalResolution -eq $null) {
            $_.CurrentHorizontalResolution = "N/a"
        }
        if ($_.CurrentVerticalResolution -eq $null) {
            $_.CurrentVerticalResolution = "N/a"
        }
        $_  
    } | Format-List
}

    
    Get-SystemHardware | Format-list
    
    Get-OperatingSystem

    Get-Processor

    Get-RAM | Format-Table -AutoSize

    Get-DiskDrive | Format-Table -AutoSize

    Get-NetworkAdapter

    Get-GPU

