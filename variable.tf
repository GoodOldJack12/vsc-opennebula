variable "vm_name" {
  type = string
}
variable "image_name" {
  description = "Name of the OS Image. See `oneimage list`."
}
locals {
  rootdisk_size = (var.is_windows ? max(var.rootdisk_size, 70) : var.rootdisk_size) * 1024
}
variable "rootdisk_size" {
  description = "Size of the bootdisk in Gibibyte"
  default     = 30
  type        = number
}
variable "memory" {
  description = "Memory allocated to the VM in Gibibytes"
  type        = number
  default     = null
}
variable "cpu" {
  type        = number
  description = "Real CPU cores allocated to the VM"
  default     = null
}
variable "template" {
  description = "Template to apply to the VM. Default should be OK unless you need a GPU."
  type        = string
  default     = "UserDefault" # To be changed
}
variable "vsc" {
  description = "Enable VSC network."
  default     = false
  type        = bool
}
variable "disks" {
  description = "List of disks to attach to the VM."
  type = map(object({
    size       = number
    filesystem = optional(string, "ext4")
  }))
  default = {}
}
variable "custom_context" {
  description = "Custom opennebula context to append to the VM."
  type        = map(string)
  default     = {}
}
variable "start_script" {
  description = "Script that runs ONCE after VM creation"
  type        = string
  default     = "echo"
  validation {
    condition     = var.is_windows ? (var.start_script == "echo") : true
    error_message = "start_script is incompatible with Windows!"
  }
}
variable "firewall_rules" {
  description = "Firewall rules per network ('vm' or 'vsc')"
  type = map(list(object({
    protocol  = string
    rule_type = optional(string, "INBOUND")
    range     = string
  })))
  default     = {"vm" = [], "vsc" = []}
  validation {
    condition = alltrue([
      for nic, rules in var.firewall_rules : alltrue([
        for v in rules : can(regex("^(INBOUND|OUTBOUND)$", v.rule_type))
      ])
    ])
    error_message = "rule_type must be INBOUND or OUTBOUND"
  }
  validation {
    condition = alltrue([
      for nic, rules in var.firewall_rules : alltrue([
        for v in rules : can(regex("^(ALL|TCP|UDP|ICMP|IPSEC)$", v.protocol))
      ])
    ])
    error_message = "protocol must be ALL, TCP, UDP, ICMP or IPSEC"
  }
  validation {
    condition     = alltrue([for k in keys(var.firewall_rules) : contains(["vm", "vsc"], k)])
    error_message = "Network name must be one of: vm, vsc"
  }
}
variable "firewall_services" {
  description = "Quick alternative to firewall_rules for known services per network ('vm' or 'vsc')"
  type        = map(list(string))
  default     = {"vm" = [], "vsc" = []}
  validation {
    condition = alltrue([
      for nic, services in var.firewall_services : alltrue([
        for s in services : contains(keys(local.service-templates), s)
      ])
    ])
    error_message = "Unknown service! Valid services: ${join(",", keys(local.service-templates))}"
  }
  validation {
    condition     = alltrue([for k in keys(var.firewall_services) : contains(["vm", "vsc"], k)])
    error_message = "Network must be one of: primary, secondary"
  }
}
variable "is_windows" {
  description = "Set true if image is windows based"
  type        = bool
}
variable "group" {
  default = ""
  description = "Opennebula group to create the virtual machine for."
  type = string
}
