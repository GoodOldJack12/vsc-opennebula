variable "access_vm" {
  type = object({
    ip          = string
    ssh_port    = number
    include_rdp = bool
    command     = string
  })
  default = null
}
locals {
  external_ips = concat([opennebula_virtual_router_nic.external.ip], opennebula_virtual_router_nic.extra[*].ip)
  port_forwards_from_vm = var.access_vm == null ? {} : {
    "VM-SSH" = {
      internal_ip   = var.access_vm.ip
      external_port = var.access_vm.ssh_port
      internal_port = var.access_vm.ssh_port
      external_ip_id   = 0
    }
  }
  all_port_forwards = [
    for pf in concat(values(local.port_forwards_from_vm), values(var.port_forwards)) : {
      internal_ip   = coalesce(pf.internal_ip, var.access_vm.ip)
      internal_port = coalesce(pf.internal_port, pf.external_port)
      external_port = pf.external_port
      external_ip   = local.external_ips[pf.external_ip_id]
    }
  ]
  port_forward_context = {
    for idx, pf in local.all_port_forwards :
    "ONEAPP_VNF_NAT4_PORT_FWD${idx}" =>
    format(
      "%s:%d:%s:%d",
      pf.external_ip,
      pf.external_port,
      pf.internal_ip,
      pf.internal_port
    )
  }
  primary_vm_output = replace(var.access_vm.command, var.access_vm.ip, opennebula_virtual_router_nic.external.ip)
  

}
