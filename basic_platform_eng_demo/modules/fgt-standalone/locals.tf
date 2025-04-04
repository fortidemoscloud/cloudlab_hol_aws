#-----------------------------------------------------------------------------------------------------
# FortiGate Terraform deployment
# Active Passive High Availability MultiAZ with AWS Transit Gateway with VPC standard attachment
#-----------------------------------------------------------------------------------------------------
locals {
  # map tags used in fgt_subnet_tags to tag subnet names (this valued are define in modules as default)
  subnet_tags = var.subnet_tags != null ? var.subnet_tags : {
    "public"  = "public"
    "private" = "private"
    "mgmt"    = "mgmt"
    "ha"      = "ha"
  }

  # fgt_subnet_tags -> add tags to FGT subnets (port1, port2, public, private ...)
  #      - leave blank or don't add elements to not create a ports
  #      - FGCP type of cluster requires a management port
  #      - port1 must have Internet access in terms of validate license in case of using FortiFlex token or lic file.
  fgt_subnet_tags = var.fgt_subnet_tags != null ? var.fgt_subnet_tags : {
    "port1.${local.subnet_tags["public"]}"  = "untrusted"
    "port2.${local.subnet_tags["private"]}" = "trusted"
    "port3.${local.subnet_tags["mgmt"]}"    = var.fgt_cluster_type == "fgcp" ? "mgmt" : ""
    "port4.${local.subnet_tags["ha"]}"      = ""
  }

  # List of subnet names for FortiGate public and private subnets
  fgt_public_subnets  = [local.fgt_subnet_tags["port1.${local.subnet_tags["public"]}"], local.fgt_subnet_tags["port3.${local.subnet_tags["mgmt"]}"]]
  fgt_private_subnets = [local.fgt_subnet_tags["port2.${local.subnet_tags["private"]}"], local.fgt_subnet_tags["port4.${local.subnet_tags["ha"]}"]]

  # List of subnet names in FortiGate VPC
  public_subnet_names  = concat(local.fgt_public_subnets, var.public_subnet_names_extra)
  private_subnet_names = concat(local.fgt_private_subnets, var.private_subnet_names_extra)

}
