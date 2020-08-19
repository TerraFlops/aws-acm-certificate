output "acm_certificate_arn" {
    description = "The AWS ARN of the certificate"
    value = aws_acm_certificate.acm_certificate.arn
}
