module "fgt-cluster-fgcp-1az" {
  source  = "jmvigueras/ftnt-aws-modules/aws//examples/basic_fgt-cluster-fgcp-1az"
  version = "0.0.9"

  prefix = "fgt-cluster"

  region = "eu-west-1"
  azs    = ["eu-west-1a", "eu-west-1b"]

  fgt_number_peer_az = 1
  fgt_cluster_type = "fgcp"

  license_type  = "byol"
  instance_type = "c6i.large"
  fgt_build     = "build2726"

  fgt_vpc_cidr = "10.10.0.0/24"

  public_subnet_names_extra = ["bastion"]
  private_subnet_names_extra = ["tgw", "protected"]
}

output "fgt" {
  value = module.fgt-cluster-fgcp-1az.fgt
}

