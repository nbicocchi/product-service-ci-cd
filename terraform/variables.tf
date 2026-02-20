variable "aws_region" {
  description = "aws region for resources"
  type        = string
  default     = "eu-north-1"
}

variable "ami_id" {
  description = "Ami ID for EC2 instance (UBUNTU 24.04 LTS)"
  type        = string
  default     = "ami-0a716d3f3b16d290c" 
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}


variable "app_name" {
  description = "App name for resources tag"
  type        = string
  default     = "product-service"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "Staging"
}