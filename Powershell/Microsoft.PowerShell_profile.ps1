$env:PATH = "$env:PATH;C:\Users\there\Downloads\Documents\GitHub\COMP2101\Powershell"
Import-Module C:\Users\there\Documents\PowerShell\Modules\Module200414132.psm1
new-item -path alias:np -value notepad |out-null
