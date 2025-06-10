# SD-WAN Hub and Spoke Demo

This deployment creates an SD-WAN topology with hub and spoke architecture using FortiGate devices in AWS.

## Architecture

- SD-WAN hub deployment
- Spoke site configurations
- Inter-site connectivity via SD-WAN
- Traffic steering and policy enforcement

## Configuration

Copy `terraform.tfvars.example` to `terraform.tfvars` and edit with your settings:

```bash
cp terraform.tfvars.example terraform.tfvars
```

This deployment supports various SD-WAN configuration options including:
- Hub site configuration
- Spoke site parameters
- Overlay network settings
- Routing and policy configurations

## Deployment

1. Configure your AWS credentials
2. Copy and edit the terraform.tfvars file as described above
3. Run terraform commands:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Resources Created

- FortiGate instances for hub and spoke sites
- VPC infrastructure for each site
- SD-WAN overlay configuration
- Inter-site connectivity setup
- Traffic steering policies

## SD-WAN Features

This demo showcases:
- Centralized policy management
- Dynamic path selection
- Application-aware routing
- Site-to-site connectivity
- Performance monitoring

## Clean Up

Run: `terraform destroy` when finished to avoid ongoing charges.
