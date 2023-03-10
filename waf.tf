resource "aws_wafv2_web_acl" "cdn" {
  name  = replace(local.hostname, ".", "-")
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "rule-1"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "na"
      sampled_requests_enabled   = false
    }
  }



  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "na"
    sampled_requests_enabled   = false
  }
}
