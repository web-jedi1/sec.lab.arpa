<#
    helper functions for the environment
#>

function SEC-GeneratePassword {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Position=0)]
        [int]$Length,
        [ValidateNotNullOrEmpty()]
        [Parameter(Position=1)]
        [bool]$Secure       
    )
    if ($Length -eq $Null) {
        $Length = 64
    }
    try {
        Add-Type -Assembly System.Web
    } catch {
        $_; exit 1
    }
    if ($Secure) {
        return $(ConvertTo-SecureString $([Web.Security.Membership]::GeneratePassword($Length,4)) -AsPlainText -Force)
    } else {
        return $([Web.Security.Membership]::GeneratePassword($Length,4))
    }
}

Export-ModuleMember -Function SEC-GeneratePassword
