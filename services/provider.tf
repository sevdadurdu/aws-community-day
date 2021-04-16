# AWS provider
provider "aws" {
  region  = lookup(var.aws_region_map, local.aws_env)
  profile = "default"
}

provider "aws" {
  alias   = "peer"
  region  = "us-east-1"
  profile = "default"
}

terraform {
  backend "s3" {
    profile = "default"
    bucket  = "community-day-terraform-remote-state-test2"
    key     = "services"
    region  = "eu-central-1"
  }
}