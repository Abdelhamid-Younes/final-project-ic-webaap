terraform {
  backend "s3" {
    bucket = "terraform-backend-hamid"
    key = "webapp-dev.tfstate"
    region = "us-east-1"
    #shared_credentials_files = ["C:/Users/Administrados/aws_credentials2"]
    access_key = "AKxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    secret_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"   

  }
}