# Available variables of VPC module

variable "aws_env" {
  type        = string
  description = "AWS Environment name"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "aws_cidr" {
  type        = string
  description = "AWS CIDR block of VPC"
}

variable "aws_subnets" {
  type        = map(string)
  description = "AWS CIDR blocks of subnets"
}

variable "create_vpc_role" {
  type        = string
  description = "VPC role will be created on Main VPC only"
}
