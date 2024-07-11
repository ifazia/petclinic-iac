
terraform {
  backend "s3" {
    bucket = "tfstate-petclinic-devops"
    key    = "tfstatefiles/terraform.tfstate"
    region = "eu-west-3"
  }
}