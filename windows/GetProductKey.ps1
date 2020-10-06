
# Select from SLS
Write-Output "From SoftwareLicensingService:"
(Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey
Write-Output ""

# From registry
Write-Output "From registry:"
function Get-ProductKey {
    [cmdletbinding()]
    Param (
        [parameter(ValueFromPipeLine = $true, ValueFromPipeLineByPropertyName = $true)]
        [Alias("IPAddress", "Server")]
        [string[]]$Computername = $env:COMPUTERNAME
    )
    Begin {   
        $map = "BCDFGHJKMPQRTVWXY2346789" 
    }
    Process {
        foreach ($Computer in $Computername) {
            if (!(Test-Connection -ComputerName $Computer -Count 1 -Quiet)) {
                Write-Warning "Computer $Computer is unreachable"
                continue
            }
            # try and determine if this is a 64 or 32 bit machine
            try {
                $OS = Get-WmiObject -ComputerName $Computer -Class Win32_OperatingSystem -ErrorAction Stop                
            } 
            catch {
                Write-Warning "Could not retrieve OS version from computer $Computer"
                continue
            }
            # try and read the registry
            try {
                $remoteReg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine,$Computer)
                $valueName = if ([int]($OS.OSArchitecture -replace '\D') -eq 64) { 'DigitalProductId4' } else { 'DigitalProductId' }
                $value = $remoteReg.OpenSubKey("SOFTWARE\Microsoft\Windows NT\CurrentVersion").GetValue($valueName)[0x34..0x42]
                $productKey = for ($i = 24; $i -ge 0; $i--) { 
                    $k = 0 
                    for ($j = 14; $j -ge 0; $j--) { 
                        $k = ($k * 256) -bxor $value[$j] 
                        $value[$j] = [math]::Floor([double]($k/24)) 
                        $k = $k % 24 
                    }
                    # output one character to collect in the $productKey array
                    $map[$k]
                    # output a hyphen
                    if (($i % 5) -eq 0 -and $i -ne 0) { "-" } 
                }
                # reverse the array
                [array]::Reverse($productKey)
                # output the ProductKey as string
                $productKey -join ''
            } 
            catch {
                Write-Warning "Could not read registry from computer $Computer"
            }        
            finally {
                if ($remoteReg) { $remoteReg.Close() }
            }
        } 
    }
}

Get-ProductKey
Write-Output ""
