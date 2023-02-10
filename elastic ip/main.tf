resource "aws_eip" "CustomIP" {
  vpc = true
  tags = {
    "Name" = var.custom-elastic-ip
  }
}