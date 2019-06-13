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

iotedge check
```

### Modify URI Schemes for Listen and Connect

If necessary the URI Listen and Connect URI Schemes can be modified from UNIX to HTTP in order to support .NET Framework Modules

1. Locate the IP Address of the machine `ipconfig`

2. Edit the Configuration and modify the Connect and Listen URI's using the IP Address `C:\programdata\iotedge\config.yaml`

```powershell
connect:
  management_uri: "http://10.0.0.4:15580"
  workload_uri: "http://10.0.0.4:15581"

listen:
  management_uri: "http://10.0.0.4:15580"
  workload_uri: "http://10.0.0.4:15581"
```

3. Restart the IoT Edge Service
    `restart-service iotedge`

4.	Set the Environment Variable to access the iotedge cli tool

```powershell
    [Environment]::SetEnvironmentVariable("IOTEDGE_HOST", "http://10.0.0.4:15580", [System.EnvironmentVariableTarget]::User)
```

5. Deploy an Empty Manifest and Routes

```bash
./deploy.sh <hub> <device>
```

### Test the Solution (Optional)

>NOTE:  THIS CAN ONLY BE DONE FROM A LINUX SHELL!!

Manually run the test suite

```bash
npm install
npm test
```
