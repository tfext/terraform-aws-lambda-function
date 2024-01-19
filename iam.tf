module "lambda_assume_role" {
  source = "github.com/tfext/terraform-aws-assume-role-policy"
  type   = "lambda"
}

data "aws_iam_policy_document" "function" {
  statement {
    sid       = "logs"
    actions   = ["logs:*"]
    resources = [aws_cloudwatch_log_group.function.arn]
  }
}

resource "aws_iam_role" "function" {
  name               = "${var.name}-lambda-function"
  description        = module.tagging.managed_by_description
  assume_role_policy = module.lambda_assume_role.policy.json
}

resource "aws_iam_role_policy" "function" {
  role   = aws_iam_role.function.id
  policy = data.aws_iam_policy_document.function.json
}
