<#
Contains common functions for specialized init scripts
#>


function Write-Log {
    param(
        [CmdletBinding()]
        [ValidateNotNullOrEmpty()]
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True)]
        [string]$Message,
        [ValidateNotNullOrEmpty()]
        [Parameter(Position=2, Mandatory=$True)]
        [string]$Level,
        [ValidateNotNullOrEmpty()]
        [Parameter(Position=3, Mandatory=$True)]
        [string]$Logfile = "C:\Windows\temp\sec_lab_arpa.log"     
    )
    switch ($Level) {
        "OK" | 0 { $Sign = "+" }
        "WARN" | 1 { $Sign = "!" }
        "ERROR" | 2 { $Sign = "-" }
        default { $Sign = "?" }
    }
    "[$([DateTime]::Now)] - [$Sign] - $Message" | Out-File $Logfile -Append
}

function Generate-Chaos {
    <#
        Function to randomly generate vulnerabilities in the domain
    #>
    return 0
}

Export-ModuleMember -Function Generate-Chaos