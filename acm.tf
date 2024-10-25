# Création de la zone hébergée pour le domaine
resource "aws_route53_zone" "petclinic_zone" {
  name    = var.domain_name
  comment = "Zone hébergée pour le domaine Petclinic"
}

# Zone hébergée pour le domaine
data "aws_route53_zone" "petclinic_zone" {
  name = aws_route53_zone.petclinic_zone.name
}

# Certificat ACM pour le domaine
resource "aws_acm_certificate" "petclinic_cert" {
  provider          = aws.us-east-1
  domain_name       = var.domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

# Enregistrement DNS pour la validation du certificat
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.petclinic_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }
  zone_id = aws_route53_zone.petclinic_zone.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.record]
}
# Crée dynamiquement www-dev, www-staging, www-production
resource "aws_route53_record" "www_namespace" {
  for_each = toset(var.namespaces)

  zone_id = aws_route53_zone.petclinic_zone.zone_id
  name     = "www-${each.key}.var.domain_name"
  type     = "CNAME"
  records  = ["petclinicapp.net"]  # Redirige vers petclinicapp.net
}
# Validation du certificat ACM
resource "aws_acm_certificate_validation" "petclinic_cert_validation" {
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.petclinic_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

