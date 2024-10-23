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
# Ajouter l'enregistrement DNS pour la validation du certificat
resource "aws_route53_record" "petclinic_cert_validation" {
  name    = aws_acm_certificate.petclinic_cert.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.petclinic_cert.domain_validation_options[0].resource_record_type
  zone_id = aws_route53_zone.petclinicapp.zone_id
  records = [aws_acm_certificate.petclinic_cert.domain_validation_options[0].resource_record_value]
  ttl     = 60
}