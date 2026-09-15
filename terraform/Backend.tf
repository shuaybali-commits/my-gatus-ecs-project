terraform {
  backend "s3" {
    bucket       = "shuayb-gatus-terraform-state"
    key          = "gatus/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}
