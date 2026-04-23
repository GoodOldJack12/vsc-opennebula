data "opennebula_virtual_network" "main" {
  name = "${data.opennebula_group.primary.name}_vm"
}
data "opennebula_virtual_network" "vsc" {
  name = "${data.opennebula_group.primary.name}_vsc"
  lifecycle {
    enabled = var.vsc
  }
}
resource "opennebula_security_group" "main" {
  name        = "${var.vm_name}-security-group"
  description = "Terraform security group"

  rule {
    protocol  = "ALL"
    rule_type = "OUTBOUND"
    network_id = data.opennebula_virtual_network.main.id

  }

  rule {
    protocol  = "TCP"
    rule_type = "INBOUND"
    range     = "22"
    network_id = data.opennebula_virtual_network.main.id
  }

  rule {
    protocol  = "ICMP"
    rule_type = "INBOUND"
    network_id = data.opennebula_virtual_network.main.id
  }
  dynamic "rule" {
    for_each = var.firewall_rules["vm"]
    content {
      rule_type = rule.value.rule_type
      range     = rule.value.range
      protocol  = rule.value.protocol
      network_id = data.opennebula_virtual_network.main.id
    }
  }
  dynamic "rule" {
    for_each = {
      for name in try(var.firewall_services["vm"],[]) :
      name => local.service-templates[name]
      if contains(keys(local.service-templates), name)
    }

    content {
      protocol   = rule.value.protocol
      range      = try(rule.value.range, null)
      rule_type  = try(rule.value.rule_type, "INBOUND")
      network_id = data.opennebula_virtual_network.main.id
    }
  }
}

resource "opennebula_security_group" "vsc" {
  name        = "${var.vm_name}-security-group-vsc"
  description = "Terraform security group"
  rule {
    protocol  = "ALL"
    rule_type = "OUTBOUND"
    network_id = data.opennebula_virtual_network.vsc.id
  }
  dynamic "rule" {
    for_each = var.firewall_rules["vsc"]
    content {
      rule_type = rule.value.rule_type
      range     = rule.value.range
      protocol  = rule.value.protocol
      network_id = data.opennebula_virtual_network.vsc.id
    }
  }
  dynamic "rule" {
    for_each = {
      for name in try(var.firewall_services["vsc"],[]) :
      name => local.service-templates[name]
      if contains(keys(local.service-templates), name)
    }

    content {
      protocol   = rule.value.protocol
      range      = try(rule.value.range, null)
      rule_type  = try(rule.value.rule_type, "INBOUND")
      network_id = data.opennebula_virtual_network.vsc.id
    }
  }
  lifecycle {
    enabled = var.vsc
  }
}
locals {
  service-templates = {
    ssh = {
      range    = 22
      protocol = "TCP"
    }
    http = {
      range    = "80,443"
      protocol = "TCP"
    }
    rdp = {
      range    = 3389
      protocol = "TCP"
    }
    nfs = {
      range    = 2049
      protocol = "TCP"
    }
    smb = {
      range    = 445
      protocol = "TCP"
    }
    all-local = {
      rule_type  = "INBOUND"
      protocol   = "ALL"
      network_id = data.opennebula_virtual_network.main.id
    }
  }
}
