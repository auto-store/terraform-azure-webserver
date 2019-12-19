resource "azurerm_resource_group" "group" {
  name     = var.resource_group
  location = var.location
}

resource "azurerm_virtual_network" "public" {
  name                = var.public-network
  address_space       = ["10.50.0.0/16"]
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name
}

resource "azurerm_subnet" "public" {
  name                 = var.public-subnet 
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.50.1.0/24"
}

resource "azurerm_public_ip" "public" {
  name                = "publicip"
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "public" {
  name                = "publicfirewall"
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name

  ip_configuration {
    name                 = "publicconfig"
    subnet_id            = azurerm_subnet.public.id
    public_ip_address_id = azurerm_public_ip.public.id
  }
}

resource "azurerm_network_interface" "public" {
  name                = "webserver"
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name

  ip_configuration {
    name                          = "webserver-config"
    subnet_id                     = azurerm_subnet.public.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_virtual_machine" "main" {
  name                  = var.instance_name
  location              = azurerm_resource_group.group.location
  resource_group_name   = azurerm_resource_group.group.name
  network_interface_ids = [ azurerm_network_interface.public.id ]
  vm_size               = var.instance_size 

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "webserver"
    admin_username = var.admin
    admin_password = var.password
  }