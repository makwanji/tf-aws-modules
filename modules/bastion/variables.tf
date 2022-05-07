variable "bastion_user_keys" {
  type = list(string)
}

variable "public_key" {
  type = string
}

variable "private_key" {
  type = string
}

variable "dept" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "availability_zone" {
  type    = string
  default = "ap-northeast-1a"
}

variable "billing_dept" {
  type = string
}

variable "billing_environment" {
  type = string
}

variable "billing_owner" {
  type = string
}

variable "billing_product" {
  type = string
}

variable "ami" {
  type    = string
  default = "ami-0fe22bffdec36361c"
}

variable "attached_security_groups" {
  type    = list(string)
  default = []
}

variable "key_name" {
  type = string
}