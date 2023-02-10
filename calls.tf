module "vpc-module" {
  source    = "./vpc"
  cidr-vpc = "10.0.0.0/16"
  name-vpc = "VPC Dev"
}

module "igw-module" {
  source        = "./igw"
  vpc-id        = module.vpc-module.vpc-id
  igw-desc-name = "VPC-IGW"
}

module "subnets" {
  source         = "./subnets"
  vpc-az         = "us-east-1a"
  cidr-subnets   = ["10.0.0.0/24", "10.0.2.0/24", "10.0.1.0/24", "10.0.3.0/24"]
  subnets-type   = ["public", "public", "private", "private"]
  subnets-region = ["us-east-1a", "us-east-1b", "us-east-1a", "us-east-1b"]
  vpc-id         = module.vpc-module.vpc-id
} 



module "eip-module" {
  source            = "./elastic ip"
  custom-elastic-ip = "Custom Elastic IP"
}



module "natgateway-module" {
  source        = "./nat"
  eip-id        = module.eip-module.eip-id
  public-subnet = module.subnets.public-subnet-1-id
}

module "routtable-module" {
  source              = "./route"
  vpc-id              = module.vpc-module.vpc-id
  igw-id              = module.igw-module.igw-id
  public-subnet-1-id  = module.subnets.public-subnet-1-id
  public-subnet-2-id  = module.subnets.public-subnet-2-id
  private-subnet-1-id = module.subnets.private-subnet-1-id
  private-subnet-2-id = module.subnets.private-subnet-2-id
  natgateway-id       = module.natgateway-module.natgateway-id
} 

module "loadbalancer-module" {
  source             = "./loadbalancer"
  vpc-id             = module.vpc-module.vpc-id
  lb-name            = "Application LB"
  public-subnets     = [module.subnets.public-subnet-1-id, module.subnets.public-subnet-2-id]
  private-subnets    = [module.subnets.private-subnet-1-id, module.subnets.private-subnet-2-id]
  load_balancer_type = "application"
  sg-description     = "Application Load Balancer Allowing HTTP Connections"
  public-ec2-sg-id   = module.ec2-sg-module.public-ec2-sg-id
}

module "ec2-sg-module" {
  source            = "./security groups"
  vpc-id            = module.vpc-module.vpc-id
  private-alb-sg-id = module.loadbalancer-module.private-alb-sg-id
  sg-rules = {
    ingress = [
      {
        description = "Allow http inbound traffic"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

      },
      {
        description = "Allow https inbound traffic"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

      },
      {
        description = "Allow ssh inbound traffic"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

      }

    ],
    egress = [
      {
        description = "Allow http outbound traffic"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

      },
      {
        description = "Allow https outbound traffic"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

      },
      {
        description = "Allow ssh outbound traffic"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

      }
    ]
  }
}

module "ec2-module" {
  source               = "./ec2"
  vpc-id               = module.vpc-module.vpc-id
  public-subnets       = [module.subnets.public-subnet-1-id, module.subnets.public-subnet-2-id]
  ami                  = data.aws_ami.amazon_linux.image_id
  instance-type        = "t2.micro"
  public-tg-arn        = module.loadbalancer-module.public-tg-arn
  public-ec2-instances = ["Public-1-EC2", "Public-2-EC2"]
  key_name             = "radwa"
  public-ec2-sg-id     = module.ec2-sg-module.public-ec2-sg-id

  private-subnets       = [module.subnets.private-subnet-1-id, module.subnets.private-subnet-2-id]
  private-tg-arn        = module.loadbalancer-module.private-tg-arn
  private-ec2-instances = ["Private-1-EC2", "Private-2-EC2"]
  private-ec2-sg-id     = module.ec2-sg-module.private-ec2-sg-id

  private-load-balancer-dns = module.loadbalancer-module.private-lb-dns
  conn-type = "ssh"
  instance-user = "ec2-user"
}

