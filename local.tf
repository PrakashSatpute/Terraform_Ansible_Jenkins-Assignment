# Local Declaration
variable "owner" {
  type = string
  default = "prakash satpute"
}

variable "environment" {
  type = string
  default  = "dev"
}

variable "vpc_name" {
  type = string
 default  = "main"
}
locals {
  owners = var.owner
  environment = var.environment
  name = var.vpc_name
  common_tags = {
    owners = local.owners
    environment = local.environment
  }
} 
