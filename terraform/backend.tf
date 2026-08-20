terraform {
  backend "s3" {
    bucket = "my-lab-bucket-1998"
    key    = "terraform/teraform.tfstate"
    region = "eu-central-1"
  }
}
