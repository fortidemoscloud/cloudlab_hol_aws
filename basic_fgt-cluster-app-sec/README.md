# FortiGate Cluster - Application Security Demo

This deployment creates a FortiGate cluster with application security features using FGCP (FortiGate Clustering Protocol) in AWS.

## Architecture

- FortiGate FGCP cluster in single AZ with 2 members
- Application security and inspection capabilities
- Protected and bastion subnets
- EKS cluster for containerized applications

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

- FortiGate FGCP cluster (2 instances)
- VPC with public/private subnets
- EKS cluster for application deployment
- Security groups and routing tables
- Bastion host for management access

## Clean Up

Run: `terraform destroy` when finished to avoid ongoing charges.
