output "ecs_cluster_id" {
    description = "Id del ECS cluster creado"
    value = aws_ecs_cluster.my_cluster.id
}

output "s3_bucket_id" {
    description = "Id del depósito S3 creado"
    value = aws_s3_bucket.example_bucket.id
}

