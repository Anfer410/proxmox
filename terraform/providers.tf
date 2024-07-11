terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
    jq = {
      source  = "massdriver-cloud/jq"
      version = "0.2.0"
    }
  }

  backend "pg" {
    skip_index_creation  = true
    skip_schema_creation = true
    skip_table_creation  = true
  }
}

provider "jq" {}

provider "proxmox" {
  endpoint = "https://${var.pve_node_endpoint}:8006/"
  # api_token = "${var.pve_user}@${var.pve_realm}!${var.pve_api_token_name}=${var.pve_api_token}"
  password = var.pve_password
  username = "${var.pve_user}@${var.pve_realm}"

  insecure = true

  ssh {
    agent    = true
    username = "root"
  }
}