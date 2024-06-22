data "archive_file" "lambda_file_zip" { 
  type = "zip" 
  source_dir = "${path.module}/src"  
  output_path = "${path.module}/cw-lambda-alerts.zip" 
} 


resource "aws_lambda_function" "cloudwatch_auto_alarms" {
  function_name    = "CloudWatchAutoAlarms"
  role             = aws_iam_role.cloudwatch_auto_alarm_lambda_role.arn
  handler          = "cw_auto_alarms.lambda_handler"
  runtime          = "python3.8"
  memory_size      = var.memory
  timeout          = 600
  filename         = data.archive_file.lambda_file_zip.output_path  # 수정
  source_code_hash = data.archive_file.lambda_file_zip.output_base64sha256  #  수정

  environment {
    variables = {
      ALARM_TAG                        = "Create_Auto_Alarms"
      CREATE_DEFAULT_ALARMS            = "true"
      CLOUDWATCH_NAMESPACE             = "CWAgent"
      ALARM_CPU_HIGH_THRESHOLD         = "75"
      ALARM_DEFAULT_ANOMALY_THRESHOLD  = "2"
      ALARM_CPU_CREDIT_BALANCE_LOW_THRESHOLD = "100"
      ALARM_MEMORY_HIGH_THRESHOLD      = "75"
      ALARM_DISK_PERCENT_LOW_THRESHOLD = "20"
      ALARM_IDENTIFIER_PREFIX          = var.alarm_identifier_prefix
      CLOUDWATCH_APPEND_DIMENSIONS     = "InstanceId, ImageId, InstanceType"

      ALARM_LAMBDA_ERROR_THRESHOLD     = "0"
      ALARM_LAMBDA_THROTTLE_THRESHOLD  = "0"

      DEFAULT_ALARM_SNS_TOPIC_ARN      = var.alarm_notification_arn
    }
  }
}
