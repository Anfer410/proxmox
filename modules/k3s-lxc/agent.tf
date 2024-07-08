locals {
  agent_id = var.id + 1
  prefix   = var.prefix != "" ? "${var.prefix}-" : ""
}

module "lxc_k3s_agent" {
  source = "../container"
  count  = var.agent_number

  depends_on = [module.lxc_k3s_controlplane]

  node_id       = var.pve_details["pve_node_id"]
  node_endpoint = var.pve_details["pve_node_endpoint"]

  hostname = "${local.prefix}agent-${count.index + 1}.k3s"
  id       = local.agent_id + count.index

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
  
  ssh_private_key = var.ssh_private_key
  ssh_public_key = var.ssh_public_key 
}

output "lxc_agent_id" {
  value = module.lxc_k3s_agent[*].lxc_id
}

output "lxc_agent_ip" {
  value = module.lxc_k3s_agent[*].lxc_ip
}

resource "null_resource" "push_boot_config_agents" {
  count      = var.agent_number
  depends_on = [module.lxc_k3s_agent]

  connection {
    type     = "ssh"
    user     = var.pve_details["pve_user"]
    password = var.pve_details["pve_password"]
    host     = var.pve_details["pve_node_endpoint"]
  }

  provisioner "remote-exec" {
    when = create
    inline = [
      "pct push ${module.lxc_k3s_agent[count.index].lxc_id} /boot/config-$(uname -r) /boot/config-$(uname -r)"
    ]
  }
}

resource "null_resource" "provision_agents" {
  count      = var.agent_number
  depends_on = [null_resource.push_boot_config_agents]

  connection {
    type        = "ssh"
    user        = "root"
    host        = module.lxc_k3s_agent[count.index].lxc_ip
    private_key = var.ssh_private_key
  }

  provisioner "file" {
    source      = "${path.module}/scripts/agent.sh"
    destination = "/tmp/agent.sh"
  }

  provisioner "remote-exec" {
    when = create
    inline = [
      "chmod +x /tmp/agent.sh",
      "/tmp/agent.sh \"${split("\n", data.remote_file.node_token.content)[0]}\" \"${module.lxc_k3s_controlplane.lxc_ip}\""
    ]
  }

}