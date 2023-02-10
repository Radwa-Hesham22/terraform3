resource "aws_security_group" "public-ec2-sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc-id
}


resource "aws_security_group_rule" "allow_all-ingress" {
  type              = "ingress"
  count             = length(var.sg-rules.ingress)
  description       = var.sg-rules.ingress[count.index].description
  from_port         = var.sg-rules.ingress[count.index].from_port
  to_port           = var.sg-rules.ingress[count.index].to_port
  protocol          = var.sg-rules.ingress[count.index].protocol
  cidr_blocks       = var.sg-rules.ingress[count.index].cidr_blocks
  security_group_id = aws_security_group.public-ec2-sg.id
}

resource "aws_security_group_rule" "allow_all-egress" {
  type              = "egress"
  count             = length(var.sg-rules.egress)
  description       = var.sg-rules.egress[count.index].description
  from_port         = var.sg-rules.egress[count.index].from_port
  to_port           = var.sg-rules.egress[count.index].to_port
  protocol          = var.sg-rules.egress[count.index].protocol
  cidr_blocks       = var.sg-rules.egress[count.index].cidr_blocks
  security_group_id = aws_security_group.public-ec2-sg.id
}

###########################################################

resource "aws_security_group" "private-ec2-sg" {
  name        = "allow private tls"
  description = "Allow TLS inbound and outbound traffic"
  vpc_id      = var.vpc-id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.private-alb-sg-id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private SG"
  }
}