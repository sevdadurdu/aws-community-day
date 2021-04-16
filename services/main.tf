locals {
  aws_env = lookup(var.aws_env_map, terraform.workspace)
}

module "vpc" {
  source          = "../modules/vpc"
  aws_env         = local.aws_env
  aws_region      = lookup(var.aws_region_map, local.aws_env)
  aws_subnets     = lookup(var.aws_subnets_regional_map, local.aws_env)
  aws_cidr        = lookup(var.aws_cidr_map, local.aws_env)
  create_vpc_role = false
}

data "aws_iam_policy_document" "community_day_instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_key_pair" "community_day" {
  key_name   = "community_day"
  public_key = file(var.public_key_path)
}