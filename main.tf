provider "aws" {
  region = var.aws_region
}

# 1. The Building (VPC)
resource "aws_vpc" "secure_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "SecureVPC" }
}

# 2. The Lobby (Public Subnet)
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.secure_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.aws_az
  map_public_ip_on_launch = true
  tags = { Name = "PublicSubnet" }
}

# 3. The Vault (Private Subnet)
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.secure_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.aws_az
  tags = { Name = "PrivateSubnet" }
}

# 4. The Front Door (Internet Gateway)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.secure_vpc.id
}

# 5. The One-Way Exit (NAT Gateway)
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id
}

# 6. Route Tables (The Directions)
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.secure_vpc.id
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.secure_vpc.id
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}

# 7. The Bouncer (Security Group)
resource "aws_security_group" "private_sg" {
  name   = "PrivateEC2SG"
  vpc_id = aws_vpc.secure_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip] # Only YOUR IP can get in
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 8. The Server (EC2 Instance)
resource "aws_instance" "private_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type  # <--- Change this line
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = var.key_name
  tags = { Name = "PrivateEC2" }
}

# 9. The Secure Storage (S3 Bucket)
resource "aws_s3_bucket" "secure_bucket" {
  bucket = "secure-storage-${var.unique_suffix}" # Uses the random numbers from variables.tf
  force_destroy = true # Allows terraform to delete it even if it has files later
}

# 10. Enable Versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.secure_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 11. Enable Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.secure_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 12. Block All Public Access
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}