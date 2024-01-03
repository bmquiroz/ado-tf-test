<powershell>

Write-Host "Starting bootstrap script.."

# Disable Windows Firewall
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Configure WinRM
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'

# Install Python 3.12
choco install python3 -y
$env:Path += ";C:\Python312;C:\Python312\Scripts"

Write-Host "Syncing inventory.."
$user = 'admin'
$pass = 'password'
$uri = 'http://10.30.0.22/api/v2/inventory_sources/8/update/'
$pair = "$($user):$($pass)"
$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
$basicAuthValue = "Basic $encodedCreds"
$Headers = @{
    Authorization = $basicAuthValue;
    Accept = 'application/json'
}
Invoke-WebRequest -Uri $uri -Headers $Headers -Method POST
Start-Sleep -Seconds 60

Write-Host "Executing callback provisioner.."
# Execute callback provisioner on target instance
$POSTParams = @{
    host_config_key = "D2g46x7y6dbPCCZgtXWLJIAHtbLt"
}
Invoke-WebRequest -Uri "http://10.30.0.22/api/v2/job_templates/11/callback/" -Method POST -Body $POSTParams

</powershell>