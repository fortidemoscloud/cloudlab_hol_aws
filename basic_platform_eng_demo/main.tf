# ----------------------------------------------------------------------------------------
# Variables
# ----------------------------------------------------------------------------------------
variable "prefix" {
  description = "Prefix to configured items in AWS"
  type        = string
  default     = "ptf-eng-demo"
}

variable "fortiflex_token" {
  description = "FortiFlex token"
  type        = string
  default     = ""
}

variable "custom_vars" {
  description = "Custom variables"
  type = object({
    region                     = optional(string, "eu-west-1")
    fgt_build                  = optional(string, "build2731")
    license_type               = optional(string, "byol")
    fgt_size                   = optional(string, "c6i.large")
    fgt_cluster_type           = optional(string, "fgcp")
    fgt_number_peer_az         = optional(number, 1)
    number_azs                 = optional(number, 1)
    fgt_vpc_cidr               = optional(string, "172.10.0.0/23")
    public_subnet_names_extra  = optional(list(string), ["bastion"])
    private_subnet_names_extra = optional(list(string), ["protected"])
    k8s_size                   = optional(string, "t3.2xlarge")
    k8s_version                = optional(string, "1.31")
    tags                       = optional(map(string), { "Deploy" = "CloudLab AWS", "Project" = "CloudLab" })
  })
  default = {}
}

#--------------------------------------------------------------------------------------------------------------
# FGT Cluster module example
# - 1 FortiGate cluster FGCP in 2 AZ
#--------------------------------------------------------------------------------------------------------------
module "fgt" {
  source = "./modules/fgt"

  prefix = var.prefix

  region = var.custom_vars["region"]
  azs    = local.azs

  fgt_build = var.custom_vars["fgt_build"]

  license_type    = var.custom_vars["license_type"]
  fortiflex_token = var.fortiflex_token

  instance_type = var.custom_vars["fgt_size"]

  fgt_number_peer_az = var.custom_vars["fgt_number_peer_az"]
  fgt_cluster_type   = var.custom_vars["fgt_cluster_type"]

  fgt_vpc_cidr               = var.custom_vars["fgt_vpc_cidr"]
  public_subnet_names_extra  = var.custom_vars["public_subnet_names_extra"]
  private_subnet_names_extra = var.custom_vars["private_subnet_names_extra"]
}

#--------------------------------------------------------------------------------------------------------------
# K8S server
# - Two applications deployed
#--------------------------------------------------------------------------------------------------------------
module "k8s" {
  source  = "jmvigueras/ftnt-aws-modules/aws//modules/vm"
  version = "0.0.14"

  prefix        = var.prefix
  keypair       = module.fgt.keypair_name
  instance_type = var.custom_vars["k8s_size"]

  user_data = local.k8s_user_data

  subnet_id       = module.fgt.subnet_ids["az1"]["bastion"]
  subnet_cidr     = module.fgt.subnet_cidrs["az1"]["bastion"]
  security_groups = [module.fgt.sg_ids["default"]]
}


locals {
  # K8S configuration and APP deployment
  k8s_deployment = templatefile("./templates/voteapp.yml.tp", {
    node_port = "31000"
    }
  )
  k8s_user_data = templatefile("./templates/k8s.sh.tp", {
    k8s_version    = var.custom_vars["k8s_version"]
    linux_user     = "ubuntu"
    k8s_deployment = local.k8s_deployment
    }
  )
}

#-------------------------------------------------------------------------------------------------------------
# Data and Locals
#-------------------------------------------------------------------------------------------------------------
data "aws_availability_zones" "available" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, lookup(var.custom_vars, "number_azs", 2))
}

#-------------------------------------------------------------------------------------------------------------
# Terraform Backend config
#-------------------------------------------------------------------------------------------------------------
provider "aws" {
  region = var.custom_vars["region"]
}

# Prepare to add backend config from CLI
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.94.0"
    }
  }
  backend "s3" {}
}