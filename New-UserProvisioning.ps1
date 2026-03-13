# New User Provisioning Script
# Created by James Mitchell
# Date: February 2026

# Input Prompts
Write-Host "============================" -ForegroundColor Cyan
Write-Host "New User Provisioning Script" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan

$FirstName = Read-Host "Enter First Name"
$LastName = Read-Host "Enter Last Name"
$Department = Read-Host "Enter Department (HR, IT, Sales)"
$Password = Read-Host "Enter Temporary Password"

# Auto-generated values
$Username = "$FirstName.$LastName".ToLower()
$DisplayName = "$FirstName $LastName"
$OUPath = "OU=$Department,OU=Corp Users,DC=CORP,DC=local"

# Confirm before proceeding
Write-Host "`n============================" -ForegroundColor Yellow
Write-Host "Please confirm the following:" -ForegroundColor Yellow
Write-Host "Name: $DisplayName" -ForegroundColor Yellow
Write-Host "Username: $Username" -ForegroundColor Yellow
Write-Host "Department: $Department" -ForegroundColor Yellow
Write-Host "OU Path: $OUPath" -ForegroundColor Yellow
Write-Host "============================`n" -ForegroundColor Yellow

$Confirm = Read-Host "Proceed with provisioning? (Y/N)"

If ($Confirm -ne "Y") {
    Write-Host "Provisioning cancelled." -ForegroundColor Red
    Exit
}

Try {
    # Step tracker — Creating User
    $CurrentStep = "Creating AD User"

    # Create the AD User
    New-ADUser `
        -Name $DisplayName `
        -GivenName $FirstName `
        -Surname $LastName `
        -SamAccountName $Username `
        -UserPrincipalName "$Username@corp.local" `
        -Path $OUPath `
        -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
        -Enabled $true `
        -ChangePasswordAtLogon $true

    Write-Host "User $Username created successfully." -ForegroundColor Green

    # Step tracker — Assigning Group
    $CurrentStep = "Assigning Security Group"

    # Add user to department security group
    $Group = "$Department`_Users"
    Add-ADGroupMember -Identity $Group -Members $Username

    Write-Host "Added to group: $Group" -ForegroundColor Green

    # Success Summary
    Write-Host "============================" -ForegroundColor Cyan
    Write-Host "Provisioning Complete" -ForegroundColor Cyan
    Write-Host "User: $Username" -ForegroundColor Cyan
    Write-Host "Department: $Department" -ForegroundColor Cyan
    Write-Host "OU Path: $OUPath" -ForegroundColor Cyan
    Write-Host "Group: $Group" -ForegroundColor Cyan
    Write-Host "============================" -ForegroundColor Cyan
}
Catch {
    Write-Host "============================" -ForegroundColor Red
    Write-Host "ERROR: Provisioning Failed" -ForegroundColor Red
    Write-Host "Step: $CurrentStep" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host "============================" -ForegroundColor Red
}