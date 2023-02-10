resource "aws_vpc" "vpc-dev" {
    cidr_block = var.cidr-vpc
    tags ={
        "Name" = var.name-vpc
    }
}