resource "aws_route_table" "public-rt" {
  vpc_id = var.vpc-id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw-id
  }

  tags = {
    Name = "public-rt"
  }

}

resource "aws_route_table_association" "public-subnet-1-association" {
  subnet_id      = var.public-subnet-1-id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-subnet-2-association" {
  subnet_id      = var.public-subnet-2-id
  route_table_id = aws_route_table.public-rt.id
}


resource "aws_route_table" "private-rt" {
  vpc_id = var.vpc-id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.natgateway-id
  }
  tags = {
    Name = "private-rt"
  }


}

resource "aws_route_table_association" "private-subnet-1-association" {
  subnet_id      = var.private-subnet-1-id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "private-subnet-2-association" {
  subnet_id      = var.private-subnet-2-id
  route_table_id = aws_route_table.private-rt.id
}