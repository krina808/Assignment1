 Disable guest account
Set-LocalUser -Name "Guest" -Enabled $false

# Change default administrator account name
Rename-LocalUser -Name "Administrator" -NewName "Admin" 

# Set strong password policies
$minLength = 14
$maxLength = 16
$minLowerCase = 2
$minUpperCase = 2
$minDigits = 2
$minSpecialChars = 2

$policy = Get-LocalUserPasswordPolicy
$policy | Set-LocalUserPasswordPolicy -MinPasswordLength $minLength -MaxPasswordLength $maxLength -PasswordHistoryCount 24 -MinLowerCaseCharacters $minLowerCase -MinUpperCaseCharacters $minUpperCase -MinDigitCharacters $minDigits -MinNonLetterCharacters $minSpecialChars

# Enable firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

# Enable Windows Defender Antivirus
Set-MpPreference -DisableRealtimeMonitoring $false

# Enable Windows Event Log Forwarding
$computerName = $env:COMPUTERNAME
$eventCollector = "EventCollectorServer"
$subscriptionName = "Subscription01"

$eventLog = New-WinEventLog -LogName "ForwardedEvents"
$eventLog | Add-WinEventLogSubscriber -ComputerName $eventCollector -SourceName "*" -Credential (Get-Credential) -SubscriptionName $subscriptionName

# Enable BitLocker
$encryptionMethod = "AES128"
$recoveryPassword = "1234-5678-ABCD-EFGH"
$volume = "C:"
$tpm = Get-Tpm

if ($tpm.TpmPresent -and $tpm.TpmReady) {
    Enable-BitLocker -MountPoint $volume -EncryptionMethod $encryptionMethod -UsedSpaceOnly -RecoveryPasswordProtector -RecoveryPassword $recoveryPassword
} else {
    Write-Host "TPM not present or not ready."
}
