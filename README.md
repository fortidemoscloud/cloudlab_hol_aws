# CloudLab HOL AWS - Fortinet Demos

This repository contains Terraform configurations for deploying various Fortinet solutions on AWS. These are hands-on lab examples designed for testing and demonstration purposes.

## Repository Structure

### [basic_fgt-cluster-app-sec](./basic_fgt-cluster-app-sec/)
FortiGate cluster deployment with application security features using FGCP clustering in AWS.

### [basic_platform_eng_demo](./basic_platform_eng_demo/)
Platform engineering demonstration with FortiGate standalone deployment and associated infrastructure.

### [middle_sdwan_hub_spoke](./middle_sdwan_hub_spoke/)
SD-WAN hub and spoke topology demonstration with FortiGate devices.

## Prerequisites

- [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) >= 1.5.0
- AWS CLI configured with appropriate credentials
- Basic understanding of Terraform and AWS networking

## Quick Start

1. Clone this repository
2. Navigate to the desired deployment folder
3. Copy and customize the `terraform.tfvars` file
4. Run terraform commands: `terraform init`, `terraform plan`, `terraform apply`

## Important Notes

- **Cost Warning**: These deployments will incur AWS charges
- **Demo Purpose**: These configurations are for testing and demonstration only
- **No Support**: This is a personal repository without official support

## License

See [LICENSE](./LICENSE) file for details.
