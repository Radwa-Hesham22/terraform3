resource "aws_nat_gateway" "nat-01" {
  allocation_id = var.eip-id
  subnet_id     = var.public-subnet

  tags = {
    Name = "GW NAT"
  }
}