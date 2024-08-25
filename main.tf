terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region                   = "us-east-1"
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "omer-prog" # profile name in the credentials file
}
# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/26" # 64 IPs
  tags = {
    Name = "omer-main-vpc"
  }
}

#public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.0.0/28" #16 IPs
  map_public_ip_on_launch = true          # public subnet (ensures that instances launched in that subnet automatically receive a public IP address.)
  availability_zone       = "us-east-1a"
  tags = {
    Name = "omer-public-subnet"
  }
}
#ec2 instance
resource "aws_instance" "omer-ec2" {
  ami           = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "omer-ec2"
  }
}

