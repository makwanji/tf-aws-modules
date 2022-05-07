terraform {
  required_version = ">= 0.15.0"

  required_providers {
    aws = ">= 3.40.0"
  }
}

variable "dns_zone" {
  type = string
}
