# Introduction
Infrastructure as Code using ARM - Windows Edge VM and Azure Container Registery.




### Create Environment File

Create an environment setting file in the root directory ie: `.env.ps1` or `.envrc`

Default Environment Settings

| Parameter             | Default                              | Description                              |
| --------------------  | ------------------------------------ | ---------------------------------------- |
| _ARM_SUBSCRIPTION_ID_ | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | Azure Subscription Id                    |
| _AZURE_LOCATION_      | CentralUS                            | Azure Region for Resources to be located |



# Provision Infrastructure 

>NOTE:  This can be performed via Portal UI or CloudShell (Bash/Powershell)

## Provision using portal

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdanielscholl%2Fiac-winedge-quickstart%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>


## Provision using bash

__PreRequisites__

Requires the use of [direnv](https://direnv.net/)

1. Run Install Script for ARM Process

```bash
# Initialize the Modules
initials="<your_initials>"
install.sh $initials
```


## Provision using powershell

__PreRequisites__

Requires the use of [powershell](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-6)

1. Run Install Script for ARM Process

```bash
# Initialize the Modules
$initials = "<your_initials>"
install.ps1 -Initials $initials
```

## Configure IoT Edge

1. Connect to the Edge VM from CloudShell

```powershell
$vm = "<your_vm_name>"
$group = "<your_resourceGroup>"
$cred = get-credential
Enable-AzVMPSRemoting -Name $vm -ResourceGroup $group -Protocol https -OsType Windows
Enter-AzVM -name $vm -ResourceGroup $group -Credential $cred
```

1. Retrieve Connection String for Edge Device from the desired IoT Hub

1. Configure the Edge Runtime on the Edge VM

```powershell
#  Configure IOT Edge on Edge VM
$DeviceConnectionString = "<your_connection_string>"
. {Invoke-WebRequest -useb aka.ms/iotedge-win} | Invoke-Expression; `
    Install-IoTEdge -Manual -DeviceConnectionString $DeviceConnectionString -ContainerOs Windows
```