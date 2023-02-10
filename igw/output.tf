output "igw-arn" {
  value = aws_internet_gateway.igw-01.arn
}

output "igw-id" {
  value = aws_internet_gateway.igw-01.id
}

output "igw-vpc-id" {
  value = aws_internet_gateway.igw-01.vpc_id
}