#-----------------------------------------------------------------------------------------------------
# FortiGate Terraform deployment
# Active Passive High Availability MultiAZ with AWS Transit Gateway with VPC standard attachment
#-----------------------------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Create FGT cluster:
# - VPC
# - FGT NI and SG
# - Fortigate config
# - FGT instance
#------------------------------------------------------------------------------
# Create VPC for hub EU
module "fgt_vpc" {
  source  = "jmvigueras/ftnt-aws-modules/aws//modules/vpc"
  version = "0.0.8"

  prefix     = "${var.prefix}-fgcp"
  admin_cidr = var.admin_cidr
  region     = var.region
  azs        = var.azs

  cidr = var.fgt_vpc_cidr

  public_subnet_names  = local.public_subnet_names
  private_subnet_names = local.private_subnet_names
}
# Create FGT NIs
module "fgt_nis" {
  source  = "jmvigueras/ftnt-aws-modules/aws//modules/fgt_ni_sg"
  version = "0.0.8"

  prefix = "${var.prefix}-fgcp"
  azs    = var.azs

  vpc_id      = module.fgt_vpc.vpc_id
  subnet_list = module.fgt_vpc.subnet_list

  subnet_tags     = local.subnet_tags
  fgt_subnet_tags = local.fgt_subnet_tags

  fgt_number_peer_az = var.fgt_number_peer_az
  cluster_type       = var.fgt_cluster_type
}
# Create FGTs config
module "fgt_config" {
  for_each = { for k, v in module.fgt_nis.fgt_ports_config : k => v }
  source   = "jmvigueras/ftnt-aws-modules/aws//modules/fgt_config"
  version  = "0.0.8"

  admin_cidr     = var.admin_cidr
  admin_port     = var.admin_port
  rsa_public_key = tls_private_key.ssh.public_key_openssh
  api_key        = random_string.api_key.result

  ports_config = each.value

  config_fgcp       = var.fgt_cluster_type == "fgcp" ? true : false
  config_fgsp       = var.fgt_cluster_type == "fgsp" ? true : false
  config_auto_scale = var.fgt_cluster_type == "fgsp" ? true : false

  fgt_id     = each.key
  ha_members = module.fgt_nis.fgt_ports_config

  static_route_cidrs = [var.fgt_vpc_cidr] //necessary routes to stablish BGP peerings and bastion connection
}
# Create FGT for hub EU
module "fgt" {
  source  = "jmvigueras/ftnt-aws-modules/aws//modules/fgt"
  version = "0.0.8"

  prefix        = "${var.prefix}-fgcp"
  region        = var.region
  instance_type = var.instance_type
  keypair       = trimspace(aws_key_pair.keypair.key_name)

  license_type = var.license_type
  fgt_build    = var.fgt_build

  fgt_ni_list = module.fgt_nis.fgt_ni_list
  fgt_config  = { for k, v in module.fgt_config : k => v.fgt_config }
}

#------------------------------------------------------------------------------
# General resources
#------------------------------------------------------------------------------
# Create key-pair
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
resource "aws_key_pair" "keypair" {
  key_name   = "${var.prefix}-eu-keypair"
  public_key = tls_private_key.ssh.public_key_openssh
}
resource "local_file" "ssh_private_key_pem" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "./ssh-key/${var.prefix}-ssh-key.pem"
  file_permission = "0600"
}
# Create new random API key to be provisioned in FortiGates.
resource "random_string" "api_key" {
  length  = 30
  special = false
  numeric = true
}
# Create new random API key to be provisioned in FortiGates.
resource "random_string" "vpn_psk" {
  length  = 20
  special = false
  numeric = true
}