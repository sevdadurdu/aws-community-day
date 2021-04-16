data "template_file" "community_day_service_virginia" {
  count    = lookup(var.virginia_region_enabled_map, local.aws_env)
  template = file("./templates/ecs-service-virginia.tpl")

  vars = {
    image          = "${aws_ecr_repository.community_day_service.repository_url}:latest"
    memory         = 512
    aws_region     = lookup(var.aws_region_map, local.aws_env)
    log_group_name = "/ecs/service/community-day-${local.aws_env}-service"
  }
}

resource "aws_ecs_task_definition" "community_day_virginia" {
  count                    = lookup(var.virginia_region_enabled_map, local.aws_env)
  family                   = "community-day-${local.aws_env}-task-def"
  requires_compatibilities = ["EC2"]
  memory                   = 512
  network_mode             = "bridge"
  container_definitions    = data.template_file.community_day_service_virginia[0].rendered

}

resource "aws_ecs_service" "community_day_virginia" {
  name            = "community-day-${local.aws_env}-service"
  cluster         = module.community_day_cluster.cluster_id
  task_definition = aws_ecs_task_definition.community_day_virginia[0].arn
  desired_count   = var.service_desired_task_count
  launch_type     = "EC2"
}
