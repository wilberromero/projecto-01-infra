# Depósito S3
resource "aws_s3_bucket" "example_infra23" {
  bucket = "example-infra23"  

  # Configuración de políticas para permitir el acceso desde CloudFront
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "GrantCloudFrontAccess",
        Effect = "Allow",
        Principal = {
          AWS = "*"
        },
        Action = "s3:GetObject",
        Resource = "var.aws_cloudfront_distribution_arn_from_networking_module/*",
        Condition = {
          StringLike = {
            "aws:Referer": [
              "http://distribucion-cloudfront-id.cloudfront.net/*"
            ]
          }
        }
      }
    ]
  })
}