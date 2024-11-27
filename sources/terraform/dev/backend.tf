terraform {
  backend "s3" {
    bucket = "terrafor-backend-hamid"
    key = "webapp-dev.tfstate"
    region = "us-east-1"
    shared_credentials_files = ["C:/Users/Administrados/aws_credentials"]
  }
}