terraform {
  required_providers {
    aws = ">= 0.13.0"
  }
}

locals {
  all_domain_names = concat(
    [var.domain_name],
    [for subject_alternative_name in var.subject_alternative_names : subject_alternative_name["name"]]
  )

  all_hosted_zone_ids = concat(
    [var.hosted_zone_id],
    [for subject_alternative_name in var.subject_alternative_names : subject_alternative_name["hosted_zone_id"]]
  )

  lookup_hosted_zone_id = zipmap(local.all_domain_names, local.all_hosted_zone_ids)

  certificate_subject_alternative_names = reverse(sort([
    for subject_alternative_name in var.subject_alternative_names : subject_alternative_name["name"]
  ]))

}
resource "aws_acm_certificate" "acm_certificate" {
  domain_name = var.domain_name
  validation_method = "DNS"
  subject_alternative_names = local.certificate_subject_alternative_names
}

resource "aws_route53_record" "acm_certificate_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options: dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  }

  zone_id = lookup(local.lookup_hosted_zone_id, each.key)
  allow_overwrite = true
  name = each.value["name"]
  type = each.value["type"]
  ttl = 60
  records = [
    each.value["record"]
  ]
}

resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  certificate_arn = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_certificate_validation_record : record.fqdn]
}
