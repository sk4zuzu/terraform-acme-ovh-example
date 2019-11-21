
variable "OVH_APPLICATION_KEY" {}
variable "OVH_DNS_ZONE" {}

variable "OVH_ENDPOINT" {}
variable "OVH_APPLICATION_SECRET" {}
variable "OVH_CONSUMER_KEY" {}

variable "OVH_DNS_SUBDOMAIN" {}
variable "OVH_IP_ADDRESS" {}

variable "ACME_SERVER_URL" {}
variable "ACME_EMAIL_ADDRESS" {}

provider "ovh" {
  endpoint           = var.OVH_ENDPOINT
  application_key    = var.OVH_APPLICATION_KEY
  application_secret = var.OVH_APPLICATION_SECRET
  consumer_key       = var.OVH_CONSUMER_KEY
}

data "ovh_domain_zone" "zone" {
  name = var.OVH_DNS_ZONE
}

resource "ovh_domain_zone_record" "record" {
  zone      = data.ovh_domain_zone.zone.name
  subdomain = var.OVH_DNS_SUBDOMAIN
  fieldtype = "A"
  ttl       = 3600
  target    = var.OVH_IP_ADDRESS
}

provider "tls" {}

resource "tls_private_key" "key" {
  algorithm = "RSA"
}

provider "acme" {
  server_url = var.ACME_SERVER_URL
}

resource "acme_registration" "registration" {
  account_key_pem = tls_private_key.key.private_key_pem
  email_address   = var.ACME_EMAIL_ADDRESS
}

resource "acme_certificate" "certificate" {
  account_key_pem = acme_registration.registration.account_key_pem
  common_name     = "${var.OVH_DNS_SUBDOMAIN}.${var.OVH_DNS_ZONE}"

  recursive_nameservers = [
    "dns108.ovh.net:53",
    "ns108.ovh.net:53",
  ]

  dns_challenge {
    provider = "ovh"

    config = {
      OVH_ENDPOINT           = var.OVH_ENDPOINT
      OVH_APPLICATION_KEY    = var.OVH_APPLICATION_KEY
      OVH_APPLICATION_SECRET = var.OVH_APPLICATION_SECRET
      OVH_CONSUMER_KEY       = var.OVH_CONSUMER_KEY
    }
  }
}

output "id" {
  value = acme_certificate.certificate.id
}

output "certificate_url" {
  value = acme_certificate.certificate.certificate_url
}

output "certificate_domain" {
  value = acme_certificate.certificate.certificate_domain
}

output "private_key_pem" {
  value = acme_certificate.certificate.private_key_pem
}

output "certificate_pem" {
  value = acme_certificate.certificate.certificate_pem
}

output "issuer_pem" {
  value = acme_certificate.certificate.issuer_pem
}

# vim:ts=2:sw=2:et:syn=terraform:
