# SD-WAN Hub and Spoke Demo

This deployment creates an SD-WAN topology with hub and spoke architecture using FortiGate devices in AWS.

## Architecture

- SD-WAN hub deployment
- Spoke site configurations
- Inter-site connectivity via SD-WAN
- Traffic steering and policy enforcement

## Configuration

Edit `terraform.tfvars` with your settings. This deployment supports various SD-WAN configuration options including:

- Hub site configuration
- Spoke site parameters
- Overlay network settings
- Routing and policy configurations

## Deployment

1. Configure your AWS credentials
2. Edit `terraform.tfvars` with your parameters
3. Run: `./0_terraform_script.sh`

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
