# Définir la zone hébergée
resource "aws_route53_zone" "petclinicapp" {
  name = "petclinicapp.net"
}

# Créer le certificat ACM avec validation par e-mail
resource "aws_acm_certificate" "petclinic_cert" {
  domain_name       = "petclinicapp.net"
  validation_method = "EMAIL"

  tags = {
    Name = "petclinic_cert"
  }
}

# Obtenir les adresses e-mail de validation
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = aws_acm_certificate.petclinic_cert.arn

  validation_emails = [
    "iguetf@gmail.com",
    "iguetf1@gmail.com"
  ]
}

# Enregistrement pour le www
resource "aws_route53_record" "www_namespace" {
  for_each = toset(var.namespaces)

  zone_id = aws_route53_zone.petclinicapp.zone_id
  name     = "www-${each.key}.petclinicapp.net"  # Crée dynamiquement www-dev, www-staging, www-production
  type     = "CNAME"
  ttl      = 300
  records  = ["petclinicapp.net"]  # Redirige vers petclinicapp.net
}