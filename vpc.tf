module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "mutual_fund_sandbox"
  cidr   = "10.0.0.0/16"

  azs            = ["${var.aws_region}a"]
  public_subnets = ["10.0.101.0/24"]

  enable_nat_gateway      = false
  enable_vpn_gateway      = false
  map_public_ip_on_launch = true

  tags = {
    Terraform   = "true"
    Environment = "Sandbox"
  }

  public_subnet_tags = {
    name = "mutual_fund_sandbox-public"

  }
}
