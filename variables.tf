variable "hosted_zone_id" {
  description = "Hosted zone ID in which the certificate validation record will be created"
  type = string
}

variable "domain_name" {
  description = "Certificate domain name"
  type = string
}

variable "subject_alternative_names" {
  description = "Optional alternate subject names to be added to the certificate"
  type = set(object({
    name = string
    zone = string
  }))
  default = []
}
