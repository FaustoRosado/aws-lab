variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr_blocks" {
  description = "CIDR blocks for VPC access"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}
