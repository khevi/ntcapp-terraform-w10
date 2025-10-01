terraform {
  backend "s3" {
    bucket       = "w6-kossid-terraform"
    key          = "week10/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = false

  }
}