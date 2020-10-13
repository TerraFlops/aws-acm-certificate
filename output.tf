output "arn" {
  description = "The ARN of the certificate"
  value = aws_acm_certificate.acm_certificate.arn
}

output "id" {
  description = "The ID of the certificate"
  value = aws_acm_certificate.acm_certificate.id
}

output "domain_name" {
  description = "The domain name for which the certificate is issued"
  value = aws_acm_certificate.acm_certificate.domain_name
}

output "domain_validation_options" {
  description = "Set of domain validation objects which can be used to complete certificate validation. Can have more than one element, e.g. if SANs are defined. Only set if DNS-validation was used."
  value = aws_acm_certificate.acm_certificate.domain_validation_options
}

output "status" {
  description = "Status of the certificate."
  value = aws_acm_certificate.acm_certificate.status
}
