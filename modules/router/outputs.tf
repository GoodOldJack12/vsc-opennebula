output "router-ip" {
  description = "Outputs the external IP of the router"
  value       = opennebula_virtual_router_nic.external.ip
}
output "services_list" {
  description = "Outputs the services that the router exposes"
  value = merge(
    { "Primary VM" = local.primary_vm_output },
    { for name, svc in var.port_forwards :
      "${name}" => "${local.external_ips[svc.external_ip_id]}:${svc.external_port}"
    }
  )
}
output "private-ip" {
  value = opennebula_virtual_router_nic.internal.ip
}
