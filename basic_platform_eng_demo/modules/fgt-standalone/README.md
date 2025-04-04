# Example: Forigate deployment

This is an example of how to deploy fortigates using [ftnt-aws-modules](https://registry.terraform.io/modules/jmvigueras/ftnt-aws-modules/aws/latest)

You can choose type of cluster to deploy, number of AZs to deploy and number of FortiGate cluster members.

> [!NOTE]
> FGCP cluster has two members only and can be deployed in 1 or 2 AZs
> FGSP cluster can have up to 16 members, recommended no more than 8 and can be split in several AZs.

## Deployment Overview

```hcl

# Example 1: FGT cluster FGCP in 1 AZ with 2 members

module "fgt-cluster-fgcp-1az" {
  source  = "jmvigueras/ftnt-aws-modules/aws//examples/basic_fgt-cluster-fgcp-1az"
  version = "0.0.12"

  prefix = "fgt-cluster-fgcp-1az"

  region = "eu-west-1"
  azs    = ["eu-west-1a"]

  fgt_number_peer_az = 2
  fgt_cluster_type = "fgcp"

  license_type  = "byol"
  instance_type = "c6i.large"
  fgt_build     = "build2726"

  fgt_vpc_cidr = "10.10.0.0/24"

  public_subnet_names_extra = ["bastion"]
  private_subnet_names_extra = ["tgw","protected"]
}

# Example 2: FGT cluster FGCP in 2 AZ with 2 members
 
module "fgt-cluster-fgcp-2az" {
  source  = "jmvigueras/ftnt-aws-modules/aws//examples/basic_fgt-cluster-fgcp-1az"
  version = "0.0.12"

  prefix = "fgt-cluster-fgcp-1az"

  region = "eu-west-1"
  azs    = ["eu-west-1a", "eu-west-1b"]

  fgt_number_peer_az = 1
  fgt_cluster_type = "fgcp"

  license_type  = "byol"
  instance_type = "c6i.large"
  fgt_build     = "build2726"

  fgt_vpc_cidr = "10.10.0.0/24"

  public_subnet_names_extra = ["bastion"]
  private_subnet_names_extra = ["tgw","protected"]
}

# Example 3: FGT cluster FGSP in 3 AZ with 3 members
 
module "fgt-cluster-fgsp-3az" {
  source  = "jmvigueras/ftnt-aws-modules/aws//examples/basic_fgt-cluster-fgcp-1az"
  version = "0.0.12"

  prefix = "fgt-cluster-fgcp-1az"

  region = "eu-west-1"
  azs    = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

  fgt_number_peer_az = 1
  fgt_cluster_type = "fgsp"

  license_type  = "byol"
  instance_type = "c6i.large"
  fgt_build     = "build2726"

  fgt_vpc_cidr = "10.10.0.0/24"

  public_subnet_names_extra = ["bastion"]
  private_subnet_names_extra = ["tgw", "gwlb"]
}

# Example 4: FGT cluster FGSP in 1 AZ with 2 members
 
module "fgt-cluster-fgsp-1az" {
  source  = "jmvigueras/ftnt-aws-modules/aws//examples/basic_fgt-cluster-fgcp-1az"
  version = "0.0.12"

  prefix = "fgt-cluster-fgcp-1az"

  region = "eu-west-1"
  azs    = ["eu-west-1a"]

  fgt_number_peer_az = 2
  fgt_cluster_type = "fgsp"

  license_type  = "byol"
  instance_type = "c6i.large"
  fgt_build     = "build2726"

  fgt_vpc_cidr = "10.10.0.0/24"

  public_subnet_names_extra = ["bastion"]
  private_subnet_names_extra = ["tgw", "gwlb"]
}
```

## Requirements
* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) >= 1.5.0
* Check particulars requiriments for each deployment (AWS) 

## Deployment

# Support
This a personal repository with goal of testing and demo Fortinet solutions on the Cloud. No support is provided and must be used by your own responsability. Cloud Providers will charge for this deployments, please take it in count before proceed.


