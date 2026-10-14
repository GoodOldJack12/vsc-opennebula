provider "opennebula" {
  endpoint = "https://cloudpr4.ugent.be:2633/RPC2"
  username = chomp(split(":", file("~/.one/one_auth"))[0])
  password = chomp(split(":", file("~/.one/one_auth"))[1])
}
variables {
  vm_name       = "SimpleExampleTest"
  image_name    = "Rocky Linux 9"
  is_windows    = false
  cpu           = 2
  memory        = 4
  rootdisk_size = 30
}
run "mainVM" {
  expect_failures = [
    check.disk_resize
  ]
}

run "router" {
  variables {
    access_vm = run.MainVM.router_access
    port_forwards = {
      http = {
        external_port = 80
        ip            = run.webVM.ip
      }
      prometheus = { # Define a port forward rule for the second VM
        external_port = 59999
        internal_port = 9090
        ip            = run.webVM.ip
      }
    }
  }
  expect_failures = [
    check.disk_resize
  ]
}
