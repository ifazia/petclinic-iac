
terraform {
  backend "s3" {
    bucket = "tfstate-petclinic-bucket-devops"
    key    = "tfstatefiles/terraform.tfstate"
    region = "us-east-1"
  }
}