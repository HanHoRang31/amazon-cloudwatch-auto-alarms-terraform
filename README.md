# amazon-cloudwatch-auto-alarms-terraform
이 프로젝트는 amazon-cloudwatch-auto-alarms(https://github.com/aws-samples/amazon-cloudwatch-auto-alarms/tree/main) 프로젝트를 테라폼 모듈화한 프로젝트입니다.

<img width="506" alt="blog 754" src="https://github.com/HanHoRang31/amazon-cloudwatch-auto-alarms-terraform/assets/117359361/d84b3925-c93d-41cc-9878-08597d376c0d">


# 실행 
### 1. SNS Topic 생성
SNS Topic Arn 을 복사하여 main.tf 의 alarm_notification_arn 에 입력

### 2. Terraform 프로비저닝
terraform init

terraform plan

terraform apply 


# 삭제 
terraform destroy 
