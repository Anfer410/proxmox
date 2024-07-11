resource "proxmox_virtual_environment_container" "lxc_container" {
  description = "Managed by Terraform"

  node_name = var.node_id
  vm_id     = var.id

  unprivileged = var.unprivileged

  initialization {
    hostname = var.hostname

    user_account {
      password = var.password
      keys = [
        var.ssh_public_key
      ]
    }

    dynamic "ip_config" {
      for_each = var.network_interfaces

      content {
        dynamic "ipv4" {
          for_each = ip_config.value["ip_config"] != null ? (ip_config.value["ip_config"]["ipv4"] != null ? [ip_config.value["ip_config"]["ipv4"]["address"]] : ["default"]) : ["default"]
          content {
            address = ipv4.value != "default" ? ip_config.value["ip_config"]["ipv4"]["address"] : "dhcp"
            gateway = ipv4.value != "default" ? ip_config.value["ip_config"]["ipv4"]["gateway"] : null
          }
        }
        dynamic "ipv6" {
          for_each = ip_config.value["ip_config"] != null ? ip_config.value["ip_config"]["ipv6"] != null ? [ip_config.value["ip_config"]["ipv6"]["address"]] : [] : []
          content {
            address = ip_config.value["ip_config"]["ipv6"] != null ? ip_config.value["ip_config"]["ipv6"]["address"] : null
            gateway = ip_config.value["ip_config"]["ipv6"] != null ? ip_config.value["ip_config"]["ipv6"]["gateway"] : null
          }
        }
      }
    }
  }

  dynamic "network_interface" {
    for_each = var.network_interfaces

    content {
      name    = network_interface.key
      bridge  = network_interface.value["bridge"]
      enabled = network_interface.value["enabled"]
      vlan_id = network_interface.value["vlan"]
    }

  }

  operating_system {
    template_file_id = var.lxc_template["template_file_id"]
    type             = var.lxc_template["type"]
  }

  disk {
    datastore_id = var.rootfs.datastore_id
    size         = var.rootfs.size
  }

  cpu {
    cores = var.spec["cpu_cores"]
  }

  memory {
    swap      = var.spec["swap"]
    dedicated = var.spec["dedicated_ram"]
  }

  pool_id = var.pool_id
  tags    = var.tags

  lifecycle {
    ignore_changes = [started, initialization[0].user_account[0].password, initialization[0].hostname]
  }
  start_on_boot = var.start_on_boot
  started       = var.started

  features {
    fuse    = var.features_fuse
    nesting = var.features_nesting
  }
}

resource "time_sleep" "wait_30_seconds" {
  depends_on      = [proxmox_virtual_environment_container.lxc_container]
  create_duration = "30s"
}


data "http" "lxc_ip" {
  depends_on = [time_sleep.wait_30_seconds]

  url      = "https://${var.node_endpoint}:8006/api2/json/nodes/${var.node_id}/lxc/${var.id}/interfaces"
  insecure = true
  method   = "GET"
  request_headers = {
    Authorization = "PVEAPIToken=${var.pve_user}@${var.pve_realm}!${var.pve_token_name}=${var.pve_api_token}"
  }

  retry {
    attempts = 3
  }
}

data "jq_query" "lxc_ip" {
  depends_on = [data.http.lxc_ip]
  data       = data.http.lxc_ip.response_body
  query      = ".data[] | select(.name==\"${proxmox_virtual_environment_container.lxc_container.network_interface[0].name}\").inet | split(\"/\")[0]"
}


output "lxc_ip" {
  value = jsondecode(data.jq_query.lxc_ip.result)
}

output "lxc_id" {
  value = var.id
}

output "lxc_hostname" {
  value = var.hostname
}

output "lxc_user" {
  value     = "root"
}

# output "lxc_user_password" {
#   value     = var.password
#   sensitive = true
# }

# output "lxc_ssh_private_key" {
#   value = var.ssh_private_key
# }

# output "lxc_ssh_public_key" {
#   value = var.ssh_public_key
# }

# resource "local_file" "private_key_file" {
#   filename        = "${path.module}/../../keys/${var.id}.pem"
#   content         = var.ssh_private_key
#   file_permission = 0400
# }