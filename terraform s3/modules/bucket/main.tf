
resource "aws_s3_bucket" bucket {

    bucket = var.bucket_name

    tags = {
      "BucketName" = var.bucket_name
      "Env" = "Dev"
    }

}


resource "aws_s3_bucket_ownership_controls" "bucker_ownership_controls" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket =  aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.bucker_ownership_controls,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.bucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "indexobject" {
  bucket = aws_s3_bucket.bucket.id
  key    = "index.html"
  source = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "errorobject" {
  bucket = aws_s3_bucket.bucket.id
  key    = "error.html"
  source = "error.html"
  content_type = "text/html"
}


resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}


resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
  Version = "2012-10-17"
  Statement = [
    {
    Sid       = "PublicReadGetObject"
    Effect    = "Allow"
    Principal = "*"
    Action    = "s3:GetObject"
    "Resource":["arn:aws:s3:::${var.bucket_name}/*"]
    },
  ]
  })

  depends_on = [
  aws_s3_bucket_public_access_block.example
  ]
}

output "s3_url" {
  
  value = aws_s3_bucket.bucket.bucket_regional_domain_name
}