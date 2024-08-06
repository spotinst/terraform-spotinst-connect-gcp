locals {
  name            = var.name == null ? var.project : var.name
  spotinst_token  = var.debug == true ? nonsensitive(var.spotinst_token) : var.spotinst_token
}