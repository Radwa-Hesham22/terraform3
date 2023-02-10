output "public-ec2-sg-id" {
  value = aws_security_group.public-ec2-sg.id
}

output "public-ec2-sg-arn" {
  value = aws_security_group.public-ec2-sg.arn
}


output "private-ec2-sg-id" {
  value = aws_security_group.private-ec2-sg.id
}

output "private-ec2-sg-arn" {
  value = aws_security_group.private-ec2-sg.arn
}