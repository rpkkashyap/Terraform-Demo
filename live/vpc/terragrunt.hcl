generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "us-west-2"
}
EOF
}

terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws?version=3.14.0"
}

inputs = {
  name = "dev-environments"
  cidr = "172.20.0.0/16"

  azs             = ["us-west-2a", "us-west-2b"]
  private_subnets = ["172.20.20.0/24"]
  public_subnets  = ["172.20.10.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false
}