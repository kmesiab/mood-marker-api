resource "aws_ecs_task_definition" "mood_marker_api_task" {
  family                   = "mood-marker-api-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.mood_marker_api_ecs_task_execution_role.arn
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "mood-marker-api"
      image     = "${aws_ecr_repository.ecr_repository.repository_url}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        },
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.mood_marker_api_log_group.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
          awslogs-create-group  = "true"
        }
      }
    }
  ])
}
