/*
Example S3 backend configuration for remote state (prod).


terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket"
    key            = "terraform/solution/environments/prod/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

*/
