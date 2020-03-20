//Read S3 Bucket JSON Policy document
data "template_file" "bucket_policy" {
  template = file("scripts/bucket-policy.json")

  vars = {
    bucket      = var.s3_static_content
    environment = var.environment
    region      = var.default_region
    allowed_ips = var.allowed_ips
  }
}

resource "aws_s3_bucket" "website_bucket" {
  depends_on = [data.template_file.bucket_policy]

  bucket = var.s3_static_content
  acl    = "public-read"

  policy        = data.template_file.bucket_policy.rendered
  force_destroy = false

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  versioning {
    enabled = var.versioning_enabled
  }

  lifecycle_rule {
    id      = "staticFile"
    enabled = var.lifecycle_rule_enabled
    prefix  = var.prefix

    noncurrent_version_expiration {
      days = var.noncurrent_version_expiration_days
    }
  }

  tags = merge(local.common_tags, map("Name", "Portfolio-website"))
}

resource "aws_s3_bucket_object" "index_file" {
  bucket       = aws_s3_bucket.website_bucket.id
  source       = "static-content/index.html"
  key          = "index.html"
  content_type = "text/html"
  etag   = filemd5("${path.module}/static-content/index.html")

  depends_on = [aws_s3_bucket.website_bucket]
}

resource "aws_s3_bucket_object" "error_file" {
  bucket       = aws_s3_bucket.website_bucket.id
  source       = "static-content/error.html"
  key          = "error.html"
  content_type = "text/html"
  etag   = filemd5("${path.module}/static-content/error.html")

  depends_on = [aws_s3_bucket.website_bucket]
}

resource "aws_s3_bucket_object" "css_file" {
  bucket       = aws_s3_bucket.website_bucket.id
  source       = "static-content/styles.css"
  key          = "styles.css"
  content_type = "text/css"
  etag   = filemd5("${path.module}/static-content/styles.css")

  depends_on = [aws_s3_bucket.website_bucket]
}

resource "aws_s3_bucket_object" "developer_img" {
  bucket       = aws_s3_bucket.website_bucket.id
  source       = "static-content/images/developer.jpg"
  key          = "images/developer.jpg"
  content_type = "image/jpg"

  depends_on = [aws_s3_bucket.website_bucket]
}

resource "aws_s3_bucket_object" "img_first" {
  bucket       = aws_s3_bucket.website_bucket.id
  source       = "static-content/images/img-1.jpg"
  key          = "images/img-1.jpg"
  content_type = "image/jpg"

  depends_on = [aws_s3_bucket.website_bucket]
}

resource "aws_s3_bucket_object" "img_second" {
  bucket       = aws_s3_bucket.website_bucket.id
  source       = "static-content/images/img-2.jpg"
  key          = "images/img-2.jpg"
  content_type = "image/jpg"

  depends_on = [aws_s3_bucket.website_bucket]
}

resource "aws_s3_bucket_object" "img_third" {
  bucket       = aws_s3_bucket.website_bucket.id
  source       = "static-content/images/img-3.jpg"
  key          = "images/img-3.jpg"
  content_type = "image/jpg"

  depends_on = [aws_s3_bucket.website_bucket]
}

resource "aws_s3_bucket_object" "img_fourth" {
  bucket       = aws_s3_bucket.website_bucket.id
  source       = "static-content/images/img-4.jpg"
  key          = "images/img-4.jpg"
  content_type = "image/jpg"

  depends_on = [aws_s3_bucket.website_bucket]
}

resource "aws_s3_bucket_object" "img_sitebg" {
  bucket       = aws_s3_bucket.website_bucket.id
  source       = "static-content/images/sitebg.jpg"
  key          = "images/sitebg.jpg"
  content_type = "image/jpg"

  depends_on = [aws_s3_bucket.website_bucket]
}

resource "aws_s3_bucket_object" "img_sitebg_second" {
  bucket       = aws_s3_bucket.website_bucket.id
  source       = "static-content/images/sitebg2.jpg"
  key          = "images/sitebg2.jpg"
  content_type = "image/jpg"

  depends_on = [aws_s3_bucket.website_bucket]
}

resource "aws_s3_bucket_object" "script_file" {
  bucket       = aws_s3_bucket.website_bucket.id
  source       = "static-content/script.js"
  key          = "script.js"
  content_type = "text/js"

  depends_on = [aws_s3_bucket.website_bucket]
}

resource "aws_s3_bucket_object" "fonts_others" {
  bucket       = aws_s3_bucket.website_bucket.id
  source       = "static-content/TheHistoriaDemo.eot"
  key          = "TheHistoriaDemo.eot"
  content_type = "text/eot"

  depends_on = [aws_s3_bucket.website_bucket]
}

resource "aws_s3_bucket_object" "fonts_others_second" {
  bucket       = aws_s3_bucket.website_bucket.id
  source       = "static-content/TheHistoriaDemo.svg"
  key          = "TheHistoriaDemo.svg"
  content_type = "text/svg"

  depends_on = [aws_s3_bucket.website_bucket]
}

resource "aws_s3_bucket_object" "fonts_others_third" {
  bucket       = aws_s3_bucket.website_bucket.id
  source       = "static-content/TheHistoriaDemo.ttf"
  key          = "TheHistoriaDemo.ttf"
  content_type = "text/ttf"

  depends_on = [aws_s3_bucket.website_bucket]
}

resource "aws_s3_bucket_object" "fonts_others_fourth" {
  bucket       = aws_s3_bucket.website_bucket.id
  source       = "static-content/TheHistoriaDemo.woff"
  key          = "TheHistoriaDemo.woff"
  content_type = "text/woff"

  depends_on = [aws_s3_bucket.website_bucket]
}


data "aws_route53_zone" "main" {
  name         = var.domain
  private_zone = false
}


resource "aws_route53_record" "portfolio_web_1" {
  zone_id  = data.aws_route53_zone.main.zone_id
  name     = "vivekmishra.doubledigit-solutions.com"
  type     = "A"

  alias {
    name    = aws_s3_bucket.website_bucket.website_domain
    zone_id = aws_s3_bucket.website_bucket.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "portfolio_web_2" {
  zone_id  = data.aws_route53_zone.main.zone_id
  name     = "www.vivekmishra.doubledigit-solutions.com"
  type     = "A"

  alias {
    name    = aws_s3_bucket.website_bucket.website_domain
    zone_id = aws_s3_bucket.website_bucket.hosted_zone_id
    evaluate_target_health = false
  }
}