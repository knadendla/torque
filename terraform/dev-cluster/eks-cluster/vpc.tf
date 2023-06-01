module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.14.4"

  name = "${var.cluster-name}-vpc"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = [for k, v in data.aws_availability_zones.available.names : cidrsubnet(var.vpc_cidr, 8, k + 10)]
  public_subnets  = [for k, v in data.aws_availability_zones.available.names : cidrsubnet(var.vpc_cidr, 8, k)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster-name}" = "owned"
    "kubernetes.io/role/internal-elb"           = 1
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster-name}" = "owned"
    "kubernetes.io/role/elb"                    = 1
  }
}
