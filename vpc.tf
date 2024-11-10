# Filter out local zones, which are not currently supported with managed node groups
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.6.0"

  name = "petclinic-vpc"
  cidr = "10.0.0.0/16"
  
  # Sélection de 3 zones de disponibilité
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  # Définition des sous-réseaux privés et publics
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  # Activation du NAT Gateway
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false  # À modifier si vous souhaitez une passerelle NAT par AZ
  enable_dns_hostnames   = true
  enable_dns_support     = true

  # Balises pour les sous-réseaux publics
  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
    "subnet-description"                          = "public"
  }

  # Balises pour les sous-réseaux privés
  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
    "subnet-description"                          = "private"
  }

  # Tag pour le VPC
  tags = {
    Name      = "petclinic-vpc"
    petclinic = ""
  }
}
