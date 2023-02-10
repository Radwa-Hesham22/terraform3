variable "vpc-id" {
  type = string
}

variable "sg-rules" {
  type = object({
    ingress = list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })),
    egress = list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  })
}

variable "private-alb-sg-id" {
  type = string
}