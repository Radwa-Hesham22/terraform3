resource "aws_instance" "public-ec2-instances" {
  ami                         = var.ami
  instance_type               = var.instance-type
  count                       = length(var.public-ec2-instances)
  subnet_id                   = var.public-subnets[count.index]
  vpc_security_group_ids      = [var.public-ec2-sg-id]
  associate_public_ip_address = "true"
  key_name                    = var.key_name
  


  provisioner "local-exec" {
    command = "echo public-${count.index}: ${self.public_ip} >> all-ips.txt"
  }


  tags = {
    Name = var.public-ec2-instances[count.index]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install nginx -y ",
      "echo 'server {\nlisten 80 default_server;\nlisten [::]:80 default_server;\nserver_name _;\nlocation / {\nproxy_pass http://${var.private-load-balancer-dns};\n}\n}' > default",
      "sudo mv default /etc/nginx/sites-enabled/default",
      "sudo systemctl restart nginx"
    ]
  }

  

  connection {
    type = var.conn-type
    host = self.public_ip
    user = var.instance-user
    private_key = file("./radwa.pem")
  }
}



resource "aws_lb_target_group_attachment" "public-target-group-attachment-1" {
  count            = length(var.public-ec2-instances)
  target_group_arn = var.public-tg-arn
  target_id        = aws_instance.public-ec2-instances[count.index].id
  port             = 80
}


#####################################################################

resource "aws_instance" "private-ec2-instances" {
  ami                    = var.ami
  instance_type          = var.instance-type
  count                  = length(var.private-ec2-instances)
  subnet_id              = var.private-subnets[count.index]
  vpc_security_group_ids = [var.private-ec2-sg-id]
  key_name               = var.key_name
  user_data                   = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y nginx
    sudo service nginx start
    EOF
  

  provisioner "local-exec" {
    command = "echo private-${count.index}: ${self.private_ip} >> all-ips.txt"
  }


  tags = {
    Name = var.private-ec2-instances[count.index]
  }

  

}

resource "aws_lb_target_group_attachment" "private-target-group-attachment-1" {
  count            = length(var.private-ec2-instances)
  target_group_arn = var.private-tg-arn
  target_id        = aws_instance.private-ec2-instances[count.index].id
  port             = 80
}