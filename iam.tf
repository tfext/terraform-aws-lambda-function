data "aws_iam_policy_document" "assume_role" {
  statement {
    principals {
      identifiers = ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
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
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "function" {
  role   = aws_iam_role.function.id
  policy = data.aws_iam_policy_document.function.json
}
