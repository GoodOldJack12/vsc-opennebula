###
# Global settings
###
locals {
  # Resource limits
  # VMs exceeding these limits will be shut down
  MAX_MEMORY = 368640
  MAX_CPU    = 20
}