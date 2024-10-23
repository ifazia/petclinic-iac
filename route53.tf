
# Ajouter l'enregistrement DNS pour la validation du certificat
resource "aws_route53_record" "petclinic_cert_validation" {
  # Utiliser for_each avec une liste d'options
  for_each = { for idx, option in aws_acm_certificate.petclinic_cert.domain_validation_options : option.resource_record_name => option }

  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  zone_id = aws_route53_zone.petclinicapp.zone_id
  records = [each.value.resource_record_value]
  ttl     = 60
}