resource "aws_s3_bucket" "my-bucket-resource" {
  bucket = var.bucket_name
}


resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.my-bucket-resource.bucket
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.my-bucket-resource.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.my-bucket-resource.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}


resource "aws_s3_bucket_policy" "public_bucket_policy" {
  bucket = aws_s3_bucket.my-bucket-resource.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.my-bucket-resource.arn}/*"
      }
    ]
  })

  depends_on = [
    aws_s3_bucket.my-bucket-resource,
    aws_s3_bucket_public_access_block.example,
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_website_configuration.example
  ]
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.example.website_endpoint
}


