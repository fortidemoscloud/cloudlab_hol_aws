# Example: Forigate deployment

This is an example of how to deploy fortigates using [ftnt-aws-modules](https://registry.terraform.io/modules/jmvigueras/ftnt-aws-modules/aws/latest)

## Deployment Overview

```hcl

# FGT cluster FGCP in 1 AZ with 2 members

# Define custom_vars at terraform.tfstate or use terraform cli -var option. 
custom_vars = {
    prefix                     = "fgt-appsec"
    region                     = "eu-west-1"
    fgt_build                  = "build2731"
    license_type               = "payg"
    fgt_size                   = "c6i.large"
    fgt_cluster_type           = "fgcp"
    fgt_number_peer_az         = 1
    number_azs                 = 2
    fgt_vpc_cidr               = "172.10.0.0/23"
    public_subnet_names_extra  = ["bastion"]
    private_subnet_names_extra = ["protected"]
    k8s_size                   = "t3.2xlarge"
    k8s_version                = "1.31"
    tags                       = { "Deploy" = "CloudLab AWS", "Project" = "CloudLab" }
}

# FGT cluster module
module "fgt-cluster" {
  source  = "jmvigueras/ftnt-aws-modules/aws//examples/basic_fgt-cluster"
  version = "0.0.12"

  prefix = var.custom_vars["prefix"]

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
```

## Requirements
* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) >= 1.5.0
* Check particulars requiriments for each deployment (AWS) 

## Deployment

# Support
This a personal repository with goal of testing and demo Fortinet solutions on the Cloud. No support is provided and must be used by your own responsability. Cloud Providers will charge for this deployments, please take it in count before proceed.


