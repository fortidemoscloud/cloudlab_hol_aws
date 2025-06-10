# Platform Engineering Demo

This deployment demonstrates platform engineering concepts with FortiGate standalone deployment and supporting infrastructure for application deployment scenarios.

## Architecture

- FortiGate standalone instance
- Platform engineering infrastructure
- Application deployment components
- Vote application demo setup

## Configuration

Edit `terraform.tfvars` with your settings:

```hcl
custom_vars = {
    prefix                     = "platform-eng"
    region                     = "eu-west-1"
    fgt_build                  = "build2731"
    license_type               = "payg"
    fgt_size                   = "c6i.large"
    # Add other configuration variables as needed
}
```

## Deployment

1. Configure your AWS credentials
2. Edit `terraform.tfvars` with your parameters
3. Run: `./0_terraform_script.sh`

## Resources Created

- FortiGate standalone instance
- VPC with appropriate subnets
- Application infrastructure
- Demo voting application
- Supporting networking components

## Applications

The deployment includes a sample voting application template that demonstrates:
- Container-based application deployment
- Network security integration
- Platform engineering best practices

## Clean Up

Run: `terraform destroy` when finished to avoid ongoing charges.
