# Depósito S3
resource "aws_s3_bucket" "example_infra23" {
  bucket = "example-infra23"  

}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.example_infra23.arn}/*""]

    principals {
      type        = "AWS"
      identifiers = [var.aws_cloudfront_OAI_arn_from_networking_module]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.example_infra23.id
  policy = data.aws_iam_policy_document.s3_policy.json
}
