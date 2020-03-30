#############################
# Global Variables          #
#############################
variable "profile" {
  type = string
  description = "AWS profile name for credentials"
}

variable "default_region" {
  type = string
  description = "AWS region to deploy resources"
}

variable "environment" {
  type = string
  description = "Environment to be configured 'dev', 'qa', 'prod'"
}

variable "component" {
  type = string
  description = "Component name for tfstate"
}


variable "allowed_ips" {
  type        = string
  description = "List of ips allow"
}

variable "versioning_enabled" {
  type        = string
  description = "Specify version enabled or not"
}

variable "lifecycle_rule_enabled" {
  type        = string
  description = "Specify lifecycle enabled or not"
}

variable "prefix" {
  type        = string
  description = "S3 prefix considered for Lifecycle Rule"
}

variable "noncurrent_version_expiration_days" {
  type = string
}

variable "s3_static_content" {
  type    = string
  description = "Static website domain name"
}

variable "domain" {
  type = string
  description = "Domain name registered with AWS Route 53"
}

####################################
# Local variables                  #
####################################
locals {
  common_tags = {
    owner       = "Vivek"
    team        = "TeamConcept"
    environment = var.environment
  }
}