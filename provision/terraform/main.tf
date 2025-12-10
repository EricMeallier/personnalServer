terraform {
  required_providers {
    vultr = {
      source = "vultr/vultr"
      version = "2.12.1"
    }
  }
}

# Configure the Vultr Provider
provider "vultr" {
  api_key = var.vultr_api_key
  rate_limit = 100
  retry_limit = 3
}

resource "vultr_ssh_key" "my_user" {
  name = "Root SSH key"
  ssh_key = file("~/.ssh/ovhuser.pub")
}

resource "vultr_instance" "my_instance" {
    plan = "vc2-2c-4gb"
    region = "cdg"
    os_id = 2625
    enable_ipv6 = false
    ssh_key_ids = ["${vultr_ssh_key.my_user.id}"]
    script_id = vultr_startup_script.bootinit.id
}

resource "vultr_startup_script" "bootinit" {
    name = "ansible-deploy"
    script = filebase64("bootinit.sh")
    type = "boot"
}
	
resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl",
    {
     main_ip = vultr_instance.my_instance.main_ip
    }
  )
  filename = "../../inventory/inventoryTerraform.yml"
}
