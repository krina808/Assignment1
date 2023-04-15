#implementing testDnsBlock
function TestDnsBlock {


    #Determining the ip address
    $ip = Resolve-DnsName "www.isitblocked.org"
    Write-Output = $ip  
    
    Invoke-ScriptAnalyzer -Path "C:\Users\dell\Desktop\CYBER\Assignment1\defend.ps1"
    
    }
    
    function Enable-Doh {
    
    # Set the DoH server address
    $DoHServer = "https://cloudflare-dns.com/dns-query"
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" -Name "EnableAutoDoh" -Value 2
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" -Name "AutoDohServer" -Value $DoHServer
    
    # Set the test domain name
    $TestDomain = TestDnsBlock
    
    # Resolve the test domain name using traditional DNS
    #$TraditionalDNSResult = Resolve-DnsName -Name $TestDomain
    
    # Resolve the test domain name using DoH
    $DoHResult = Resolve-DnsName -Name $TestDomain -Server $DoHServer -Type A
    
    # Compare the results
    if ($TraditionalDNSResult.IPAddress -eq $DoHResult.IPAddress) {
        Write-Output "DoH is enabled"
        TestDnsBlock
    }
    else {
        Write-Output "DoH is not working"
    }
    
    }
    
    Enable-Doh
    
    
    #setupQuadDoH
    function setupQuadDoH{
    
     # Set the name of the Ethernet adapter
    $AdapterName = "Ethernet3"
    
    # Set the DNS server addresses
    $DNSAddresses = "8.8.8.8", "9.9.9.9"

     #creating $guid
     $guid = New-Guid

     $guidString = "1"
   # $guid = [guid]::Parse($guidString)
   
   #registry path created
   New-Item -Path HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\'+$guid+'\InterfaceSpecificParameters\DoH\9.9.9.9 

   Set-ItemProperty Path HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\'+$guid+'\InterfaceSpecificParameters\DoH\9.9.9.9 

    }
    
    setupQuadDoH


    
    function postTest {
        $hostsFilePath = "C:\Windows\System32\drivers\etc\hosts"
        $blockedDomain = "TestDnsBlock"
        
        # Check if the website is already blocked
        $hostsContent = Get-Content -Path $hostsFilePath
        if ($hostsContent -match $blockedDomain) {
            Write-Output "The website is already blocked"
        } else {
            # Add an entry to the hosts file to block the website
            $newLine = "`n0.0.0.0 $blockedDomain"
            Add-Content -Path $hostsFilePath -Value $newLine
            Write-Output "The website has been blocked"
        }
        
        
    }
    postTest
 
function resetDoH { # Reset the DNS server value to the default settings
    netsh interface ip set dns "Local Area Connection" dhcp

    #set-ItemProperty of DOH-Flag
    Set-ItemProperty -Path Path HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\'+$guid+'\InterfaceSpecificParameters\DoH\0
   
}
resetDoH
