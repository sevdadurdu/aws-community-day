# Create a VPC
resource "aws_vpc" "community_day_vpc" {
  cidr_block           = var.aws_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "community-day-${var.aws_env}"
  }
}

resource "aws_flow_log" "community_day_flowgs" {
  iam_role_arn    = aws_iam_role.community_day_vpc_role.arn
  log_destination = aws_cloudwatch_log_group.community_day_flowlogs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.community_day_vpc.id
}

resource "aws_cloudwatch_log_group" "community_day_flowlogs" {
  name = "/vpc/${var.aws_env}/flowlogs"
}

resource "aws_iam_role" "community_day_vpc_role" {
  name = "community-day-${var.aws_env}-vpc-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "community_day_vpc_flowlogs_policy" {
  name = "community-day-${var.aws_env}-vpc-flowlogs-policy"
  role = aws_iam_role.community_day_vpc_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:logs:::log-group:/vpc/community-day-${var.aws_env}-flowlogs:*"
    }
  ]
}
EOF
}

resource "aws_default_security_group" "community_day_default_security_group" {
  vpc_id = aws_vpc.community_day_vpc.id
}

resource "aws_internet_gateway" "community_day_igw" {
  vpc_id = aws_vpc.community_day_vpc.id

  tags = {
    Name = "community-day-${var.aws_env}-igw"
  }
}

resource "aws_default_route_table" "community_day_public_table" {
  default_route_table_id = aws_vpc.community_day_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.community_day_igw.id
  }

  tags = {
    Name = "community-day-${var.aws_env}-public"
  }
  
  lifecycle {
    ignore_changes = all
  }
}

resource "aws_subnet" "community_day_public_1a" {
  vpc_id                  = aws_vpc.community_day_vpc.id
  cidr_block              = lookup(var.aws_subnets, "public-1a")
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "community-day-${var.aws_env}-public-1a"
  }
}

resource "aws_route_table_association" "community_day_public_table_public_1a" {
  route_table_id = aws_default_route_table.community_day_public_table.id
  subnet_id      = aws_subnet.community_day_public_1a.id
}
