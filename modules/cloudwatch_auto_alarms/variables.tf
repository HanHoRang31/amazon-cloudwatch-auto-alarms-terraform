variable "memory" {
  description = "Memory to allocate to Lambda function"
  type        = number
  default     = 128
}

variable "event_state" {
  description = "Create Cloudwatch event to trigger execution on instance start / terminate."
  type        = string
  default     = "ENABLED"
}

variable "alarm_notification_arn" {
  description = "Enter the Amazon SNS Notification ARN for alarm notifications, leave blank to disable notifications."
  type        = string
  default     = ""
}

variable "alarm_identifier_prefix" {
  description = "Enter the prefix that should be added to the beginning of each alarm created by the solution"
  type        = string
  default     = "AutoAlarm"
}
