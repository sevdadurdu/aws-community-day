resource "aws_security_group" "community_day_efs_sg" {
  count       = lookup(var.region_enabled_map, local.aws_env)
  name        = "community-day-efs-sg"
  description = "Controls access to the Web EFS Mount Points"
  vpc_id      = module.vpc.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = "2049"
    to_port     = "2049"
    cidr_blocks = ["10.11.0.0/20", "10.10.0.0/20"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_efs_file_system" "community_day_efs" {
  count = lookup(var.region_enabled_map, local.aws_env)
  tags = {
    Name = "community-day-efs"
  }
}

resource "aws_efs_mount_target" "community_day_efs" {
  count           = lookup(var.region_enabled_map, local.aws_env)
  file_system_id  = aws_efs_file_system.community_day_efs[0].id
  subnet_id       = module.vpc.public_subnet_1a
  security_groups = [aws_security_group.community_day_efs_sg[0].id]
}