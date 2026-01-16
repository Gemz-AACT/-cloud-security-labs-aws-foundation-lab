#The settings

variable "aws_region" {
  default = "ca-central-1"
}

variable "aws_az" {
  default = "ca-central-1a"
}

variable "my_ip" {
  default = "0.0.0.0/0" # OVERRIDE THIS WITH YOUR IP 
}

variable "key_name" {
  default = "aws-foundation-key" 
}

variable "instance_type" {
  default = "t3.micro" 
}

variable "ami_id" {
  default = "ami-0ea18256de20ecdfc" 
}

variable "unique_suffix" {
  description = "A unique name for the S3 bucket"
  type        = string
  default     = "student-lab-774411" 

}

