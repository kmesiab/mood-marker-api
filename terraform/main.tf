terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider aws {
  region  = var.region
}

resource "aws_ecs_cluster" "mood_marker_api_cluster" {
  name = "mood-marker-api-cluster"
}

resource "aws_iam_role" "mood_marker_api_ecs_task_execution_role" {
  name = "mood_marker_api_ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com",
        },
        Effect = "Allow",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.mood_marker_api_ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

  resource "aws_iam_role_policy_attachment" "ecs_task_access_ecr_policy" {
  role       = aws_iam_role.mood_marker_api_ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "ecs_task_logs_policy" {
  role       = aws_iam_role.mood_marker_api_ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_ecs_service" "mood_marker_api_service" {
  name            = "mood-marker-api-service"
  cluster         = aws_ecs_cluster.mood_marker_api_cluster.id
  task_definition = aws_ecs_task_definition.mood_marker_api_task.arn
  desired_count   = 1 # Number of instances of the task to run
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.mood_marker_api_subnet_1.id, aws_subnet.mood_marker_api_subnet_2.id]
    assign_public_ip = true
    security_groups = [aws_security_group.mood_marker_api_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.mood_maker_api_target_group.arn
    container_name   = "mood-marker-api"
    container_port   = 443
  }

  depends_on = [
    aws_ecs_cluster.mood_marker_api_cluster,
    aws_ecs_task_definition.mood_marker_api_task
  ]
}
