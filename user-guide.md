# User Guide
This guide will guide you through the process of configuring your Azure virtual machine for use as your primary development environment.

## Initial VM creation
Ask your Principal to create a VM for you. Our Azure infrastructure is managed by Terraform - they will update the configuration and run the plan. Once the plan is successfully applied, it will have created the following:
* A resource group named something like `rg-ukcg-dev-simon` - this will contain the other resources personal to you.
* A virtual machine named something like `vm-ukcg-dev-simon`.
* An OS disk (your C:\\ drive). This will hold the Windows operating system, applications etc.
* A data disk (Your E:\\ or F:\\ drive). This will hold your source code and the WSL (Windows Subsystem for Linux) data. Storing data here is encouraged will help in the event of VM problems or migration requiring a new VM to be created at some point in the future).
* A network interface to our virtual network.
* A public IP address with a DNS name to allow easy connection - something like `vm-civica-ukcg-mas-simon.uksouth.cloudapp.azure.com`.

Note that a shared network security group in the subscription will prevent access from anywhere outside of the Civica network.

## First use
Once the VM and it's resources have been created by your principal, you will be given a VM username and a link to the VM resource in Azure, where you can start and stop the virtual machine as required, obtain the connection details and reset passwords etc. To prepare your VM for first use, please follow these steps carefully:

### Azure portal
1. Login to https://portal.azure.com using your Civica credentials.
1. Navigate to the VM resource link provided by your principal.
1. Use the Search box or otherwise navigate to the `Reset password` page.
1. Reset the password **for the username supplied to you** to a secure one of your choosing.
1. Use the Search box or otherwise navigate to the `Auto-shutdown` page.
1. Schedule a shutdown for 7:00:00 pm UTC, or whatever is appropriate for your working hours.
1. Select to `Send notification before auto-shutdown`.
1. Enter your Email address and Save - this will ensure you have the chance to easily postpone or cancel the auto-shutdown that will otherwise occur.
1. Navigate to the `Overview` page - this is where you can start and stop the virtual machine as required.
1. Navigate to the 'Connect' page to download the RDP file or obtain IP/DNS details. 

### Remote desktop
1. Start Remote Desktop and enter the DNS name.
1. Enter your credentials when prompted and accept certificate warning.
1. Select No for all Privacy options that appear - none of this is for your benefit.
1. When logged on, you should observe a PowerShell script running. If you observe any error messages (in red) please take a copy and let your principal know. 
1. If all appears well, press any key to restart when prompted.
1. Restart Remote Desktop and login again as before.
1.  When logged on, another PowerShell script will be running - this one will take longer so best to come back to it.
1. Eventually, you will be prompted for a password for your WSL account (username `wsl`) - enter something secure.
1. Enter your details if you like (or just keep pressing Enter).
1. Wait while standard tools are installed.
1. Select optional tools when prompted and click OK.
1. Wait while optional tools are installed.

## What do you get?
Once the scripts have run successfully, you should have the following:
* Chocolatey package manager (used to install various useful tools)
* Windows Subsystem for Linux (WSL) with a default Ubuntu installation on your U:\\ drive
* A `Source` folder on your secondary drive  (E:\\ or F:\\) where your code repositories should be cloned to.
* Visual Studio Code, Docker Desktop and Windows Terminal are installed by default.
* The optional tools you selected during the installation process will also be available.

## What's next?

### General
You can start using the VM now and install any other things you need and even consider doing some actual work.
* Remember to script updates if possible - you can use chocolatey to install additional tools for example.
* Run `choco upgrade all -y` regularly to update all software installed via chocolatey to the latest versions.
* If you think any tools should be part of the standard installation script then please let your principal know.

### VS Code
1. Start it up and install recommended extenions where prompted.
1. Install Microsoft's Docker extension.
1. Execute in terminal, substituting your name: `git config --global user.name "Simon Thomas"`
1. Execute in terminal, substituting your email: `git config --global user.email "simon.thomas@civica.co.uk"`