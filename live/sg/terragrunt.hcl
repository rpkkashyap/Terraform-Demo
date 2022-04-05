

terraform {
    source = "tfr:///terraform-aws-modules/security-group/aws?version=4.9.0"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
    name        = "dev-app"
    description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
    vpc_id      = dependency.vpc.outputs.vpc_id

    ingress_with_cidr_blocks = [
        {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        description = "Jenkins Port"
        cidr_blocks = "0.0.0.0/0"
        },
    ]
}