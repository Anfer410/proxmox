module "k3s_cluster_test" {
  source = "./modules/k3s-cluster"

  id = 2000
  prefix = "test"

  pve_details = {
    pve_api_token      = var.pve_api_token
    pve_realm          = var.pve_realm
    pve_user           = var.pve_user
    pve_password       = var.pve_password
    pve_api_token_name = var.pve_api_token_name
    pve_node_id        = var.pve_node_id
    pve_node_endpoint  = var.pve_node_endpoint
  }

  spec = {
    cpu_cores     = 4
    dedicated_ram = 4096
    swap          = 0
  }

  public_bridge = var.public_bridge
  lxc_template = local.debian_container_template

  agent_number = 2
}

output "controller" {
  value = zipmap([module.k3s_cluster_test.lxc_id], [module.k3s_cluster_test.lxc_ip])
}

output "agents" {
  value = zipmap(module.k3s_cluster_test.lxc_agent_id, module.k3s_cluster_test.lxc_agent_ip)
}