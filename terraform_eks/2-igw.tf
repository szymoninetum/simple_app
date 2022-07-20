resource "aws_intetnet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "igw"
    }
}