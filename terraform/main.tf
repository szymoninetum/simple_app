data "template_file" "user_data" {
  template = file("scripts/add-ssh-web-app.yaml")
}

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

#Network_interface
resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.public-subnet-1.id
  private_ips = ["10.0.0.100"]
  security_groups = [aws_security_group.main.id]

  tags = {
    Name = "primary_network_interface"
  }
}

#Instance with Ubuntu 22.04 LTS (change AMI to specify system: Ubuntu, Amazon Linux etc.)
resource "aws_instance" "app_server" {
  ami           = "ami-052efd3df9dad4825"    #ubuntu server
  instance_type = var.instance_type
  key_name = "app"
  user_data = data.template_file.user_data.rendered
  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }

  tags = {
    Name = "webapp"
 }
  # depends_on = [aws_security_group.main]
}


# #Configure Security Groups
resource "aws_security_group" "main" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    description      = "SSH Access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    protocol         = "tcp"
    from_port        = 1080
    to_port          = 1080
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 1081
    to_port          = 1081
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 1085
    to_port          = 1085
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 8000
    to_port          = 8000
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
  #  ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg_main"
  }
}

#ssh sg configure
# resource "aws_security_group" "ssh-security-group" {
#   name        = "SSH Security Group"
#   description = "Enable SSH access on Port 22"
#   vpc_id      = aws_vpc.vpc.id

#   ingress {
#     description      = "SSH Access"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   tags   = {
#     Name = "SSH Security Group"
#   }
# }

# Create Security Group for the Web Server
# Create Security Group for the Application Load Balancer
# terraform aws create security group
# resource "aws_security_group" "alb-security-group" {
#   name        = "ALB Security Group"
#   description = "Enable HTTP/HTTPS access on Port 80/443"
#   vpc_id      = aws_vpc.vpc.id

#   ingress {
#     description      = "HTTP Access"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   tags   = {
#     Name = "ALB Security Group"
#   }
# }

# # Create Security Group for the Web Server
# # terraform aws create security group
# resource "aws_security_group" "webserver-security-group" {
#   name        = "Web Server Security Group"
#   description = "Enable HTTP/HTTPS access on Port 80/443 via ALB and SSH access on Port 22 via SSH SG"
#   vpc_id      = aws_vpc.vpc.id

#   ingress {
#     description      = "HTTP Access"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     security_groups  = ["${aws_security_group.alb-security-group.id}"]
#   }

#   ingress {
#     description      = "SSH Access"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     security_groups  = ["${aws_security_group.ssh-security-group.id}"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   tags   = {
#     Name = "Web Server Security Group"
#   }
# }

 # End of the Security Groups


############################
#VPC

# Create VPC
# terraform aws create vpc
resource "aws_vpc" "vpc" {
  cidr_block              = "${var.vpc-cidr}"
  instance_tenancy        = "default"
  enable_dns_hostnames    = true

  tags      = {
    Name    = "VPC for webapp"
  }
}

# Create Internet Gateway and Attach it to VPC
# terraform aws create internet gateway
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id    = aws_vpc.vpc.id

  tags      = {
    Name    = "Test IGW"
  }
}

# Create Public Subnet 1
# terraform aws create subnet
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.public-subnet-1-cidr}"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags      = {
    Name    = "Public Subnet 1"
  }
}

# Create Public Subnet 2
# terraform aws create subnet
resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.public-subnet-2-cidr}"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags      = {
    Name    = "Public Subnet 2"
  }
}

# Create Route Table and Add Public Route
# terraform aws create route table
resource "aws_route_table" "public-route-table" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags       = {
    Name     = "Public Route Table"
  }
}

# Associate Public Subnet 1 to "Public Route Table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public-subnet-1-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-1.id
  route_table_id      = aws_route_table.public-route-table.id
}

# Associate Public Subnet 2 to "Public Route Table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public-subnet-2-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-2.id
  route_table_id      = aws_route_table.public-route-table.id
}

# Create Private Subnet 1
# terraform aws create subnet
resource "aws_subnet" "private-subnet-1" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "${var.private-subnet-1-cidr}"
  availability_zone        = "us-east-1a"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "Private Subnet 1 | App Tier"
  }
}

# Create Private Subnet 2
# terraform aws create subnet
resource "aws_subnet" "private-subnet-2" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "${var.private-subnet-2-cidr}"
  availability_zone        = "us-east-1b"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "Private Subnet 2 | App Tier"
  }
}

# Create Private Subnet 3
# terraform aws create subnet
resource "aws_subnet" "private-subnet-3" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "${var.private-subnet-3-cidr}"
  availability_zone        = "us-east-1a"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "Private Subnet 3 | Database Tier"
  }
}

# Create Private Subnet 4
# terraform aws create subnet
resource "aws_subnet" "private-subnet-4" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "${var.private-subnet-4-cidr}"
  availability_zone        = "us-east-1b"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "Private Subnet 4 | Database Tier"
  }
}

