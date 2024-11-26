provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

resource "aws_s3_bucket" "tf-root-module-bucket" {
  bucket = var.s3_bucket_name
 # acl    = "private"

  tags = {
    Name        = var.s3_bucket_name
    Environment = var.tag_env
  }
}

resource "aws_s3_bucket_versioning" "tf-root-module-bucket" {
  bucket = aws_s3_bucket.tf-root-module-bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_acl" "tf-root-module-bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.tf-root-module-bucket]

  bucket = aws_s3_bucket.tf-root-module-bucket.id
  acl    = "private"
}
#resource "aws_s3_bucket" "tf-root-module-bucket" {
#  bucket = "${var.s3_bucket_name}"
#  acl = "private"
  
#  versioning_configuration {
#    status = "Enabled"
#  }
  
#  tags = {
#    Name        = "${var.s3_bucket_name}"
 #   Environment = "${var.tag_env}"
#  }
# }
## module "s3_module_private_repo" {
##  source = "git@github.com:rc-harness/private.git"
##  }
  
