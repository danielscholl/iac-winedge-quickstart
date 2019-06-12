<#
    .SYNOPSIS
        Downloads and configures Windows IoT Edge.
#>

Param (

)

# Firewall
## Inbound Ports required 15580, 15581
New-NetFirewallRule -DisplayName "IoT Edge" -Direction Inbound -LocalPort 15580, 15581 -Protocol TCP -Action Allow

## Outbound Ports required 443, 8883, 5671
New-NetFirewallRule -DisplayName "IoT Edge" -Direction Outbound -LocalPort 443, 8883, 5671 -Protocol TCP -Action Allow

# Setup System Environment Variable to connect to Moby.
[System.Environment]::SetEnvironmentVariable("DOCKER_HOST", "npipe:////./pipe/iotedge_moby_engine", [System.EnvironmentVariableTarget]::User)

# Write daemon.json file
Set-Content -Path 'C:\ProgramData\iotedge-moby\config\daemon.json' -Value @'
{
  "log-driver": "json-file",
  "log-opts": {
      "max-size": "10m",
      "max-file": "3"
  }
}
'@

# Deploy IoT Edge
. { Invoke-WebRequest -useb aka.ms/iotedge-win } | Invoke-Expression; `
  Deploy-IoTEdge -ContainerOs Windows -RestartIfNeeded
