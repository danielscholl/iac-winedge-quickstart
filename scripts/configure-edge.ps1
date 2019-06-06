<#
    .SYNOPSIS
        Downloads and configures Windows IoT Edge.
#>

Param (
    [string]$deviceConnectionString = "HostName=???.azure-devices.net;DeviceId=edge;SharedAccessKey="
)

# Firewall
## Inbound Ports required 15580, 15581
New-NetFirewallRule -DisplayName "IoT Edge" -Direction Inbound -LocalPort 15580,15581 -Protocol TCP -Action Allow
 
## Outbound Ports required 443, 8883, 5671
New-NetFirewallRule -DisplayName "IoT Edge" -Direction Outbound -LocalPort 443,8883,5671 -Protocol TCP -Action Allow

# Install Containers
Install-WindowsFeature web-server -IncludeManagementTools

# Install IoT Edge

. {Invoke-WebRequest -useb aka.ms/iotedge-win} | Invoke-Expression; `
  Initialize-IoTEdge -Manual -DeviceConnectionString $deviceConnectionString -ContainerOs Windows