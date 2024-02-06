output "arn" {
  value = aws_lambda_function.function.arn
}

output "function_name" {
  value = aws_lambda_function.function.function_name
}

output "latest_arn" {
  value = aws_lambda_alias.latest.arn
}

output "latest_qualifier" {
  value = aws_lambda_alias.latest.name
}

output "version" {
  value = aws_lambda_function.function.version
}

output "version_arn" {
  value = "${aws_lambda_function.function.arn}:${aws_lambda_function.function.version}"
}
