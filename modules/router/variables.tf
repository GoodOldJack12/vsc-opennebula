variable "port_forwards" {
  type = map(object({
    internal_ip   = optional(string)
    internal_port = optional(number)
    external_port = number
    external_ip_id = optional(number,0)
  }))
  default = {}
  validation {
    condition = (
      alltrue([
        for v in var.port_forwards :
        (
          var.vsc || v.external_port == 80 || v.external_port == 443 || v.external_port == 22 ||
          (
            v.external_port >= local.ugent_port_range.min &&
            v.external_port <= local.ugent_port_range.max
          )
        )
      ])
    )
    error_message = "External port must be 80, 443, or between ${local.ugent_port_range.min} and ${local.ugent_port_range.max}."
  }
  validation {
    condition = (
      alltrue([
        for v in var.port_forwards :
        (
          v.external_ip_id == null || v.external_ip_id <= var.external_ips
        )
      ])
    )
    error_message = "external_ip_id must be one of ${join(",",range(1,var.external_ips))}"
  }
  
  description = "List of port forwarding rules. Map of objects with following attributes: external_port (required), internal_port, internal_ip, external_ip_id"
  
}
variable "vsc" {
  default     = false
  description = "Enable to connect the router to the VSC network. Only ONE per group and you need to have requested access to the VSC network."
  type        = bool
}
variable "external_ips" {
  default = 1
  description = "Amount of external IPs"
  type = number
  validation {
    condition = var.external_ips > 0
    error_message = "You need at least one external IP!"
  }
}
