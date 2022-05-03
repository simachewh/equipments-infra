variable "profile" {
  description = "AWS profile to use"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "app_name" {
  type        = string
  description = "Name of the application"
}

variable "namespace" {
  type        = string
  description = "Name of the namespace"
}

variable "region" {
  type        = string
  description = "The AWS region to use"
}

variable "repo_name" {
  type        = string
  description = "The name of the GitHub repository"
}

variable "repo_owner" {
  type        = string
  description = "The name of the Github repository owner. Orginisation or username"
}

variable "tenant" {
  type        = string
  description = "The customer identifier that indicates who this instance is for"
}
