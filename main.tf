terraform {
  required_providers {
    aws = ">= 0.13.0"
  }
}

resource "aws_acm_certificate" "acm_certificate" {
  domain_name = var.domain_name
  validation_method = "DNS"
  subject_alternative_names = var.subject_alternative_names
}

resource "aws_route53_record" "acm_certificate_validation_record" {
  for_each = {
    for domain_validation_option in aws_acm_certificate.acm_certificate.domain_validation_options: domain_validation_option.domain_name => {
      name = domain_validation_option.resource_record_name
      record = domain_validation_option.resource_record_value
      type = domain_validation_option.resource_record_type
    }
  }
  zone_id = var.hosted_zone_id
  allow_overwrite = true
  ttl = 60
  name = each.value["name"]
  type = each.value["type"]
  records = [
    each.value["record"]
  ]
}

resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  certificate_arn = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [
    for record in aws_route53_record.acm_certificate_validation_record : record.fqdn
  ]
}
