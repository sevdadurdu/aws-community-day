module "community_day_cluster" {
  source    = "../modules/cluster"
  local_env = local.aws_env
}

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "ecs_role" {
  name               = "community-day-${local.aws_env}-ecs-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_instance_profile" "ecs_profile" {
  name = "community-day-${local.aws_env}-ecs-profile"
  role = aws_iam_role.ecs_role.name
}

data "aws_iam_policy" "ecs_instance" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_policy" "ecs_instance" {
  name   = "community-day-${local.aws_env}-ecs-instance"
  policy = data.aws_iam_policy.ecs_instance.policy
  path   = "/"
}

resource "aws_iam_role_policy_attachment" "ecs_instance" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = aws_iam_policy.ecs_instance.arn
}

resource "aws_security_group" "ecs_sg" {
  name        = "community-day-ecs-sg"
  description = "ECS Security Group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Ssh access from everywhere"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Internet access from everywhere"
    from_port   = 0
    protocol    = "tcp"
    to_port     = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "ecs_user_data" {
  template = file("templates/user_data.tpl")
}

resource "aws_instance" "ecs" {
  count = lookup(var.cluster_instance_count_map, local.aws_env)

  instance_type          = "t2.small"
  ami                    = lookup(var.linux2_ami_map, local.aws_env)
  key_name               = aws_key_pair.community_day.id
  vpc_security_group_ids = [aws_security_group.ecs_sg.id]
  subnet_id              = module.vpc.public_subnet_1a
  iam_instance_profile   = aws_iam_instance_profile.ecs_profile.name

  volume_tags = {
    Name = "community-day-${local.aws_env}-ecs"
  }

  tags = {
    "Name" = "community-day-ecs-instance"
  }

  user_data = data.template_file.ecs_user_data.rendered
}
