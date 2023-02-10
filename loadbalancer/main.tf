resource "aws_security_group" "public-lb-sg" {

  vpc_id      = var.vpc-id
  description = var.sg-description

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "public-alb-sg"
  }
}

resource "aws_lb" "public-alb" {

  load_balancer_type = var.load_balancer_type
  internal           = false
  security_groups    = [aws_security_group.public-lb-sg.id]
  subnets            = var.public-subnets


  tags = {
    name        = var.lb-name,
    Environment = "Dev"
  }
}

resource "aws_lb_target_group" "public-lb-tg" {

  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = "5"
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
  }

  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc-id
  tags = {
    name = "public-tg"
  }
}

resource "aws_lb_listener" "public-alb-listener" {
  load_balancer_arn = aws_lb.public-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.public-lb-tg.arn
    type             = "forward"
  }
}


####################################################################

resource "aws_security_group" "private-lb-sg" {

  vpc_id      = var.vpc-id
  description = var.sg-description

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.public-ec2-sg-id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "private-alb-sg"
  }
}

resource "aws_lb" "private-alb" {

  load_balancer_type = var.load_balancer_type
  internal           = true
  security_groups    = [aws_security_group.private-lb-sg.id]
  subnets            = var.private-subnets


  tags = {
    name        = "Private LB",
    Environment = "Dev"
  }
}

resource "aws_lb_target_group" "private-lb-tg" {

  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = "5"
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
  }

  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc-id
  tags = {
    name = "private-tg"
  }
}

resource "aws_lb_listener" "private-alb-listener" {
  load_balancer_arn = aws_lb.private-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.private-lb-tg.arn
    type             = "forward"
  }
}