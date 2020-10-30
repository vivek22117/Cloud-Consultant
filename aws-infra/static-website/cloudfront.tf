#############################################################
# Cloud-Front distribution for S3 static website            #
#############################################################
resource "aws_cloudfront_origin_access_identity" "dd_origin_access_identity" {
  comment = "DoubleDigit CDN"
}


resource "aws_cloudfront_distribution" "s3_dd_distribution" {
  depends_on = [aws_acm_certificate.dd_solutions, aws_acm_certificate_validation.cert, aws_route53_record.cert_validation]

  http_version        = "http2"
  enabled             = true
  is_ipv6_enabled     = false
  default_root_object = var.index_document

  aliases = var.aliases

  origin {
    domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id   = var.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.dd_origin_access_identity.cloudfront_access_identity_path
    }
  }


  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = var.s3_origin_id
    compress         = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 300
    max_ttl                = 86400
  }

  custom_error_response {
    error_code            = "404"
    error_caching_min_ttl = "300"
    response_code         = var.error_response_code
    response_page_path    = "/${var.error_document}"
  }


  price_class = var.cloudfront_price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.dd_solutions.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
}