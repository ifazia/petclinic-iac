
terraform {
  backend "s3" {
    bucket = "tfstate-petclinic"
    key    = "tfstatefiles/terraform.tfstate"
    region = "eu-west-3"
  }
}