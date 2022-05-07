locals {
  authorized_keys = join("\n", var.bastion_user_keys)
}