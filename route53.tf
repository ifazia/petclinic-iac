
resource "aws_route53_record" "petclinic_cert_validation" {
  zone_id = aws_route53_zone.petclinicapp.zone_id
  name     = "_d90ec101eea920ec92b0bed129b7d84f.petclinicapp.net"  # Nom fourni par ACM
  type     = "CNAME"
  ttl      = 60
  records  = ["_0e50455f067f74ee3d6fa679ebc31c4a.djqtsrsxkq.acm-validations.aws."]  # Valeur fournie par ACM
}