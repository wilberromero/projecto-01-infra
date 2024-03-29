
# terraform import aws_s3_bucket.example-infra23 example-infra23

# Configuramos el proveedor de AWS-git 
provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "networking" {
    source = "./modules/networking"
    aws_bucket_id_from_networking_module = module.bucket.bucket_id
    aws_bucket_name_regional_from_networking_module = module.bucket.bucket_domain_name
}

module "container" {
    source = "./modules/container"
    subnet_public_1_id_from_networking_module = module.networking.subnet_public_1
    subnet_public_2_id_from_networking_module = module.networking.subnet_public_2
    aws_security_group_id_from_networking_module = module.networking.aws_security_group
    ecs_task_execution_role_arn_from_iamrole_module = module.iamrole.arn_iam_role_ecs_task_execution

}

module "application_load_balancer" {
    source = "./modules/alb"
    subnet_public_1_id_from_networking_module = module.networking.subnet_public_1
    subnet_public_2_id_from_networking_module = module.networking.subnet_public_2
    vpc_id_from_networking_module = module.networking.vpc_id
}

module "iamrole" {
    source = "./modules/iamrole"  

}

module "bucket" {
    source = "./modules/s3"
    aws_cloudfront_distribution_arn_from_networking_module = module.networking.aws_cloudfront_distribution
    aws_cloudfront_OAI_arn_from_networking_module = module.networking.oai_arn
}
















