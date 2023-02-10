variable "vpc-id" {
  type = string
}

variable "lb-name" {
  type = string
}

variable "load_balancer_type" {
  type = string
}

variable "public-subnets" {
  type = list(string)
}

variable "private-subnets" {
  type = list(string)
}

variable "sg-description" {
  type = string
}
variable "public-ec2-sg-id" {
  type = string
}