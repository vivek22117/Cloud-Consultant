data "template_file" "website_formlogic" {
  template = file("${path.module}/templates/formlogic.js.tpl")

  vars = {
    api-gateway-api = aws_api_gateway_deployment.portfolio_api_deployment.invoke_url
  }
}

##################################################
#  Creates a file the specified filename field   #
##################################################
resource "local_file" "rendered_formlogic_js" {
  filename = "${path.module}/../static-website/static-content/formlogic.js"
  content  = data.template_file.website_formlogic.rendered
}

#######################################################
#              ZIP file for email lambda              #
#######################################################
data "archive_file" "lambda_for_email" {
  type        = "zip"
  source_file = "lambda-function/email-processor-lambda.py"
  output_path = "lambda-function/email-processor-lambda.zip"
}

################################################
#    Remote state to fetch s3 deploy bucket    #
################################################
data "terraform_remote_state" "backend" {
  backend = "s3"

  config = {
    profile = "admin"
    bucket  = "${var.s3_bucket_prefix}-${var.environment}-${var.default_region}"
    key     = "state/${var.environment}/backend/terraform.tfstate"
    region  = var.default_region
  }
}

