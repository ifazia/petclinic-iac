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
