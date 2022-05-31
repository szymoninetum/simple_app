variable "instance_type" {
    description = "Value of the instance type for the EC2 instance"
    type = string
    default = "t2.micro"
}

variable "aws_region" {
    description = "Value of the aws default region"
    type = string
    default = "us-east-1"
}

variable "aws_profile" {
    description = "Value of the aws profile"
    type = string
    default = "default"
}