



resource "aws_ecs_cluster" "ecs" {
  name = "app_cluster"  
}

resource "aws_ecs_service" "service" {
    name = "app_service"
    cluster = aws_ecs_cluster.ecs.arn
    launch_type = "FARGATE"
    enable_execute_command = true

    deployment_maximum_percent = 200
    deployment_minimum_healthy_percent = 100
    desired_count = 2
    task_definition = aws_ecs_task_definition.td.arn

    network_configuration {
        assign_public_ip = true
        security_groups = [aws_security_group.ecs_tasks.id]
        subnets = aws_subnet.private.*.id

    
    }

    load_balancer {
        target_group_arn = aws_alb_target_group.app.id
        container_name   = "cb-app"
        container_port   = 5678
    }

    depends_on = [aws_alb_listener.front_end]
}

resource "aws_ecs_task_definition" "td" {
  family = "app"
  container_definitions = jsonencode([
    
    {
      name      = "cb-app"
      image     = "758560478625.dkr.ecr.us-east-1.amazonaws.com/app_repo"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 5678
          hostPort      = 5678
        }
      ]
    }
  ])

  
  requires_compatibilities = ["FARGATE"]
  cpu = "256"
  memory = "512"
  network_mode = "awsvpc"
  task_role_arn = "arn:aws:iam::758560478625:role/ecsTaskExecutionRole"
  execution_role_arn = "arn:aws:iam::758560478625:role/ecsTaskExecutionRole"

}