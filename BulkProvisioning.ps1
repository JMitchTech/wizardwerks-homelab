# Bulk User Provisioning Script
# Created by James Mitchell
# Date: February 2026

# CSV Path
$CSVPath = "C:\Scripts\NewUsers.csv"

# Opening Banner
Write-Host "============================" -ForegroundColor Cyan
Write-Host "Bulk User Provisioning Script" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan

# Verify CSV exists
If (-Not (Test-Path $CSVPath)) {
    Write-Host "ERROR: CSV file not found at $CSVPath" -ForegroundColor Red
    Exit
}

# Import CSV
$Users = Import-Csv $CSVPath

Write-Host "Found $($Users.Count) users to provision." -ForegroundColor Yellow
Write-Host ""

# Confirm before proceeding
$Confirm = Read-Host "Proceed with bulk provisioning? (Y/N)"

If ($Confirm -ne "Y") {
    Write-Host "Bulk provisioning cancelled." -ForegroundColor Red
    Exit
}

Write-Host ""

# Track results
$Success = 0
$Failed = 0

# Loop through each user in CSV
ForEach ($User in $Users) {

    # Set variables from CSV row
    $FirstName = $User.FirstName
    $LastName = $User.LastName
    $Department = $User.Department
    $Password = $User.Password
    $Username = "$FirstName.$LastName".ToLower()
    $DisplayName = "$FirstName $LastName"
    $OUPath = "OU=$Department,OU=Corp Users,DC=CORP,DC=local"
    $HomeFolderPath = "\\FS01\HomeDirectories\$Username"
    $Group = "$Department`_Users"

    Write-Host "Provisioning: $DisplayName..." -ForegroundColor Yellow

    Try {
        # Step tracker
        $CurrentStep = "Creating AD User"

        # Create AD User
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

        # Step tracker
        $CurrentStep = "Assigning Security Group"

        # Add to security group
        Add-ADGroupMember -Identity $Group -Members $Username

        # Step tracker
        $CurrentStep = "Creating Home Folder"

        # Create home folder
        New-Item -Path $HomeFolderPath -ItemType Directory | Out-Null

        # Set NTFS permissions
        $Acl = Get-Acl $HomeFolderPath
        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            "$Username",
            "FullControl",
            "ContainerInherit,ObjectInherit",
            "None",
            "Allow"
        )
        $Acl.SetAccessRule($AccessRule)
        Set-Acl -Path $HomeFolderPath -AclObject $Acl

        # Map home drive in AD
        Set-ADUser -Identity $Username `
            -HomeDirectory $HomeFolderPath `
            -HomeDrive "H:"

        Write-Host "SUCCESS: $DisplayName provisioned." -ForegroundColor Green
        $Success++
    }
    Catch {
        Write-Host "FAILED: $DisplayName — Step: $CurrentStep — $($_.Exception.Message)" -ForegroundColor Red
        $Failed++
    }

    Write-Host ""
}

# Final Summary
Write-Host "============================" -ForegroundColor Cyan
Write-Host "Bulk Provisioning Complete" -ForegroundColor Cyan
Write-Host "Successfully provisioned: $Success" -ForegroundColor Green
Write-Host "Failed: $Failed" -ForegroundColor Red
Write-Host "============================" -ForegroundColor Cyan