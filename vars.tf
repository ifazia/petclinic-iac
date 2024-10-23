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