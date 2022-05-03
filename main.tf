terraform {
  backend "s3" {
    bucket = "equipments-terraform-state"
    key    = "equipments/backend"
    region = "eu-north-1"
  }
}


provider "aws" {
  profile = var.profile
  region  = "eu-north-1"
}

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "equipments-terraform-state"
  acl    = "private"
}

resource "aws_cloudwatch_log_group" "equipments_log_group" {
  name = "equipments-log-group"
}

resource "aws_ecs_cluster" "equipments_cluster" {
  name = var.ecs_cluster_name

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"
      log_configuration {
        cloud_watch_encryption_enabled = false
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.equipments_log_group.name
      }
    }
  }
}

resource "aws_ecs_task_definition" "equipments_backend" {
  family = "equipments_backend_tasks"
  container_definitions = jsonencode([
    {
      name      = var.app_name,
      image     = var.docker_image,
      cpu       = 256,
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3100
          hostPort      = 3100
        }
      ]
    }
  ])

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}
resource "aws_ecs_service" "equipments_backend_service" {
  name                               = "equipments-service"
  cluster                            = aws_ecs_cluster.equipments_cluster.id
  task_definition                    = aws_ecs_task_definition.equipments_backend.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = "100"
  deployment_maximum_percent         = "200"
}
