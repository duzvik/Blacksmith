# Blacksmith

[![Open_Threat_Research Community](https://img.shields.io/badge/Open_Threat_Research-Community-brightgreen.svg)](https://twitter.com/OTR_Community)
[![Open Source Love](https://badges.frapsoft.com/os/v3/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/)

The Blacksmith project focuses on providing dynamic easy-to-use templates for security researches to model and provision resources to automatically deploy applications and small networks in the cloud. It currently leverages [AWS CloudFormation](https://aws.amazon.com/cloudformation/) and [Microsoft Azure Resource Manager (ARM)]() templates to implement infrastructure as code for cloud solutions.

# Goals

* Expedite research by providing dynamic templates to deploy applications in the cloud.
* Translate favorite applications or tools into cloud templates for developing and testing.
* Replicate research environments for training purposes
* Learn more about AWS CloudFormation
* Learn more about Microsoft's Azure Resource Manager (ARM) templates

# Getting Started

* [Blacksmith ReadTheDocs](https://blacksmith.readthedocs.io/en/latest/index.html)

# Contributing

We would love to hear your feedback after using the templates in this project. Let me know also if you also would like to share an environment or an application with the community. Thank you in advance!

# License: GPL-3.0

[ Blacksmith's GNU General Public License](https://github.com/OTRF/Blacksmith/blob/master/LICENSE)

A few deployments available through Azure Sentinel To-go!



| Items | Deploy | Deploy US Gov |
| :---| :---| :--- |
| [Azure Sentinel](https://github.com/OTRF/Azure-Sentinel2Go/tree/master/azure-sentinel) | [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FOTRF%2FAzure-Sentinel2Go%2Fmaster%2Fazure-sentinel%2Fazuredeploy.json) | [![Deploy to Azure Gov](https://aka.ms/deploytoazuregovbutton)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FOTRF%2FAzure-Sentinel2Go%2Fmaster%2Fazure-sentinel%2Fazuredeploy.json) |
| [Azure Sentinel + Custom Log Pipeline](https://github.com/OTRF/Azure-Sentinel2Go/tree/master/grocery-list/custom-log-pipeline) | [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FOTRF%2FAzure-Sentinel2Go%2Fmaster%2Fgrocery-list%2Fcustom-log-pipeline%2Fazuredeploy.json) | [![Deploy to Azure Gov](https://aka.ms/deploytoazuregovbutton)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FOTRF%2FAzure-Sentinel2Go%2Fmaster%2Fgrocery-list%2Fcustom-log-pipeline%2Fazuredeploy.json) |
| [Azure Sentinel + Win10 Workstations](https://github.com/OTRF/Azure-Sentinel2Go/tree/master/grocery-list/win10) | [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FOTRF%2FAzure-Sentinel2Go%2Fmaster%2Fgrocery-list%2Fwin10%2Fazuredeploy.json) | [![Deploy to Azure Gov](https://aka.ms/deploytoazuregovbutton)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FOTRF%2FAzure-Sentinel2Go%2Fmaster%2Fgrocery-list%2Fwin10%2Fazuredeploy.json) |
| [Azure Sentinel + Win10 + AD](https://github.com/OTRF/Azure-Sentinel2Go/tree/master/grocery-list/win10-AD) | [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FOTRF%2FAzure-Sentinel2Go%2Fmaster%2Fgrocery-list%2Fwin10-AD%2Fazuredeploy.json) | [![Deploy to Azure Gov](https://aka.ms/deploytoazuregovbutton)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FOTRF%2FAzure-Sentinel2Go%2Fmaster%2Fgrocery-list%2Fwin10-AD%2Fazuredeploy.json) |
| [DUZVIK Azure Sentinel + Win10 + AD + ADFS](https://github.com/OTRF/Azure-Sentinel2Go/tree/master/grocery-list/win10-AD-ADFS) | [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fduzvik%2FBlacksmith%2Fmaster%2Fwin10-AD-ADFS-azuredeploy.json) | [![Deploy to Azure Gov](https://aka.ms/deploytoazuregovbutton)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FOTRF%2FAzure-Sentinel2Go%2Fmaster%2Fgrocery-list%2Fwin10-AD-ADFS%2Fazuredeploy.json) |
| [Azure Sentinel + Win10 + Palo Alto Networks VM-Series Firewall](https://github.com/OTRF/Azure-Sentinel2Go/tree/master/grocery-list/win10-PAN-FW) | [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FOTRF%2FAzure-Sentinel2Go%2Fmaster%2Fgrocery-list%2Fwin10-PAN-FW%2Fazuredeploy.json) | [![Deploy to Azure Gov](https://aka.ms/deploytoazuregovbutton)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FOTRF%2FAzure-Sentinel2Go%2Fmaster%2Fgrocery-list%2Fwin10-PAN-FW%2Fazuredeploy.json) |
| [Azure Sentinel + Linux (Ubuntu,CentOS,RHEL)](https://github.com/OTRF/Azure-Sentinel2Go/tree/master/grocery-list/linux) | [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FOTRF%2FAzure-Sentinel2Go%2Fmaster%2Fgrocery-list%2Flinux%2Fazuredeploy.json) | [![Deploy to Azure Gov](https://aka.ms/deploytoazuregovbutton)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FOTRF%2FAzure-Sentinel2Go%2Fmaster%2Fgrocery-list%2Flinux%2Fazuredeploy.json) |



