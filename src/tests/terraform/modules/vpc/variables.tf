variable "vpc_cidr_block" {
  type = string
}

variable "vpc_subnet_count" {
  type = number
  default = 2
}

variable "vpc_tags" {
  type = map
  default = {}
}

