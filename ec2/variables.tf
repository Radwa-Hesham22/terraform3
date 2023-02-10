variable "vpc-id" {
  type = string
}

variable "ami" {
  type = string
}

variable "key_name" {
  type = string
}

variable "instance-type" {
  type = string
}

variable "public-subnets" {
  type = list(string)
}

variable "public-tg-arn" {
  type = string
}

variable "public-ec2-instances" {
  type = list(string)
}

variable "public-ec2-sg-id" {
  type = string
}

variable "conn-type" {

}

variable "instance-user" {
  
}


##################################################

variable "private-subnets" {
  type = list(string)
}

variable "private-tg-arn" {
  type = string
}

variable "private-ec2-instances" {
  type = list(string)
}

variable "private-ec2-sg-id" {
  type = string
}

variable "private-load-balancer-dns" {
  type = string
}