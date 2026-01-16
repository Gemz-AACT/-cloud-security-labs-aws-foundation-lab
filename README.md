# -cloud-security-labs-aws-foundation-lab
Build a secure AWS environment using best practices. Focus on networking, IAM, encryption, and minimal exposure.


# AWS Secure Cloud Infrastructure Starter Lab

## Overview
This project demonstrates a secure AWS environment following best practices:
- VPC with public and private subnets
- NAT Gateway for secure outbound access
- EC2 instance in private subnet with least privilege IAM role
- S3 bucket with KMS encryption and versioning
- Security groups with minimal inbound rules

## Architecture
**Need to upload Gemz!! ->  (Insert architecture-diagram.png) DONT FORGET

## Security Decisions
- Private subnet for EC2 prevents public exposure
- IAM role grants only S3 read/write for this bucket
- Security groups restrict SSH access to my IP
- S3 bucket encrypted with AWS KMS

## Usage
1. Install Terraform
2. Configure AWS CLI
3. Set variables in `variables.tf`
4. Run:
```bash
terraform init
terraform plan
terraform apply
