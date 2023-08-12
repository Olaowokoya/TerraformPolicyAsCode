resource "aws_codebuild_project" "validate" {
  name         = "codebuild-validate"
  description  = "terraform validate, format, checkov, and tfsec with codebuild"
  service_role = aws_iam_role.codebuild.arn
  tags         = local.common_tags

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = var.codebuild_configuration["cb_compute_type"]
    image        = var.codebuild_configuration["cb_image"]
    type         = var.codebuild_configuration["cb_type"]
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./templates/buildspec-validate.yml"
  }
}

# resource "aws_codebuild_project" "terraform_lint" {
#   name         = "codebuild-linting"
#   description  = "terraform lint with codebuild"
#   service_role = aws_iam_role.codebuild.arn
#   tags         = local.common_tags

#   artifacts {
#     type = "CODEPIPELINE"
#   }

#   environment {
#     compute_type = var.codebuild_configuration["cb_compute_type"]
#     image        = var.codebuild_configuration["cb_image"]
#     type         = var.codebuild_configuration["cb_type"]
#   }

#   source {
#     type      = "CODEPIPELINE"
#     buildspec = "./templates/buildspec-tflint.yml"
#   }
# }

resource "aws_codebuild_project" "terraform_plan" {
  name         = "codebuild-plan"
  description  = "terraform plan with codebuild"
  service_role = aws_iam_role.codebuild.arn
  tags         = local.common_tags

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = var.codebuild_configuration["cb_compute_type"]
    image        = var.codebuild_configuration["cb_image"]
    type         = var.codebuild_configuration["cb_type"]
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./templates/buildspec-plan.yml"
  }
}

resource "aws_codebuild_project" "terraform_apply" {
  name         = "codebuild-apply"
  description  = "codebuild project"
  service_role = aws_iam_role.codebuild.arn
  tags         = local.common_tags

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = var.codebuild_configuration["cb_compute_type"]
    image        = var.codebuild_configuration["cb_image"]
    type         = var.codebuild_configuration["cb_type"]
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./templates/buildspec-apply.yml"
  }
}