# resource "proxmox_virtual_environment_network_linux_bridge" "vmbr1000" {
#   count = length(data.proxmox_virtual_environment_nodes.available_nodes.names)

#   name       = "vmbr1000"
#   node_name  = data.proxmox_virtual_environment_nodes.available_nodes.names[count.index]
#   comment    = "Managed by Terraform"
#   vlan_aware = false
# }

module "k3s_cluster" {
  source = "./modules/k3s-lxc"

  id = var.id_start

  pve_details = {
    pve_api_token      = var.pve_api_token
    pve_realm          = var.pve_realm
    pve_user           = var.pve_user
    pve_password       = var.pve_password
    pve_api_token_name = var.pve_api_token_name
    pve_node_id        = var.pve_node_id
    pve_node_endpoint  = var.pve_node_endpoint
  }


  ssh_private_key = file("./keys/id_rsa")
  ssh_public_key  = file("./keys/id_rsa.pub")

  spec = {
    cpu_cores     = 4
    dedicated_ram = 4096
    swap          = 0
  }

  public_bridge = var.public_bridge

  lxc_template = var.pull_ct ? { template_id=proxmox_virtual_environment_file.debian_container_template[0].file_name } : local.debian_container_template

  agent_number = var.agent_number  
}