
terraform {
  backend "s3" {
    bucket = "tfstate-petclinic-bucket-projet"
    key    = "tfstatefiles/terraform.tfstate"
    region = "us-east-1"
  }
}