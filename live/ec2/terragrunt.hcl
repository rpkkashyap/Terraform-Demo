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
    source = "tfr:///terraform-aws-modules/ec2-instance/aws?version=3.5.0"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "sg" {
    config_path = "../sg"
}

locals {
  name   = "example-ec2-complete"
  region = "eu-west-1"

  user_data = <<-EOT
  #!/bin/bash
  touch /tmp/test-done
  sudo yum install java-1.8.0 -y
  sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
  sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
  sudo yum install jenkins -y
  sudo service jenkins start
  #Install Ansible
  sudo wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  sudo yum install epel-release-latest-7.noarch.rpm -y
  sudo yum install python python-devel python-pip openssl ansible -y
  EOT
}

inputs = {
    
    name                   = "dev-ec2-app"
    ami                    = "ami-00ee4df451840fa9d"
    instance_type          = "t3.micro"
    key_name               = "ssm-test"
    monitoring             = false
    vpc_security_group_ids = [dependency.sg.outputs.security_group_id] 
    subnet_id              = sort(dependency.vpc.outputs.public_subnets)[0]
    user_data_base64 = base64encode(local.user_data)
}