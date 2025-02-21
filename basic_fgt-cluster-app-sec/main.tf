# ----------------------------------------------------------------------------------------
# Variables
# ----------------------------------------------------------------------------------------
variable "prefix" {
  description = "Prefix to configured items in Azure"
  type        = string
  default     = "fgt-ha-xlb"
}

variable "custom_vars" {
  description = "Custom variables"
  type = object({
    region                     = optional(string, "eu-west-1")
    fgt_build                  = optional(string, "build2731")
    license_type               = optional(string, "payg")
    fgt_size                   = optional(string, "c6i.large")
    fgt_cluster_type           = optional(string, "fgcp")
    fgt_number_peer_az         = optional(number, 1)
    number_azs                 = optional(number, 2)
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
module "fgt-cluster" {
  source  = "jmvigueras/ftnt-aws-modules/aws//examples/basic_fgt-cluster"
  version = "0.0.14"

  prefix = var.prefix

  region = var.custom_vars["region"]
  azs    = local.azs

  fgt_build     = var.custom_vars["fgt_build"]
  license_type  = var.custom_vars["license_type"]
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
  keypair       = module.fgt-cluster.keypair_name
  instance_type = var.custom_vars["k8s_size"]

  user_data = local.k8s_user_data

  subnet_id       = module.fgt-cluster.subnet_ids["az1"]["bastion"]
  subnet_cidr     = module.fgt-cluster.subnet_cidrs["az1"]["bastion"]
  security_groups = [module.fgt-cluster.sg_ids["default"]]
}

output "fgt" {
  value = module.fgt-cluster.fgt
}

output "k8s" {
  value = module.k8s.vm
}

locals {
  # K8S configuration and APP deployment
  k8s_deployment = templatefile("./templates/k8s-dvwa-swagger.yaml.tp", {
    dvwa_nodeport    = "31000"
    swagger_nodeport = "31001"
    swagger_host     = element(module.fgt-cluster.fgt_ni_list["az1.fgt1"].public_eips, 0)
    swagger_url      = "http://${element(module.fgt-cluster.fgt_ni_list["az1.fgt1"].public_eips, 0)}:31001"
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
# Access and secret keys
variable "access_key" {}
variable "secret_key" {}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.custom_vars["region"]
}

# Prepare to add backend config from CLI
terraform {
  backend "s3" {}
}