# creating backend to store remote state file in storage account container
terraform {
  backend "azurerm" {
    resource_group_name  = "AzureDatawareHouse"
    storage_account_name = "terraformbackend220324"
    container_name       = "statefile1"
    key                  = "ADW220324.tfstate"
  }
}