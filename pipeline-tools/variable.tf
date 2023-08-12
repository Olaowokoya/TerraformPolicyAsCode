variable "region" {
  type    = string
  default = "us-east-1"
}
variable "aws_accounts_id" {
  type = map(string)
  default = {
    admin-account = "123456789012"
    sandbox       = "123456789013"
  }
}

variable "codebuild_configuration" {
  type = map(string)
  default = {
    cb_compute_type = "BUILD_GENERAL1_SMALL"
    cb_image        = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    cb_type         = "LINUX_CONTAINER"
  }
}

variable "project_name" {
  type    = string
  default = "ssme-artifact"
}

## Locals

locals {

  # ## pipeline related variables
  # codebuild_bucket                   = "${var.project_name}-permission-sets-${var.aws_accounts_id["admin-account"]}"
  # repository_name    = "${var.project_name}-repo"
  # branch_name = "main"

  ## tags & meta
  common_tags = {
    Project   = "My Project"
    ManagedBy = "Terraform"
  }
}