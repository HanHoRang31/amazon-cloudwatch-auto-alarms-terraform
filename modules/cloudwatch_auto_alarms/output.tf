output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.cloudwatch_auto_alarms.function_name
}

output "lambda_role_arn" {
  description = "ARN of the Lambda function IAM role"
  value       = aws_iam_role.cloudwatch_auto_alarm_lambda_role.arn
}
