# AWS Secure Cloud Infrastructure Starter Lab

## Overview
This project demonstrates a secure AWS environment built using **Terraform (Infrastructure as Code)**. The goal was to build a secure foundation following the principle of "Least Privilege" and minimal exposure.

## Key Features
* **VPC Networking:** Custom VPC with isolated Public and Private subnets.
* **Secure Outbound:** NAT Gateway allows the private server to download updates without being exposed to the public internet.
* **Compute:** Amazon Linux 2023 EC2 instance residing in the Private Subnet.
* **Storage:** S3 Bucket with AES-256 Encryption, Versioning, and "Block Public Access" enabled.
* **IAM:** Custom IAM Role using the "Least Privilege" principle, granting the EC2 instance access only to its specific bucket.

## Architecture


## Security Decisions
* **Private Isolation:** The EC2 instance has no Public IP, making it invisible to the internet.
* **Restricted Access:** Security Groups are configured to restrict SSH access specifically to the administrator's IP address.
* **Data Protection:** S3 encryption is enforced at the bucket level to ensure all data is encrypted at rest.
* **Identity Management:** Used an Instance Profile to avoid storing AWS Access Keys inside the server.

## Usage
1. **Install Terraform** and **Configure AWS CLI**.
2. **Clone the repo:** `git clone <your-repo-link>`
3. **Set Variables:** Update `variables.tf` with your specific Region and IP.
4. **Deploy:**
   ```powershell
   terraform init
   terraform plan
   terraform apply
