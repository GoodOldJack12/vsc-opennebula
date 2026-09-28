###
# Global settings
###
locals {
  # Range allowed through UGent firewall
  ugent_port_range = {
    min = 50000
    max = 60000
  }
}