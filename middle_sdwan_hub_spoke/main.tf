#--------------------------------------------------------------------------------------------------------------
# Locals
#--------------------------------------------------------------------------------------------------------------
locals {
  hubs = concat(module.hub_aws_1.hubs, module.hub_aws_2.hubs)

  hub_aws_1 = [
  {
    id            = "hubAWS"
    bgp_asn_hub   = "65000"
    bgp_asn_spoke = "65000"
    vpn_cidr      = "172.16.1.0/24"
    vpn_psk       = random_string.vpn_psk.result
    cidr          = "10.0.0.0/8" // network to be announces by BGP to peers
    vpn_port      = "public"
  }
]

hub_aws_2 = [
  {
    id            = "hubAWS"
    bgp_asn_hub   = "65000"
    bgp_asn_spoke = "65000"
    vpn_cidr      = "172.16.2.0/24"
    vpn_psk       = random_string.vpn_psk.result
    cidr          = "10.0.0.0/8" // network to be announces by BGP to peers
    vpn_port      = "public"
  }
]
}

#--------------------------------------------------------------------------------------------------------------
# FGT HUBs
#--------------------------------------------------------------------------------------------------------------
module "hub_aws_1" {
  source = "github.com/jmvigueras/aws-fgt-cluster-module?ref=v1.0.3"

  # Add custom variables
  prefix = "${var.prefix}-hub-aws-1"
  region = "eu-south-2"
  azs    = ["eu-south-2a"]

  instance_type = "c6in.large"

  fgt_vpc_cidr = "10.0.1.0/24"

  config_hub = true
  hub        = local.hub_aws_1

  tags       = var.custom_vars["tags"]
}

module "hub_aws_2" {
  source = "github.com/jmvigueras/aws-fgt-cluster-module?ref=v1.0.3"

  # Add custom variables
  prefix = "${var.prefix}-hub-aws-2"
  region = "eu-west-1"
  azs    = ["eu-west-1a"]

  instance_type = "c6in.large"

  fgt_vpc_cidr = "10.0.2.0/24"

  config_hub = true
  hub        = local.hub_aws_2

  tags       = var.custom_vars["tags"]
}

#--------------------------------------------------------------------------------------------------------------
# FGT Spokes
#--------------------------------------------------------------------------------------------------------------
module "spoke_aws" {
  source = "github.com/jmvigueras/aws-fgt-cluster-module?ref=v1.0.3"
  
  # Add custom variables
  prefix = "${var.prefix}-spoke"
  region = "eu-west-1"
  azs    = ["eu-west-1a"]

  fgt_vpc_cidr = "192.168.0.0/24"

  config_spoke = true
  spoke = {
    id      = "spoke-eu-west"
    cidr    = "192.168.0.0/24"
    bgp_asn = "65000"
  }
  hubs = local.hubs

  tags = var.custom_vars["tags"]
}

#--------------------------------------------------------------------------------------------------------------
# General resources
#--------------------------------------------------------------------------------------------------------------
resource "random_string" "vpn_psk" {
  length  = 20
  special = false
  numeric = true
}

#--------------------------------------------------------------------------------------------------------------
# Backend
#--------------------------------------------------------------------------------------------------------------
terraform {
  backend "s3" {}
}