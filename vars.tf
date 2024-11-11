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

#################
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}