# resource "proxmox_virtual_environment_user" "andy_user" {
#   comment  = "Managed by Terraform"
#   password = "start2024"
#   user_id  = "andy@pve"

#   acl {
#     path      = "/vms"
#     propagate = true
#     role_id   = "PVEVMAdmin"
#   }

#   acl {
#     path      = "/mapping"
#     propagate = true
#     role_id   = "PVEAdmin"
#   }

#   lifecycle {
#     ignore_changes = [password]
#   }
# }
