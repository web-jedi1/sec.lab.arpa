<#
    creates a user, can also reset 
#>

function SEC-CreateUser {
    [CmdletBinding()]
    param(
        [ValidatePattern('^[a-zA-Z-\$]+$')]
        [Parameter(Position=0,Mandatory=$True)]
        [string]$UserName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Position=1,Mandatory=$True)]
        [string]$Token,
        [ValidateNotNullOrEmpty()]
        [Parameter(Position=2)]
        [bool]$ResetUser = $True,
        [ValidateNotNullOrEmpty()]
        [Parameter(Position=3)]
        [string]$Endpoint = "https://vault.lab.arpa:8200"
    )

    try {
        Import-Module SECHashiVault
        Import-Module SECSecEnvHelpers
        Import-Module SECActiveDirectory
    } catch {
        $_; exit 1
    }

    $Path = "/v1/kv/data/sec-lab-arpa/$UserName"

    try {
        if (Get-ADUser -Identity $UserName -ErrorAction Stop) {
            if ($ResetUser) {
                SEC-WriteVaultSecret `
                    -Endpoint $Endpoint `
                    -Path $Path `
                    -Token $Token `
                    -Secret  @{ "password" = SEC-GeneratePassword }
                Set-ADAccountPassword -Identity $UserName -Password $(
                    ConvertTo-SecureString `
                    $(SEC-ReadVaultSecret `
                        -Endpoint $Endpoint `
                        -Path $Path `
                        -Token $Token)["data"]["data"]["password"] `
                    -AsPlainText -Force)
            } else {
                return
            }
        }
    } catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
        SEC-WriteVaultSecret `
            -Endpoint $Endpoint `
            -Path $Path `
            -Token $Token `
            -Secret  @{ "password" = SEC-GeneratePassword } 
        New-ADUser `
            -SamAccountName $UserName `
            -Name $UserName `
            -ChangePasswordAtLogon:$False `
            -PasswordNeverExpires:$True
        Set-ADAccountPassword -Identity $UserName -Password $(
            ConvertTo-SecureString `
            $(SEC-ReadVaultSecret `
                -Endpoint $Endpoint `
                -Path $Path `
                -Token $Token)["data"]["data"]["password"] `
            -AsPlainText -Force)
    } finally {
        $_; exit 1
    }
}

Export-ModuleMember -Function SEC-CreateUser