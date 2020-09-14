locals {
  all_domains = concat([var.domain_name], [
   for san in var.subject_alternative_names : san.name
  ])

  all_zones = concat([var.hosted_zone_id], [
    for san in var.subject_alternative_names : san.zone
  ])

  domain_to_zone_map = zipmap(local.all_domains, local.all_zones)

  cert_san = reverse(sort([
    for san in var.subject_alternative_names : san.name
  ]))

  cert_validation_domains = [
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : tomap(dvo)
  ]
}
resource "aws_acm_certificate" "acm_certificate" {
  domain_name = var.domain_name
  validation_method = "DNS"
  subject_alternative_names = local.cert_san
}

resource "aws_route53_record" "acm_certificate_validation_record" {
  count = length(distinct(local.all_domains))

  zone_id = lookup(local.domain_to_zone_map, local.cert_validation_domains[count.index]["domain_name"])
  allow_overwrite = true
  name = local.cert_validation_domains[count.index]["resource_record_name"]
  type = local.cert_validation_domains[count.index]["resource_record_type"]
  ttl = 60
  records = [
    local.cert_validation_domains[count.index]["resource_record_value"]
  ]
}

resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  certificate_arn = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = local.cert_validation_domains[*]["resource_record_name"]
}
