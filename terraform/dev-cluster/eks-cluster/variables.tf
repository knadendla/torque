variable "aws-region" {
  type    = string
  default = "eu-west-1"
}

variable "cluster-name" {
  type    = string
  default = "dev-cluster"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "cluster_enabled_log_types" {
  type    = list(string)
  default = ["api", "audit"]
}

variable "manage_aws_auth_configmap" {
  type    = bool
  default = true
}

variable "load_config_file" {
  type    = bool
  default = false
}

variable "account" {
  type = string
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.2xlarge"]
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 5
}

variable "desired_size" {
  type    = number
  default = 1
}

variable "role_arn" {
  type = string
}

variable "role_username" {
  type = string
}