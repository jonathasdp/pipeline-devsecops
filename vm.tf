resource "azurerm_public_ip" "pip-atividade" {
  name                = "pip-atividade"
  resource_group_name = azurerm_resource_group.rg-atividade.name
  location            = azurerm_resource_group.rg-atividade.location
  allocation_method   = "Static"

  tags = {
    faculdade = "Impacta"
  }
}

resource "azurerm_network_interface" "nic-atividade" {
  name                = "nic-atividade"
  location            = azurerm_resource_group.rg-atividade.location
  resource_group_name = azurerm_resource_group.rg-atividade.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sub-atividade.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-atividade.id
  }

  tags = {
    faculdade = "Impacta"
  }
}

resource "azurerm_network_interface_security_group_association" "nic-nsg-atividade" {
  network_interface_id      = azurerm_network_interface.nic-atividade.id
  network_security_group_id = azurerm_network_security_group.nsg-atividade.id
}

resource "azurerm_linux_virtual_machine" "vm-atividade" {
  name                            = "vm-atividade"
  resource_group_name             = azurerm_resource_group.rg-atividade.name
  location                        = azurerm_resource_group.rg-atividade.location
  size                            = "Standard_DS1_v2"
  admin_username                  = var.user_name
  admin_password                  = var.user_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic-atividade.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

resource "null_resource" "install_nginx" {
  triggers = {
    order = azurerm_linux_virtual_machine.vm-atividade.id
  }
  connection {
    type     = "ssh"
    host     = azurerm_public_ip.pip-atividade.ip_address
    user     = var.user_name
    password = var.user_password
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",
      "echo 'server { listen 80; location / { root /usr/share/nginx/html; try_files $uri $uri/ /index.html; } }' | sudo tee /etc/nginx/sites-available/default",
      "sudo systemctl restart nginx"
    ]
  }
}

output "public_ip" {
  value = azurerm_public_ip.pip-atividade.ip_address
}
