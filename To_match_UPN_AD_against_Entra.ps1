$upns = "sam@damopro.in","test@damopro.in","py@damopro.in","alistor@damopro.in","test2@damopro.in"

foreach ($u in $upns) {
    $cloud = (Get-MgUser -UserId $u -Property UserPrincipalName).UserPrincipalName
    $ad    = (Get-ADUser -LDAPFilter "(userPrincipalName=$u)" -Properties UserPrincipalName).UserPrincipalName
    Write-Output "$u - Cloud: $cloud | AD: $ad | Match: $($cloud -eq $ad)"
}
