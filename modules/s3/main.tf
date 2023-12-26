# Depósito S3
resource "aws_s3_bucket" "example_infra23" {
  bucket = "example-infra23"  

}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.example_infra23.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "GrantAccessToOAI",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.aws_cloudfront_OAI_arn_from_networking_module}:root"
        },
        Action =  "s3:GetObject",
        Resource = "${aws_s3_bucket.example_infra23.arn}/*"
      }
    ]
  })
}