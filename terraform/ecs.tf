resource "aws_ecs_cluster" "kd-cluster" {
  name = "kd-cluster"
}

resource "aws_ecs_task_definition" "display_service" {
  family                   = "kd-display-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "kd-display-service"
      image     = var.display_service_image
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      environment = [
        {
          name  = "DATABASE_HOST"
          value = aws_db_instance.kd_postgres.address
        },
        {
          name  = "DATABASE_PORT"
          value = tostring(aws_db_instance.kd_postgres.port)
        },
        {
          name  = "DATABASE_NAME"
          value = aws_db_instance.kd_postgres.db_name
        },
        {
          name  = "DATABASE_USER"
          value = var.database_username
        },
        {
          name  = "DATABASE_PASS"
          value = var.database_password
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.display_service.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "reset_service" {
  family                   = "kd-reset-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "kd-reset-service"
      image     = var.reset_service_image
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      environment = [
        {
          name  = "DATABASE_HOST"
          value = aws_db_instance.kd_postgres.address
        },
        {
          name  = "DATABASE_PORT"
          value = tostring(aws_db_instance.kd_postgres.port)
        },
        {
          name  = "DATABASE_NAME"
          value = aws_db_instance.kd_postgres.db_name
        },
        {
          name  = "DATABASE_USER"
          value = var.database_username
        },
        {
          name  = "DATABASE_PASS"
          value = var.database_password
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.reset_service.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "display_service" {
  name            = "kd-display-service"
  cluster         = aws_ecs_cluster.kd-cluster.id
  task_definition = aws_ecs_task_definition.display_service.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.kd_private_subnets[*].id
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.display_service.arn
    container_name   = "kd-display-service"
    container_port   = 80
  }
}


resource "aws_ecs_service" "reset_service" {
  name            = "kd-reset-service"
  cluster         = aws_ecs_cluster.kd-cluster.id
  task_definition = aws_ecs_task_definition.reset_service.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.kd_private_subnets[*].id
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.reset_service.arn
    container_name   = "kd-reset-service"
    container_port   = 80
  }
}
