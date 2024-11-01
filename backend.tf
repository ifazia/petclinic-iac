# Configuration du bucket S3 pour stocker les fichiers d'état
resource "aws_s3_bucket" "tfstate" {
  bucket = "tfstate-petclinic-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = "Petclinic Terraform State Bucket"
  }
}

# Table DynamoDB pour le verrouillage de l'état Terraform
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform Lock Table"
  }
}

# Configuration du backend S3 pour Terraform avec DynamoDB pour le verrouillage
terraform {
  backend "s3" {
    bucket         = aws_s3_bucket.tfstate.bucket
    key            = "tfstatefiles/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = aws_dynamodb_table.terraform_locks.name
    encrypt        = true
  }
}
