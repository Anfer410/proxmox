terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.43.3"
    }
    jq = {
      source  = "massdriver-cloud/jq"
      version = ">=0.2.0"
    }
    remote = {
      source = "tenstad/remote"
      version = ">=0.1.3"
    }
  }
}