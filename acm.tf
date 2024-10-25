# Création de la zone hébergée pour le domaine
resource "aws_route53_zone" "petclinic_zone" {
  name    = var.domain_name
  comment = "Zone hébergée pour le domaine Petclinic"
  validation_method = "DNS"
}

# Zone hébergée pour le domaine
data "aws_route53_zone" "petclinic_zone" {
  name = aws_route53_zone.petclinic_zone.name
  private_zone = false
}
# Certificat ACM pour le domaine
resource "aws_acm_certificate" "petclinic_zone" {
  provider          = aws.us-east-1
  domain_name       = var.domain_name
  validation_method = "DNS"
}

# Enregistrement DNS pour la validation du certificat
resource "aws_route53_record" "petclinic_zone" {
  for_each = {
    for dvo in aws_acm_certificate.petclinic_zone.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
  zone_id         = data.aws_route53_zone.petclinic_zone.zone_id
}

# Crée dynamiquement www-dev, www-staging, www-production
resource "aws_route53_record" "petclinic_zone" {
  for_each = toset(var.namespaces)

  zone_id = aws_route53_zone.petclinic_zone.zone_id
  name     = "www-${each.key}.var.domain_name"
  type     = "CNAME"
  records  = ["petclinicapp.net"]  # Redirige vers petclinicapp.net
}
---
# Validation du certificat ACM
resource "aws_acm_certificate_validation" "petclinic_zone" {
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.petclinic_zone.arn
  validation_record_fqdns = [for record in aws_route53_record.petclinic_zone : record.fqdn]
}
