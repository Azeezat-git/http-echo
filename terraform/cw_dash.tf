resource "aws_cloudwatch_dashboard" "ecs_dashboard" {
  dashboard_name = "ECS_Dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "text"
        x    = 0
        y    = 0
        width  = 24
        height = 1

        properties = {
          markdown = "# ECS Infrastructure Dashboard\nMonitoring ECS cluster and services."
        }
      },

      {
        type   = "metric"
        x      = 0
        y      = 1
        width  = 8
        height = 6

        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", "app_cluster"],
            ["AWS/ECS", "MemoryUtilization", "ClusterName", "app_cluster"],
          ],
          region = "us-east-1"  # Replace with your desired AWS region
        }
      },

      {
        type   = "metric"
        x      = 8
        y      = 1
        width  = 8
        height = 6

        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ServiceName", "app_service"],
            ["AWS/ECS", "MemoryUtilization", "ServiceName", "app_service"],
          ],
          region = "us-east-1"  # Replace with your desired AWS region
        }
      },

      {
        type   = "metric"
        x      = 16
        y      = 1
        width  = 8
        height = 6

        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "TaskDefinitionFamily", "app"],
            ["AWS/ECS", "MemoryUtilization", "TaskDefinitionFamily", "app"],
          ],
          region = "us-east-1"  # Replace with your desired AWS region
        }
      },

      {
        type   = "metric"
        x      = 0
        y      = 7
        width  = 24
        height = 6

        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ServiceName", "app_service"],
            ["AWS/ECS", "MemoryUtilization", "ServiceName", "app_service"],
            ["AWS/ECS", "DesiredTaskCount", "ServiceName", "app_service"],
            ["AWS/ECS", "RunningTaskCount", "ServiceName", "app_service"],
          ],
          region = "us-east-1"  # Replace with your desired AWS region
        }
      },
    ]
  })
}