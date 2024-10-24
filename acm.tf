# Définir la zone hébergée
resource "aws_route53_zone" "petclinicapp" {
  name = "petclinicapp.net"
}

# Créer le certificat ACM
resource "aws_acm_certificate" "petclinic_cert" {
  domain_name       = "petclinicapp.net"
  validation_method = "DNS"

  tags = {
    Name = "petclinic_cert"
  }
}

# Obtenir les informations de validation DNS du certificat
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.petclinic_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = aws_route53_zone.petclinicapp.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.record]
}

# Attendre que le certificat soit validé
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.petclinic_cert.arn
  validation_record_fqdns  = [for record in aws_route53_record.cert_validation : record.fqdn]

  depends_on = [aws_route53_record.cert_validation]
}