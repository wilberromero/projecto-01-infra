
# terraform import aws_s3_bucket.example-infra23 example-infra23

# Configuramos el proveedor de AWS-git 
provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "networking" {
    source = "./modules/networking"
}

module "container" {
    source = "./modules/container"
    subnet_public_1_id_from_networking_module = module.networking.subnet_public_1
    subnet_public_2_id_from_networking_module = module.networking.subnet_public_2
    aws_security_group_id_from_networking_module = module.networking.aws_security_group

}

module "application_load_balancer" {
    source = "./modules/alb"
    subnet_public_1_id_from_networking_module = module.networking.subnet_public_1
    subnet_public_2_id_from_networking_module = module.networking.subnet_public_2
    vpc_id_from_networking_module = module.networking.vpc_id
}


module "bucket" {
    source = "./modules/s3"
}
















