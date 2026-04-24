output "router-ip" {
  description = "Outputs the external IP of the router"
  value       = opennebula_virtual_router_nic.external.ip
}
output "services_list" {
  description = "Outputs the services that the router exposes"
  value = merge(
    { "Primary VM" = local.primary_vm_output },
    { for name, svc in var.port_forwards :
      "${name}" => "${ svc.network == "public" ? opennebula_virtual_router_nic.external.ip : opennebula_virtual_router_nic.vsc.ip}:${svc.external_port}"
    }
  )
}
output "private-ip" {
  value = opennebula_virtual_router_nic.internal.ip
}
output "vsc-ip" {
  description = "Outputs the VSC IP of the router (if enabled)"
  value = try(opennebula_virtual_router_nic.vsc.ip,"N/A")
}
