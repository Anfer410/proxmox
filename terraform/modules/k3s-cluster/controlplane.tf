module "lxc_k3s_controlplane" {
  source = "../container"

  node_id       = var.pve_details["pve_node_id"]
  node_endpoint = var.pve_details["pve_node_endpoint"]

  id       = var.id
  hostname = "${local.prefix}controlplane.k3s"

  pve_user       = var.pve_details["pve_user"]
  pve_realm      = var.pve_details["pve_realm"]
  pve_api_token  = var.pve_details["pve_api_token"]
  pve_token_name = var.pve_details["pve_api_token_name"]

  lxc_template = var.lxc_template

  rootfs = var.rootfs
  
  network_interfaces = {
    "veth0" = {
      bridge = var.public_bridge
    }
  }

  spec = var.spec

  started      = true
  unprivileged = false
  tags         = var.tags

  features_nesting = true
  features_fuse    = true

  ssh_public_key = trimspace(module.auth.public_key)

}

resource "null_resource" "controlplane_replacement_trigger" {
  depends_on = [module.lxc_k3s_controlplane]
  triggers = {
    ip = module.lxc_k3s_controlplane.lxc_ip
    id = module.lxc_k3s_controlplane.lxc_id
  }
}


resource "null_resource" "push_boot_config_controller" {
  depends_on = [module.lxc_k3s_controlplane]
  lifecycle {
    replace_triggered_by = [null_resource.controlplane_replacement_trigger]
  }

  connection {
    type     = "ssh"
    user     = var.pve_details["pve_user"]
    password = var.pve_details["pve_password"]
    host     = var.pve_details["pve_node_endpoint"]
  }

  provisioner "remote-exec" {
    when = create
    inline = [
      "pct push ${module.lxc_k3s_controlplane.lxc_id} /boot/config-$(uname -r) /boot/config-$(uname -r)"
    ]
  }
}

output "lxc_id" {
  value = module.lxc_k3s_controlplane.lxc_id
}

output "lxc_ip" {
  value = module.lxc_k3s_controlplane.lxc_ip
}





# resource "null_resource" "provision_controlplane_controller" {
#   depends_on = [null_resource.push_boot_config_controller]
#   lifecycle {
#     replace_triggered_by = [null_resource.controlplane_replacement_trigger]
#   }

#   connection {
#     type        = "ssh"
#     user        = "root"
#     host        = module.lxc_k3s_controlplane.lxc_ip
#     private_key = var.ssh_private_key
#   }

#   provisioner "file" {
#     source      = "${path.module}/scripts/controlplane.sh"
#     destination = "/tmp/controlplane.sh"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "chmod +x /tmp/controlplane.sh",
#       "/tmp/controlplane.sh"
#     ]
#   }
# }

# data "remote_file" "node_token" {
#   depends_on = [ null_resource.provision_controlplane_controller ]
#   conn {
#     user        = "root"
#     host        = module.lxc_k3s_controlplane.lxc_ip
#     private_key = var.ssh_private_key
#   }

#   path = "/var/lib/rancher/k3s/server/node-token"
# }
