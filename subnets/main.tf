resource "aws_subnet" "vpc-subnets" {
  count             = length(var.cidr-subnets)
  vpc_id            = var.vpc-id
  availability_zone = var.subnets-region[count.index]
  cidr_block        = var.cidr-subnets[count.index]
  tags = {
    Name = var.subnets-type[count.index]
  }
}