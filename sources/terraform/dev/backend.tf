terraform {
  backend "s3" {
    bucket = "terrafor-backend-hamid"
    key = "webapp-dev.tfstate"
    region = "us-east-1"
  }
}