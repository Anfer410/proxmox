locals {
  agent_id = var.id + 1
  prefix   = var.prefix != "" ? "${var.prefix}-" : ""
}

resource "local_file" "k3s-cluster-test" {
  depends_on = [ module.lxc_k3s_controlplane, module.lxc_k3s_agent ]
  filename = "${path.root}/../ansible/inventory-raw/${local.prefix}k3s.json"
  content  = jsonencode({ 
    "controller" = "${module.lxc_k3s_controlplane.lxc_ip}"
    "agent" = "[${ join(",", [for i in range(length(module.lxc_k3s_agent[*].lxc_ip)) : "\"${module.lxc_k3s_agent[i].lxc_ip}\""])}]"
    "ssh" = "${local.prefix}k3s.pem"
    })
}