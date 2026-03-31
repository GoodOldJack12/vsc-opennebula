data "opennebula_user" "me" {
  name = chomp(split(":", file("~/.one/one_auth"))[0])
}
data "opennebula_group" "primary" {
  name = var.group != "" ? var.group : null
  id = var.group == "" ? data.opennebula_user.me.primary_group : null
}

data "opennebula_image" "image" {
  name = var.image_name
}
data "opennebula_template" "template" {
  name = var.template
}
resource "random_pet" "windows" {
  count  = var.is_windows ? 1 : 0
  length = 3
}
