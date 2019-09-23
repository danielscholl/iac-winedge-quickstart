<#
    .SYNOPSIS
        Downloads and configures Windows IoT Edge.
#>

Param (

)

# Firewall
## Inbound Ports required 15580, 15581
#New-NetFirewallRule -DisplayName "IoT Edge" -Direction Inbound -LocalPort 15580, 15581 -Protocol TCP -Action Allow

## Outbound Ports required 443, 8883, 5671
#New-NetFirewallRule -DisplayName "IoT Edge" -Direction Outbound -LocalPort 443, 8883, 5671 -Protocol TCP -Action Allow

# Setup System Environment Variable to connect to Moby.
[System.Environment]::SetEnvironmentVariable("DOCKER_HOST", "npipe:////./pipe/iotedge_moby_engine", [System.EnvironmentVariableTarget]::Machine)

# Write daemon.json file
New-Item -ItemType Directory -Force -Path C:\ProgramData\iotedge-moby\config
Set-Content -Path 'C:\ProgramData\iotedge-moby\config\daemon.json' -Value @'
{
  "log-driver": "json-file",
  "log-opts": {
      "max-size": "10m",
      "max-file": "3"
  }
}
'@

# Deploy IoT Edge aka.ms/iotedge-win
. { Invoke-WebRequest -useb https://raw.githubusercontent.com/danielscholl/iac-winedge-quickstart/master/scripts/IotEdgeSecurityDaemon.ps1 } | Invoke-Expression; `
   Deploy-IoTEdge -ContainerOs Windows -RestartIfNeeded

#  . { Invoke-WebRequest -useb aka.ms/iotedge-win } | Invoke-Expression; `
#  Deploy-IoTEdge -ContainerOs Windows -RestartIfNeeded

#. {Invoke-WebRequest -useb https://aka.ms/iotedge-win} | Invoke-Expression; `
#Initialize-IoTEdge -Dps -ScopeId {scope ID} -RegistrationId {registration ID} -SymmetricKey {symmetric key}
