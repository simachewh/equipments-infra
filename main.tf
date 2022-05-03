terraform {
  # backend "s3" {
  #   bucket = "terraform-state"
  #   key    = "iac/terraform.tfstate"
  #   region = "eu-north-1"
  # }
}


provider "aws" {
  profile = var.profile
  region  = "eu-north-1"
}

# resource "aws_ecs_service" "equipments_service" {
#   name                               = "equipments-service"
#   cluster                            = "equipmet-cluster"
#   task_definition                    = "equipments-task"
#   desired_count                      = 1
#   deployment_minimum_healthy_percent = "100"
#   deployment_maximum_percent         = "200"
# }

module "ecs-codepipeline" {
  source  = "cloudposse/ecs-codepipeline/aws"
  version = "0.28.5"
  # insert the 21 required variables here
  branch              = "master"
  delimiter           = "-"
  ecs_cluster_name    = var.ecs_cluster_name
  enabled             = true
  environment         = terraform.workspace
  id_length_limit     = 12
  image_repo_name     = "codepipeline-ecs-image-${terraform.workspace}"
  label_key_case      = "upper"
  label_order         = ["environment", "name"]
  label_value_case    = "upper"
  name                = var.app_name
  namespace           = var.namespace
  regex_replace_chars = "/[^a-zA-Z0-9-]/"
  region              = var.region
  repo_name           = "codepipeline-ecs-image-${terraform.workspace}"
  repo_owner          = var.repo_owner
  # secondary_artifact_bucket_id = 
  # secondary_artifact_identifier =
  service_name = "${var.app_name}-${terraform.workspace}"
  stage        = terraform.workspace
  tenant       = var.tenant
}
