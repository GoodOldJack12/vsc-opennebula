check "disk_resize" {
  assert {
    condition     = opennebula_virtual_machine.main.disk[0].computed_size == local.rootdisk_size
    error_message = "Disk 0 is ${opennebula_virtual_machine.main.disk[0].computed_size} MiB, expected ${local.rootdisk_size}. Resize the disk via the dashboard or with: `onevm disk-resize ${opennebula_virtual_machine.main.id} 0 ${local.rootdisk_size}`"
  }
}
check "disk_count" {
  assert {
    condition     = (length(opennebula_virtual_machine.main.disk) - 1) == length(var.disks)
    error_message = "Some disks in var.disks are not mounted. Mount them to the VM manually!"
  }
}