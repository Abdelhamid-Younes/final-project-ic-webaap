terraform {
  backend "s3" {
    bucket = "terraform-backend-hamid"
    key = "webapp-prod.tfstate"
    region = "us-east-1"
    #shared_credentials_files = ["C:/Users/Administrados/aws_credentials2"]
    access_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"  

  }
}