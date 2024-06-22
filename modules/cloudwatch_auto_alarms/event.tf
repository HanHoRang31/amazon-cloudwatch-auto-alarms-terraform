resource "aws_cloudwatch_event_rule" "ec2_event_rule" {
  name        = "Initiate-CloudWatchAutoAlarmsEC2"
  description = "Creates CloudWatch alarms on instance start via Lambda CloudWatchAutoAlarms and deletes them on instance termination."
  event_pattern = jsonencode({
    source = ["aws.ec2"],
    detail-type = ["EC2 Instance State-change Notification"],
    detail = {
      state = ["running", "terminated"]
    }
  })
  state = var.event_state
}

resource "aws_cloudwatch_event_target" "ec2_event_target" {
  rule      = aws_cloudwatch_event_rule.ec2_event_rule.name
  target_id = "ec2EventTarget"
  arn       = aws_lambda_function.cloudwatch_auto_alarms.arn
}

resource "aws_lambda_permission" "ec2_event_permission" {
  statement_id  = "AllowExecutionFromCloudWatchEventsEC2"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloudwatch_auto_alarms.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2_event_rule.arn
}

resource "aws_cloudwatch_event_rule" "rds_create_event_rule" {
  name        = "Initiate-CloudWatchAutoAlarmsRDSCreate"
  description = "Creates CloudWatch alarms for RDS instances with CloudWatchAutoAlarms activation tag"
  event_pattern = jsonencode({
    source = ["aws.rds"],
    detail-type = ["AWS API Call via CloudTrail"],
    detail = {
      eventSource = ["rds.amazonaws.com"],
      eventName = ["AddTagsToResource"]
    }
  })
  state = var.event_state
}

resource "aws_cloudwatch_event_target" "rds_create_event_target" {
  rule      = aws_cloudwatch_event_rule.rds_create_event_rule.name
  target_id = "rdsCreateEventTarget"
  arn       = aws_lambda_function.cloudwatch_auto_alarms.arn
}

resource "aws_lambda_permission" "rds_create_event_permission" {
  statement_id  = "AllowExecutionFromCloudWatchEventsRDSCreate"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloudwatch_auto_alarms.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.rds_create_event_rule.arn
}

resource "aws_cloudwatch_event_rule" "rds_delete_event_rule" {
  name        = "Initiate-CloudWatchAutoAlarmsRDSDelete"
  description = "Deletes CloudWatch alarms for corresponding RDS instance is deleted"
  event_pattern = jsonencode({
    source = ["aws.rds"],
    detail = {
      EventCategories = ["creation", "deletion"]
    }
  })
  state = var.event_state
}

resource "aws_cloudwatch_event_target" "rds_delete_event_target" {
  rule      = aws_cloudwatch_event_rule.rds_delete_event_rule.name
  target_id = "rdsDeleteEventTarget"
  arn       = aws_lambda_function.cloudwatch_auto_alarms.arn
}

resource "aws_lambda_permission" "rds_delete_event_permission" {
  statement_id  = "AllowExecutionFromCloudWatchEventsRDSDelete"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloudwatch_auto_alarms.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.rds_delete_event_rule.arn
}

resource "aws_cloudwatch_event_rule" "lambda_event_rule" {
  name        = "Initiate-CloudWatchAutoAlarmsLambda"
  description = "Creates and deletes CloudWatch alarms for lambda functions with the CloudWatchAutoAlarms activation tag"
  event_pattern = jsonencode({
    source = ["aws.lambda"],
    detail-type = ["AWS API Call via CloudTrail"],
    detail = {
      eventSource = ["lambda.amazonaws.com"],
      eventName = ["TagResource20170331v2", "DeleteFunction20150331"]
    }
  })
  state = var.event_state
}

resource "aws_cloudwatch_event_target" "lambda_event_target" {
  rule      = aws_cloudwatch_event_rule.lambda_event_rule.name
  target_id = "lambdaEventTarget"
  arn       = aws_lambda_function.cloudwatch_auto_alarms.arn
}

resource "aws_lambda_permission" "lambda_event_permission" {
  statement_id  = "AllowExecutionFromCloudWatchEventsLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloudwatch_auto_alarms.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_event_rule.arn
}

resource "aws_cloudwatch_event_rule" "scheduled_rule" {
  name        = "CloudWatchAutoAlarmsScheduledRule"
  description = "Execute CloudWatchAutoAlarms on schedule"
  schedule_expression = "rate(1 day)"
  state       = "ENABLED"
}

resource "aws_cloudwatch_event_target" "scheduled_target" {
  rule      = aws_cloudwatch_event_rule.scheduled_rule.name
  target_id = "scheduledEventTarget"
  arn       = aws_lambda_function.cloudwatch_auto_alarms.arn
  input     = jsonencode({
    action = "scan"
  })
}

resource "aws_lambda_permission" "scheduled_event_permission" {
  statement_id  = "AllowExecutionFromCloudWatchEventsScheduled"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloudwatch_auto_alarms.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduled_rule.arn
}
