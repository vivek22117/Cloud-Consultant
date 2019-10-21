output "s3_bucket_website_endpoint" {
  value       = aws_s3_bucket.website_bucket.website_endpoint
  description = "The website endpoint URL"
}

