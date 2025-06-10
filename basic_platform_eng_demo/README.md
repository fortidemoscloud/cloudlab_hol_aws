# Platform Engineering Demo

This deployment demonstrates platform engineering concepts with FortiGate standalone deployment and supporting infrastructure for application deployment scenarios.

## Architecture

- FortiGate standalone instance
- Platform engineering infrastructure
- Application deployment components
- Vote application demo setup

## Configuration

Copy `terraform.tfvars.example` to `terraform.tfvars` and edit with your settings:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Then customize the variables according to your requirements.

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
