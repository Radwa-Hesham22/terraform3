resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-up"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "enable_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-up-locks"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-up"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-up-locks"
    encrypt = true
  }
}