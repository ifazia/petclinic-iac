variable "DB_USERNAME" {
  description = "Database username"
  type        = string
  sensitive   = true
}
variable "DB_PASSWORD_VET" {
  description = "Database vetdb password"
  type        = string
  sensitive   = true
}

variable "DB_PASSWORD_VISIT" {
  description = "Database visitdb password"
  type        = string
  sensitive   = true
}
variable "DB_PASSWORD_CUSTOMER" {
  description = "Database customerdb password"
  type        = string
  sensitive   = true
}

variable "GRAFANA_PASSWORD" {
  description = "Grafana password"
  type        = string
  sensitive   = true
}
variable "namespaces" {
  description = "Liste des namespaces pour l'application"
  type        = list(string)
  default     = ["dev", "staging", "production"]
}
# Nom de domaine comme variable
variable "domain_name" {
  type    = string
  default = "petclinicapp.net"
}
variable "s3_bucket_name" {
  description = "Nom du bucket S3 pour stocker les fichiers d'état"
  type        = string
  default = "tfstate-petclinic-bucket"
}

variable "dynamodb_table_name" {
  description = "Nom de la table DynamoDB pour le verrouillage"
  type        = string
  default = "terraform-state-locks"
}

#variable "kms_key_arn" {
  #description = "ARN de la clé KMS pour le chiffrement du cluster EKS"
  #type        = string
  #default     = "arn:aws:kms:us-east-1:590184139086:key/3241fc68-ae93-45b1-a940-c6408718d657"
#}