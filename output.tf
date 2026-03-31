output "ssh" {
  description = "SSH Command to use for connecting. (local IP)"
  value       = local.ssh-command
}
output "rdp" {
  description = "RDP Command to use for connecting. (local IP)"
  value       = local.rdp-command
}
output "ip" {
  description = "Local VM IP."
  value       = opennebula_virtual_machine.main.ip
}
output "router_access" {
  description = "Returns information for the router module."
  value = {
    ip          = opennebula_virtual_machine.main.ip
    include_rdp = var.is_windows
    ssh_port    = local.ports.ssh
    rdp_port    = local.ports.rdp
    vm_name     = var.vm_name
    commands    = compact([local.ssh-command, local.rdp-command])
  }
}
locals {
  ssh-user = var.is_windows ? "Admin" : "root"
  ports = {
    ssh   = 22
    http  = 80
    https = 443
    rdp   = 3389
  }
  ssh-command = "ssh ${local.ssh-user}@${opennebula_virtual_machine.main.ip}"
  rdp-command = var.is_windows ? "xfreerdp /dynamic-resolution /v:${opennebula_virtual_machine.main.ip} /p:${random_pet.windows.id} /u:admin" : ""
}
