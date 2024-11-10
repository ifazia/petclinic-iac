# Création du groupe de sécurité pour RDS
resource "aws_security_group" "petclinic-rds-sg" {
  vpc_id = module.vpc.vpc_id

  # Autorisation du trafic entrant sur le port 3306 depuis les sous-réseaux privés
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = module.vpc.private_subnets_cidr_blocks
  }

  # Autorisation du trafic sortant vers tout
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "petclinic-rds-sg",
    petclinic = ""
  }
}

# Configuration de la base de données 'vet_db'
module "vet_db" {
  source     = "terraform-aws-modules/rds/aws"
  identifier = "vet-db"

  engine            = "mysql"
  engine_version    = "8.0.35"
  instance_class    = "db.t3.small"
  allocated_storage = 5

  db_name                     = "vetdb"
  username                    = var.DB_USERNAME
  password                    = var.DB_PASSWORD_VET
  manage_master_user_password = false
  port                        = "3306"

  # Lien avec le groupe de sécurité RDS
  vpc_security_group_ids = [aws_security_group.petclinic-rds-sg.id]

  tags = {
    Name      = "vet-db",
    petclinic = ""
  }

  backup_retention_period = 0 # 7
  backup_window           = "03:00-06:00"
  skip_final_snapshot     = true

  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets

  family = "mysql8.0"
  major_engine_version = "8.0"
  deletion_protection  = false

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

  availability_zone = "us-east-1a"
}

# Configuration de la base de données 'visit_db'
module "visit_db" {
  source     = "terraform-aws-modules/rds/aws"
  identifier = "visit-db"

  engine            = "mysql"
  engine_version    = "8.0.35"
  instance_class    = "db.t3.small"
  allocated_storage = 5

  db_name                     = "visitdb"
  username                    = var.DB_USERNAME
  password                    = var.DB_PASSWORD_VISIT
  manage_master_user_password = false
  port                        = "3306"

  # Lien avec le groupe de sécurité RDS
  vpc_security_group_ids = [aws_security_group.petclinic-rds-sg.id]

  tags = {
    Name      = "visit-db",
    petclinic = ""
  }

  backup_retention_period = 0 # 7
  backup_window           = "03:00-06:00"
  skip_final_snapshot     = true

  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets

  family = "mysql8.0"
  major_engine_version = "8.0"
  deletion_protection  = false

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

  availability_zone = "us-east-1a"
}

# Configuration de la base de données 'customer_db'
module "customer_db" {
  source     = "terraform-aws-modules/rds/aws"
  identifier = "customer-db"

  engine            = "mysql"
  engine_version    = "8.0.35"
  instance_class    = "db.t3.small"
  allocated_storage = 5

  db_name                     = "customerdb"
  username                    = var.DB_USERNAME
  password                    = var.DB_PASSWORD_CUSTOMER
  manage_master_user_password = false
  port                        = "3306"

  # Lien avec le groupe de sécurité RDS
  vpc_security_group_ids = [aws_security_group.petclinic-rds-sg.id]

  tags = {
    Name      = "customer-db",
    petclinic = ""
  }

  backup_retention_period = 0 # 7
  backup_window           = "03:00-06:00"
  skip_final_snapshot     = true

  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets

  family = "mysql8.0"
  major_engine_version = "8.0"
  deletion_protection  = false

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

  availability_zone = "us-east-1a"
}
