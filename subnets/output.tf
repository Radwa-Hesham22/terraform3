output "public-subnet-arn-1" {
  value = aws_subnet.vpc-subnets[0].arn
}

output "public-subnet-arn-2" {
  value = aws_subnet.vpc-subnets[1].arn
}

output "private-subnet-arn-1" {
  value = aws_subnet.vpc-subnets[2].arn
}


output "private-subnet-arn-2" {
  value = aws_subnet.vpc-subnets[3].arn
}


output "public-subnet-1-id" {
  value = aws_subnet.vpc-subnets[0].id
}

output "public-subnet-2-id" {
  value = aws_subnet.vpc-subnets[1].id
}

output "private-subnet-1-id" {
  value = aws_subnet.vpc-subnets[2].id
}

output "private-subnet-2-id" {
  value = aws_subnet.vpc-subnets[3].id
}