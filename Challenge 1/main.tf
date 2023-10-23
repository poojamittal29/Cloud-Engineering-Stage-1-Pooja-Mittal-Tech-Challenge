provider "azurerm" {
  features {
  }
}

resource "azurerm_resource_group" "challenge1" {
  name     = "example-resources"
  location = "East US"
}

resource "azurerm_virtual_network" "challenge1" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.challenge1.location
  resource_group_name = azurerm_resource_group.challenge1.name
}

resource "azurerm_subnet" "web" {
  name                 = "web-subnet"
  resource_group_name  = azurerm_resource_group.challenge1.name
  virtual_network_name = azurerm_virtual_network.challenge1.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "app" {
  name                 = "app-subnet"
  resource_group_name  = azurerm_resource_group.challenge1.name
  virtual_network_name = azurerm_virtual_network.challenge1.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "db" {
  name                 = "db-subnet"
  resource_group_name  = azurerm_resource_group.challenge1.name
  virtual_network_name = azurerm_virtual_network.challenge1.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_network_interface" "app" {
  name                = "app-nic"
  location            = azurerm_resource_group.challenge1.location
  resource_group_name = azurerm_resource_group.challenge1.name

  ip_configuration {
    name                          = "app-ip"
    subnet_id                     = azurerm_subnet.app.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "db" {
  name                = "db-nic"
  location            = azurerm_resource_group.challenge1.location
  resource_group_name = azurerm_resource_group.challenge1.name

  ip_configuration {
    name                          = "db-ip"
    subnet_id                     = azurerm_subnet.db.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "app" {
  name                  = "app-vm"
  location              = azurerm_resource_group.challenge1.location
  resource_group_name   = azurerm_resource_group.challenge1.name
  network_interface_ids = [azurerm_network_interface.app.id]

  vm_size     = "Standard_A2"  # Choose an appropriate size
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"
  }

  os_profile {
    computer_name  = "app-vm"
    admin_username = "azureuser"
  }

  storage_os_disk {
    name              = "app-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"  # Choose an appropriate disk type
  }
}

resource "azurerm_virtual_machine" "db" {
  name                  = "db-vm"
  location              = azurerm_resource_group.challenge1.location
  resource_group_name   = azurerm_resource_group.challenge1.name
  network_interface_ids = [azurerm_network_interface.db.id]

  vm_size     = "Standard_A2"  # Choose an appropriate size
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"
  }

  os_profile {
    computer_name  = "db-vm"
    admin_username = "azureuser"
  }
  os_profile_linux_config {
    disable_password_authentication = true
  }

  storage_os_disk {
    name              = "db-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"  # Choose an appropriate disk type
  }
}

