resource "aws_internet_gateway" "igw-01" {
  vpc_id = var.vpc-id

  tags = {
    Name = var.igw-desc-name
  }
}