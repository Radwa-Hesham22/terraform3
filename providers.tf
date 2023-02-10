provider "aws" {
  shared_credentials_files = ["./creds"]
  profile                  = var.profile
  region                   = var.region
}