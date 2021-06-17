# Creamos una máquina virtual
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine

resource "azurerm_linux_virtual_machine" "myVM1" {
    name                = "master"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    size                = var.vm_size
    admin_username      = var.ssh_user
    network_interface_ids = [ azurerm_network_interface.myNic1.id ]
    disable_password_authentication = true
    computer_name = "master.ipxsistemas.com"
    

    admin_ssh_key {
        username   = var.ssh_user
        public_key = file(var.public_key_path)
    }

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    plan {
        name      = "centos-8-stream-free"
        product   = "centos-8-stream-free"
        publisher = "cognosys"
    }

    source_image_reference {
        publisher = "cognosys"
        offer     = "centos-8-stream-free"
        sku       = "centos-8-stream-free"
        version   = "1.2019.0810"
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.stAccount.primary_blob_endpoint
    }

    tags = {
        environment = "CP2"
    }
/*
    provisioner "file" {
        source      = "custom_files/hosts"
        destination = "/etc/hosts"

        connection {
            type     = "ssh"
            user     = var.ssh_user
            password = "${var.root_password}"
            host     = "${var.host}"
  }
    }
    provisioner "file" {
        connection {
            type = "ssh"
            user = "ubuntu"
            host = azurerm_public_ip.terraform-PUBLIC-IP.ip_address
            private_key = file("/home/ubuntu/.ssh/id_rsa")
            agent    = false
            timeout  = "10m"
    }
        source = "/home/ubuntu/.ssh/terraform.pub"
        destination = "/home/ubuntu/.ssh/terraform.pub"
  }

    */
}