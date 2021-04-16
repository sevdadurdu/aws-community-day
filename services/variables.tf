variable "aws_env_map" {
  type        = map(string)
  description = "Environment list"
  default = {
    frankfurt = "frankfurt"
    virginia  = "virginia"
  }
}

variable "aws_region_map" {
  type        = map(string)
  description = "Region List"
  default = {
    frankfurt = "eu-central-1"
    virginia  = "us-east-1"
  }
}

variable "aws_subnets_regional_map" {
  type        = map(map(string))
  description = "AWS CIDR blocks of subnets for each region"
  default = {
    frankfurt = {
      public-1a = "10.10.0.0/20"
    }
    virginia = {
      public-1a = "10.11.0.0/20"
    }
  }
}

variable "aws_cidr_map" {
  type        = map(string)
  description = "AWS CIDR blocks of VPC for each region"
  default = {
    frankfurt = "10.10.0.0/16"
    virginia  = "10.11.0.0/16"
  }
}

variable "region_enabled_map" {
  type        = map(string)
  description = "Region enabled"

  default = {
    frankfurt = "1"
    virginia  = "0"
  }
}

variable "virginia_region_enabled_map" {
  type        = map(string)
  description = "Region enabled"

  default = {
    frankfurt = "0"
    virginia  = "1"
  }
}

variable "peering_region_enabled_map" {
  type        = map(string)
  description = "Region enabled"

  default = {
    frankfurt = "0"
    virginia  = "1"
  }
}

variable "public_key_path" {
  default     = "./ssh/public.pem"
  description = "Public key path for instance login"
}

variable "frankfurt_vpc_cidr_block" {
  default     = "10.10.0.0/16"
  description = "Virginia VPC Cidr Block"
}

variable "virginia_vpc_cidr_block" {
  default     = "10.11.0.0/16"
  description = "Virginia VPC Cidr Block"
}

variable "virginia_vpc_id" {
  default     = "vpc-043d94d30f8748478"
  description = "Virginia VPC Id"
}

variable "vpc_peering_connection_id" {
  default     = "pcx-033819814f8007771"
  description = "Vpc peering id"
}

variable "cluster_name" {
  default     = "community-day-cluster"
  description = "ECS Cluster Name"
}

variable "cluster_instance_count_map" {
  type        = map(string)
  description = "Cluster instance count"

  default = {
    frankfurt = "1"
    virginia  = "1"
  }
}

variable "linux2_ami_map" {
  type        = map(string)
  description = "Default ECS Linux 2 AMI"

  default = {
    frankfurt = "ami-01d359866d075d46c"
    virginia  = "ami-09a3cad575b7eabaa"
  }
}

variable "service_desired_task_count" {
  default     = 1
  description = "ECS Service Desired Task Count"
}

variable "efs_file_system_id" {
  default     = "fs-1933fc42"
  description = "EFS File System Id"
}