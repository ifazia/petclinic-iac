resource "aws_security_group" "petclinic-rds-sg" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = module.vpc.private_subnets_cidr_blocks
  }

  tags = {
    Name      = "petclinic-rds-sg",
    petclinic = ""
  }
}

module "vet_db" {
  source     = "terraform-aws-modules/rds/aws"
  identifier = "vet-db"

  engine            = "mysql"
  engine_version    = "8.0.35"
  instance_class    = "db.t3.small"
  allocated_storage = 5

  db_name                     = "vetdb"
  username                    = var.DB_USERNAME_VET
  password                    = var.DB_PASSWORD_VET
  manage_master_user_password = false
  port                        = "3306"

  vpc_security_group_ids = [aws_security_group.petclinic-rds-sg.id]

  tags = {
    Name      = "vet-db",
    petclinic = ""
  }

  backup_retention_period = 7
  backup_window           = "03:00-06:00"
  skip_final_snapshot     = true

  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets

  family = "mysql8.0"

  major_engine_version = "8.0"

  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]
}

module "visit_db" {
  source     = "terraform-aws-modules/rds/aws"
  identifier = "visit-db"

  engine            = "mysql"
  engine_version    = "8.0.35"
  instance_class    = "db.t3.small"
  allocated_storage = 5

  db_name                     = "visitdb"
  username                    = var.DB_USERNAME_VISIT
  password                    = var.DB_PASSWORD_VISIT
  manage_master_user_password = false
  port                        = "3306"

  vpc_security_group_ids = [aws_security_group.petclinic-rds-sg.id]

  tags = {
    Name      = "visit-db",
    petclinic = ""
  }

  backup_retention_period = 7
  backup_window           = "03:00-06:00"
  skip_final_snapshot     = true

  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets

  family = "mysql8.0"

  major_engine_version = "8.0"

  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]
}

module "customer_db" {
  source     = "terraform-aws-modules/rds/aws"
  identifier = "customer-db"

  engine            = "mysql"
  engine_version    = "8.0.35"
  instance_class    = "db.t3.small"
  allocated_storage = 5

  db_name                     = "customerdb"
  username                    = var.DB_USERNAME_CUSTOMER
  password                    = var.DB_PASSWORD_CUSTOMER
  manage_master_user_password = false
  port                        = "3306"

  vpc_security_group_ids = [aws_security_group.petclinic-rds-sg.id]

  tags = {
    Name      = "customer-db",
    petclinic = ""
  }

  backup_retention_period = 7
  backup_window           = "03:00-06:00"
  skip_final_snapshot     = true

  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets

  family = "mysql8.0"

  major_engine_version = "8.0"

  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]
}
