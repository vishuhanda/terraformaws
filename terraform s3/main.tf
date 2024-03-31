provider "aws" {
  region = var.aws_region
}


module "bucket" {
  source = "./modules/bucket"

}

output "name" {
  
value = module.bucket.s3_url
sensitive =true

}   