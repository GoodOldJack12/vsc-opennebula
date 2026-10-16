# VSC networking example
This example illustrates how to run a simple server with access to the VSC networking

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
