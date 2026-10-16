# Server with disks example
This example illustrates how to create a server with disks.

**Due to an upstream bug, disks can only be added or removed upon initial creation, and resizing is not supported (They can be resized via CLI/Web UI, however).**

## Use
1) (**First time only**) Run `tofu init`
2) Run `tofu apply`
3) Type `yes` + enter
## Connecting to the VM
After running `tofu apply`, you will see something like:
```
services = {
  "Primary VM" = [
    "ssh root@10.141.2.51",
  ]
}
```
You can use that command to connect to your VM.
If you forgot the details, you can always run `tofu output` to see the outputs again.
