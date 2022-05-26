remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "test-rk-terrafrom"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
  }
}
