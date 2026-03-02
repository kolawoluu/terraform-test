/*
Copy this block into your environment and update the values, then uncomment.

terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket"
    key            = "terraform/solution/environments/dev/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

*/
