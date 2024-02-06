terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {}
  }
}

module "tagging" {
  source = "github.com/tfext/terraform-utilities-tagging"
}

resource "aws_lambda_function" "function" {
  function_name    = var.name
  description      = module.tagging.managed_by_description
  handler          = "${var.entrypoint}.handler"
  role             = aws_iam_role.function.arn
  runtime          = var.runtime
  filename         = data.archive_file.source.output_path
  source_code_hash = data.archive_file.source.output_base64sha256
  timeout          = var.timeout
  memory_size      = var.memory
  publish          = true

  dynamic "environment" {
    for_each = var.environment == null ? [] : [1]
    content {
      variables = var.environment
    }
  }

  lifecycle {
    ignore_changes = [filename]
  }

  depends_on = [
    aws_iam_role_policy.function
  ]
}

data "archive_file" "source" {
  type        = "zip"
  source_dir  = startswith(var.source_dir, "/") ? var.source_dir : "${path.root}/${trimprefix(var.source_dir, "/")}"
  output_path = "${path.root}/tmp/${var.name}-lambda.zip"
}

resource "aws_lambda_alias" "latest" {
  name             = var.alias
  function_name    = aws_lambda_function.function.function_name
  function_version = aws_lambda_function.function.version
}

resource "aws_cloudwatch_log_group" "function" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = var.log_retention_days
}
