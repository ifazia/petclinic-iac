variable "DB_USERNAME_VET" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "DB_PASSWORD_VET" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "DB_USERNAME_VISIT" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "DB_PASSWORD_VISIT" {
  description = "Database password"
  type        = string
  sensitive   = true
}
variable "DB_USERNAME_CUSTOMER" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "DB_PASSWORD_CUSTOMER" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "GRAFANA_PASSWORD" {
  description = "Grafana password"
  type        = string
  sensitive   = true
}