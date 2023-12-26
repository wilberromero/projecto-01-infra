output "bucket_id" {
    value = aws_s3_bucket.example_infra23.id
}

output "bucket_domain_name" {
    value = aws_s3_bucket.example_infra23.bucket_regional_domain_name
}