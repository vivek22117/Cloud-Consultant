
resource "aws_cloudwatch_log_group" "lambda-api-loggroup" {
  name              = "/aws/lambda/${var.email-reminder-lambda}"

  retention_in_days = var.log-retention-in-days
}


#########################################################
#          Lambda function for Email Notification       #
#########################################################
resource "aws_lambda_function" "email_reminder" {
  function_name = var.email-reminder-lambda
  handler       = "email-processor-lambda.lambda_handler"

  filename         = data.archive_file.lambda_for_email.output_path
  source_code_hash = data.archive_file.lambda_for_email.output_base64sha256
  role             = aws_iam_role.lambda_access_role.arn

  memory_size = var.memory-size
  runtime     = "python3.7"
  timeout     = var.time-out

  environment {
    variables = {
      verified_email = var.verified_email
    }
  }
  tags = local.common_tags
}

#####################################################
# Adding the lambda archive to the defined bucket   #
#####################################################
resource "aws_s3_bucket_object" "lambda-package" {
  bucket                 = data.terraform_remote_state.backend.outputs.aritfactory_bucket_name
  key                    = var.email-lambda-bucket-key
  source                 = "lambda-function/email-processor-lambda.zip"
  server_side_encryption = "AES256"
}


resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.email_reminder.arn
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_deployment.portfolio_api_deployment.execution_arn}/*/*/*"
}

