locals {
  debian_container_template = {
    template_file_id = var.debian_image_location
    type             = "debian"
  }
}

data "proxmox_virtual_environment_nodes" "available_nodes" {}

output "available_nodes" {
  value = data.proxmox_virtual_environment_nodes.available_nodes.names
}

resource "proxmox_virtual_environment_file" "debian_container_template" {
  count = var.pull_ct ? 1 : 0

  content_type = "vztmpl"
  datastore_id = "local"
  node_name = var.pve_node_id

  source_file {
    path = "http://download.proxmox.com/images/system/debian-12-standard_12.2-1_amd64.tar.zst"
  }

}
