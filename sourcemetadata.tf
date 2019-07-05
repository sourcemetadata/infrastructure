# SPDX-Copyright: ©  Basil Peace
# SPDX-License-Identifier: Apache-2.0

# Use FIDATA shared infrastructure
terraform {
  required_version = "~> 0.10"
  backend "artifactory" {
    url      = "https://fidata.jfrog.io/fidata"
    repo     = "terraform-state"
    subpath  = "sourcemetadata"
  }
}

# Variables

variable "cloudflare_email" {
  type = "string"
}
variable "cloudflare_token" {
  type = "string"
}

# Providers

provider "cloudflare" {
  version = "~> 1.1"
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

# VPC and security groups

# DNS

resource "cloudflare_record" "website" {
  domain = "sourcemetadata.org"
  name = "sourcemetadata.org"
  type = "CNAME"
  value = "sourcemetadata.github.io"
  proxied = false
}

resource "cloudflare_record" "www" {
  domain = "sourcemetadata.org"
  name = "www"
  type = "CNAME"
  value = "sourcemetadata.github.io"
  proxied = false
}

resource "cloudflare_record" "CAA_letsencrypt" {
  domain = "sourcemetadata.org"
  name = "sourcemetadata.org"
  type = "CAA"
  data = {
    flags = 0
    tag   = "issue"
    value = "letsencrypt.org"
  }
}

resource "cloudflare_record" "CAA_mailto_1" {
  domain = "sourcemetadata.org"
  name = "sourcemetadata.org"
  type = "CAA"
  data = {
    flags = 0
    tag   = "issue"
    value = "mailto:grv87@yandex.ru"
  }
}

resource "cloudflare_record" "CAA_mailto_2" {
  domain = "sourcemetadata.org"
  name = "sourcemetadata.org"
  type = "CAA"
  data = {
    flags = 0
    tag   = "issue"
    value = "mailto:basil.peace@gmail.com"
  }
}

resource "cloudflare_record" "yandex_mail_verification" {
  domain = "sourcemetadata.org"
  name = "sourcemetadata.org"
  type = "TXT"
  value = "yandex-verification: e9bacdecb69b7eaa"
}

resource "cloudflare_record" "mail" {
  domain = "sourcemetadata.org"
  name = "sourcemetadata.org"
  type = "MX"
  value = "mx.yandex.net"
  priority = 10
}

resource "cloudflare_record" "mail_subdomain" {
  domain = "sourcemetadata.org"
  name = "mail"
  type = "CNAME"
  value = "domain.mail.yandex.net"
}

resource "cloudflare_record" "yandex_mail_dkim" {
  domain = "sourcemetadata.org"
  name = "mail._domainkey"
  type = "TXT"
  value = "v=DKIM1; k=rsa; t=s; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC0Vyiv7feOJRZWIJcVv03666ZDVqBELZ9BMaoJQ3ga6vQbNu3cJFXsWYS7h/seEU26tjUV3+9oq/YZJPk9lnFfoM0u/tciyaCSTRcIEFylk1Cbm1pX3ey9yms1sYTKpd6bjqLbnqDEMUrMpRwFybsCGkkc5hyVTkWLQvIzQog7BQIDAQAB"
}

resource "cloudflare_record" "spf_txt" {
  domain = "sourcemetadata.org"
  name = "@"
  type = "TXT"
  value = "v=spf1 redirect=_spf.yandex.net"
}

resource "cloudflare_record" "spf" {
  domain = "sourcemetadata.org"
  name = "@"
  type = "SPF"
  value = "v=spf1 redirect=_spf.yandex.net"
}

resource "cloudflare_record" "github_verify_domain" {
  domain = "sourcemetadata.org"
  name = "_github-challenge-sourcemetadata.sourcemetadata.org."
  type = "TXT"
  value = "075bcded9f"
}
