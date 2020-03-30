//Global Variables
variable "profile" {
  type        = string
  description = "AWS Profile name for credentials"
}

variable "environment" {
  type        = string
  description = "Environment to be configured 'dev', 'qa', 'prod'"
}

variable "default_region" {
  type    = string
  description = "AWS region to deploy resources"
}

#####========================Lambda Configuration======================#####
variable "log-retention-in-days" {
  type = number
  description = "Numer of days to retain logs"
}

variable "email-reminder-lambda" {
  type        = string
  description = "Name of lambda function for Email Reminder"
}

variable "memory-size" {
  type        = string
  description = "Lambda memory size"
}

variable "time-out" {
  type        = string
  description = "Lambda time out"
}

variable "api_gateway_reminder_path" {
  type        = string
  description = "URL path for reminder api gateway resource"
}

variable "email-lambda-bucket-key" {
  type    = string
  description = "S3 bucket key to hold lambda artifactory"
}

variable "verified_email" {
  type    = string
  description = "Verified email Id to send email!"
}

#####====================Default Variables==================#####
variable "s3_bucket_prefix" {
  type    = string
  default = "doubledigit-tfstate"
}

#####============================Local variables=====================#####
locals {
  common_tags = {
    owner       = "Vivek"
    team        = "DoubleDigitTeam"
    environment = var.environment
  }
}

