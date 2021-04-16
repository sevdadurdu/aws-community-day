resource "aws_ecr_repository" "community_day_service" {
  name = "community-day-${local.aws_env}-service"

  tags = {
    name = "community-day-${local.aws_env}-service"
  }
}

data "template_file" "community_day_service_frankfurt" {
  count    = lookup(var.region_enabled_map, local.aws_env)
  template = file("./templates/ecs-service-frankfurt.tpl")

  vars = {
    image               = "${aws_ecr_repository.community_day_service.repository_url}:latest"
    memory              = 512
    aws_region          = lookup(var.aws_region_map, local.aws_env)
    log_group_name      = "/ecs/service/community-day-${local.aws_env}-service"
    efs_website_commons = "community-day-${local.aws_env}-website-commons"
    efs_blog            = "community-day-${local.aws_env}-blog"
  }
}

resource "aws_ecs_task_definition" "community_day_frankfurt" {
  count                    = lookup(var.region_enabled_map, local.aws_env)
  family                   = "community-day-${local.aws_env}-task-def"
  requires_compatibilities = ["EC2"]
  memory                   = 512
  network_mode             = "bridge"
  container_definitions    = data.template_file.community_day_service_frankfurt[0].rendered

  volume {
    name = "community-day-${local.aws_env}-website-commons"

    efs_volume_configuration {
      root_directory = "/website-commons"
      file_system_id = var.efs_file_system_id
    }
  }

  volume {
    name = "community-day-${local.aws_env}-blog"

    efs_volume_configuration {
      root_directory = "/${local.aws_env}-blog"
      file_system_id = var.efs_file_system_id
    }
  }
}

resource "aws_ecs_service" "community_day_frankfurt" {
  count           = lookup(var.region_enabled_map, local.aws_env)
  name            = "community-day-${local.aws_env}-service"
  cluster         = module.community_day_cluster.cluster_id
  task_definition = aws_ecs_task_definition.community_day_frankfurt[0].arn
  desired_count   = var.service_desired_task_count
  launch_type     = "EC2"
}
