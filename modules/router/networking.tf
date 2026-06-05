locals {
  public_network_suffix = var.vsc ? "_vsc" : "_public"
  vm_network_suffix     = var.vsc ? "_vm_vsc" : "_vm"
}


data "opennebula_virtual_network" "external" {
  name = "${data.opennebula_group.primary.name}${local.public_network_suffix}"
}

data "opennebula_virtual_network" "internal" {
  name = "${data.opennebula_group.primary.name}${local.vm_network_suffix}"
}

resource "opennebula_virtual_router_nic" "external" {
  floating_ip       = true
  floating_only     = true
  virtual_router_id = opennebula_virtual_router.main.id
  network_id        = data.opennebula_virtual_network.external.id
  depends_on        = [opennebula_virtual_router_instance.main]
  model             = "virtio"
}


data "opennebula_virtual_network_address_range" "internal" {
  virtual_network_id = data.opennebula_virtual_network.internal.id
  id                 = "1"
}

resource "opennebula_virtual_router_nic" "internal" {
  floating_ip       = true
  virtual_router_id = opennebula_virtual_router.main.id
  network_id        = data.opennebula_virtual_network.internal.id
  depends_on        = [opennebula_virtual_router_nic.external]
  model             = "virtio"
  ip                = data.opennebula_virtual_network_address_range.internal.ip4
}
