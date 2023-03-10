resource "aws_cloudfront_distribution" "cdn" {
  aliases             = [local.hostname]
  price_class         = "PriceClass_100"
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  origin {
    domain_name              = data.aws_s3_bucket.source.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = var.bucket
    origin_path              = format("/%s", var.artifact_version)
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.bucket
    viewer_protocol_policy = "redirect-to-https"
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html?icmpid=docs_cf_help_panel#managed-cache-policies-list
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-origin-request-policies.html?icmpid=docs_cf_help_panel#managed-origin-request-policies-list
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  logging_config {
    bucket = data.aws_s3_bucket.source.bucket_regional_domain_name
    prefix = "cf-logs/"
  }

  web_acl_id = aws_wafv2_web_acl.cdn.arn
}

data "aws_s3_bucket" "source" {
  bucket = var.bucket
}

# https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html
resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "default"
  description                       = "Default S3 Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_s3_bucket_policy" "allow_access_from_cdn" {
  bucket = data.aws_s3_bucket.source.id
  policy = data.aws_iam_policy_document.allow_access_from_cdn.json
}

# From https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html#create-oac-overview-s3
data "aws_iam_policy_document" "allow_access_from_cdn" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadOnly"
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "cloudfront.amazonaws.com"
      ]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      format("%s/*", data.aws_s3_bucket.source.arn),
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values = [
        format("arn:aws:cloudfront::%s:distribution/*", data.aws_caller_identity.current.account_id),
      ]
    }
  }
}

