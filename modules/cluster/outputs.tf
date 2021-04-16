output "cluster_id" {
  value = aws_ecs_cluster.community_day_cluster.id
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_execution_role_id" {
  value = aws_iam_role.ecs_task_execution_role.id
}