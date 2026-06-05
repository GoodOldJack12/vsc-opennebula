data "opennebula_virtual_network" "main" {
  name = "${data.opennebula_group.primary.name}_vm"
}
data "opennebula_virtual_network" "vsc" {
  name = "${data.opennebula_group.primary.name}_vm_vsc"
  lifecycle {
    enabled = var.vsc
  }
}
