terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "ca0bc75f-df2f-4ca4-86d5-98212cb47c6f"
  client_id       = "e0abf0a4-b019-4936-8a1f-935a02d5ce56"
  client_secret   = "Alo8Q~JwWnR55CsDsU.ADw1lk29f.TaXwloIkcJm"
  tenant_id       = "17ae4838-a90c-4c04-846b-2c4976eff0d0"
    }

# Create a resource group
resource "azurerm_resource_group" "rg1" {
  name     = "${var.resource_group_name}"
  location = "${var.resource_location}"
}


resource "azurerm_virtual_network" "vnet1" {
  name                = "${var.virtual_network_name}"
  address_space       = ["${var.virtual_network_id}"]
  location            = "${azurerm_resource_group.rg1.location}"
  resource_group_name = "${azurerm_resource_group.rg1.name}"
}

resource "azurerm_subnet" "snet1" {
  name                 = "${var.subnet_name}"
  resource_group_name  = "${azurerm_resource_group.rg1.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet1.name}"
  address_prefixes     = ["${var.subnet_id}"]
  
}
resource "azurerm_network_interface" "main" {
  name                = "${var.Nic_name}-nic"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.snet1.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_virtual_machine" "main1" {
  name                  = "${var.VM_name}-vm"
  location              = azurerm_resource_group.rg1.location
  resource_group_name   = azurerm_resource_group.rg1.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_windows_config{
    
  }
  tags = {
    environment = "staging"
  }
}