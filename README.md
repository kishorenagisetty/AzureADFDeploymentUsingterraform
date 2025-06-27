<!-- 👑 AUTHOR BADGE -->
<p align="center">
  <img src="https://img.shields.io/badge/Made%20by-Kishore%20Kumar%20Nagisetty-ff69b4?style=for-the-badge&logo=crown&logoColor=white" alt="Author Badge"/>
</p>

<h1 align="center">🎯 Azure Synapse Data Warehouse Deployment using Terraform</h1>

<p align="center"><strong>A 100% automated Synapse Infrastructure by Kishore — Azure DevOps | Terraform | GitOps | Key Vault 👑</strong></p>

<p align="center">
  <a href="https://www.linkedin.com/in/kishorekumarnagisetty/">
    <img src="https://img.shields.io/badge/LinkedIn-Kishore%20Nagisetty-blue?style=for-the-badge&logo=linkedin" alt="LinkedIn Badge"/>
  </a>
</p>

<p align="center">
  <a href="https://github.com/kishorenagisetty">
    <img src="https://img.shields.io/badge/GitHub-Kishore%20Nagisetty-181717?style=for-the-badge&logo=github" alt="GitHub Badge"/>
  </a>
</p>


# 🎯 Azure Synapse Data Warehouse Deployment using Terraform

A fully automated solution to deploy **Azure Synapse Analytics** with private networking, integrated GitOps, secure secrets via Key Vault, and a SQL Pool — all powered by **Terraform** and **Azure DevOps**.

![Terraform](https://img.shields.io/badge/IaC-Terraform-blueviolet?style=for-the-badge&logo=terraform)
![Azure](https://img.shields.io/badge/Cloud-Azure-0078D4?style=for-the-badge&logo=microsoft-azure)
![CI/CD](https://img.shields.io/badge/CI/CD-Azure%20Pipelines-blue?style=for-the-badge&logo=azuredevops)
![GitOps](https://img.shields.io/badge/GitOps-Enabled-yellowgreen?style=for-the-badge&logo=git)
![Security](https://img.shields.io/badge/Security-KeyVault-green?style=for-the-badge&logo=keepassdx)
![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen?style=for-the-badge)

## 📦 Features

- 🧱 **Modular Architecture**: Cleanly structured Terraform modules for Synapse, Key Vault, VNet.
- 🔐 **Key Vault Integration**: Secrets like SQL passwords are stored securely in Azure Key Vault.
- 🌐 **Private Endpoints**: Synapse access is controlled via private endpoints and firewall rules.
- 🧾 **Role Assignments**: System-assigned identities are given the right Synapse/SQL roles.
- 🚀 **CI/CD Enabled**: Azure DevOps YAML pipeline provided for automated deployments.
- 📂 **Remote State Management**: Backend configuration stores Terraform state in Azure blob.

---

## 📁 Repository Structure
```bash
├── main.tf                  # Root orchestrator that calls all modules
├── backend.tf               # Remote state configuration
├── devops-pipeline.yml      # CI/CD pipeline definition
├── terraform.tfvars         # Variable values for deployment
├── /Vnet                    # Module for Azure Virtual Network
├── /keyvault                # Module for Key Vault + Secrets + Policies
└── /synapse                 # Main Synapse workspace deployment module


---

## 🚀 How It Works

1. **Provision Infrastructure**  
   - Deploys RG, VNet, Subnet, Storage Account, and Data Lake Gen2  
   - Creates Synapse Workspace with managed resource group  
   - Deploys SQL Pool (DW100c) + optional private endpoint  
   
2. **Secure Configuration**  
   - Secrets and credentials are generated via `random_password`  
   - Stored securely in Azure Key Vault  
   - System & User identities granted scoped access  

3. **Pipeline Deployment (CI/CD)**  
   - YAML pipeline copies code, stages artifacts, and deploys infra  
   - Fully GitOps-ready: supports Azure DevOps repo link inside Synapse  

4. **Firewall Setup & Delay Handling**  
   - Supports multiple predefined IP ranges  
   - `time_sleep` resource waits post-rule creation for stability  

5. **RBAC/Role Assignments**  
   - SQL DB Contributor assigned at Subscription level  
   - Synapse Administrator assigned at workspace level

---

## 📌 Prerequisites

- ✅ Azure CLI configured and logged in  
- ✅ Terraform CLI v1.0 or higher  
- ✅ Azure DevOps project with repository  
- ✅ SPN (Service Principal) with Contributor & KeyVault Secrets Officer roles  

---

## 🧪 Example `terraform.tfvars`

```hcl
resource_group_name    = "TF-AzureDatawareHouse"
location               = "uksouth"
virtual_network_name   = "TF-VNet"
vnet_address_space     = ["10.69.2.0/24"]
subnet_name            = "TF-subnet"
subnet_address_space   = ["10.69.2.0/25"]

synapse_workspace_name                 = "my-synapse-ws"
storage_account_name                   = "tfadwhstorage1"
storage_data_lake_gen2_filesystem_name = "tfadwhfilesystem"
synapse_sql_pool_name                  = "sqlpool01"
sql_username                           = "adminuser"

vault_Name                             = "TF-KeyVault"
kv_secret_name                         = "sqlPassword"
user_object_id                         = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

azure_devops_account_name              = "myADOAccount"
azure_devops_project_name              = "myADOProject"
azure_devops_branch_name               = "main"
azure_devops_repo_name                 = "datawarehouse-Terraform"

Pipeline YAML (Azure DevOps)
pool:
  name: Azure Pipelines

steps:
  - task: CopyFiles@2
    inputs:
      SourceFolder: '$(agent.builddirectory)'
      TargetFolder: '$(build.artifactstagingdirectory)'

  - task: PublishBuildArtifacts@1
    inputs:
      pathToPublish: '$(build.artifactstagingdirectory)'
      artifactName: 'drop'

🧠 Best Practices Followed
☑️ Remote state secured via Azure Blob
☑️ Passwords never stored in code
☑️ GitOps-ready ADO repo sync with Synapse
☑️ Modular reusable Terraform structure
☑️ Supports role-based access with principle ID flexibility
☑️ Highly readable and scalable design

📄 License
This project is licensed under the MIT License.
🙌 Author
Kishore Kumar Nagisetty
🔗 GitHub | 💼 Azure & DevOps | 🚀 CI/CD | 📊 AI DataOps Engineering
📬 Feel free to fork, star ⭐, and open an issue or PR!
