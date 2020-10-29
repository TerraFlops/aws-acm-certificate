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

  domain_validation_options_list = aws_acm_certificate.acm_certificate.domain_validation_options
}

resource "aws_acm_certificate" "acm_certificate" {
  domain_name = var.domain_name
  validation_method = "DNS"
  subject_alternative_names = local.certificate_subject_alternative_names
}

resource "aws_route53_record" "acm_certificate_validation_record" {
  count = length(local.certificate_subject_alternative_names) + 1
  zone_id = length(local.certificate_subject_alternative_names) != 0 ? lookup(local.lookup_hosted_zone_id, element(local.certificate_subject_alternative_names, count.index)) : var.hosted_zone_id
  ttl = 60
  allow_overwrite = true
  name    = element(aws_acm_certificate.acm_certificate.domain_validation_options.*.resource_record_name, count.index)
  type    = element(aws_acm_certificate.acm_certificate.domain_validation_options.*.resource_record_type, count.index)
  records = [element(aws_acm_certificate.acm_certificate.domain_validation_options.*.resource_record_value, count.index)]
}

resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  certificate_arn = join("", aws_acm_certificate.acm_certificate.*.arn)
  validation_record_fqdns = aws_route53_record.acm_certificate_validation_record.*.fqdn

  depends_on = [
    aws_route53_record.acm_certificate_validation_record
  ]
}
