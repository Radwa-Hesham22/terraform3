output "public-tg-arn" {
  value = aws_lb_target_group.public-lb-tg.arn
}


output "public-lb-dns" {
  value = aws_lb.public-alb.dns_name
}

output "private-tg-arn" {
  value = aws_lb_target_group.private-lb-tg.arn
}


output "private-lb-dns" {
  value = aws_lb.private-alb.dns_name
}

output "private-alb-sg-id" {
  value = aws_security_group.private-lb-sg.id
}