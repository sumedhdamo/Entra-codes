# PowerShell Script: create_single_user.ps1

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All"

# Prompt for user input
$firstName = Read-Host "Enter First Name"
$lastName = Read-Host "Enter Last Name"
$domain = "damopro.in"  # Replace with your actual domain

# Generate base username
$baseUsername = ($firstName.Substring(0,1) + $lastName).ToLower()
$userPrincipalName = "$baseUsername@$domain"

# Check for conflict
$suffix = 1
while (Get-MgUser -Filter "userPrincipalName eq '$userPrincipalName'" -ErrorAction SilentlyContinue) {
    $userPrincipalName = "$baseUsername-$suffix@$domain"
    $suffix++
}

# Final UPN
Write-Host "Final UPN: $userPrincipalName"

# Create the user
$newUser = @{
    AccountEnabled = $true
    DisplayName = "$firstName $lastName"
    MailNickname = $baseUsername
    UserPrincipalName = $userPrincipalName
    PasswordProfile = @{
        ForceChangePasswordNextSignIn = $true
        Password = "P@ssword123!"
    }
    UsageLocation = "IN"
}

$user = New-MgUser -BodyParameter $newUser

# Get RedGlass group
$group = Get-MgGroup -Filter "displayName eq 'RedGlass'"
if ($group) {
    New-MgGroupMember -GroupId $group.Id -DirectoryObjectId $user.Id
    Write-Host "✅ User added to RedGlass group."
} else {
    Write-Warning "⚠️ RedGlass group not found."
}
