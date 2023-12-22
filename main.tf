module "tagging" {
  source = "github.com/dan-drew/terraform-utilities-tagging"
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

  dynamic "environment" {
    for_each = var.environment == null ? [] : [1]
    content {
      variables = var.environment
    }
  }

  # lifecycle {
  #   ignore_changes = [last_modified]
  # }

  depends_on = [
    aws_iam_role_policy.function
  ]
}

data "archive_file" "source" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.root}/${var.name}-lambda.zip"
}

resource "aws_lambda_alias" "latest" {
  name             = "latest"
  function_name    = aws_lambda_function.function.function_name
  function_version = "$LATEST"
}

resource "aws_cloudwatch_log_group" "function" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = var.log_retention_days
}
