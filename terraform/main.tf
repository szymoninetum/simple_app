terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  profile = var.aws_profile
  region = var.aws_region
}

resource "aws_instance" "app_server" {
  ami           = "ami-0022f774911c1d690"    
  instance_type = var.instance_type
  key_name = "webapp"
  vpc_security_group_ids = [aws_security_group.main.id]

tags = {
  Name = "webapp"
 }
}

resource "aws_security_group" "main" {
  vpc_id = "vpc-2c9d1f51"

  ingress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }

  egress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg_main"
  }
}
