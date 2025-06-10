# FortiGate Cluster - Application Security Demo

This deployment creates a FortiGate cluster with application security features using FGCP (FortiGate Clustering Protocol) in AWS.

## Architecture

- FortiGate FGCP cluster in single AZ with 2 members
- Application security and inspection capabilities
- Protected and bastion subnets
- EKS cluster for containerized applications

## Configuration

Edit `terraform.tfvars` with your settings:

```hcl
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
```

## Deployment

1. Configure your AWS credentials
2. Edit `terraform.tfvars` with your parameters
3. Run: `./0_terraform_script.sh`

## Resources Created

- FortiGate FGCP cluster (2 instances)
- VPC with public/private subnets
- EKS cluster for application deployment
- Security groups and routing tables
- Bastion host for management access

## Clean Up

Run: `terraform destroy` when finished to avoid ongoing charges.
