variable "vpc_cidr_block" {
  description = "vpc cidr value"
}

variable "terra_subnet_cidr" {
  description = "subnet cidr value"
}

variable "terra_subnet_2_cidr" {
  description = "subnet-2 cidr value"
}

variable "env" {
  description = "terraform environment"
}

variable "avail_zone" {
  description = "subnet availability zone"
}
variable "my_ip" {
  description = "my ip for ingress"
}
