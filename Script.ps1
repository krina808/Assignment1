# Pre-test section

# Check if the current user has administrative privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Warning "You must run this script with administrative privileges."
    return
}

#post-Test Section
Remove-Item -Path C:\TestFiles -Recurse


#reset-function
Remove-Item -Path C:\TestFiles -Recurse


# Check if the required module is installed
if (-not (Get-Module -Name MyModule -ListAvailable)) {
    Write-Warning "The MyModule module is required to run this script."
    return
}



# Install the MyModule module
Install-Module -Name MyModule -Scope CurrentUser
