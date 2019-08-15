# Introduction
Infrastructure as Code using ARM - Windows Edge VM and Azure Container Registery.

[![Build Status](https://dascholl.visualstudio.com/IoT/_apis/build/status/danielscholl.iac-winedge-quickstart?branchName=master)](https://dascholl.visualstudio.com/IoT/_build/latest?definitionId=29&branchName=master)


### Create Environment File

Create an environment setting file in the root directory ie: `.env.ps1` or `.envrc`

Default Environment Settings

| Parameter             | Default                              | Description                              |
| --------------------  | ------------------------------------ | ---------------------------------------- |
| _ARM_SUBSCRIPTION_ID_ | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | Azure Subscription Id                    |
| _AZURE_LOCATION_      | CentralUS                            | Azure Region for Resources to be located |



### Provision Infrastructure 

>Note:  This can be performed via Portal UI or CloudShell (Bash/Powershell)

__Provision using portal__

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdanielscholl%2Fiac-winedge-quickstart%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>


__Provision using bash__

>Note:  Requires the use of [direnv](https://direnv.net/)

Run Install Script for ARM Process

```bash
# Initialize the Modules
initials="<your_initials>"
install.sh $initials
```


__Provision using powershell__


>Note:  Requires the use of [powershell](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-6)

Run Install Script for ARM Process

```bash
# Initialize the Modules
$initials = "<your_initials>"
install.ps1 -Initials $initials
```

### Configure IoT Edge

1. Connect to the Edge VM from CloudShell

```powershell
$vm = "<your_vm_name>"
$group = "<your_resourceGroup>"
$cred = get-credential
Enable-AzVMPSRemoting -Name $vm -ResourceGroup $group -Protocol https -OsType Windows
Enter-AzVM -name $vm -ResourceGroup $group -Credential $cred
```

2. Retrieve Connection String for Edge Device from the desired IoT Hub


3. Configure the Edge Runtime on the Edge VM

```powershell
#  Configure IOT Edge on Edge VM
$DeviceConnectionString = "<your_connection_string>"
. {Invoke-WebRequest -useb aka.ms/iotedge-win} | Invoke-Expression; `
Initialize-IoTEdge -Manual -DeviceConnectionString $DeviceConnectionString -ContainerOs Windows

Get-IoTEdgeLog
iotedge check
```



### Enable Container Solution Monitoring (Optional)

Enable the [Azure Container Monitoring Solution](https://docs.microsoft.com/en-us/azure/azure-monitor/insights/containers).

```powershell
stop-service iotedge
stop-service iotedge-moby

# Reconfigure the iotedge-moby Service to use the following executable path
C:\Program Files\iotedge-moby\dockerd.exe -H npipe:////./pipe/docker_engine -H 0.0.0.0:2376 --exec-opt isolation=process --run-service --data-root C:\ProgramData\iotedge-moby --exec-root C:\ProgramData\iotedge-moby\\exec-root

# Start the Container Service
start-service iotedge-moby

# Test the connections
docker -H npipe:////./pipe/docker_engine images
docker -H 0.0.0.0:2376 images

# Setup Environment Variable for Docker to connect to container service.
[System.Environment]::SetEnvironmentVariable("DOCKER_HOST", "npipe:////./pipe/docker_engine", [System.EnvironmentVariableTarget]::Machine)

# --> Logoff for Environment Variable to take effect 

# Modify the config.yaml
 # uri: 'npipe://./pipe/iotedge_moby_engine'
  uri: 'npipe://./pipe/docker_engine'

# Start IoTEdge Service
start-service iotedge

# Check
iotedge check
```


### Modify URI Schemes to HTTP for Listen and Connect (Optional)

The URI Listen and Connect URI Schemes can be modified from UNIX to HTTP in order to support .NET Framework Modules

> Note: This is not recommended for a production scenario.

1. Open the firewall rule to allow 15580 and 15581 and identify the IP Address

```powershell
# Add Firewall Rule
New-NetFirewallRule -DisplayName "IoT Edge" -Direction Inbound -LocalPort 15580, 15581 -Protocol TCP -Action Allow

# Retrieve IP Address
ipconfig
```

2. Edit the Configuration and modify the Connect and Listen URI's using the IP Address `C:\programdata\iotedge\config.yaml`

>Note: Use the _IP ADDRESS_ from the results of `ipconfig`

```powershell
connect:
  management_uri: "http://10.0.0.4:15580"
  workload_uri: "http://10.0.0.4:15581"

listen:
  management_uri: "http://10.0.0.4:15580"
  workload_uri: "http://10.0.0.4:15581"
```

3.	Set the Environment Variable to access the iotedge cli tool and restart the service

> Note: Use the _IP ADDRESS_ from the results of `ipconfig`

```powershell
# Setup the Environment variable (requires logoff to apply)
[System.Environment]::SetEnvironmentVariable("IOTEDGE_HOST", "http://10.0.0.4:15580", [System.EnvironmentVariableTarget]::Machine)

# Restart the Iot Edge Service
restart-service iotedge
```
